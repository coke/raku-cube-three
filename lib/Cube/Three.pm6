#!/usr/bin/env perl6

enum Side «:Up('U') :Down('D') :Front('F') :Back('B') :Left('L') :Right('R')»;
enum Colors «:Red('R') :Green('G') :Blue('B') :Yellow('Y') :White('W') :Orange('O')»;
enum Cell-State «Positioned Oriented Nope»;

class Cube::Three {
    has %!Sides;

    has %!expected-sides = (
        Pair.new(Red,    Front),
        Pair.new(Blue,   Right),
        Pair.new(Orange, Back),
        Pair.new(Green,  Left),
    );

    # Refer to layout.md for details on which cell is where on the cube.
    submethod BUILD() {
        %!Sides{Up}    = [White  xx 9]; # v
        %!Sides{Down}  = [Yellow xx 9]; # v
        %!Sides{Front} = [Red    xx 9]; # >
        %!Sides{Right} = [Blue   xx 9]; # >
        %!Sides{Back}  = [Orange xx 9]; # >
        %!Sides{Left}  = [Green  xx 9]; # >
    }

    # Provide debug output suitable for testing. Each side lists
    # single letter color abbreviations, in internal order, showing
    # Up, Front, Right, Back, Left, Down (separated by pipes)
    # So, default cube shows as:
    # WWWWWWWWW|RRRRRRRRR|BBBBBBBBB|OOOOOOOOO|GGGGGGGGG|YYYYYYYYY
    method dump {
        gather for (Up, Front, Right, Back, Left, Down) -> $side {
            take %!Sides{$side}.join('');
        }.join('|');
    }

    # Provide a pretty print.
    method gist {
        my $result;
        $result = %!Sides{Up}.rotor(3).join("\n").indent(6);
        $result ~= "\n";

        for 2,1,0 -> $row {
            for (Left, Front, Right, Back) -> $side {
                my @slice = (0,3,6) >>+>> $row;
                $result ~= ~%!Sides{$side}[@slice].join(' ') ~ ' ';
            }
            $result ~= "\n";
        }
        $result ~= %!Sides{Down}.rotor(3).join("\n").indent(6);
        $result;
    }

    # Provide utility method for checking corners
    # Array of corners, each an array of pieces.
    has @!corners = [
        [Pair.new(Up,  0),  Pair.new(Back,  8), Pair.new(Left,  2)],
        [Pair.new(Up,  2),  Pair.new(Right, 8), Pair.new(Back,  2)],
        [Pair.new(Up,  6),  Pair.new(Left,  8), Pair.new(Front, 2)],
        [Pair.new(Up,  8),  Pair.new(Front, 8), Pair.new(Right, 2)],
        [Pair.new(Down, 0), Pair.new(Front, 0), Pair.new(Left,  6)],
        [Pair.new(Down, 2), Pair.new(Right, 0), Pair.new(Front, 6)],
        [Pair.new(Down, 6), Pair.new(Left,  0), Pair.new(Back,  6)],
        [Pair.new(Down, 8), Pair.new(Back,  0), Pair.new(Right, 6)],
    ];

    method !corner-state(Int $pos)  {
        my $corner = @!corners[$pos];
        my @expected;
        my @found;
        for $corner.kv -> $pos, $cell {
            @expected[$pos] = %!Sides{$cell.key}[4];
            @found[$pos] = %!Sides{$cell.key}[$cell.value];
        }
        return Oriented   if @expected eqv @found;
        return Positioned if @expected.sort eqv @found.sort;
        return Nope;
    }

    # Since all faces use the same handedness (even if 0 is in a different spot)
    # this algorithm works for all faces. Don't bother moving 4.
    # 0 1 2     6 3 0
    # 3 4 5 ->  7 4 1
    # 6 7 8     8 5 2
    method !rotate-clockwise(Side \side) {
        %!Sides{side}[0,1,2,3,5,6,7,8] = %!Sides{side}[6,3,0,7,1,8,5,2];
    }

    # The inverse…
    method !rotate-counter-clockwise(Side \side) {
        %!Sides{side}[6,3,0,7,1,8,5,2] = %!Sides{side}[0,1,2,3,5,6,7,8];
    }

