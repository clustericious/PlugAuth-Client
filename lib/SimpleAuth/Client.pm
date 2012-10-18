package SimpleAuth::Client;

use strict;
use warnings;
use v5.10;
use Log::Log4perl qw(:easy);
use Clustericious::Client;

# ABSTRACT: SimpleAuth Client
# VERSION

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

=head1 DESCRIPTION

This module provides a perl front-end to the SimpleAuth API.

=cut

route welcome      => 'GET', '/';

=head1 METHODS

=head2 $client-E<gt>auth

Returns true if the SimpleAuth server can authenticate the user.  
Username and passwords can be specified with the login method or
via the application's configuration file, see L<Clustericious::Client>
for details.

=cut

route auth         => 'GET', '/auth';

=head2 $client-E<gt>authz($user $action, $resource)

Returns true if the given user ($user) is authorized to perform the
given action ($action) on the given resource ($resource).

=cut

route_doc authz    => "user action resource";
sub authz
{
  my($self, $user, $action, $resource) = @_;

  my $url = Mojo::URL->new( $self->server_url );

  $resource = "/$resource" unless $resource =~ m{^/};
  
  $url->path("/authz/user/$user/$action$resource");

  $self->_doit('GET', $url);
}

=head2 $client-E<gt>user

Returns a list reference containing all usernames.

=cut

route user         => 'GET', '/user';

=head2 $client-E<gt>create_user( \%args )

Create a user with the given username and password.

=over 4

=item * username

The new user's username

=item * password

The new user's password

=back

=cut

route create_user => 'POST', '/user', \("--user username --password password");
route_args create_user => [
  { name => 'user',     type => '=s', required => 1 },
  { name => 'password', type => '=s', required => 1 },
];

=head2 $client-E<gt>delete_user( $username )

Delete the user with the given username.

=cut

route delete_user  => 'DELETE',  '/user', \("user");

=head2 $client-E<gt>groups($user)

Returns a list reference containing the groups that the given user ($user)
belongs to.

=cut 

route groups       => 'GET', '/groups', \("user");

=head2 $client-E<gt>change_password($user, $password)

Change the password of the given user ($user) to a new password ($password).

=cut

route_doc change_password => 'username password';
sub change_password
{
  my($self, $user, $password) = @_;
  my $url = Mojo::URL->new( $self->server_url );
  $url->path("/user/$user");
  $self->_doit('POST', $url, { password => $password });
}

=head2 $client-E<gt>group

Returns a list reference containing all group names.

=cut

route group        => 'GET', '/group';

=head2 $client-E<gt>users($group)

Returns the list of users belonging to the given group ($group).

=cut

route users        => 'GET', '/users', \("group");

=head2 $client-E<gt>create_group( \%args )

Create a group.

=over 4

=item * group

The name of the new group

=item * users

Comma separated list (as a string) of the users that
should initially belong to this group.

=back

=cut

route create_group => 'POST', '/group', \("--group group --users user1,user2,...");
route_args create_group => [
  { name => 'group', type => '=s', required => 1 },
  { name => 'users', type => '=s', required => 1 },
];

=head2 $client-E<gt>update_group( $group, '--users' => $users )

Update the given group ($group) replacing the existing list with
the new list ($users), wihch is a comma separated list as a string.

=cut

route_doc 'update_group' => 'group --users user1,user2,...';
route_args update_group => [
  { name => 'users', type => '=s', required => 1 },
];
sub update_group
{
  my $self = shift;
  my $group = shift;
  my $args = ref($_[0]) eq 'HASH' ? $_[0] : {@_}; 

  LOGDIE "group needed for update"
    unless $group;

  my $url = Mojo::URL->new( $self->server_url );
  $url->path("/group/$group");

  TRACE("updating $group ", $url->to_string);

  $self->_doit('POST', $url, { users => $args->{users} // $args->{'--users'} });
}

=head2 $client-E<gt>delete_group( $group )

Delete the given group ($group).

=cut

route delete_group => 'DELETE', '/group', \("group");

=head2 $client-E<gt>grant( $user, $action, $resource )

Grants the given user ($user) the authorization to perform the given
action ($action) on the given resource ($resource).

=cut

route_doc 'grant'  => 'group action resource';

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

=head2 $client-E<gt>actions

Returns a list reference containing the actions that the SimpleAuth server
knows about.

=cut

route actions      => 'GET', '/actions';

=head2 $client-E<gt>host_tag($ip_address, $tag)

Returns true if the host specified by the given IP address ($ip_address)
has the given host tag ($tag).

=cut

route host_tag     => 'GET', '/host', \("host tag");

=head2 $client-E<gt>resources( $user, $action, $resource_regex )

Returns a list reference containing the resources that match the regex
provided ($resource_regex) that the given user ($user) can perform the
given action ($action).  To see all the resources that the user can
perform the given action against, pass in '.*' as the regex.

=cut

route resources    => 'GET', '/authz/resources', \("user action resource_regex");

1;

__END__

=head1 COMMAND LINE

The SimpleAuth API can also be interfaced on the command line
using the simpleauthclient command:

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

=head1 SEE ALSO

L<Clustericious::Client>, L<SimpleAuth>

=cut
