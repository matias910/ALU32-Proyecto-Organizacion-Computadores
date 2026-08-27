// Objetivo 2 - Proyecto ALU Nand2Tetris
// Script de prueba: ALU3.tst
// Responsable: Persona 2 (con apoyo de Persona 3)
//
// TODO: completar un caso de prueba por cada operación definida en el conjunto de
// operaciones (ver README.md de esta carpeta), cubriendo casos de borde (ceros, negativos).

load ALU3.hdl,
output-file ALU3.out,
compare-to ALU3.cmp,
output-list x%D1.6.1 y%D1.6.1 z%D1.6.1 opcode%B1.3.1 out%D1.6.1 zr%B1.1.1 ng%B1.1.1;

// Ejemplo de caso (ajustar valores y opcode según el diseño final):
set x 1,
set y 2,
set z 3,
set opcode %B000,
eval,
output;

// TODO: añadir un caso por cada operación del conjunto definido
