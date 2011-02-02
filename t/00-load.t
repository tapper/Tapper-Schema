#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Tapper::Schema' );
}

diag( "Testing Tapper::Schema $Tapper::Schema::VERSION, Perl $], $^X" );
