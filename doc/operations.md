Operations for the the `oper` opcode
Sourced from hexdump of `libfglvm.so` using `hexdump -C /opt/fgl/lib/libfglvm.so -s 0xc3300 -e '18/1 "%_p" 6/1 "%02x "' | less`

000c3300  72 74 73 5f 4f 70 31 43  6c 69 70 70 00 00 00 00  |rts_Op1Clipp....|
rts_Op1Clipp......00 00 01 00 00 00000c3318  72 74 73 5f 4f 70 31 43  6f 6c 75 6d 6e 00 00 00  |rts_Op1Column...|
rts_Op1Column.....00 00 01 00 00 00000c3330  72 74 73 5f 4f 70 31 49  73 4e 6f 74 4e 75 6c 6c  |rts_Op1IsNotNull|
rts_Op1IsNotNull..00 00 01 00 00 00000c3348  72 74 73 5f 4f 70 31 49  73 4e 75 6c 6c 00 00 00  |rts_Op1IsNull...|
rts_Op1IsNull.....00 00 01 00 00 00000c3360  72 74 73 5f 4f 70 31 4e  6f 74 00 00 00 00 00 00  |rts_Op1Not......|
rts_Op1Not........00 00 01 00 00 00000c3378  72 74 73 5f 4f 70 31 53  70 61 63 65 73 00 00 00  |rts_Op1Spaces...|
rts_Op1Spaces.....00 00 01 00 00 00000c3390  72 74 73 5f 4f 70 31 55  4d 69 00 00 00 00 00 00  |rts_Op1UMi......|
rts_Op1UMi........00 00 01 00 00 00000c33a8  72 74 73 5f 4f 70 32 41  6e 64 00 00 00 00 00 00  |rts_Op2And......|
rts_Op2And........00 00 02 00 00 00000c33c0  72 74 73 5f 4f 70 32 44  69 00 00 00 00 00 00 00  |rts_Op2Di.......|
rts_Op2Di.........00 00 02 00 00 00000c33d8  72 74 73 5f 4f 70 32 45  71 00 00 00 00 00 00 00  |rts_Op2Eq.......|
rts_Op2Eq.........00 00 02 00 00 00000c33f0  72 74 73 5f 4f 70 32 47  65 00 00 00 00 00 00 00  |rts_Op2Ge.......|
rts_Op2Ge.........00 00 02 00 00 00000c3408  72 74 73 5f 4f 70 32 47  74 00 00 00 00 00 00 00  |rts_Op2Gt.......|
rts_Op2Gt.........00 00 02 00 00 00000c3420  72 74 73 5f 4f 70 32 49  6e 74 44 69 00 00 00 00  |rts_Op2IntDi....|
rts_Op2IntDi......00 00 02 00 00 00000c3438  72 74 73 5f 4f 70 32 49  6e 74 4d 69 00 00 00 00  |rts_Op2IntMi....|
rts_Op2IntMi......00 00 02 00 00 00000c3450  72 74 73 5f 4f 70 32 49  6e 74 4d 75 00 00 00 00  |rts_Op2IntMu....|
rts_Op2IntMu......00 00 02 00 00 00000c3468  72 74 73 5f 4f 70 32 49  6e 74 50 6c 00 00 00 00  |rts_Op2IntPl....|
rts_Op2IntPl......00 00 02 00 00 00000c3480  72 74 73 5f 4f 70 32 4c  65 00 00 00 00 00 00 00  |rts_Op2Le.......|
rts_Op2Le.........00 00 02 00 00 00000c3498  72 74 73 5f 4f 70 32 4c  74 00 00 00 00 00 00 00  |rts_Op2Lt.......|
rts_Op2Lt.........00 00 02 00 00 00000c34b0  72 74 73 5f 4f 70 32 4d  69 00 00 00 00 00 00 00  |rts_Op2Mi.......|
rts_Op2Mi.........00 00 02 00 00 00000c34c8  72 74 73 5f 4f 70 32 4d  6f 00 00 00 00 00 00 00  |rts_Op2Mo.......|
rts_Op2Mo.........00 00 02 00 00 00000c34e0  72 74 73 5f 4f 70 32 4d  75 00 00 00 00 00 00 00  |rts_Op2Mu.......|
rts_Op2Mu.........00 00 02 00 00 00000c34f8  72 74 73 5f 4f 70 32 4e  65 00 00 00 00 00 00 00  |rts_Op2Ne.......|
rts_Op2Ne.........00 00 02 00 00 00000c3510  72 74 73 5f 4f 70 32 4f  72 00 00 00 00 00 00 00  |rts_Op2Or.......|
rts_Op2Or.........00 00 02 00 00 00000c3528  72 74 73 5f 4f 70 32 50  6c 00 00 00 00 00 00 00  |rts_Op2Pl.......|
rts_Op2Pl.........00 00 02 00 00 00000c3540  72 74 73 5f 4f 70 32 50  6f 00 00 00 00 00 00 00  |rts_Op2Po.......|
rts_Op2Po.........00 00 02 00 00 00000c3558  72 74 73 5f 4f 70 32 54  65 73 74 00 00 00 00 00  |rts_Op2Test.....|
rts_Op2Test.......00 00 02 00 00 00000c3570  72 74 73 5f 4f 70 46 6f  72 00 00 00 00 00 00 00  |rts_OpFor.......|
rts_OpFor.........00 00 02 00 00 00000c3588  72 74 73 5f 4f 70 46 6f  72 53 74 65 70 00 00 00  |rts_OpForStep...|
rts_OpForStep.....00 00 03 00 00 00000c35a0  72 74 73 5f 4f 70 50 6f  70 00 00 00 00 00 00 00  |rts_OpPop.......|
rts_OpPop.........00 00 01 00 00 00000c35b8  72 74 73 5f 4f 70 53 75  62 53 74 72 31 00 00 00  |rts_OpSubStr1...|
rts_OpSubStr1.....00 00 02 00 00 00000c35d0  72 74 73 5f 4f 70 53 75  62 53 74 72 31 4c 65 66  |rts_OpSubStr1Lef|
rts_OpSubStr1Left.00 00 02 00 00 00000c35e8  72 74 73 5f 4f 70 53 75  62 53 74 72 32 00 00 00  |rts_OpSubStr2...|
rts_OpSubStr2.....00 00 03 00 00 00000c3600  72 74 73 5f 4f 70 53 75  62 53 74 72 32 4c 65 66  |rts_OpSubStr2Lef|
rts_OpSubStr2Left.00 00 03 00 00 00000c3618  72 74 73 5f 4f 70 41 6c  6f 61 64 00 00 00 00 00  |rts_OpAload.....|
rts_OpAload.......00 00 03 00 00 00000c3630  72 74 73 5f 4f 70 31 41  6e 64 00 00 00 00 00 00  |rts_Op1And......|
rts_Op1And........00 00 01 00 00 00000c3648  72 74 73 5f 4f 70 31 4f  72 00 00 00 00 00 00 00  |rts_Op1Or.......|
rts_Op1Or.........00 00 01 00 00 00000c3660  72 74 73 5f 4f 70 31 4e  56 4c 00 00 00 00 00 00  |rts_Op1NVL......|
rts_Op1NVL........00 00 01 00 00 00000c3678  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

