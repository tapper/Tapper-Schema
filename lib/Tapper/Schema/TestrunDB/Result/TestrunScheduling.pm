# TODO: rename into "(Scheduler|Result)::Job"?

package Tapper::Schema::TestrunDB::Result::TestrunScheduling;

use YAML::Syck;
use Safe;
use common::sense;
## no critic (RequireUseStrict)
use parent 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::Object::Enum", "Core");
__PACKAGE__->table("testrun_scheduling");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,  is_auto_increment => 1,                                 },
     "testrun_id",      { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,  is_foreign_key => 1,                                    },
     "queue_id",        { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "host_id",         { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "prioqueue_seq",   { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,                                                          },
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

=head2 match_host

Return hosts that match scheduler criteria.

=cut

sub match_host {
        my ($self, $free_hosts) = @_;

        foreach my $req_host ($self->requested_hosts->all)
        {
                no strict 'refs'; ## no critic (ProhibitNoStrict)
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

our @functions = ('&hostname');

=head2 hostname

Utility function in requested features to match against current or
specified hostname.

=cut

sub hostname (;$) ## no critic (ProhibitSubroutinePrototypes)
{
        my ($given) = @_;

        if ($given) {
                # available
                return $given ~~ $_->{features}->{hostname};
        } else {
                return $_->{features}->{hostname};
        }
}

=head2 gen_schema_functions

Generate utility function to be used by expressions in
requested_features.

=cut

sub gen_schema_functions
{
        # vendor("AMD");        # with optional argument the value is checked against available features and returns the matching features
        # vendor eq "AMD";      # without argument returns the value
        # $_ is the current context inside the while-loop (see below) where the eval happens
        my ($self) = @_;

        my $features = $self->result_source->schema->resultset('HostFeature')->search(
                                                                                            {
                                                                                            },
                                                                                            {
                                                                                             columns => [ qw/entry/ ],
                                                                                             distinct => 1,
                                                                                            });
        while ( my $feature = $features->next ) {
                my $entry = $feature->entry;
                push @functions, "&".$entry;
                my $eval_string = "sub $entry (;\$)";
                $eval_string   .= "{
                            my (\$given) = \@_;

                            if (\$given) {
                                    # available
                                    return \$given ~~ \$_->{features}->{$entry};
                            } else {
                                    return \$_->{features}->{$entry} };
                    }";
                eval $eval_string;                ## no critic
        }
}

=head2 match_feature

Match list of free hosts against requested_features.

=cut

sub match_feature {
        my ($self, $free_hosts) = @_;
 HOST:
        foreach my $host( @$free_hosts )
        {
                # filter out queuebound hosts
                if ($host->{host}->queuehosts->count){
                QUEUE_CHECK:
                        {
                                foreach my $queuehost($host->{host}->queuehosts->all) {
                                        last QUEUE_CHECK if $queuehost->queue->id == $self->queue->id;
                                }
                                next HOST;
                        }
                }

                $_ = $host;
                my $compartment = Safe->new();
                $compartment->permit(qw(:base_core));
                $compartment->share(@functions);

                foreach my $this_feature( $self->requested_features->all )
                {
                        my $success = $compartment->reval($this_feature->feature);
                        print STDERR "Error in TestRequest.fits: ", $@ if $@;
                        next HOST if not $success;
                }
                return $host->{host};
        }
        return;
}

=head2 fits

Checks a TestrunScheduling against a list of available hosts and
returns the matching host.

=cut

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

=head2 mark_as_running

Mark a testrun as currently I<running>.

=cut

sub mark_as_running
{
        my ($self) = @_;

        use Data::Dumper;

        # set scheduling info
        $self->status("running");
        $self->host->free(0);
        $self->prioqueue_seq(undef);

        # sync db
        $self->host->update;
        $self->update;
}

=head2 mark_as_finished

Mark a testrun as I<finished>.

=cut

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

1;
