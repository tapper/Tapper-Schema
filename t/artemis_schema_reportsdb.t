#! /usr/bin/env perl

use lib '.';

use  strict;
use warnings;

use t::Tools;
use Data::Dumper;
use Test::Fixture::DBIC::Schema;
use Test::More tests => 14;

BEGIN {
        use_ok( 'Artemis::Schema' );
        use_ok( 'Artemis::Schema::ReportsDB' );
}

is($Artemis::Schema::VERSION, $Artemis::Schema::ReportsDB::VERSION, "global schema version number");
diag("Version: ".$Artemis::Schema::ReportsDB::VERSION);

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('Report')->count, 3,  "report count" );

my $report = reportsdb_schema->resultset('Report')->find(21);


# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportsection.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportSection')->count, 8,  "reportsection count" );

my @reportsections = reportsdb_schema->resultset('ReportSection')->search({report_id => 21})->all;
is( scalar @reportsections, 8,  "reportsection count" );

is( $reportsections[0]->some_meta_available, 1, "some meta available");
is( $reportsections[1]->some_meta_available, 1, "some meta available");
is( $reportsections[2]->some_meta_available, 1, "some meta available");
is( $reportsections[3]->some_meta_available, 1, "some meta available");
is( $reportsections[4]->some_meta_available, 1, "some meta available");
is( $reportsections[5]->some_meta_available, 0, "some meta available");
is( $reportsections[6]->some_meta_available, 1, "some meta available");
is( $reportsections[7]->some_meta_available, 1, "some meta available");
