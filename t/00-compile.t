use Test;
use Cube::Three;

plan 1;

my $a = Cube::Three.new();

isa-ok $a, Cube::Three, "new obj";

