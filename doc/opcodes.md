Sourced from hexdump of fglrun-bin

```
opcode number           opcode name            operand bytes
          \/ /------------------------------\  \/
000665a0  00 6e 6f 4f 70 00 00 00  00 00 00 00 00 00 00 00  |.noOp...........|
000665b0  01 70 75 73 68 4c 6f 63  00 00 00 00 01 00 00 00  |.pushLoc........|
000665c0  02 70 75 73 68 4c 6f 63  00 00 00 00 02 00 00 00  |.pushLoc........|
000665d0  03 70 75 73 68 4d 6f 64  00 00 00 00 01 00 00 00  |.pushMod........|
000665e0  04 70 75 73 68 4d 6f 64  00 00 00 00 02 00 00 00  |.pushMod........|
000665f0  05 70 75 73 68 47 6c 62  00 00 00 00 01 00 00 00  |.pushGlb........|
00066600  06 70 75 73 68 47 6c 62  00 00 00 00 02 00 00 00  |.pushGlb........|
00066610  07 70 75 73 68 43 6f 6e  00 00 00 00 01 00 00 00  |.pushCon........|
00066620  08 70 75 73 68 43 6f 6e  00 00 00 00 02 00 00 00  |.pushCon........|
00066630  09 70 75 73 68 49 6e 74  00 00 00 00 05 00 00 00  |.pushInt........|
00066640  0a 70 75 73 68 4e 75 6c  6c 00 00 00 00 00 00 00  |.pushNull.......|
00066650  0b 70 6f 70 41 72 67 00  00 00 00 00 02 00 00 00  |.popArg.........|
00066660  0c 74 68 72 75 00 00 00  00 00 00 00 07 00 00 00  |.thru...........|
00066670  0d 67 65 6e 4c 69 73 74  00 00 00 00 01 00 00 00  |.genList........|
00066680  0e 67 65 6e 4c 69 73 74  00 00 00 00 02 00 00 00  |.genList........|
00066690  0f 61 73 73 46 00 00 00  00 00 00 00 00 00 00 00  |.assF...........|
000666a0  10 61 73 73 52 00 00 00  00 00 00 00 00 00 00 00  |.assR...........|
000666b0  11 6c 6f 61 64 00 00 00  00 00 00 00 01 00 00 00  |.load...........|
000666c0  12 6c 6f 61 64 00 00 00  00 00 00 00 02 00 00 00  |.load...........|
000666d0  13 63 61 6c 6c 30 00 00  00 00 00 00 01 00 00 00  |.call0..........|
000666e0  14 63 61 6c 6c 30 00 00  00 00 00 00 02 00 00 00  |.call0..........|
000666f0  15 63 61 6c 6c 31 00 00  00 00 00 00 01 00 00 00  |.call1..........|
00066700  16 63 61 6c 6c 31 00 00  00 00 00 00 02 00 00 00  |.call1..........|
00066710  17 63 61 6c 6c 4e 00 00  00 00 00 00 01 00 00 00  |.callN..........|
00066720  18 63 61 6c 6c 4e 00 00  00 00 00 00 02 00 00 00  |.callN..........|
00066730  19 63 61 6c 6c 52 65 70  00 00 00 00 07 00 00 00  |.callRep........|
00066740  1a 6f 70 65 72 00 00 00  00 00 00 00 01 00 00 00  |.oper...........|
00066750  1b 72 65 74 41 6c 6c 00  00 00 00 00 01 00 00 00  |.retAll.........|
00066760  1c 72 65 74 41 6c 6c 00  00 00 00 00 02 00 00 00  |.retAll.........|
00066770  1d 72 65 74 00 00 00 00  00 00 00 00 00 00 00 00  |.ret............|
00066780  1e 2a 67 6f 74 6f 00 00  00 00 00 00 04 00 00 00  |.*goto..........|
00066790  1f 2a 67 6f 74 6f 00 00  00 00 00 00 05 00 00 00  |.*goto..........|
000667a0  20 2a 6a 6e 7a 00 00 00  00 00 00 00 04 00 00 00  | *jnz...........|
000667b0  21 2a 6a 6e 7a 00 00 00  00 00 00 00 05 00 00 00  |!*jnz...........|
000667c0  22 2a 6a 70 7a 00 00 00  00 00 00 00 04 00 00 00  |"*jpz...........|
000667d0  23 2a 6a 70 7a 00 00 00  00 00 00 00 05 00 00 00  |#*jpz...........|
000667e0  24 2a 6a 6e 63 00 00 00  00 00 00 00 04 00 00 00  |$*jnc...........|
000667f0  25 2a 6a 6e 63 00 00 00  00 00 00 00 05 00 00 00  |%*jnc...........|
00066800  26 2a 6a 70 63 00 00 00  00 00 00 00 04 00 00 00  |&*jpc...........|
00066810  27 2a 6a 70 63 00 00 00  00 00 00 00 05 00 00 00  |'*jpc...........|
00066820  28 2a 6a 70 65 00 00 00  00 00 00 00 07 00 00 00  |(*jpe...........|
00066830  29 65 78 74 65 6e 64 00  00 00 00 00 00 00 00 00  |)extend.........|
00066840  2a 6d 65 6d 62 65 72 00  00 00 00 00 01 00 00 00  |*member.........|
00066850  2b 6d 65 6d 62 65 72 00  00 00 00 00 02 00 00 00  |+member.........|
00066860  2c 61 72 72 53 75 62 00  00 00 00 00 00 00 00 00  |,arrSub.........|
00066870  2d 73 74 72 53 75 62 00  00 00 00 00 00 00 00 00  |-strSub.........|
00066880  2e 73 74 72 53 75 62 32  00 00 00 00 00 00 00 00  |.strSub2........|
00066890  2f 73 74 72 53 75 62 4c  00 00 00 00 00 00 00 00  |/strSubL........|
000668a0  30 73 74 72 53 75 62 4c  32 00 00 00 00 00 00 00  |0strSubL2.......|
000668b0  31 72 65 70 53 65 74 4f  70 00 00 00 00 00 00 00  |1repSetOp.......|
000668c0  32 2a 67 6f 74 6f 00 00  00 00 00 00 06 00 00 00  |2*goto..........|
000668d0  33 2a 6a 6e 7a 00 00 00  00 00 00 00 06 00 00 00  |3*jnz...........|
000668e0  34 2a 6a 70 7a 00 00 00  00 00 00 00 06 00 00 00  |4*jpz...........|
000668f0  35 2a 6a 6e 63 00 00 00  00 00 00 00 06 00 00 00  |5*jnc...........|
00066900  36 2a 6a 70 63 00 00 00  00 00 00 00 06 00 00 00  |6*jpc...........|
00066910  37 2a 6a 70 65 00 00 00  00 00 00 00 08 00 00 00  |7*jpe...........|
00066920  38 63 61 6c 6c 4e 61 74  69 76 65 00 07 00 00 00  |8callNative.....|
00066930  39 62 72 65 61 6b 70 6f  69 6e 74 00 00 00 00 00  |9breakpoint.....|
```


