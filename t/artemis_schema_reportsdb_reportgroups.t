#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Data::Dumper;
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Test::More;
use Test::Deep;
use Scalar::Util;

BEGIN {
        use_ok( 'Artemis::Schema::ReportsDB' );
}

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportgroups.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportgroupTestrun')->count,   3, "reportgrouptestrun count" );
is( reportsdb_schema->resultset('ReportgroupArbitrary')->count, 3, "reportgrouparbitrary count" );

# find report
my $report = reportsdb_schema->resultset('Report')->find(23);
like($report->tap, qr/OK 2 bar CCC/ms, "found report");

# find according report group (grouped by testrun)
my $rgt = $report->reportgrouptestrun;
ok(defined $rgt, "has according reportgroup testrun");

# find according report group stats -- should not exist yet
my $rgt_stats = reportsdb_schema->resultset('ReportgroupTestrunStats')->find($rgt->testrun_id);
is($rgt_stats, undef, "no reportgroup stats yet");

# re-create report group stats
$rgt_stats = reportsdb_schema->resultset('ReportgroupTestrunStats')->new({ testrun_id => $rgt->testrun_id });
$rgt_stats->insert;
is($rgt_stats->testrun_id, 753, "reportgroup stats created");

is($rgt_stats->testrun_id, 753, "reportgroup stats created");


done_testing;
