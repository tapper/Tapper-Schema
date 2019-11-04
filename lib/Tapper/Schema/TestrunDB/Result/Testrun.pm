package Tapper::Schema::TestrunDB::Result::Testrun;

# ABSTRACT: Tapper - Containing Testruns

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table('testrun');
__PACKAGE__->add_columns(
    'id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
    },
    'shortname', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 255,
    },
    'notes', {
        data_type           => 'TEXT',
        default_value       => undef,
        is_nullable         => 1,
    },
    'topic_name', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 255,
        is_foreign_key      => 1,
    },
    'starttime_earliest', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
    },
    'starttime_testrun', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
    },
    'starttime_test_program', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
    },
    'endtime_test_program', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
    },
    'owner_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 1,
        size                => 11,
        is_foreign_key      => 1,
    },
    'testplan_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 1,
        size                => 11,
        is_foreign_key      => 1,
    },
    'wait_after_tests', {
        data_type           => 'TINYINT',
        default_value       => 0,
        is_nullable         => 1,           #TODO: 0
        size                => 1,
    },
    # number of times to rerun this test on error
    'rerun_on_error', {
        data_type           => 'TINYINT',
        default_value       => 0,
        is_nullable         => 1,           #TODO: 0
        size                => 1,
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
        set_on_create       => 1,
    },
    'updated_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
        set_on_create       => 1,
        set_on_update       => 1,
    },
);

__PACKAGE__->set_primary_key('id');

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

# * : 1
__PACKAGE__->belongs_to(
    owner                   => "${basepkg}::Owner",
    { 'foreign.id'          => 'self.owner_id' },
);
__PACKAGE__->belongs_to(
    testplan_instance       => "${basepkg}::TestplanInstance",
    { 'foreign.id'          => 'self.testplan_id' },
);

# 1 : 0,1
__PACKAGE__->might_have(
    testrun_scheduling      => "${basepkg}::TestrunScheduling",
    { 'foreign.testrun_id'  => 'self.id' },
);
__PACKAGE__->might_have(
    scenario_element        => "${basepkg}::ScenarioElement",
    { 'foreign.testrun_id'  => 'self.id' },
);
__PACKAGE__->might_have(
    state                   => "${basepkg}::State",
    { 'foreign.testrun_id'  => 'self.id' },
);
__PACKAGE__->might_have(
    reportgrouptestrunstats => "${basepkg}::ReportgroupTestrunStats",
    { 'foreign.testrun_id'  => 'self.id' },
);

# 1 : *
__PACKAGE__->has_many(
    testrun_precondition    => "${basepkg}::TestrunPrecondition",
    { 'foreign.testrun_id'  => 'self.id' },
);
__PACKAGE__->has_many(
    message                 => "${basepkg}::Message",
    { 'foreign.testrun_id'  => 'self.id' },
);
__PACKAGE__->has_many(
    testrun_requested_host  => "${basepkg}::TestrunRequestedHost",
    { 'foreign.testrun_id'  => 'self.id' },
);

# * : *
__PACKAGE__->many_to_many(
    preconditions           => "testrun_precondition",
    'precondition'
);

# -------------------- methods on results --------------------

=head2 to_string

Return printable representation.

=cut

sub to_string
{
        my ($self) = @_;

        my $format = join( $Tapper::Schema::TestrunDB::DELIM, qw/%s %s %s %s %s %s %s %s %s %s %s %s %s %s /, '');
        sprintf (
                 $format,
                 map {
                      defined $self->$_
                      ? $self->$_
                      : $Tapper::Schema::TestrunDB::NULL
                     } @{$self->result_source->{_ordered_columns} }
                );
}

=head2 is_member($head, @tail)

Checks if the first element is already in the list of the remaining
elements.

=cut

sub is_member
{
        my ($head, @tail) = @_;
        grep { $head->id eq $_->id } @tail;
}

=head2 ordered_preconditions

Returns all preconditions in the order they need to be installed.

=cut

sub ordered_preconditions
{
        my ($self) = @_;

        my @done = ();
        my %seen = ();
        my @todo = ();

        @todo = $self->preconditions->search({}, {order_by => 'succession'})->all;

        while (my $head = shift @todo)
        {
                if ($seen{$head->id})
                {
                        push @done, $head unless is_member($head, @done);
                }
                else
                {
                        $seen{$head->id} = 1;
                        my @pre_todo = $head->child_preconditions->search({}, { order_by => 'succession' } )->all;
                        unshift @todo, @pre_todo, $head;
                }
        }
        return @done;
}

=head2 update_content

Update precondition from given params.

=cut

sub update_content {
        my ($self, $args) =@_;

        $self->notes                 ( $args->{notes}                 ) if $args->{notes};
        $self->shortname             ( $args->{shortname}             ) if $args->{shortname};
        $self->topic_name            ( $args->{topic}                 ) if $args->{topic};
        $self->starttime_earliest    ( $args->{date}                  ) if $args->{date};
        $self->owner_id              ( $args->{owner_id}              ) if $args->{owner_id};
        $self->update;
        return $self->id;
}

=head2 rerun

Insert a new testrun similar to this one. Arguments can be given to overwrite
some values. All values of the new testrun not given as argument will be taken
from $self.

@param hash ref - overwrite arguments

@return success - new testrun id
@return error   - exception

=cut

