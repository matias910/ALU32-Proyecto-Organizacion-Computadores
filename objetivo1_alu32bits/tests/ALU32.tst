// Script de prueba de la ALU de 32 bits.
// Los valores se escriben en binario (%B) porque un numero de 32 bits se
// representa aqui como dos pines de 16, y el binario deja ver directamente
// el acarreo cruzando la frontera del bit 15 al 16.

load ALU32.hdl,
output-file ALU32.out,
compare-to ALU32.cmp,
output-list xHigh%B1.16.1 xLow%B1.16.1 yHigh%B1.16.1 yLow%B1.16.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1 ny%B1.1.1 f%B1.1.1 no%B1.1.1 outHigh%B1.16.1 outLow%B1.16.1 zr%B1.1.1 ng%B1.1.1;

// 1) 0 + 0 = 0  -> verifica zr
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// 2) 17 + 3 = 20, sin acarreo entre mitades
set xHigh %B0000000000000000, set xLow %B0000000000010001,
set yHigh %B0000000000000000, set yLow %B0000000000000011,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// 3) CASO CLAVE: 65535 + 1. La mitad baja desborda y el acarreo
//    debe subir a la mitad alta -> outHigh = 1, outLow = 0
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// 4) (-1) + 1 = 0 en 32 bits -> zr = 1, exige acarreo cruzando
set xHigh %B1111111111111111, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// 5) Suma de dos negativos: (-1) + (-1) = -2
set xHigh %B1111111111111111, set xLow %B1111111111111111,
set yHigh %B1111111111111111, set yLow %B1111111111111111,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// 6) AND bit a bit (f=0). No hay acarreo: las dos mitades son independientes.
set xHigh %B1111000011110000, set xLow %B1111111100000000,
set yHigh %B1010101010101010, set yLow %B0000111111111111,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 0,
eval, output;

// 7) OR bit a bit, via De Morgan (nx=1, ny=1, f=0, no=1)
set xHigh %B1111000011110000, set xLow %B1111111100000000,
set yHigh %B1010101010101010, set yLow %B0000111111111111,
set zx 0, set nx 1, set zy 0, set ny 1, set f 0, set no 1,
eval, output;

// 8) CASO CLAVE: x-1 con prestamo cruzando la frontera.
//    x = 0x00050000. x-1 = 0x0004FFFF -> outHigh=4, outLow=0xFFFF
set xHigh %B0000000000000101, set xLow %B0000000000000000,
set yHigh %B0111011101110111, set yLow %B1000100010001000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 0,
eval, output;

// 9) CASO CLAVE: x-1 SIN prestamo, pero con y "sucio" en el bit 15.
//    x = 0x00050001. x-1 = 0x00050000 -> outHigh=5, outLow=0
//    Aqui es donde falla una formula de acarreo basada en los operandos
//    crudos: y no participa en x-1, pero su bit 15 esta en 1.
set xHigh %B0000000000000101, set xLow %B0000000000000001,
set yHigh %B0000000000000000, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 0,
eval, output;

// 10) CASO CLAVE: constante 0 (zx=1,nx=0,zy=1,ny=0,f=1,no=0) con x,y
//     que tienen el bit 15 en 1. El resultado debe ser 0 y zr=1.
set xHigh %B1111111111111111, set xLow %B1000000000000000,
set yHigh %B1111111111111111, set yLow %B1000000000000000,
set zx 1, set nx 0, set zy 1, set ny 0, set f 1, set no 0,
eval, output;

// 11) CASO CLAVE: constante -1 (zx=1,nx=1,zy=1,ny=0,f=1,no=0).
//     Resultado esperado: los 32 bits en 1, ng=1.
set xHigh %B1111111111111111, set xLow %B1000000000000000,
set yHigh %B1111111111111111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 1, set ny 0, set f 1, set no 0,
eval, output;
