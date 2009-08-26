#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Artemis::Model 'model';
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;

plan tests => 1;

# --------------------------------------------------------------------------------
construct_fixture( schema  => hardwaredb_schema, fixture => 't/fixtures/hardwaredb/systems.yml' );
# --------------------------------------------------------------------------------

my $iring_lid = 12;

my $retval = model('HardwareDB')->resultset('Systems')->find($iring_lid)->revisions->mem;
is ($retval, 4096, 'Getting sum of ram sizes');
