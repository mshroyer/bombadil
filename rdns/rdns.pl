#!/usr/bin/env perl

use warnings;
use strict;

use Pod::Usage;
use Getopt::Long;
use Net::IP qw(:PROC);

my ($help, $man, $subnet);

GetOptions(
    'subnet|s=s' => \$subnet,
    'man'        => \$man,
    'help'       => \$help,
) or die "Incorrect usage!\n";

pod2usage({ -verbose => 2 }) if $man;
pod2usage({ -verbose => 1 }) if $help;

if (@ARGV != 1 || !$subnet) {
    die "Usage: $0 --subnet <subnet_prefix/prefix_length> <input_zone_file>\n";
}

my $input_file = $ARGV[0];
my $subnet_obj = new Net::IP($subnet) or die(Net::IP::Error());
my $ip_version = $subnet_obj->version();
my $origin     = "";

open(my $input_fh, '<', $input_file) or die "Cannot open input file: $!";

print ";; Generated by rdns.pl
;; Do not modify directly.\n\n";

while (my $line = <$input_fh>) {
    chomp($line);

    if ($line =~ /^\$ORIGIN\s+(\S+)/) {
        $origin = $1;
    } elsif ($line =~ /^(\$TTL\s+\S+|\@\s+SOA\s)/) {

        # Copy default TTL and SOA record verbatim.
        print "$line\n\n";
    } elsif ($ip_version == 4 && $line =~ /^\s*([^\s;]+)\s+A\s+(\S+)/) {
        my ($hostname, $ipv4) = ($1, $2);
        my $ip_obj = new Net::IP($ipv4) or die(Net::IP::Error());
        if ($subnet_obj->overlaps($ip_obj) != $IP_NO_OVERLAP) {
            my $reverse_ipv4 =
              join('.', reverse(split(/\./, $ipv4))) . ".in-addr.arpa.";
            print "$reverse_ipv4\tPTR\t$hostname.$origin\n";
        }
    } elsif ($ip_version == 6 && $line =~ /^\s*([^\s;]+)\s+AAAA\s+(\S+)/) {
        my ($hostname, $ipv6) = ($1, $2);
        my $ip_obj = new Net::IP($ipv6) or die(Net::IP::Error());
        if ($subnet_obj->overlaps($ip_obj) != $IP_NO_OVERLAP) {
            my $reverse_ipv6 = $ip_obj->reverse_ip();
            print "$reverse_ipv6\tPTR\t$hostname.$origin\n";
        }
    }
}

close($input_fh);

__END__

=head1 NAME

rdns.pl - Generate reverse DNS zone files

=head1 SYNOPSIS

rdns.pl --subnet 192.168.42.0/24 foo.zone

rdns.pl --subnet fd5b:a1f8:cef:1::/64 foo.zone

rdns.pl --man

=head1 DESCRIPTION

This script reads a forward zone file and creates a reverse zone file for the
specified subnet based on the input's matching A or AAAA records.  $TTL
directives and SOA records from the input zone are preserved verbatim.

The purpose is to simplify managing reverse DNS zone files as new hosts are
added to the forward zone file.

=cut
