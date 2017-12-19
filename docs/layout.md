Overview
=======
The internal cube layout has six sides; each side has a 9
element array containing a list of colors. Methods that turn
sides or rotate the entire cube take this layout into account.

The six sides are Up, Down, Left, Right, Front, and Back.
The rendering layout shows the cube in this order:

```
       Up
Left Front Right Back    
      Down
```

The cell positions for each side are laid out as follows
(Shown with the color layout on a fresh cube)

```
         W0 W1 W2
         W3 W4 W5
         W6 W7 W8
G2 G5 G8 R2 R5 R8 B2 B5 B8 O2 O5 O8
G1 G4 G7 R1 R4 R7 B1 B4 B7 O1 O4 O7
G0 G3 G6 R0 R3 R6 B0 B3 B6 B0 B3 B6
         Y0 Y1 Y2
         Y3 Y4 Y5
         Y6 Y7 Y8
```

