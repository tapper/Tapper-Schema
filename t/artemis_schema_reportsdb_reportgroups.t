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

my $report = reportsdb_schema->resultset('Report')->find(24);
like($report->tap, qr/OK 2 bar DDD/ms, "found report");
my $reportgroup_arbitrary = $report->reportgrouparbitrary;
ok(defined $reportgroup_arbitrary, "has according reportgroup arbitrary");

$report = reportsdb_schema->resultset('Report')->find(23);
like($report->tap, qr/OK 2 bar CCC/ms, "found report");
my $reportgroup_testrun = $report->reportgrouptestrun;
ok(defined $reportgroup_testrun, "has according reportgroup testrun");

unlike($report->tapdom, qr/\$VAR1/, "no tapdom yet");
my $tapdom = $report->get_cached_tapdom;
is(Scalar::Util::reftype($tapdom), "ARRAY", "got tapdom");

# get it again
$report = reportsdb_schema->resultset('Report')->find(23);
like($report->tapdom, qr/\$VAR1/, "tapdom created on demand looks like Data::Dumper string");
#diag "tapdom: ".$report->tapdom;
my $VAR1;
eval $report->tapdom;
my $tapdom2 = $VAR1;
#diag "tapdom2: ".Dumper($tapdom2);
cmp_bag($tapdom2, $tapdom, "stored tapdom keeps constant");

done_testing;
