#!/usr/bin/perl -w

# DigiKey.pm
#
# Parses DigiKey's CSVs.

package Store::DigiKey;

use strict;
use warnings;

use File::Slurp;

# Constructor.
sub new {
	my ($class) = @_;
	my $self = {
		file_name => $_[1]
	};

	bless $self, $class;
	return $self;
}

sub print {
	my ($self) = @_;
	print "The file is: " . File::Slurp::read_file($self->{file}) . "\n";
}

1;
