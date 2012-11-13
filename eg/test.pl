#!/usr/bin/env perl

use PlugAuth::Client;
use Data::Dumper;

my $r = PlugAuth::Client->new();

print Dumper($r->status);
print Dumper($r->version);

$r->login(username => "charliebrown", password => "snoopy");
if ($r->auth) {
    print "ok\n";
} else {
    print "failed\n";
}

$r->login(username => "charliebrown", password => "snoopy2");
if ($r->auth) {
    print "ok\n";
} else {
    print "failed\n";
}

if ($r->authz("charliebrown","kick","football")) {
    print "ok\n";
} else {
    print "failed\n";
}

if ($r->authz("charliebrown","kick","flootball")) {
    print "ok\n";
} else {
    print "failed\n";
}
