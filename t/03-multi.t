use Test;
use Cube::Three;

plan 4;

my $a = Cube::Three.new();

is $a.Fʼ.B.U.dump,
    'BWBBWBBWB|RRYRRBRRY|YYOBBOYYO|OOWOOGOOW|WWRGGRWWR|GGGYYYGGG',
    'misc';

$a = Cube::Three.new();
is $a.F.R.U.Rʼ.Uʼ.Fʼ.dump,
    'WWGWWRWOG|RRBRRWRRR|BBWBBWBBW|OOOOOBOOB|GGOGGGGGR|YYYYYYYYY',
    'cross colors';

$a = Cube::Three.new();
is $a.Lʼ.U.R.Uʼ.L.U.Rʼ.Uʼ.dump,
    'RWGWWWOWW|RRBRRRRRR|BBBBBBBBW|OOOOOOOOW|GGGGGGGGW|YYYYYYYYY',
    'corners position';

$a = Cube::Three.new();
is $a.R.U2.Rʼ.Uʼ.R.Uʼ.Rʼ.Lʼ.U2.L.U.Lʼ.U.L.dump,
    'WWBWWWWWB|RRRRRRRRW|BBRBBBBBO|OOWOOOOOO|GGGGGGGGG|YYYYYYYYY',
    'corners rotation';

