#!perl -T

use Test::More;

BEGIN {
        plan tests => 1;
	use_ok( 'Artemis::Schema' );
}

diag( "Testing Artemis::Schema $Artemis::Schema::VERSION, Perl $], $^X" );
