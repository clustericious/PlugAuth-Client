#!perl

use Test::More $ENV{SIMPLEAUTH_LIVE_TESTS} ? "no_plan" : (skip_all => "Set SIMPLEAUTH_LIVE_TESTS to use simpleAuth configuration ");
use SimpleAuth::Client;
use Log::Log4perl;

#BEGIN{ $SIG{USR1} = \&Carp::confess; }

use strict;

Log::Log4perl->easy_init(level => "WARN");

diag "Contacting SimpleAuth server";

my $r = SimpleAuth::Client->new;

ok $r, "made a client object";

my $welcome = $r->welcome;

like $welcome, qr/welcome to simple auth/i, "got welcome message";

1;

