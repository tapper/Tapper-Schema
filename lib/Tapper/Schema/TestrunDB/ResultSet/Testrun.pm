package Tapper::Schema::TestrunDB::ResultSet::Testrun;

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
              testplan_id           => $args->{testplan_id},
              notes                 => $args->{notes},
              shortname             => $args->{shortname},
              topic_name            => $args->{topic_name},
              starttime_earliest    => $args->{earliest},
              owner_user_id         => $args->{owner_user_id},
              rerun_on_error        => $args->{rerun_on_error},
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
        if ($args->{priority}) {
                $testrunscheduling->prioqueue_seq($self->result_source->schema->resultset('TestrunScheduling')->max_priority_seq()+1);
        }

        $testrunscheduling->insert;

        if ($args->{scenario_id}) {
                my $scenario_element = $self->result_source->schema->resultset('ScenarioElement')->new
                  ({
                    scenario_id => $args->{scenario_id},
                    testrun_id  => $testrun->id,
                   });
                $scenario_element->insert;
        }

        foreach my $host_id(@{$args->{requested_host_ids}}) {
                my $requested_host = $self->result_source->schema->resultset('TestrunRequestedHost')->new
                  ({
                    host_id => $host_id,
                    testrun_id  => $testrun->id,
                   });
                $requested_host->insert;
        }

        return $testrun->id;
}



1;
