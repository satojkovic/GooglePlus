#!perl

use strict;
use warnings;

use Storable;

my @list_of_hash = ();
foreach my $i (1..5) {
	my $hash = {
		name => 'satojkovic',
		post => 'post' . $i,
		icon => 'icon' . $i
	};
	push(@list_of_hash, $hash);
}

Storable::nstore(\@list_of_hash, "test.dat");

