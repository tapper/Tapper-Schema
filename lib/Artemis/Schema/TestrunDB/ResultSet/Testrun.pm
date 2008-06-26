package Artemis::Schema::TestrunDB::ResultSet::Testrun;

use strict;
use warnings;

use DateTime;
use Artemis::Model 'model';


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
        return shift->search(
                             {
                              starttime_earliest => { '<', model('TestrunDB')->storage->datetime_parser(DateTime->now)}, 
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

1;