    # Take an array of 4 pairs with info on the adjacent sides to fix;
    # keys are the sides, values are the lookup slice to get at the pieces
    method !fixup-sides(@fixups) {
        my $s1 = @fixups[0].key;
        my $s2 = @fixups[1].key;
        my $s3 = @fixups[2].key;
        my $s4 = @fixups[3].key;

        my $i1 = @fixups[0].value;
        my $i2 = @fixups[1].value;
        my $i3 = @fixups[2].value;
        my $i4 = @fixups[3].value;

        my @temp = %!Sides{$s4}[$i4.list];

        %!Sides{$s4}[$i4.list] = %!Sides{$s3}[$i3.list];
        %!Sides{$s3}[$i3.list] = %!Sides{$s2}[$i2.list];
        %!Sides{$s2}[$i2.list] = %!Sides{$s1}[$i1.list];
        %!Sides{$s1}[$i1.list] = @temp;
    }

    method U {
        self!rotate-clockwise(Up);
        self!fixup-sides([
            Pair.new(Front, [2,5,8]),
            Pair.new(Left,  [2,5,8]),
            Pair.new(Back,  [2,5,8]),
            Pair.new(Right, [2,5,8]),
        ]);
        self;
    }

    method D {
        self!rotate-clockwise(Down);
        self!fixup-sides([
            Pair.new(Front, [0,3,6]),
            Pair.new(Right, [0,3,6]),
            Pair.new(Back,  [0,3,6]),
            Pair.new(Left,  [0,3,6]),
        ]);
        self;
    }

    method F {
        self!rotate-clockwise(Front);
        self!fixup-sides([
            Pair.new(Up,    [6,7,8]),
            Pair.new(Right, [2,1,0]),
            Pair.new(Down,  [2,1,0]),
            Pair.new(Left,  [6,7,8]),
        ]);
        self;
    }

    method R {
        self!rotate-clockwise(Right);
        self!fixup-sides([
            Pair.new(Up,    [2,5,8]),
            Pair.new(Back,  [0,1,2]),
            Pair.new(Down,  [2,5,8]),
            Pair.new(Front, [8,7,6]),
        ]);
        self;
    }

    method B {
        self!rotate-clockwise(Back);
        self!fixup-sides([
            Pair.new(Up,    [0,1,2]),
            Pair.new(Left,  [0,1,2]),
            Pair.new(Down,  [8,7,6]),
            Pair.new(Right, [8,7,6]),
        ]);
        self;
    }

    method L {
        self!rotate-clockwise(Left);
        self!fixup-sides([
            Pair.new(Up,    [0,3,6]),
            Pair.new(Front, [2,1,0]),
            Pair.new(Down,  [0,3,6]),
            Pair.new(Back,  [6,7,8]),
        ]);
        self;
    }

    # Define x2 methods (do the clockwise move twice)
    # Define xʼ methods (3 rights make a left)
    method U2 { self.U.U; }
    method Uʼ { self.U.U.U; }
    method D2 { self.D.D; }
    method Dʼ { self.D.D.D; }
    method F2 { self.F.F; }
    method Fʼ { self.F.F.F; }
    method R2 { self.R.R; }
    method Rʼ { self.R.R.R; }
    method B2 { self.B.B; }
    method Bʼ { self.B.B.B; }
    method L2 { self.L.L; }
    method Lʼ { self.L.L.L; }

    method rotate-F-L {
         self!rotate-clockwise(Up);
         self!rotate-counter-clockwise(Down);

         # All sides share index orientation
         my $temp = %!Sides{Left};
         %!Sides{Left}  = %!Sides{Front};
         %!Sides{Front} = %!Sides{Right};
         %!Sides{Right} = %!Sides{Back};
         %!Sides{Back}  = $temp;
         self;
    }

    method rotate-F-R {
         self!rotate-clockwise(Down);
         self!rotate-counter-clockwise(Up);

         # All sides share index orientation
         my $temp = %!Sides{Left};
         %!Sides{Left}  = %!Sides{Back};
         %!Sides{Back} = %!Sides{Right};
         %!Sides{Right} = %!Sides{Front};
         %!Sides{Front}  = $temp;
         self;
    }

