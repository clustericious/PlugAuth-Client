package SimpleAuth::Client;

use strict;
use warnings;

use Clustericious::Client;

our $VERSION = '0.05';

route 'welcome'   => 'GET', '/';
route 'auth'      => 'GET', '/auth';
route 'authz'     => 'GET', '/authz/user', \("user action resource");
route 'resources' => 'GET', '/authz/resources', \("user action resource_regex");
route 'host_tag'  => 'GET', '/host', \("host tag");
route 'groups'    => 'GET', '/groups', \("user");
route 'actions'   => 'GET', '/actions';

1;

__END__

=head1 NAME

SimpleAuth::Client - SimpleAuth Client

=head1 SYNOPSIS

In a perl program :

 my $r = SimpleAuth::Client->new;

 # Check auth server status and version
 my $check = $r->status;
 my $version = $r->version;

 # Authenticate user "alice", pw "sesame"
 $r->login(user => "alice", password => "sesame");
 if ($r->auth) {
    print "authentication succeeded\n";
 } else {
    print "authentication failed\n";
 }

 # Authorize "alice" to "POST" to "/board"
 if ($r->authz("alice","POST","board")) {
     print "authorization succeeded\n";
 } else {
     print "authorization failed\n";
 }

On the command line :

  # Find all URLs containing /xyz, alice has permission to GET
  simpleauthclient resources alice GET /xyz

  # Check which resources containing the word "ball" are available
  # for charliebrown to perform the "kick" action :
  simpleauthclient resources charliebrown kick ball

  # Check if a given host has the tag "trusted"
  simpleauthclient host_tag 127.0.0.1 trusted

=head1 DESCRIPTION

This module provides a perl front-end to the SimpleAuth API.

=head1 SEE ALSO

 Clustericious::Client
 SimpleAuth

