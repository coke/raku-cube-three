use Test;
use Cube::Three;

plan 3;

my $a = Cube::Three.new();

is $a.solved, True, 'default cube is solved';

$a.F.U;

is $a.solved, False, 'cube not solved';

$a.Uʼ.Fʼ;

is $a.solved, True, 'put that thing back where it came from or so help me';
