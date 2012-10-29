#!perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'PlugAuth::Client' );
}

diag( "Testing PlugAuth::Client $PlugAuth::Client::VERSION, Perl $], $^X" );
