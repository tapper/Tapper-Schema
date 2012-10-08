package Tapper::Schema::ReportsDB::ResultSet::ReportgroupTestrun;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

=head2 groupreports

Return the group of all reports belonging to the first testrun of
current result set.

=cut

sub groupreports {
        my ($self) = @_;

        $self->search({}, {rows => 1})->first->groupreports;
}

1;
