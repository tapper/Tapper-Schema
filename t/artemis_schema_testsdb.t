#! /usr/bin/env perl

use lib '.';

use  strict;
use warnings;

use t::Tools;

use Test::More tests => 4;


BEGIN {
        use_ok( 'Artemis::Schema::TestsDB' );
        use_ok( 'Artemis::Schema::HardwareDB' );
}

SKIP: {
        eval "use Test::Fixture::DBIC::Schema;";
        skip "no Test::Fixture::DBIC::Schema", 2 if $@;

        construct_fixture(
                          schema  => testsdb_schema,
                          fixture => 't/fixtures/testsdb/version.yml',
                         );


        is( testsdb_schema->resultset('Version')->count,                     1,   "version count" );
        is( (testsdb_schema->resultset('Version')->search->all)[0]->version, 815, "version number");

}

