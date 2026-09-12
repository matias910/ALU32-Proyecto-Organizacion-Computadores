// Script de prueba de la ALU de 32 bits.
// Cubre las 18 operaciones estandar del chip ALU, con 3 casos cada una:
//   (a) ambos operandos en cero
//   (b) mitad baja en el limite (0xFFFF / 0x0001), que fuerza acarreo al bit 16
//   (c) valores mixtos con el bit 15 activo en ambas mitades
//
// Los valores van en binario porque un numero de 32 bits se representa aqui
// como dos pines de 16, y asi se ve directamente el acarreo cruzando la frontera.

load ALU32.hdl,
output-file ALU32.out,
compare-to ALU32.cmp,
output-list xHigh%B1.16.1 xLow%B1.16.1 yHigh%B1.16.1 yLow%B1.16.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1 ny%B1.1.1 f%B1.1.1 no%B1.1.1 outHigh%B1.16.1 outLow%B1.16.1 zr%B1.1.1 ng%B1.1.1;

// ===== 0  (constante 0)
//       zx=1 nx=0 zy=1 ny=0 f=1 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 0, set zy 1, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 0, set zy 1, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 0, set zy 1, set ny 0, set f 1, set no 0,
eval, output;

// ===== 1  (constante 1 - requiere correccion con no=1)
//       zx=1 nx=1 zy=1 ny=1 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 1, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 1, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 1, set ny 1, set f 1, set no 1,
eval, output;

// ===== -1  (constante -1)
//       zx=1 nx=1 zy=1 ny=0 f=1 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 1, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 1, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 1, set ny 0, set f 1, set no 0,
eval, output;

// ===== x  (x)
//       zx=0 nx=0 zy=1 ny=1 f=0 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 0,
eval, output;

// ===== y  (y)
//       zx=1 nx=1 zy=0 ny=0 f=0 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 0,
eval, output;

// ===== !x  (NOT x)
//       zx=0 nx=0 zy=1 ny=1 f=0 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 1,
eval, output;

// ===== !y  (NOT y)
//       zx=1 nx=1 zy=0 ny=0 f=0 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 1,
eval, output;

// ===== -x  (-x - requiere correccion con no=1)
//       zx=0 nx=0 zy=1 ny=1 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 1,
eval, output;

// ===== -y  (-y - requiere correccion con no=1)
//       zx=1 nx=1 zy=0 ny=0 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 0, set ny 0, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 1, set no 1,
eval, output;

// ===== x+1  (x+1 - requiere correccion con no=1)
//       zx=0 nx=1 zy=1 ny=1 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 1, set zy 1, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 1, set zy 1, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 1, set zy 1, set ny 1, set f 1, set no 1,
eval, output;

// ===== y+1  (y+1 - requiere correccion con no=1)
//       zx=1 nx=1 zy=0 ny=1 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 0, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 0, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 0, set ny 1, set f 1, set no 1,
eval, output;

// ===== x-1  (x-1 - prestamo entre mitades)
//       zx=0 nx=0 zy=1 ny=1 f=1 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 1, set ny 1, set f 1, set no 0,
eval, output;

// ===== y-1  (y-1 - prestamo entre mitades)
//       zx=1 nx=1 zy=0 ny=0 f=1 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 1, set nx 1, set zy 0, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 1, set nx 1, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// ===== x+y  (x+y - acarreo entre mitades)
//       zx=0 nx=0 zy=0 ny=0 f=1 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0,
eval, output;

// ===== x-y  (x-y - requiere correccion con no=1)
//       zx=0 nx=1 zy=0 ny=0 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 1, set zy 0, set ny 0, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 1, set zy 0, set ny 0, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 1, set zy 0, set ny 0, set f 1, set no 1,
eval, output;

// ===== y-x  (y-x - requiere correccion con no=1)
//       zx=0 nx=0 zy=0 ny=1 f=1 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 0, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 0, set ny 1, set f 1, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 0, set ny 1, set f 1, set no 1,
eval, output;

// ===== x&y  (AND bit a bit)
//       zx=0 nx=0 zy=0 ny=0 f=0 no=0
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 0,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 0,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 0,
eval, output;

// ===== x|y  (OR bit a bit)
//       zx=0 nx=1 zy=0 ny=1 f=0 no=1
set xHigh %B0000000000000000, set xLow %B0000000000000000,
set yHigh %B0000000000000000, set yLow %B0000000000000000,
set zx 0, set nx 1, set zy 0, set ny 1, set f 0, set no 1,
eval, output;
set xHigh %B0000000000000000, set xLow %B1111111111111111,
set yHigh %B0000000000000000, set yLow %B0000000000000001,
set zx 0, set nx 1, set zy 0, set ny 1, set f 0, set no 1,
eval, output;
set xHigh %B1111000011110000, set xLow %B1000000000000001,
set yHigh %B0000111100001111, set yLow %B1000000000000000,
set zx 0, set nx 1, set zy 0, set ny 1, set f 0, set no 1,
eval, output;

