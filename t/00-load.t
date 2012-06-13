#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'In::Korean::Numbers' ) || print "Bail out!\n";
}

diag( "Testing In::Korean::Numbers $In::Korean::Numbers::VERSION, Perl $], $^X" );
