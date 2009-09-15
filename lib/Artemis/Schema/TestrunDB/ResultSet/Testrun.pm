package Artemis::Schema::TestrunDB::ResultSet::Testrun;

use strict;
use warnings;

use DateTime;


use parent 'DBIx::Class::ResultSet';

sub queued_testruns
{
        shift->search({
                       starttime_testrun => undef,
                      }
                     );
}

sub running_testruns
{
        shift->search({
                       starttime_testrun    => { '!=' => undef },
                       endtime_test_program => undef,
                      }
                     );
}

sub finished_testruns
{
        shift->search({
                       endtime_test_program => { '!=' => undef },
                      }
                     );
}

sub due_testruns
{
        my ($self) = @_;

        my $now = $self->result_source->storage->datetime_parser->format_datetime(DateTime->now);
        return $self->search(
                             {
                              starttime_earliest => { '<', $now},
                              starttime_testrun  => undef,
                             },
                             {
                              order_by => [qw/starttime_earliest/]
                             }
                            );
}

sub all_testruns {
        shift->search({});
}

sub add {
        my ($self, $args) = @_;

        my $testrun =  $self->new
            ({
              notes                 => $args->{notes},
              shortname             => $args->{shortname},
              topic_name            => $args->{topic_name},
              starttime_earliest    => $args->{earliest},
              owner_user_id         => $args->{owner_user_id},
              hardwaredb_systems_id => $args->{hardwaredb_systems_id},
             });

        $testrun->insert;

        my $testrunscheduling = $self->result_source->schema->resultset('TestrunScheduling')->new
            ({
              testrun_id => $testrun->id,
              queue_id   => $args->{queue_id},
              host_id    => $args->{host_id},
              status     => "schedule",
              auto_rerun => $args->{auto_rerun} || 0,
             });
        $testrunscheduling->insert;

        return $testrun->id;
}



1;
