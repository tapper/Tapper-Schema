#! /usr/bin/env perl

use lib '.';

use  strict;
use warnings;

use t::Tools;
use Data::Dumper;
use Test::Fixture::DBIC::Schema;
use Test::More tests => 2;

BEGIN {
        use_ok( 'Artemis::Schema::ReportsDB' );
}


# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('Report')->count, 3,  "report count" );

my $report = reportsdb_schema->resultset('Report')->find(21);
diag Dumper($report->tap);
