package Artemis::Schema::TestrunDB::ResultSet::Precondition;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub lonely_preconditions
{
        shift->search({
                       TODO_NOT_YET_IMPLEMENTED()
                      }
                     );
}

sub primary_preconditions
{
        # XXX: This generates a left outer join but we need a inner join 
        shift->search(
                      {},
                      {
                       join => 'testrun_precondition',
                      }
                     );

}

sub pre_preconditions
{
        shift->search({
                       TODO_NOT_YET_IMPLEMENTED()
                      }
                     );
}

sub all_preconditions
{
        my ($resultset) = @_;

        $resultset->search({});
}

1;
