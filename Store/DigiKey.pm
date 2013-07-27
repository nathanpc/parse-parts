#!/usr/bin/perl -w

# DigiKey.pm
#
# Parses DigiKey's CSVs.

package Store::DigiKey;

use strict;
use warnings;

use IO::Handle;
use File::Slurp;
use Data::Dumper;

# Constructor.
sub new {
	my ($class) = @_;
	my $self = {
		file_name => $_[1]
	};

	bless $self, $class;
	return $self;
}

sub parse_csv {
	my ($self) = @_;  # Gets the class context.
	open(my $data, "<", $self->{file_name}) or die "Couldn't open file \"$self->{file}\": $!";

	while (my $line = readline($data)) {
		chomp $line;

		if ($data->input_line_number() == 2) {
			# IDs line.
			my ($web_id, $access_id, $salesorder) = split(/,/, $line);
			print "Some IDs: $web_id - $access_id - $salesorder";
		}
	}
}

1;
