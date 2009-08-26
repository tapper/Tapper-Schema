#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Test::More;
use Artemis::Model 'model';
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;

plan tests => 1;

# --------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/hardwaredb/systems.yml' );
# --------------------------------------------------------------------------------

my $iring_lid = 112;
is( model('HardwareDB')->resultset('Systems')->find($iring_lid)->revision->lid, 8, "relations systems - revision" );
