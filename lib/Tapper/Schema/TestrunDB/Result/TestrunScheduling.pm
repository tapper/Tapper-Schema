# TODO: rename into "(Scheduler|Result)::Job"?

package Tapper::Schema::TestrunDB::Result::TestrunScheduling;

use YAML::Syck;
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



=head2 mark_as_running

Mark a testrun as currently I<running>.

=cut

sub mark_as_running
{
        my ($self) = @_;

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
