use Test;
use Cube::Three;

plan 3;

my $a = Cube::Three.new();

$a = Cube::Three.new();
is $a.U.F.dump,
    'WWWWWWGGR|RRRRRRBBB|WWWBBOBBO|OOGOOGOOG|GGRGGRYYY|BBOYYYYYY',
    '.U.F';

$a = Cube::Three.new();
is $a.R.B.dump,
    'BBBWWRWWR|RRRRRRYYY|BBBBBBYYO|OOWOOWOOW|WWRGGGGGG|YYOYYOGGG',
    '.R.B';

$a = Cube::Three.new();
is $a.L.D.dump,
    'OWWOWWOWW|GWWGRRGRR|WBBRBBRBB|BOOBOOBYY|OGGOGGYGG|RRRYYYYYY',
    '.L.D';
