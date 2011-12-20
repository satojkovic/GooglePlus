#!perl

use strict;
use warnings;

use Storable;

my $res = Storable::retrieve("test.dat");

foreach my $item (@{$res}) {
	print "[$item->{icon}] $item->{name} : $item->{post}\n";
}

