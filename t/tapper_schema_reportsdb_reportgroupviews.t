#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Data::Dumper;
use Tapper::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Test::More;
use Test::Deep;
use Scalar::Util;

BEGIN {
        use_ok( 'Tapper::Schema::ReportsDB' );
}

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportgroupviews.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportgroupTestrun')->count,      6, "reportgrouptestrun count" );
is( reportsdb_schema->resultset('ReportgroupTestrunStats')->count, 2, "reportgrouptestrunstats count" );

# find report
my $report = reportsdb_schema->resultset('Report')->find(23);
like($report->tap->tap, qr/OK 2 bar CCC/ms, "found report");

# find according report group (grouped by testrun)
my $rgt = $report->reportgrouptestrun;
ok(defined $rgt, "has according reportgroup testrun");

my $rgt_stats = reportsdb_schema->resultset('ReportgroupTestrunStats')->new({ testrun_id => 700 });
$rgt = $rgt_stats->reportgrouptestruns({});
cmp_bag([ map { $_->report_id } $rgt->all], [21, 22, 23], "reports via rgt_stats.reportgrouptestruns group 700");
# diag "rgt testruns: ", Dumper([ map { $_->report_id } $rgt->all]);

my $testrun_rs = reportsdb_schema->resultset('View020TestrunOverview')->search({}, { order_by   => 'rgt_testrun_id asc' });

# group 1 - 700
my $tr = $testrun_rs->next;
my %columns = $tr->get_columns;
is($columns{'rgt_testrun_id'},     700,           "group 700 - rgt_testrun_id");
is($columns{'rgts_success_ratio'}, '98.76',       "group 700 - success_ratio");
is($columns{'primary_report_id'},  23,            "group 700 - primary_report_id");
is($columns{'machine_name'},       'machine1c',   "group 700 - machine_name");
is($columns{'suite_id'},           '115',         "group 700 - suite_id");
is($columns{'suite_name'},         'Topic-Hossa', "group 700 - testrun_id");

# group 2 - 800
$tr = $testrun_rs->next;
%columns = $tr->get_columns;
is($columns{'rgt_testrun_id'},     800,           "group 800 - rgt_testrun_id");
is($columns{'rgts_success_ratio'}, '100.00',      "group 800 - success_ratio");
is($columns{'primary_report_id'},  26,            "group 800 - primary_report_id");
is($columns{'machine_name'},       'machine2c',   "group 800 - machine_name");
is($columns{'suite_id'},           '115',         "group 800 - suite_id");
is($columns{'suite_name'},         'Topic-Hossa', "group 800 - testrun_id");

$rgt_stats = reportsdb_schema->resultset('ReportgroupTestrunStats')->new({ testrun_id => 800 });
$rgt = $rgt_stats->reportgrouptestruns;
cmp_bag([ map { $_->report_id } $rgt->all], [24, 25, 26], "reports via rgt_stats.reportgrouptestruns group 800");

done_testing;
