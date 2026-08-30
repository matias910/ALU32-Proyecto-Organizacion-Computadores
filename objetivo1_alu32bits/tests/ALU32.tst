// Objetivo 1 - Proyecto ALU Nand2Tetris
// Script de prueba: ALU32.tst
// Responsable: Persona 1 (con apoyo de Persona 3)
//
// Casos cubiertos: suma simple, suma que da cero, acarreo positivo entre
// mitades (65535+1), acarreo con negativos (-1 + -1 = -2), AND bit a bit,
// OR bit a bit (via De Morgan), y paso de x solo (y forzado a 0).

load ALU32.hdl,
output-file ALU32.out,
compare-to ALU32.cmp,
output-list x%D1.14.1 y%D1.14.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1 ny%B1.1.1 f%B1.1.1 no%B1.1.1 out%D1.14.1 zr%B1.1.1 ng%B1.1.1;

set x 0,
set y 0,
set zx 1,
set nx 0,
set zy 1,
set ny 0,
set f 1,
set no 0,
eval,
output;

set x 17,
set y 3,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0,
eval,
output;

set x 5,
set y -5,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0,
eval,
output;

set x 65535,
set y 1,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0,
eval,
output;

set x -1,
set y -1,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0,
eval,
output;

set x 12,
set y 10,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 0,
set no 0,
eval,
output;

set x 12,
set y 10,
set zx 0,
set nx 1,
set zy 0,
set ny 1,
set f 0,
set no 1,
eval,
output;

set x -5,
set y 0,
set zx 0,
set nx 0,
set zy 1,
set ny 0,
set f 1,
set no 0,
eval,
output;

