#!/usr/bin/env perl6

use Cube::Three;
my $cube = Cube::Three.new();
$cube.scramble;
say $cube;
say '';
$cube.solve;
say $cube;
