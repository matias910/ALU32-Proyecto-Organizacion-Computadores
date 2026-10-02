load ALU3.hdl,
output-file ALU3.out,
compare-to ALU3.cmp,
output-list x%D1.7.1 y%D1.7.1 z%D1.7.1 opcode%D1.3.1 out%D1.7.1 zr%B1.1.1 ng%B1.1.1;

set x 5,
set y 3,
set z 2,
set opcode 0,
eval,
output;

set x -3856,
set y 4080,
set z 255,
set opcode 1,
eval,
output;

set x 255,
set y 3855,
set z -1,
set opcode 2,
eval,
output;

set x -1,
set y 3855,
set z 255,
set opcode 3,
eval,
output;

set x 1,
set y 2,
set z 4,
set opcode 4,
eval,
output;

set x 10,
set y 5,
set z 3,
set opcode 5,
eval,
output;

set x 0,
set y -1,
set z -1,
set opcode 6,
eval,
output;

set x 1,
set y 1,
set z 1,
set opcode 7,
eval,
output;

set x 0,
set y 0,
set z 0,
set opcode 0,
eval,
output;

set x -1,
set y -1,
set z -1,
set opcode 0,
eval,
output;