sub rerun
{
        my ($self, $args) = @_;

        my $testrun_new = $self->result_source->schema->resultset('Testrun')->new
            ({
              notes                 => $args->{notes}                 || $self->notes,
              shortname             => $args->{shortname}             || $self->shortname,
              topic_name            => $args->{topic_name}            || $self->topic_name,
              starttime_earliest    => $args->{earliest}              || DateTime->now,
              owner_id              => $args->{owner_id}              || $self->owner_id,
             });

        # prepare job scheduling infos
        my $testrunscheduling = $self->result_source->schema->resultset('TestrunScheduling')->search({ testrun_id => $self->id }, {rows => 1})->first;
        my ($queue_id, $host_id, $auto_rerun, $requested_features, $requested_hosts);
        if ($testrunscheduling) {
                $queue_id           = $testrunscheduling->queue_id;
                $host_id            = $testrunscheduling->host_id;
                $auto_rerun         = $testrunscheduling->auto_rerun;
                $requested_features = $testrunscheduling->requested_features;
                $requested_hosts    = $testrunscheduling->requested_hosts;
        } else {
                my $queue = $self->result_source->schema->resultset('Queue')->search({ name => "AdHoc"}, {rows => 1})->first;
                if (not $queue) {
                        die "No default queue 'AdHoc' found.";
                }
                $queue_id = $queue->id;
                $auto_rerun = 0;
        }

        # create testrun and job
        $testrun_new->insert;
        my $testrunscheduling_new = $self->result_source->schema->resultset('TestrunScheduling')->new
            ({
              testrun_id => $testrun_new->id,
              queue_id   => $args->{queue_id} || $queue_id,
              status     => "prepare",
              auto_rerun => $args->{host_id}  // $auto_rerun,
              host_id    => undef,
             });
        $testrunscheduling_new->insert;

        # assign requested host and features
        if ($testrunscheduling and $testrunscheduling->requested_features->count) {
                foreach my $feature (map {$_->feature}$testrunscheduling->requested_features->all) {
                        my $assigned_feature = $self->result_source->schema->resultset('TestrunRequestedFeature')->new({feature => $feature, testrun_id => $testrun_new->id});
                        $assigned_feature->insert;
                }
        }
        if ($testrunscheduling and $testrunscheduling->requested_hosts->count) {
                foreach my $host_id (map {$_->host_id}$testrunscheduling->requested_hosts->all) {
                        my $assigned_host = $self->result_source->schema->resultset('TestrunRequestedHost')->new({host_id => $host_id, testrun_id => $testrun_new->id});
                        $assigned_host->insert;
                }
        }

        # assign preconditions
        my $preconditions = $self->preconditions->search({}, {order_by => 'succession'});
        my @preconditions;
        while (my $precond = $preconditions->next) {
                push @preconditions, $precond->id;
        }
        $testrunscheduling_new->status('schedule');
        $testrunscheduling_new->update;
        $testrun_new->assign_preconditions(@preconditions);

        return $testrun_new;

}

=head2 assign_preconditions

Assign given preconditions to this testrun.

@param  array   - list of precondition ids

@return success - 0
@return error   - error message

=cut

sub assign_preconditions {
        my ($self, @preconditions) = @_;

        my $succession = 1;
        foreach my $precondition_id (@preconditions) {
                my $testrun_precondition = $self->result_source->schema->resultset('TestrunPrecondition')->new
                    ({
                      testrun_id      => $self->id,
                      precondition_id => $precondition_id,
                      succession      => $succession,
                     });
                eval {
                        $testrun_precondition->insert;
                };
                return "Can not assign $precondition_id: $@" if $@;
                $succession++;
        }
        return 0;
}

=head2 insert_preconditions

Insert given preconditions (as id) starting at given position and push
all later preconditions to make sure they come after the inserted.

@param      int - starting position
@param_list list of precondition_ids

@return success - 0
@return error   - error message

=cut

sub insert_preconditions {
        my ($self, $position, @preconditions) = @_;

        my $succession = $position;
        my $testrun_precondition = $self->result_source->schema->resultset('TestrunPrecondition');

        # move existing preconditions
        my $remaining_preconditions = $testrun_precondition->search({testrun_id => $self->id,
                                                                     succession => { '>=' => $position }});
        while (my $remain = $remaining_preconditions->next) {
                $remain->succession($remain->succession + int @preconditions);
                $remain->update;
        }

        # assign new ones
        foreach my $precondition_id (@preconditions) {
                my $testrun_precondition = $testrun_precondition->new
                    ({
                      testrun_id      => $self->id,
                      precondition_id => $precondition_id,
                      succession      => $succession,
                     });
                eval {
                        $testrun_precondition->insert;
                };
                return "Can not assign $precondition_id: $@" if $@;
                $succession++;
        }
        return 0;
}

=head2 disassign_preconditions

Disconnect list of preconditions from a testrun.

@param array - list of precondition ids

=cut

sub disassign_preconditions {
        my ($self, @preconditions) = @_;

        my $table = $self->result_source->schema->resultset('TestrunPrecondition');
        my $preconditions;
        if (not @preconditions) {
                $preconditions = $table->search({testrun_id => $self->id});
        } else {
                $preconditions = $table->search({testrun_id => $self->id,
                                                 precondition_id => [ -or => [ @preconditions ]]});
        }


        while( my $precondition = $preconditions->next) {
                $precondition->delete();
        }
        return 0;
}

=head2 sqlt_deploy_hook

Add useful indexes at deploy time.

=cut

sub sqlt_deploy_hook
{
        my ($self, $sqlt_table) = @_;
        $sqlt_table->add_index(name => 'testrun_idx_created_at',   fields => ['created_at']);
}

1;
