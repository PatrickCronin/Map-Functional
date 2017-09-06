#!perl

use strict;
use warnings;
use Test::More;
use Map::Functional qw( fmap );

sub test_list_replacement {
    is_deeply(
        [ fmap ($x) { 3 } () ],
        [],
        'empty list',
    );

    is_deeply(
        [ fmap ($x) { 3 } (42) ],
        [ 3 ],
        'single-item list',
    );

    is_deeply(
        [ fmap ($x) { 3 } (1 .. 5) ],
        [ (3) x 5 ],
        'multi-item list',
    );
}

sub test_list_reflection {
    is_deeply(
        [ fmap ($x) { $x } () ],
        [],
        'empty list',
    );

    is_deeply(
        [ fmap ($x) { $x } (42) ],
        [ 42 ],
        'single-item list',
    );

    is_deeply(
        [ fmap ($x) { $x } (1 .. 5) ],
        [ 1 .. 5 ],
        'multi-item list',
    );
}

sub test_list_modification {
    is_deeply(
        [ fmap ($x) { $x + 1 } () ],
        [],
        'empty list',
    );

    is_deeply(
        [ fmap ($x) { $x + 1 } (42) ],
        [ 43 ],
        'single-item list',
    );

    is_deeply(
        [ fmap ($x) { $x + 1 } (1 .. 5) ],
        [ 2 .. 6 ],
        'multi-item list',
    );
}

sub test_array_replacement {
    my @arr = ();
    is_deeply(
        [ fmap ($x) { 3 } @arr ],
        [],
        'empty array',
    );

    @arr = (42);
    is_deeply(
        [ fmap ($x) { 3 } @arr ],
        [ 3 ],
        'single-item array',
    );

    @arr = )1 .. 5);
    is_deeply(
        [ fmap ($x) { 3 } @arr ],
        [ (3) x 5 ],
        'multi-item array',
    );
}

sub test_array_reflection {

    my @arr = ();
    is_deeply(
        [ fmap ($x) { $x } @arr ],
        [],
        'empty array',
    );

    @arr = (42);
    is_deeply(
        [ fmap ($x) { $x } @arr ],
        [ 42 ],
        'single-item array',
    );

    @arr = (1 .. 5);
    is_deeply(
        [ fmap ($x) { $x } @arr ],
        [ 1 .. 5 ],
        'multi-item array',
    );
}

sub test_array_modification {
    my @arr = ();
    is_deeply(
        [ fmap ($x) { $x + 1 } @arr ],
        [],
        'empty array',
    );

    @arr = (42);
    is_deeply(
        [ fmap ($x) { $x + 1 } @arr ],
        [ 43 ],
        'single-item array',
    );

    @arr = (1 .. 5);
    is_deeply(
        [ fmap ($x) { $x + 1 } @arr ],
        [ 2 .. 6 ],
        'multi-item array',
    );
}

sub test_argument_modification {
    my @arr = (1 .. 5);
    is_deeply(
        [ fmap ($x) { _modify_callers_parameters($x) } @arr ],
        [ 1 .. 5 ],
        'multi-item array processed'
    );
    is_deeply( \@arr, [ 1 .. 5 ], 'arguments preserved', );
}

sub _modify_callers_parameters {
    my $val = $_[0];
    $_[0] *= 2;
    return $val;
}

#
#   use Map::Functional 'fmap';
#
#   my %values = fmap ($i) { $i => do_something($i) } 1..5;
#

# To test:
# - I should be able to import fmap from Map::Functional
# - Test format errors: No iterator variable, no BLOCK, no LIST.
# - Test iterator variable sigils: $ @ % * & \$ \@ \% \* \&
# - Test iterator variable names: none, single letter, existing named variable,
#     the topic variable
# - Test iterator variable expression: scalar variable, object attribute,
#     class method, array index, hash key, coderef, etc?
# - Test BLOCK: empty, without iterator variable, with iterator variable,
#     returning one value per iteration, returning multiple values per
#     iteration
# - Test overall functionality: BLOCK is performed on every item in LIST,
#     subs called from BLOCK that trample the global topic variable don't
#     affect the BLOCK results

