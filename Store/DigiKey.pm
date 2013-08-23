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

use DatabaseHelper::DigiKey;

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

	# Remove the last empty field if it exists.
	if ($line !~ /,$/) {
		$line = substr($line, 0, length($line) - 1);
	}

	# Escape the commas in the price field. (Since DigiKey doesn't do it and provide us badly formatted CSVs)
	if ($line =~ /\$[0-9]+,[0-9]+\.[0-9]+/) {
		my $subs = substr($line, $-[0], $+[0]);
		$subs =~ s/,/\\,/g;

		$line =~ s/\$[0-9]+,[0-9]+\.[0-9]+/$subs/g;
	}

	# Split and unescape.
	my @fields = split(/(?<!\\),/, $line);
	for (@fields) {
		s/\\,/,/g;
	}

	return @fields;
}

# Parse the whole file.
sub parse {
	my ($self) = @_;  # Gets the class context.
	my $db = new DatabaseHelper::DigiKey();
	my $salesorder;
	open(my $data, "<", $self->{file_name}) or die "Couldn't open file \"$self->{file}\": $!";

	while (my $line = readline($data)) {
		chomp $line;

		# Ignore empty lines.
		if ($line =~ /^\r$/) {
			next;
		}

		# Parse specific lines.
		if ($data->input_line_number() == 2) {
			# IDs line.
			my ($web_id, $access_id, $_salesorder) = parse_fields($line);
			$salesorder = $_salesorder;
			$db->add_order($web_id, $access_id, $_salesorder);

			print "Order added to the database:\n";
			print "    Web ID: $web_id\n";
			print "    Access ID: $access_id\n";
			print "    Salesorder: $_salesorder\n\n";
		} elsif ($data->input_line_number() == 12) {
			# Parts collumn definition line.
			my @col = parse_fields($line);
			print "Collumns: ", join(" - ", @col), "\n\n";
		} elsif ($data->input_line_number() > 12) {
			if (looks_like_number((split(/,/, $line))[0])) {
				# Part.
				my @part = parse_fields($line);
				#$order_ref, $quantity, $part_ref, $part_name, $description
				$db->add_part($salesorder, $part[1], $part[2], "", $part[3]);
				#print "Part: ", join(" - ", @part), "\n";
			} else {
				# Prices.
				my @row = parse_fields($line);
				my ($price_name, $price) = ($row[6], $row[7]);
				print "$price_name: $price\n";
			}
		}
	}

	$db->close();
}

1;
