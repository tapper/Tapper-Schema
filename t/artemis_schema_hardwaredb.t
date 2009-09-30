#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;

plan tests => 2;

# --------------------------------------------------------------------------------
construct_fixture( schema  => hardwaredb_schema, fixture => 't/fixtures/hardwaredb/systems.yml' );
# --------------------------------------------------------------------------------

my $iring_lid = 12;

my $retval = hardwaredb_schema->resultset('Systems')->find($iring_lid)->revisions->mem;
is ($retval, 4096, 'Getting sum of ram sizes');

$retval = hardwaredb_schema->resultset('Systems')->find($iring_lid)->revisions->networks->first->vendor;
is ($retval, 'RealTek', 'Getting vendor of first network card');
