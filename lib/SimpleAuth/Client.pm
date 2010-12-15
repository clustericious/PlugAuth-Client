package SimpleAuth::Client;

use strict;
use warnings;

use Clustericious::Client;

our $VERSION = '0.06';

route 'welcome' => 'GET', '/';

1;

__END__

=head1 NAME

SimpleAuth::Client - SimpleAuth Client

=head1 SYNOPSIS

 my $r = SimpleAuth::Client->new;

 # Get a string that says "welcome to SimpleAuth"
 my $string = $r->welcome;


=head1 DESCRIPTION

This module provides a perl front-end to the SimpleAuth API.

=head1 SEE ALSO

 Clustericious::Client
 SimpleAuth

