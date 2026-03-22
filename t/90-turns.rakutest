#!/usr/bin/env perl6

use Test;
use Cube::Three;

plan 1;

my $a = Cube::Three.new;

my $count = 1;
$a.F;

loop {
    $count++;
    $a.R;
    last if $a.solved;
    $count++;
    $a.B;
    last if $a.solved;
    $count++;
    $a.L;
    last if $a.solved;
    $count++;
    $a.F;
    last if $a.solved;
}

# got here, we solved it.
is $count, 1260, "turning sides in order eventually solves cube";
