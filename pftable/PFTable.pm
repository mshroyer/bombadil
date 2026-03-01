package PFTable;

use warnings;
use strict;

use Exporter qw(import);

our @EXPORT_OK = qw(add);

sub add {
    my ( $a, $b ) = @_;
    return $a + $b;
}

1;

__END__

=head1 NAME

PFTable - Placeholder module

=head1 SYNOPSIS

    use PFTable qw(add);

    my $sum = add(2, 3);

=head1 DESCRIPTION

Placeholder description.

=head1 EXPORTED FUNCTIONS

=over 4

=item B<add>(I<$a>, I<$b>)

Returns the sum of I<$a> and I<$b>.

=back

=cut
