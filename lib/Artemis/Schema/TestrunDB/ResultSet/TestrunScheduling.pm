package Artemis::Schema::TestrunDB::ResultSet::TestrunScheduling;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub non_scheduled_jobs
{
        shift->search(status => "schedule" );
}

sub max_priority_seq {
        my $job_with_max_seq = model('TestrunDB')->resultset('TestrunScheduling')->search
          (
           { prioqueue_seq => { '>', 0 } },
           {
            select => [ { max => 'prioqueue_seq' } ],
            as     => [ 'max_seq' ], }
          )->first;
        return $job_with_max_seq->get_column('max_seq') if $job_with_max_seq;
        return 0;
}


1;
