#!/usr/bin/perl -w

# DigiKey.pm
#
# Parses DigiKey's CSVs.

package Store::DigiKey;

use strict;
use warnings;

use IO::Handle qw(input_line_number);
use Scalar::Util qw(looks_like_number);
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

# Parse a CSV line.
sub parse_fields {
	my ($line) = @_;

	# Escape the commas in the price field. (Since DigiKey doesn't do it and provide us badly formatted CSVs)
	# TODO: Create a regex that matches if there's a "," between "$" and ".", then escape it.

	my @fields = split(/,/, $line);
	pop(@fields);  # Remove the last, empty, field.

	return @fields;
}

# Parse the whole file.
sub parse {
	my ($self) = @_;  # Gets the class context.
	open(my $data, "<", $self->{file_name}) or die "Couldn't open file \"$self->{file}\": $!";

	while (my $line = readline($data)) {
		chomp $line;

		if ($data->input_line_number() == 2) {
			# IDs line.
			my ($web_id, $access_id, $salesorder) = parse_fields($line);
			print "Some IDs: $web_id - $access_id - $salesorder\n";
		} elsif ($data->input_line_number() == 12) {
			# Parts collumn definition line.
			my @col = parse_fields($line);
			print "Collumns: ", join(" - ", @col), "\n";
		} elsif ($data->input_line_number() > 12) {
			if (looks_like_number((split(/,/, $line))[0])) {
				# Part.
				my @part = parse_fields($line);
				print "Part: ", join(" - ", @part), "\n";
			} else {
				# Prices.
				my @row = parse_fields($line);
				my ($price_name, $price) = ($row[6], $row[7]);
				print "$price_name: $price\n";
			}
		}
	}
}

1;
