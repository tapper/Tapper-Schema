package Artemis::Schema::TestrunDB::Result::Testrun;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';
use Data::Dumper;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("testrun");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,    is_auto_increment => 1, },
     "shortname",                 { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "notes",                     { data_type => "TEXT",      default_value => "",                   is_nullable => 1,                                        },
     "topic_name",                { data_type => "VARCHAR",   default_value => "",                   is_nullable => 0, size => 20,    is_foreign_key => 1,    },
     "starttime_earliest",        { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },
     "starttime_testrun",         { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },
     "starttime_test_program",    { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },
     "endtime_test_program",      { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },
     "hardwaredb_systems_id",     { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,                            },
     "owner_user_id",             { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,    is_foreign_key => 1,    },
     "test_program",              { data_type => "VARCHAR",   default_value => "",                   is_nullable => 0, size => 255,                           },
     "wait_after_tests",          { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 1,                             },
     "created_at",                { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                        }, # '
     "updated_at",                { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },
    );

__PACKAGE__->set_primary_key("id");

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to   ( topic                      => "${basepkg}::Topic",                   { 'foreign.name' => 'self.topic_name'    });
__PACKAGE__->belongs_to   ( owner                      => "${basepkg}::User",                    { 'foreign.id'   => 'self.owner_user_id' });

__PACKAGE__->has_many     ( testrun_precondition       => "${basepkg}::TestrunPrecondition",     { 'foreign.testrun_id' => 'self.id' });
__PACKAGE__->many_to_many ( preconditions              => "testrun_precondition",                                        'precondition' );

__PACKAGE__->might_have   ( testrun_scheduling         => "${basepkg}::TestrunScheduling",       { 'foreign.testrun_id' => 'self.id' });

# -------------------- methods on results --------------------



sub to_string
{
        my ($self) = @_;

        my $format = join( $Artemis::Schema::TestrunDB::DELIM, qw/%s %s %s %s %s %s %s %s %s %s %s %s %s %s /, '');
        sprintf (
                 $format,
                 map {
                      defined $self->$_
                      ? $self->$_
                      : $Artemis::Schema::TestrunDB::NULL
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


sub update_content {
        my ($self, $args) =@_;

        $self->notes                 ( $args->{notes}                 ) if $args->{notes};
        $self->shortname             ( $args->{shortname}             ) if $args->{shortname};
        $self->topic_name            ( $args->{topic}                 ) if $args->{topic};
        $self->starttime_earliest    ( $args->{date}                  ) if $args->{date};
        $self->owner_user_id         ( $args->{owner_user_id}         ) if $args->{owner_user_id};
        $self->hardwaredb_systems_id ( $args->{hardwaredb_systems_id} ) if $args->{hardwaredb_systems_id};
        $self->update;
        return $self->id;
}

sub rerun
{
        my ($self, $args) = @_;

        my $testrun_new = $self->result_source->schema->resultset('Testrun')->new
            ({
              notes                 => $args->{notes}                 || $self->notes,
              shortname             => $args->{shortname}             || $self->shortname,
              topic_name            => $args->{topic_name}            || $self->topic_name,
              starttime_earliest    => $args->{earliest}              || DateTime->now,
              test_program          => '',
              owner_user_id         => $args->{owner_user_id}         || $self->owner_user_id,
              hardwaredb_systems_id => $args->{hardwaredb_systems_id} || $self->hardwaredb_systems_id,
             });

        # prepare job scheduling infos
        my $testrunscheduling = $self->result_source->schema->resultset('TestrunScheduling')->search({ testrun_id => $self->id })->first;
        my $queue_id;
        my $host_id;
        my $auto_rerun;
        if ($testrunscheduling) {
                $queue_id = $testrunscheduling->queue_id;
                $host_id  = $testrunscheduling->host_id;
                $auto_rerun = $testrunscheduling->auto_rerun;
        } else {
                # TODO: unfinished
                my $host  = $self->result_source->schema->resultset('Host')->search({ name => $args->{hostname}} )->first;
                if (not $host) {
                        warn "No host '".$args->{hostname}."' found.";
                        return;
                }
                $host_id  = $host->id;
                my $queue = $self->result_source->schema->resultset('Queue')->search({ name => "AdHoc"} )->first;
                if (not $queue) {
                        warn "No default queue 'AdHoc' found.";
                        return;
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
              host_id    => $args->{host_id}  || $host_id,
              status     => "schedule",
              auto_rerun => $args->{host_id}  // $auto_rerun,
             });
        $testrunscheduling_new->insert;

        # assign preconditions
        my $preconditions = $self->preconditions->search({}, {order_by => 'succession'});
        my @preconditions;
        while (my $precond = $preconditions->next) {
                push @preconditions, $precond->id;
        }
        $testrun_new->assign_preconditions(@preconditions);
        return $testrun_new->id;
}

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
                $testrun_precondition->insert;
                $succession++;
        }
        return 0; # 0 == success (ask Maik if in doubt! :-)
}

1;

=head1 NAME

Artemis::Schema::TestrunDB::Testrun - A ResultSet description


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

