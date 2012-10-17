#!perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'SimpleAuth::Client' );
}

diag( "Testing SimpleAuth::Client $SimpleAuth::Client::VERSION, Perl $], $^X" );