    method rotate-F-U {
         self!rotate-clockwise(Right);
         self!rotate-counter-clockwise(Left);

         # In addition to moving the side data, have to
         # re-orient the indices to match the new side.
         my $temp = %!Sides{Up};
         %!Sides{Up}    = %!Sides{Front};
         self!rotate-counter-clockwise(Up);
         %!Sides{Front} = %!Sides{Down};
         self!rotate-clockwise(Front);
         %!Sides{Down}  = %!Sides{Back};
         self!rotate-clockwise(Down);
         %!Sides{Back}  = $temp;
         self!rotate-counter-clockwise(Back);
         self;
    }

    method rotate-F-D {
         self!rotate-clockwise(Left);
         self!rotate-counter-clockwise(Right);

         # In addition to moving the side data, have to
         # re-orient the indices to match the new side.
         my $temp = %!Sides{Up};
         %!Sides{Up}    = %!Sides{Back};
         self!rotate-clockwise(Up);
         %!Sides{Back}  = %!Sides{Down};
         self!rotate-counter-clockwise(Back);
         %!Sides{Down}  = %!Sides{Front};
         self!rotate-counter-clockwise(Down);
         %!Sides{Front} = $temp;
         self!rotate-clockwise(Front);
         self;
    }

    method rotate-U-L {
         self!rotate-clockwise(Back);
         self!rotate-counter-clockwise(Front);

         # In addition to moving the side data, have to
         # re-orient the indices to match the new side.
         my $temp = %!Sides{Up};
         %!Sides{Up}    = %!Sides{Right};
         self!rotate-clockwise(Up);
         self!rotate-clockwise(Up);
         %!Sides{Right} = %!Sides{Down};
         %!Sides{Down}  = %!Sides{Left};
         self!rotate-clockwise(Down);
         self!rotate-clockwise(Down);
         %!Sides{Left}  = $temp;
         self;
    }

    method rotate-U-R {
         self!rotate-clockwise(Front);
         self!rotate-counter-clockwise(Back);

         # In addition to moving the side data, have to
         # re-orient the indices to match the new side.
         my $temp = %!Sides{Up};
         %!Sides{Up}   = %!Sides{Left};
         %!Sides{Left} = %!Sides{Down};
         self!rotate-clockwise(Left);
         self!rotate-clockwise(Left);
         %!Sides{Down}  = %!Sides{Right};
         %!Sides{Right}  = $temp;
         self!rotate-clockwise(Right);
         self!rotate-clockwise(Right);
         self;
    }

    # Is the entire cube solved?
    method solved {
        # Do all the cells on each side match the center?
        for (Up, Down, Left, Right, Back, Front) -> $side {
            return False unless
                %!Sides{$side}.all eq %!Sides{$side}[4];
        }
        return True;
    }

    # Generate a random list of moves, at most 10, which
    # don't contain multiple consecutive moves of any type for a single side
    method scramble {
        my @random = <U D F R B L>.roll(100).squish[^10];
        for @random -> $method {
            my $actual = $method ~ ("", "2", "ʼ").pick(1);
            print $actual, ' ';
            self."$actual"();
        }
        say "\n";
    }

