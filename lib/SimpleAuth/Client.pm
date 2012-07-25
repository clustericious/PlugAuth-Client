package SimpleAuth::Client;

use strict;
use warnings;
use Log::Log4perl qw(:easy);

use Clustericious::Client;

our $VERSION = '0.08';

route 'welcome'   => 'GET', '/';
route 'auth'      => 'GET', '/auth';
route_doc 'authz' => "user action resource";
route 'resources' => 'GET', '/authz/resources', \("user action resource_regex");
route 'host_tag'  => 'GET', '/host', \("host tag");
route 'groups'    => 'GET', '/groups', \("user");
route 'actions'   => 'GET', '/actions';
route 'user'      => 'GET', '/user';
route 'group'     => 'GET', '/group';
route 'users'     => 'GET', '/users', \("group");
route 'create_user'  => 'POST', '/user', \("--user user --password password");
route 'delete_user'  => 'DELETE',  '/user', \("user");
route 'create_group' => 'POST', '/group', \("--group group --users user1,user2,...");
route 'delete_group' => 'DELETE', '/group', \("group");

route_doc 'update_group' => 'group --users user1,user2,...';
route_doc 'grant' => 'group action resource';

sub authz
{
  my($self, $user, $action, $resource) = @_;

  my $url = Mojo::URL->new( $self->server_url );

  $url->path("/authz/user/$user/$action$resource");

  $self->_doit('GET', $url);
}

sub update_group
{
  my($self, $group, %args) = @_;

  LOGDIE "group needed for update"
    unless $group;

  my $url = Mojo::URL->new( $self->server_url );
  $url->path("/group/$group");

  TRACE("updating $group ", $url->to_string);

  $self->_doit('POST', $url, { users => $args{'--users'} });
}

sub grant
{
  my($self, $group, $action, $resource) = @_;

  LOGDIE "group, action and resource needed for grant"
    unless $group && $action && $resource;

  $resource =~ s/^\///;

  my $url = Mojo::URL->new( $self->server_url );
  $url->path("/grant/$group/$action/$resource");

  $self->_doit('POST', $url);
}

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

 # List of users
 my @users = $r->user;

 # List of groups
 my @groups = $r->group;

 # List of users belonging to peanuts group
 my @users = $r->users('peanuts');

On the command line :

  # Find all URLs containing /xyz, alice has permission to GET
  simpleauthclient resources alice GET /xyz

  # Check which resources containing the word "ball" are available
  # for charliebrown to perform the "kick" action :
  simpleauthclient resources charliebrown kick ball

  # Check if a given host has the tag "trusted"
  simpleauthclient host_tag 127.0.0.1 trusted

  # List of users
  simpleauthclient user

  # List of groups
  simpleauthclient group

  # List of users belonging to peanuts group
  simpleauthclient users peanuts

=head1 DESCRIPTION

This module provides a perl front-end to the SimpleAuth API.

=head1 SEE ALSO

 Clustericious::Client
 SimpleAuth

