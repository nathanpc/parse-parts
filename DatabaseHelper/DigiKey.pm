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
	my $sth = $self->{store_db}->prepare("SELECT salesorder FROM Orders WHERE salesorder = '$salesorder 22'");
	$sth->execute();

	if (!defined $sth->fetchrow_arrayref()) {
		print colored("Warning: ", "yellow"), "Salesorder already exist in the database.\n\n";
	} else {
		$self->{store_db}->do("INSERT INTO Orders VALUES(NULL, '$web_id', '$access_id', '$salesorder')");
	}
}

# Close all the database connections.
sub close {
	my ($self) = @_;
	$self->{store_db}->disconnect();
	$self->{parts_db}->disconnect();
}

1;
