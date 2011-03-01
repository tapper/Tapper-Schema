package Tapper::Schema::TestrunDB::Result::Queue;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("queue");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,    is_auto_increment => 1, },
     "name",                      { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "priority",                  { data_type => "INT",       default_value => 0,                    is_nullable => 0, size => 10,                            },
     "runcount",                  { data_type => "INT",       default_value => 0,                    is_nullable => 0, size => 10,                            }, # aux for algorithm
     "active",                    { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 1,                             },
     "created_at",                { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                        }, #' emacs highlight bug
     "updated_at",                { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },
    );

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( unique_queue_name => [ qw/name/ ], );
__PACKAGE__->has_many ( testrunschedulings => 'Tapper::Schema::TestrunDB::Result::TestrunScheduling', { 'foreign.queue_id' => 'self.id' });
__PACKAGE__->has_many ( queuehosts         => "${basepkg}::QueueHost",         { 'foreign.queue_id' => 'self.id' });

# -------------------- methods on results --------------------

sub queued_testruns
{
        my ($self) = @_;

        $self->testrunschedulings->search({
                                           status => 'schedule'
                                          },
                                          {
                                           ordered_by => 'testrun_id'
                                          });
}

sub get_first_fitting
{
        my ($self, $free_hosts) = @_;
        my $jobs = $self->queued_testruns;
        while (my $job = $jobs->next()) {
                if (my $host = $job->fits($free_hosts)) {
                        $job->host_id ($host->id);

                        if ($job->testrun->scenario_element) {
                                $job->testrun->scenario_element->is_fitted(1);
                                $job->testrun->scenario_element->update();
                        }
                        return $job;
                }
        }
        return;
}

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

sub producer
{
        my ($self) = @_;

        my $producer_class = "Tapper::MCP::Scheduler::PreconditionProducer::".$self->producer;
        eval "use $producer_class"; ## no critic (ProhibitStringyEval)
        return $producer_class->new unless $@;
        return;
}

sub produce
{
        my ($self, $request) = @_;

        my $producer = $self->producer;

        if (not $producer) {
                warn "Queue ".$self->name." does not have an associated producer";
        } else {
                print STDERR "Queue.producer: ", Dumper($producer);
                return $producer->produce($request);
        }
}

sub update_content {
        my ($self, $args) =@_;

        $self->priority( $args->{priority} ) if exists($args->{priority});
        $self->active( $args->{active} ) if exists($args->{active});
        $self->update;
        return $self->id;
}


1;

=head1 NAME

Tapper::Schema::TestrunDB::Testrun - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

