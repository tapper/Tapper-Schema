package Tapper::Schema::ReportsDB::ResultSet::ReportgroupTestrun;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub groupreports {
        my ($self) = @_;

        $self->first->groupreports;
}

1;