    # Solve the white cross
    method solve-top-cross {
        # If all 4 are in place in the right location, we can stop.
        sub completed {
            %!Sides{Up}[1,3,5,7].all eq 'W' &&
            %!Sides{Front}[5] eq 'R' &&
            %!Sides{Right}[5] eq 'B' &&
            %!Sides{Back}[5]  eq 'O' &&
            %!Sides{Left}[5]  eq 'G';
        }
        # TODO - combine this with conditional above
        my @ordered-sides = [Front, Right, Back, Left];

        MAIN:
        while !completed() {
            # Is there one in the middle row?
            # 1. Rotate top into place
            # 2. Rotate piece up into top
            # 3. Rotate top back
            my @middle-edges =
                [Front, Right],
                [Right, Back],
                [Back,  Left],
                [Left,  Front],
            ;

            for @middle-edges -> $edge {
                my $side7 = $edge[0];
                my $side1 = $edge[1];
                my $color7 = %!Sides{$side7}[7];
                my $color1 = %!Sides{$side1}[1];
                if $color7 eq 'W' {
                    # find number of times we need to rotate the top:
                    my $turns = (
                        @ordered-sides.first($side1, :k) -
                        @ordered-sides.first(%!expected-sides{~$color1}, :k)
                    ) % 4;
                    self.U for 1..$turns;
                    self."$side1"();
                    self.Uʼ for 1..$turns;
                    next MAIN;
                } elsif $color1 eq 'W' {
                    my $turns = (
                        @ordered-sides.first($side7, :k) -
                        @ordered-sides.first(%!expected-sides{~$color7}, :k)
                    ) % 4;
                    self.Uʼ for 1..$turns;
                    self."$side1"();
                    self.U for 1..$turns;
                    next MAIN;
                }
            }

            # Is there one in the top, but wrong color or wrong spot?
              # Move it down to the middle row.
            my @top-edges =
                [%!Sides{Up}[7], %!Sides{Front}[5],'R', 'F'],
                [%!Sides{Up}[5], %!Sides{Right}[5],'B', 'R'],
                [%!Sides{Up}[1], %!Sides{Back}[5], 'O', 'B'],
                [%!Sides{Up}[3], %!Sides{Left}[5], 'G', 'L'],
            ;

            for @top-edges -> $edge {
                if $edge[0] eq "W" && $edge[1] ne $edge[2] {
                    self."$edge[3]"();
                    next MAIN;
                } elsif $edge[1] eq "W" {
                    self."$edge[3]"();
                    next MAIN;
                }
            }

            # Must be in the bottom row; Rotate it safely to the middle row.
            my @bottom-edges =
                [%!Sides{Front}[3], %!Sides{Down}[1]],
                [%!Sides{Right}[3], %!Sides{Down}[5]],
                [%!Sides{Back}[3],  %!Sides{Down}[7]],
                [%!Sides{Left}[3],  %!Sides{Down}[3]],
            ;

            # Find the first open top edge.
            my $open-top-pos;
            for @top-edges.kv -> $pos, $edge {
                if $edge[0] ne 'W' {
                    $open-top-pos = $pos;
                    last;
                }
            }

            # Find any W in the bottom edges
            for @bottom-edges.kv -> $pos, $edge {
                if $edge[1] eq 'W' {
                    my $side = @ordered-sides[$pos];
                    my $turns = ($pos - $open-top-pos) % 4;
                    self.Uʼ for 1..$turns;
                    self."$side"();
                    self.U for 1..$turns;
                    next MAIN;
                } elsif $edge[0] eq 'W' {
                    my $side = @ordered-sides[$pos];
                    my $turns = ($pos - $open-top-pos) % 4;
                    self."$side"();
                    self.U;
                    self."{@ordered-sides[($pos-1)%4]}ʼ"();
                    # these could be combined with some modulo math;
                    self.Uʼ;
                    self.U for 1..$turns;
                    next MAIN;
                }
            }
        }
    }

    method solve-top-corners {
        # If all 4 are in place in the right location, we can stop.
        sub completed {
            say "DID WE GET TEHRE?";
            so [==] Oriented, |(^4).map:{self!corner-state($_)}
        }

        MAIN:
        while !completed() {
            say "STARTING top-corners";
            # Find a bottom corner with white in the 0 position on the side.
            for @!corners[4..7] -> $corner {
                 if %!Sides{$corner[1].key}[$corner[1].value] eq 'W' {
                     say "solving HERE?";
                     # Get the color on the bottom. Turn Down so that the W
                     # is one turn CW from the side of that color's face
                     # (so if it's blue, put it so white faces orange)
                     # turn the face on the opposite side of the W clockwise.
                     # turn Down CCW. turn face that you just turned CW CCW.A
dd $corner;
                     my $bottom-color = %!Sides{$corner[0].key}[$corner[0].value];
                     say "BOTTOM COLOR IS $bottom-color";
                     last;;
                 }
            }
            # Find a bottom corner with white in the 6 position on the side.
            for @!corners[4..7] -> $corner {
                 if %!Sides{$corner[2].key}[$corner[2].value] eq 'W' {
                     say "OOH, I CAN FIX THIS, MAYBE";
                     last;;
                 }
            }
            # Find a top piece with white in the 2 position
            for @!corners[^4] -> $corner {
                 if %!Sides{$corner[2].key}[$corner[2].value] eq 'W' {
                     say "OOH, I CAN FIX THIS, MAYBE..";
                     last;;
                 }
            }
            for @!corners[^4] -> $corner {
                 if %!Sides{$corner[1].key}[$corner[1].value] eq 'W' {
                     say "OOH, I CAN FIX THIS, MAYBE::";
                     last;;
                 }
            }
            last; #XXX
        }
    }

    method solve {
        self.solve-top-cross;
        say self;
        self.solve-top-corners;
    }
}