```
index   name              number of stack params
                          (unclear how many each one returns to the stack)
      
 0      rts_Op1Clipp            1
 1      rts_Op1Column           1
 2      rts_Op1IsNotNull        1
 3      rts_Op1IsNull           1
 4      rts_Op1Not              1
 5      rts_Op1Spaces           1
 6      rts_Op1UMi              1
 7      rts_Op2And              2
 8      rts_Op2Di               2
 9      rts_Op2Eq               2
10      rts_Op2Ge               2
11      rts_Op2Gt               2
12      rts_Op2IntDi            2
13      rts_Op2IntMi            2
14      rts_Op2IntMu            2
15      rts_Op2IntPl            2
16      rts_Op2Le               2
17      rts_Op2Lt               2
18      rts_Op2Mi               2
19      rts_Op2Mo               2
20      rts_Op2Mu               2
21      rts_Op2Ne               2
22      rts_Op2Or               2
23      rts_Op2Pl               2
24      rts_Op2Po               2
25      rts_Op2Test             2
# 26      rts_Op2Using            2 Removed from FGL 2 in FGL 3
26      rts_OpFor               2
27      rts_OpForStep           3
28      rts_OpPop               1
29      rts_OpSubStr1           2
30      rts_OpSubStr1Left       2
31      rts_OpSubStr2           3
32      rts_OpSubStr2Left       3
33      rts_OpAload             3
34      rts_Op1And              1
35      rts_Op1Or               1
36      rts_Op1NVL              1
```

