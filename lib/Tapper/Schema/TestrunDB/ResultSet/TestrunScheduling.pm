package Tapper::Schema::TestrunDB::ResultSet::TestrunScheduling;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

=head2 non_scheduled_jobs

Return due testruns.

=cut

sub non_scheduled_jobs
{
        shift->search({ status => "schedule" });
}

=head2 max_priority_seq

Search for queue with highhest C<max_seq>.

=cut

sub max_priority_seq {
        my ($self) = @_;

        my $job_with_max_seq = $self->result_source->schema->resultset('TestrunScheduling')->search
          (
           { prioqueue_seq => { '>', 0 } },
           {
            select => [ { max => 'prioqueue_seq' } ],
            as     => [ 'max_seq' ], }
          )->first;
        return $job_with_max_seq->get_column('max_seq') if $job_with_max_seq and $job_with_max_seq->get_column('max_seq');
        return 0;
}

=head2 running_jobs

Return all currently running testruns.

=cut

sub running_jobs
{
        shift->search({ status => "running" });
}

=head2 running

Get all running jobs.

@return __PACKAGE__ object

=cut

sub running {
        shift->search({ status => 'running' });
}

1;
