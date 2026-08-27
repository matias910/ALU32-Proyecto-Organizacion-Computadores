// Objetivo 1 - Proyecto ALU Nand2Tetris
// Script de prueba: ALU32.tst
// Responsable: Persona 1 (con apoyo de Persona 3)
//
// TODO: completar los casos de prueba (incluir casos de borde: ceros, negativos, overflow
// en 32 bits) siguiendo el mismo esquema que el ALU.tst estándar de Nand2Tetris, adaptado
// a los buses de 32 bits.

load ALU32.hdl,
output-file ALU32.out,
compare-to ALU32.cmp,
output-list x%D1.16.1 y%D1.16.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1 ny%B1.1.1 f%B1.1.1 no%B1.1.1 out%D1.16.1 zr%B1.1.1 ng%B1.1.1;

// Ejemplo de caso (ajustar valores y bits de control según el diseño final):
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

// TODO: añadir más casos (x=y=-1, x=17 y=3, overflow en 32 bits, etc.)
