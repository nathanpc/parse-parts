#!/usr/bin/perl -w

# parse-parts.pl
#
# A program to help you organize and keep track of all the electronics
# parts you've ordered.

use strict;
use warnings;
use Data::Dumper;

# Import stores.
use Store::DigiKey;

my $order = new Store::DigiKey("examples/digikey.csv");
$order->parse();
#print Dumper($order);
