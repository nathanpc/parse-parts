#!/usr/bin/perl -w

# DigiKey.pm
#
# Handles the database stuff for DigiKey orders.

package DatabaseHelper::DigiKey;

use strict;
use warnings;

use DBI;
use Data::Dumper;
use Term::ANSIColor;

# Constructor.
sub new {
	my ($class) = @_;
	my $_store_db = DBI->connect(
		"DBI:SQLite:dbname=databases/digikey.db",
		"", "",
		{ RaiseError => 1}) or die $DBI::errstr;
	my $_parts_db = DBI->connect(
		"DBI:SQLite:dbname=databases/parts.db",
		"", "",
		{ RaiseError => 1}) or die $DBI::errstr;

	my $self = {
		store_db => $_store_db,
		parts_db => $_parts_db
	};

	bless $self, $class;
	return $self;
}

# Add a order to the database.
sub add_order {
	my ($self, $web_id, $access_id, $salesorder) = @_;

	# Check if the salesorder already exists.
	my $sth = $self->{store_db}->prepare("SELECT salesorder FROM Orders WHERE salesorder = '$salesorder'");
	$sth->execute();

	if (defined $sth->fetchrow_arrayref()) {
		print colored("Warning: ", "yellow"), "Salesorder already exist in the database.\n\n";
	} else {
		$self->{store_db}->do("INSERT INTO Orders VALUES(NULL, '$web_id', '$access_id', '$salesorder')");
	}
}

# Adds parts.
sub add_part {
	my ($self, $order_ref, $quantity, $part_ref, $part_name, $description) = @_;

	# Check if the part already exist in the database.
	my $sel_sth = $self->{parts_db}->prepare("SELECT orders, part_number, quantity FROM Parts WHERE part_number LIKE '%$part_ref%'");
	$sel_sth->execute();

	my $entry_ref = $sel_sth->fetchrow_arrayref();
	if (defined $entry_ref) {
		# Update a part in the database.
		my $db_order_ref = @{ $entry_ref }[0];

		if ($db_order_ref !~ /$order_ref/i) {
			# The order ref is completely new.
			$db_order_ref .= ", $order_ref";

			$self->{parts_db}->do("UPDATE Parts SET orders = '$db_order_ref' WHERE part_number LIKE '%$part_ref%'");
			print colored("Updated: ", "blue"), "$description\n";
		} else {
			print colored("No change: ", "cyan"), "$description\n";
		}
	} else {
		# Insert a new part in th database.
		my $sth = $self->{parts_db}->prepare("INSERT INTO Parts VALUES(NULL, 'DigiKey', ?, ?, ?, ?, ?)");
		$sth->execute($order_ref, $quantity, $part_ref, $part_name, $description);

		print colored("Added: ", "green"), "$description\n";
	}
}

# Close all the database connections.
sub close {
	my ($self) = @_;
	$self->{store_db}->disconnect();
	$self->{parts_db}->disconnect();
}

1;
