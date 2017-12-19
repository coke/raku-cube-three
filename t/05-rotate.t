use Test;
use Cube::Three;

plan 23;

sub fill($u, $f, $r, $b, $l, $d) {
    ($u x 9, $f x 9, $r x 9, $b x 9, $l x 9, $d x 9).join('|')
}

my $a = Cube::Three.new();

is $a.rotate-F-L.dump,
    fill(|<W B O G R Y>),
    'rotate FL';

$a = Cube::Three.new();
is $a.U.R.L.F.B.D.rotate-F-L.dump,
    'ROORWORRO|YWGYBBYYG|ROWBOWRGW|YWBYGGYYB|ORWGRWOBW|BBBRYOGGG',
    'multi rotate FL';

$a = Cube::Three.new();
is $a.rotate-F-R.dump,
    fill(|<W G R B O Y>),
    'rotate FR';

$a = Cube::Three.new();
is $a.rotate-F-U.dump,
    fill(|<R Y B W G O>),
    'rotate FU';

$a = Cube::Three.new();
is $a.rotate-F-D.dump,
    fill(|<O W B Y G R>),
    'rotate FD';

$a = Cube::Three.new();
is $a.rotate-U-R.dump,
    fill(|<G R W O Y B>),
    'rotate UR';

$a = Cube::Three.new();
is $a.rotate-U-L.dump,
    fill(|<B R Y O W G>),
    'rotate UL';

$a = Cube::Three.new();
is $a.U2.D2.rotate-U-L.dump,
    'GBGGBGGBG|OOORRROOO|YYYYYYYYY|RRROOORRR|WWWWWWWWW|BGBBGBBGB',
    'turn then rotate UL';

$a = Cube::Three.new();
is $a.U2.D2.rotate-U-R.dump,
    'BGBBGBBGB|OOORRROOO|WWWWWWWWW|RRROOORRR|YYYYYYYYY|GBGGBGGBG',
    'turn then rotate UR';

$a = Cube::Three.new();
is $a.U2.D2.rotate-F-D.dump,
    'RRROOORRR|WWWWWWWWW|GGGBBBGGG|YYYYYYYYY|BBBGGGBBB|OOORRROOO',
    'turn then rotate FD';

$a = Cube::Three.new();
is $a.U2.D2.rotate-F-U.dump,
    'OOORRROOO|YYYYYYYYY|GGGBBBGGG|WWWWWWWWW|BBBGGGBBB|RRROOORRR',
    'turn then rotate FU';

$a = Cube::Three.new();
is $a.U2.D2.rotate-F-R.dump,
    'WWWWWWWWW|BGBBGBBGB|OROOROORO|GBGGBGGBG|RORRORROR|YYYYYYYYY',
    'turn then rotate FR';

$a = Cube::Three.new();
is $a.U2.D2.rotate-F-L.dump,
    'WWWWWWWWW|GBGGBGGBG|RORRORROR|BGBBGBBGB|OROOROORO|YYYYYYYYY',
    'turn then rotate FL';

$a = Cube::Three.new();
is $a.U2.D2.rotate-U-L.rotate-F-D.dump,
    'RORRORROR|GGGBBBGGG|YYYYYYYYY|BBBGGGBBB|WWWWWWWWW|OROOROORO',
    'turn then rotate 2x';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-U-L.dump,
    'WOYWBYWRY|OROWRYORO|GBBGYBGGB|RORYOWROR|GBBGWBGGB|WRYWGYWOY',
    'many turns, rotate UL';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-F-D.dump,
    'RORYOWROR|GGGGWBBBB|WWWRBOYYY|BBBBYGGGG|YYYRGOWWW|OROWRYORO',
    'many turns, rotate FD';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-F-L.dump,
    'GGGGWBBBB|YRWYBWYOW|RWROOORYR|YOWYGWYRW|OWORRROYO|BBBBYGGGG',
    'many turns, rotate FL';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-U-R.dump,
    'YOWYGWYRW|OROYRWORO|BGGBWGBBG|RORWOYROR|BGGBYGBBG|YRWYBWYOW',
    'many turns, rotate UR';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-F-U.dump,
    'OROWRYORO|GGGGYBBBB|YYYOBRWWW|BBBBWGGGG|WWWOGRYYY|RORYOWROR',
    'many turns, rotate FU';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-F-L.dump,
    'GGGGWBBBB|YRWYBWYOW|RWROOORYR|YOWYGWYRW|OWORRROYO|BBBBYGGGG',
    'many turns, rotate FL';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-U-L.rotate-F-D.rotate-F-L.dump,
    'RORWOYROR|BBBBYGGGG|YYYRGOWWW|GGGGWBBBB|WWWRBOYYY|OROYRWORO',
    'many turns, some rotate; much wow 1';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-U-R.rotate-F-U.rotate-F-R.dump,
    'OROWRYORO|GGGGYBBBB|YYYOBRWWW|BBBBWGGGG|WWWOGRYYY|RORYOWROR',
    'many turns, some rotate; much wow 2';

$a = Cube::Three.new();
is $a.U.D.F.B.R.L.rotate-U-L.rotate-F-D.rotate-F-L.rotate-U-R.rotate-F-U.rotate-F-R.dump,
    'BGGBYGBBG|OYORRROWO|WRYWGYWOY|RYROOORWR|WOYWBYWRY|BGGBWGBBG',
    'many turns, many rotate; much wow';
