#! /usr/bin/env perl

use lib '.';

use  strict;
use warnings;

use Data::Dumper;
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Test::More;

BEGIN {
        plan tests => 15;
        use_ok( 'Artemis::Schema::ReportsDB' );
}

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

ok( reportsdb_schema->get_db_version, "schema is versioned" );
diag reportsdb_schema->get_db_version;

is( reportsdb_schema->resultset('Report')->count, 3,  "report count" );

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

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportgroups.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportgroupTestrun')->count,   3, "reportgrouptestrun count" );
is( reportsdb_schema->resultset('ReportgroupArbitrary')->count, 3, "reportgrouparbitrary count" );

