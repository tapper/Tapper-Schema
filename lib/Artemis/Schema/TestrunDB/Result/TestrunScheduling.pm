# TODO: rename into "(Scheduler|Result)::Job"?

package Artemis::Schema::TestrunDB::Result::TestrunScheduling;

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
     "host_id",         { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "status",          { data_type => "VARCHAR",   default_value => "prepare",            is_nullable => 1, size => 255, is_enum => 1, extra => { list => [qw(prepare schedule running finished)] } },
     "created_at",      { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                                                      }, # '
     "updated_at",      { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                                                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to( testrun            => 'Artemis::Schema::TestrunDB::Result::Testrun',                 { 'foreign.id'         => 'self.testrun_id' });
__PACKAGE__->belongs_to( queue              => 'Artemis::Schema::TestrunDB::Result::Queue',                   { 'foreign.id'         => 'self.queue_id'   });
__PACKAGE__->belongs_to( host               => 'Artemis::Schema::TestrunDB::Result::Host',                    { 'foreign.id'         => 'self.host_id'    });

__PACKAGE__->has_many  ( requested_features => 'Artemis::Schema::TestrunDB::Result::TestrunRequestedFeature', { 'foreign.testrun_id' => 'self.id'         });
__PACKAGE__->has_many  ( requested_hosts    => 'Artemis::Schema::TestrunDB::Result::TestrunRequestedHost',    { 'foreign.testrun_id' => 'self.id'         });

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# START --- Should belong to Artemis::MCP::Scheduler::Schema::TestrunDB::Result::TestrunScheduling
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

use MooseX::Method::Signatures;

        # Maybe it even works without those "use" statements ahead:
        use aliased 'Artemis::MCP::Scheduler::Host';
        use aliased 'Artemis::MCP::Scheduler::Queue';

        method match_host ($free_hosts)
        {
                foreach my $host ($self->requested_hosts->all)
                {
                        for (my $i = 0; $i <=  $#$free_hosts; $i++) {
                                if ($free_hosts->[$i]->{name} eq $host->hostname) {
                                        my $chosen_host = $free_hosts->[$i];
                                        my @free_hosts = @$free_hosts[0..$i-1, $i+1..$#$free_hosts];
                                        $free_hosts = \@free_hosts;
                                        return $chosen_host;
                                }
                        }
                }
                return;
        }

        # mem(4096);
        # mem > 4000;
        # TODO:
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
        # $_ is some lines later the current context inside the for-loop where the eval happens
        sub mem(;$)      { _helper($_->features->{mem},      undef,      @_) }
        sub vendor(;$)   { _helper($_->features->{cpu},      'vendors',  @_) }
        sub family(;$)   { _helper($_->features->{cpu},      'family',   @_) }
        sub model(;$)    { _helper($_->features->{cpu},      'model',    @_) }
        sub stepping(;$) { _helper($_->features->{cpu},      'stepping', @_) }
        sub revision(;$) { _helper($_->features->{cpu},      'revision', @_) }
        sub socket(;$)   { _helper($_->features->{cpu},      'socket',   @_) }
        sub cores(;$)    { _helper($_->features->{cpu},      'cores',    @_) }
        sub clock(;$)    { _helper($_->features->{cpu},      'clock',    @_) }
        sub l2cache(;$)  { _helper($_->features->{cpu},      'l2cache',  @_) }
        sub l3cache(;$)  { _helper($_->features->{cpu},      'l3cache',  @_) }

        method match_feature($free_hosts)
        {
        HOST:
                foreach my $host (@$free_hosts)
                {
                        $_ = $host;
                        foreach my $this_feature (@{$self->requested_features->all})
                        {
                                my $success = eval $this_feature->feature;
                                print STDERR "TestRequest.fits: ", $@ if $@;
                                next HOST if not $success;
                        }
                        return $host;
                }
                return;
        }

        method fits ($free_hosts)
        {
                if (not $free_hosts)
                {
                        return;
                }
                elsif ($self->hostnames)
                {
                        my $host = $self->match_host($free_hosts);
                        if ($host)
                        {
                                return $host;
                        }
                        elsif ($self->requested_features)
                        {
                                $host = $self->match_feature($free_hosts);
                                return $host if $host;
                        }
                        return;
                }
                elsif ($self->requested_features) # but no wanted hostnames
                {
                        my $host = $self->match_feature($free_hosts);
                        return $host if $host;
                        return;
                }
                else # free_hosts but no wanted hostnames and no requested_features
                {
                        return shift @$free_hosts;
                }
        }

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# END --- Should belong to Artemis::MCP::Scheduler::Schema::TestrunDB::Result::TestrunScheduling
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

