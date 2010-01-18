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
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportgroupviews.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportgroupTestrun')->count,      6, "reportgrouptestrun count" );
is( reportsdb_schema->resultset('ReportgroupTestrunStats')->count, 2, "reportgrouptestrunstats count" );

# find report
my $report = reportsdb_schema->resultset('Report')->find(23);
like($report->tap, qr/OK 2 bar CCC/ms, "found report");

# find according report group (grouped by testrun)
my $rgt = $report->reportgrouptestrun;
ok(defined $rgt, "has according reportgroup testrun");

my $rgt_stats = reportsdb_schema->resultset('ReportgroupTestrunStats')->new({ testrun_id => 700 });

$rgt = $rgt_stats->reportgrouptestruns;
cmp_bag([ map { $_->report_id } $rgt->all], [21, 22, 23], "reports via rgt_stats.reportgrouptestruns");
diag "rgt testruns: ", Dumper([ map { $_->report_id } $rgt->all]);

done_testing;
