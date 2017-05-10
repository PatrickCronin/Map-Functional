#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

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
