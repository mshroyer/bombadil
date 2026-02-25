#!/usr/bin/env perl

use warnings;
use strict;

use Carp;
use Pod::Usage;
use Getopt::Long;
use Net::IP qw(:PROC);

__END__

=head1 NAME

pubdns.pl - Generate a DNS zone file for public IPv6 addresses

=head1 SYNOPSIS


=head1 DESCRIPTION

My home network primarily uses ULA addressing for IPv6 because Comcast doesn't
guarantee static public IPv6 prefix delegation.  Therefore, my main zone file
(and its generated reverse zone files) reference ULA addresses internally.

However, it's still sometimes useful to have forward and reverse DNS entries
for hosts' public IPv6 addresses.  For example, this allows tcpdump to show
hostnames instead of IP addresses.

This script takes as input a forward zone file and a known public IPv6 prefix.
It then uses the router's NDP table to cross-reference the input file's ULA
host definitions, by MAC address, with any known corresponding addresses under
the public prefix, outputting a forward zone file for the public prefix.

=cut
