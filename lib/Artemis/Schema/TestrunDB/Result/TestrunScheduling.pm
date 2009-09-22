# TODO: rename into "(Scheduler|Result)::Job"?

package Artemis::Schema::TestrunDB::Result::TestrunScheduling;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::Object::Enum", "Core");
__PACKAGE__->table("testrun_scheduling");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,  is_auto_increment => 1,                                 },
     "testrun_id",      { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,  is_foreign_key => 1,                                    },
     "queue_id",        { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "mergedqueue_seq", { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,                                                          },
     "host_id",         { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "status",          { data_type => "VARCHAR",   default_value => "prepare",            is_nullable => 1, size => 255, is_enum => 1, extra => { list => [qw(prepare schedule running finished)] } },
     "auto_rerun",      { data_type => "TINYINT",   default_value => "0",                  is_nullable => 1,                                                                      },
     "created_at",      { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                                                      }, # '
     "updated_at",      { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                                                      },
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to( testrun            => "${basepkg}::Testrun",                 { 'foreign.id'         => 'self.testrun_id' });
__PACKAGE__->belongs_to( queue              => "${basepkg}::Queue",                   { 'foreign.id'         => 'self.queue_id'   });
__PACKAGE__->belongs_to( host               => "${basepkg}::Host",                    { 'foreign.id'         => 'self.host_id'    });

__PACKAGE__->has_many  ( requested_features => "${basepkg}::TestrunRequestedFeature", { 'foreign.testrun_id' => 'self.testrun_id' });
__PACKAGE__->has_many  ( requested_hosts    => "${basepkg}::TestrunRequestedHost",    { 'foreign.testrun_id' => 'self.testrun_id' });


# ----- scheduler related methods -----

sub match_host {
        my ($self, $free_hosts) = @_;

        foreach my $req_host ($self->requested_hosts->all)
        {
                no strict 'refs';
        FREE_HOST:
                foreach my $free_host( map {$_->{host} } @$free_hosts) {
                        if ($free_host->queuehosts->count){
                                QUEUE_CHECK:
                                {
                                        foreach my $queuehost($free_host->queuehosts->all) {
                                                last QUEUE_CHECK if $queuehost->queue->id == $self->queue->id;
                                        }
                                        next FREE_HOST;
                                }
                        }
                        return $free_host if $free_host->name eq $req_host->host->name;
                }
        }
        return;
}

# mem(4096);
# mem > 4000;
sub _helper {
        my ($available, $subkey, $given) = @_;

        if ($given)
        {
                # available
                return
                    grep
                    {
                            $given ~~ ($subkey ? $_->{$subkey} : $_)
                    } @{ $available };
        }
        else
        {
                $subkey ? $available->[0]->{$subkey} : $available->[0];
        }
}

# vendor("AMD");        # with optional argument the value is checked against available features and returns the matching features
# vendor eq "AMD";      # without argument returns the value
# @_ means this optional param
# $_ is the current context inside the while-loop (see below) where the eval happens
sub mem(;$)      { _helper($_->{features}{mem},      undef,      @_) }
sub vendor(;$)   { _helper($_->{features}{cpu},      'vendors',  @_) }
sub family(;$)   { _helper($_->{features}{cpu},      'family',   @_) }
sub model(;$)    { _helper($_->{features}{cpu},      'model',    @_) }
sub stepping(;$) { _helper($_->{features}{cpu},      'stepping', @_) }
sub revision(;$) { _helper($_->{features}{cpu},      'revision', @_) }
sub socket(;$)   { _helper($_->{features}{cpu},      'socket',   @_) }
sub cores(;$)    { _helper($_->{features}{cpu},      'cores',    @_) }
sub clock(;$)    { _helper($_->{features}{cpu},      'clock',    @_) }
sub l2cache(;$)  { _helper($_->{features}{cpu},      'l2cache',  @_) }
sub l3cache(;$)  { _helper($_->{features}{cpu},      'l3cache',  @_) }

sub match_feature {
        my ($self, $free_hosts) = @_;

 HOST:
        foreach my $host( @$free_hosts )
        {
                # filter out queuebound hosts
                if ($host->queuehosts->count){
                QUEUE_CHECK: 
                        {
                                foreach my $queuehost($host->queuehosts->all) {
                                        last QUEUE_CHECK if $queuehost->queue->id == $self->queue->id;
                                }
                                next HOST;
                        }
                }

                $_ = $host;
                
                while (my $this_feature = $self->requested_features->next)
                {
                        my $success = eval $this_feature->feature;
                        print STDERR "Error in TestRequest.fits: ", $@ if $@;
                        next HOST if not $success;
                }
                return $host->{host};
        }
        return;
}

# Checks a TestrunScheduling against a list of available hosts
# returns the matching host

sub fits {
        my ($self, $free_hosts) = @_;

        if (not $free_hosts)
        {
                return;
        }
        elsif ($self->requested_hosts->count)
        {
                my $host = $self->match_host($free_hosts);
                if ($host)
                {
                        return $host;
                }
                elsif ($self->requested_features->count)
                {
                        $host = $self->match_feature($free_hosts);
                        return $host if $host;
                }
        }
        elsif ($self->requested_features->count) # but no wanted hostnames
        {
                my $host = $self->match_feature($free_hosts);
                return $host if $host;
        }
        else # free_hosts but no wanted hostnames and no requested_features
        {
                foreach my $host (map {$_->{host} } @$free_hosts) {
                        if ($host->queuehosts->count){
                                foreach my $queuehost($host->queuehosts->all) {
                                        return $host if $queuehost->queue->id == $self->queue->id;
                                }
                        } else {
                                return $host;
                        }
                        
                }
        }
        return;
}

sub mark_as_running
{
        my ($self) = @_;

        use Data::Dumper;

        # set scheduling info
        $self->status("running");
        $self->host->free(0);
        $self->mergedqueue_seq(undef);

        # sync db
        $self->host->update;
        $self->update;
}

sub mark_as_finished
{
        my ($self) = @_;

        use Data::Dumper;

        # set scheduling info
        $self->status("finished");
        $self->host->free(1);

        # sync db
        $self->host->update;
        $self->update;
}

sub produce_preconditions
{
        my ($self) = @_;
        my $testrun = $self->testrun;
 PRECONDITION:
        my @new_preconditions;
        foreach my $precondition($testrun->ordered_preconditions) {
                my $precond_hash = $precondition->precondition_as_hash;
                if ( $precond_hash->{precondition_type} eq 'produce' ) {
                        my $producer_name = $precond_hash->{producer};
                        if (not $producer_name) {
                                # TODO: warn here about precondition_type: produce without actual producer
                                next PRECONDITION;
                        }
                        eval "use Artemis::MCP::Scheduler::PreconditionProducer::$producer_name";
                        my $producer = "Artemis::MCP::Scheduler::PreconditionProducer::$producer_name"->new();
                        my $retval = $producer->produce($self, $precond_hash);

                        if ($retval->{error}) {
                                return $retval->{error};
                        }

                        my $new_precondition_yaml = $retval->{precondition_yaml};
                        $self->testrun->topic_name($retval->{topic}) if $retval->{topic};

                        my @new_ids = $self->result_source->schema->resultset('Precondition')->add($new_precondition_yaml);
                        push @new_preconditions, @new_ids;
                } else {
                        push @new_preconditions, $precondition->id;
                }

        }
        $self->testrun->disassign_preconditions();
        $self->testrun->assign_preconditions(@new_preconditions);
        return 0;
}

1;

=head1 NAME

Artemis::Schema::TestrunDB::Result::PrePrecondition - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

