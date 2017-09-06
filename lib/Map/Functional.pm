package Map::Functional;
# ABSTRACT: map with named lexical iteration variables

use strict;
use warnings;

=head1 SYNOPSIS

    use Map::Functional qw( fmap );

    my @tomorrows = fmap ($dt) { $dt->add(days => 1) } @todays;

=head1 DESCRIPTION

L<Map::Functional> provides C<fmap>, a function that provides map-like
iteration and processing over a list, but uses a named lexical iteration
variable for clarity and safety.

=head2 Why use C<fmap> instead of C<map>?

=head3 Add clarity to your iterations

Be explicit about what's going on. Compare:

    my @doubled = map { $_ * 2 } (1 .. 5);
    my @doubled = fmap ($orig) { $orig * 2 } (1 .. 5);

Clarify what's being extracted from a complex data structure. Compare:

    my @phyla = map { $_->{phylum} } @{ $data->{$experiment}{phase} };
    my @phyla
        = fmap ($organism) { $organism->{phylum} }
          @{ $data->{$experiment}{phase} };

or

    my %deliveries = map { $_->{name} => $_->{zip} } @{ $orders->{shipping} };
    my %deliveries
        = fmap ($address) { $address->{name} => $address->{zip} }
          @{ $orders->{shipping} };

Imply data types of iterator contents by selecting a good name. Compare:

    my @rain_dates = map { $_->add(doays => 1) } @game_dates;
    my @rain_dates = fmap ($dt) { $dt->add(days => 1) } @game_dates;

=head3 Avoid unintended tramplings of the global topic variable C<$_>

Perl's C<map> is simple and powerful, but it can have unintended side effects
because it uses the global topic variable (C<$_>) to iterate through the list
provided. Consider the following example in which C<$_> is quietly trampled:

    #!/usr/bin/env perl

    use strict;
    use warnings;
    use DDP;

    my $data_start = tell DATA;
    my %calced = map { $_ => get_line_n($_) } 1..5;
    p %calced;

    sub get_line_n {
        my $int = shift;

        my $target_line;
        my $line_num = 0;
        while (<DATA>) {
            $line_num++;
            next if $line_num < $int;

            chomp;
            seek DATA, $data_start, 0;
            return $_;
        }
    }

    __DATA__
    Line 1
    Line 2
    Line 3
    Line 4
    Line 5
    Line 6

The C<<while (<DATA>)>> construct reads each line into C<$_>, overwriting
C<map>'s copy of C<$_>. While we might expect

    (
        1 => 'List 1',
        2 => 'List 2',
        3 => 'List 3',
        4 => 'List 4',
        5 => 'List 5'
    )

to our surprise we actually get

    (
        'List 1' => 'List 1',
        'List 2' => 'List 2',
        'List 3' => 'List 3',
        'List 4' => 'List 4',
        'List 5' => 'List 5',
    )

In addition to the above example demonstrating an unintended trampling of the
topic variable by lesser-known Perl behavior, consider cases where the BLOCK
calls a sub or method off-screen or in a different file, and maintenance
programmers may not be aware that in certain subs/methods, the global topic
variable shouldn't be trampled by virtue that at some point, it's called inside
a C<map> BLOCK. Using C<fmap> will address these concerns entirely.

=func fmap ($x) BLOCK LIST

Use like the BLOCK form of C<map>, but name the iteration variable for use in
BLOCK.

=cut

1;
