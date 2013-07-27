#!/usr/bin/perl -w

# parse-parts.pl
#
# A program to help you organize and keep track of all the electronics
# parts you've ordered.

use strict;
use Data::Dumper;

# Import stores.
use Store::DigiKey;

my $st = new Store::DigiKey("examples/digikey.csv");
$st->print();
print Dumper($st);
