package Artemis::Schema::TestrunDB::ResultSet::TestrunScheduling;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub non_scheduled_jobs
{
        shift->search(status => "schedule" );
}

1;