## More neatly
```
0x00 noOp            0
0x01 pushLoc         1
0x02 pushLoc         2
0x03 pushMod         1
0x04 pushMod         2
0x05 pushGlb         1
0x06 pushGlb         2
0x07 pushCon         1
0x08 pushCon         2
0x09 pushInt         5
0x0a pushNull        0
0x0b popArg          2
0x0c thru            7
0x0d genList         1
0x0e genList         2
0x0f assF            0
0x10 assR            0
0x11 load            1
0x12 load            2
0x13 call0           1
0x14 call0           2
0x15 call1           1
0x16 call1           2
0x17 callN           1
0x18 callN           2
0x19 callRep         7
0x1a oper            1
0x1b retAll          1
0x1c retAll          2
0x1d ret             0
0x1e *goto           4
0x1f *goto           5
0x20 *jnz            4
0x21 *jnz            5
0x22 *jpz            4
0x23 *jpz            5
0x24 *jnc            4
0x25 *jnc            5
0x26 *jpc            4
0x27 *jpc            5
0x28 *jpe            7
0x29 extend          0
0x2a member          1
0x2b member          2
0x2c arrSub          0
0x2d strSub          0
0x2e strSub2         0
0x2f strSubL         0
0x30 strSubL2        0
0x31 repSetOp        0
0x32 *goto           6
0x33 *jnz            6
0x34 *jpz            6
0x35 *jnc            6
0x36 *jpc            6
0x37 *jpe            8
0x38 callNative      7
0x39 breakpoint      0
```