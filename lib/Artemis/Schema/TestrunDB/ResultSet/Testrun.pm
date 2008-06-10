package Artemis::Schema::TestrunDB::ResultSet::Testrun;

use strict;
use warnings;

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

sub all_testruns {
        shift->search({});
}

1;
