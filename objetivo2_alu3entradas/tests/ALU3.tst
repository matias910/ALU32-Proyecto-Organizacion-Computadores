// Objetivo 2 - Proyecto ALU Nand2Tetris
// Script de prueba: ALU3.tst
// Responsable: Persona 2 (con apoyo de Persona 3)
//
// Un caso por cada uno de los 8 opcodes definidos en el README de esta carpeta,
// mas dos casos extra de opcode 0 para verificar la bandera zr (cero) y el manejo
// de operandos negativos (todo unos = -1 en complemento a dos).

load ALU3.hdl,
output-file ALU3.out,
compare-to ALU3.cmp,
output-list x%D1.7.1 y%D1.7.1 z%D1.7.1 opcode%B1.3.1 out%D1.7.1 zr%B1.1.1 ng%B1.1.1;

set x 5,
set y 3,
set z 2,
set opcode 0,
eval,
output;

set x 61680,
set y 4080,
set z 255,
set opcode 1,
eval,
output;

set x 255,
set y 3855,
set z 65535,
set opcode 2,
eval,
output;

set x 65535,
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
set y 65535,
set z 65535,
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

set x 65535,
set y 65535,
set z 65535,
set opcode 0,
eval,
output;

