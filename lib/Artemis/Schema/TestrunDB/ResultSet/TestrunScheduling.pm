package Artemis::Schema::TestrunDB::ResultSet::TestrunScheduling;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub non_scheduled_jobs
{
        shift->search({ mergedqueue_seq => undef, status => "schedule" });
}

1;
