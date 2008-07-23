#!perl -T

use Test::More;

plan tests => 1;

BEGIN {
	use_ok( 'Artemis::Schema' );
}

diag( "Testing Artemis::Schema $Artemis::Schema::VERSION, Perl $], $^X" );
