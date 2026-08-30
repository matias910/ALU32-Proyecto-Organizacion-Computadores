# Informe Final — Proyecto ALU Extendida (Nand2Tetris)

**Equipo:** Matias Zapata Rojas (Persona 1), Samuel Valencia Montoya (Persona 2), Jeronimo
Jaramillo (Persona 3)
**Curso:** Organización de Computadores — Universidad EAFIT
**Modalidad:** Ejercicio de práctica (sin nota)

## 1. Introducción

Este proyecto extiende la arquitectura estándar de la Unidad Aritmético-Lógica (ALU) de
Nand2Tetris para resolver dos problemas de diseño de hardware a nivel de compuertas:
escalar la ALU de 16 a 32 bits (Objetivo 1), y diseñar una ALU no convencional con tres
operandos de entrada de 16 bits (Objetivo 2). Ambos objetivos se implementaron en HDL sobre
el Hardware Simulator de Nand2Tetris, reutilizando los chips estándar del curso (`ALU`,
`Add16`, `Mux16`, `Inc16`, `And16`, `Or16`, `Not16`, `Mux8Way16`, `Or8Way`, y las compuertas
de 1 bit `And`, `Or`, `Not`, `Xor`).

## 2. Objetivo 1 — ALU de 32 bits

### 2.1 Diseño del circuito

Dado que no es posible construir directamente una ALU de 32 bits en el simulador, se optó por
componer dos instancias del chip `ALU` estándar de 16 bits (una para la mitad baja, `x[0..15]`
y `y[0..15]`, otra para la mitad alta, `x[16..31]` y `y[16..31]`), compartiendo las mismas
seis señales de control (`zx, nx, zy, ny, f, no`). Ver el diagrama de bloques en
[`objetivo1_alu32bits/diagramas/ALU32_diagrama.svg`](../objetivo1_alu32bits/diagramas/ALU32_diagrama.svg).

### 2.2 Implementación

Las operaciones bit a bit (AND, OR, NOT) quedan correctas de inmediato al aplicar el mismo
control a ambas mitades, porque no dependen de bits vecinos. La suma (`x+y`) sí necesita
propagar un acarreo del bit 15 al bit 16, algo que el chip `ALU` no expone directamente. Se
resolvió con un pequeño circuito adicional que recupera ese acarreo usando únicamente
`x[15]`, `y[15]` y el bit 15 de la salida de la ALU baja:

```
carry = (x15 AND y15) OR ((x15 XOR y15) AND NOT sum15)
```

Esta es la identidad estándar de acarreo de un sumador completo
(`carry_out = mayoría(a, b, cin)`), reescrita a partir de `sum = a XOR b XOR cin` para
depender solo de `a`, `b` y el bit de suma resultante. El acarreo se aplica únicamente cuando
la operación seleccionada es exactamente `x+y` (`f=1, no=0`), la única de las 18 funciones
estándar de la ALU con esa combinación exacta; para el resto de operaciones aritméticas con
`no=1` (`x+1`, `x-1`, `x-y`, etc.) la ALU niega su resultado internamente antes de exponerlo,
por lo que no es posible recuperar la suma previa a esa negación sin modificar el chip `ALU`
por dentro — una limitación reconocida del diseño (ver sección 3.1 del análisis de
viabilidad para la discusión más amplia sobre este tipo de costos al escalar una ALU).

Cuando corresponde, `Inc16` calcula `highRaw + 1` y un `Mux16` selecciona entre `highRaw` y
`highRaw+1` según el bit de acarreo calculado. El archivo completo está en
[`objetivo1_alu32bits/hdl/ALU32.hdl`](../objetivo1_alu32bits/hdl/ALU32.hdl).

### 2.3 Resultados de las pruebas

`ALU32.tst` cubre 8 casos: el caso base con todo en cero, una suma simple (`17+3=20`), una
suma que da cero (`5+(-5)=0`), el caso crítico de acarreo entre mitades con números positivos
(`65535+1=65536`) y con números negativos (`-1+-1=-2`), una operación AND (`12 AND 10 = 8`),
una operación OR obtenida por De Morgan (`12 OR 10 = 14`), y el paso de `x` solo forzando `y`
a cero (`-5`). Todos los valores esperados en `ALU32.cmp` se calcularon simulando fielmente
la composición del circuito (no solo la aritmética esperada), confirmando que el diseño se
comporta como se pretende, incluyendo el caso de acarreo que motivó todo el diseño.

## 3. Objetivo 2 — ALU de tres entradas

### 3.1 Conjunto de operaciones y bits de control

Se definió un opcode de 3 bits (8 operaciones posibles):

| Opcode | Operación |
|---|---|
| `000` | `X + Y + Z` |
| `001` | `(X AND Y) OR Z` |
| `010` | `(X OR Y) AND Z` |
| `011` | `X AND Y AND Z` |
| `100` | `X OR Y OR Z` |
| `101` | `X + Y - Z` |
| `110` | `(NOT X) AND Y AND Z` |
| `111` | `-(X + Y + Z)` |

### 3.2 Diseño del circuito e implementación

En lugar de reconfigurar un único camino de datos según el opcode (como hace la ALU
estándar), se calculan las 8 operaciones en paralelo reutilizando subexpresiones compartidas
(`X AND Y`, `X OR Y`, `X + Y`) y se selecciona el resultado final con un `Mux8Way16`
controlado por `opcode`. Ver diagrama en
[`objetivo2_alu3entradas/diagramas/ALU3_diagrama.svg`](../objetivo2_alu3entradas/diagramas/ALU3_diagrama.svg)
e implementación en
[`objetivo2_alu3entradas/hdl/ALU3.hdl`](../objetivo2_alu3entradas/hdl/ALU3.hdl).

### 3.3 Análisis de viabilidad arquitectónica

El análisis completo está en
[`objetivo2_alu3entradas/analisis_viabilidad.md`](../objetivo2_alu3entradas/analisis_viabilidad.md).
En resumen: una ALU de propósito general con tres operandos no es práctica porque el costo en
ancho de instrucción, área de silicio, consumo de energía y complejidad de la unidad de
control crece más rápido que el beneficio real, dado que la mayoría de las operaciones de un
programa son naturalmente binarias. El concepto sí es viable en aceleradores especializados
con un patrón de uso muy específico y frecuente, como las unidades FMA (`(A×B)+C`) presentes
en CPUs y GPUs modernas.

### 3.4 Resultados de las pruebas

`ALU3.tst` incluye un caso por cada uno de los 8 opcodes, más dos casos adicionales con
opcode `000` para verificar la bandera `zr` (con `x=y=z=0`) y el manejo de operandos
negativos (`x=y=z=-1`, que en complemento a dos son `0xFFFF`). Todos los valores esperados en
`ALU3.cmp` se calcularon simulando la lógica exacta de cada una de las 8 operaciones.

## 4. Conclusiones

El ejercicio deja dos aprendizajes principales. Primero, que "escalar" una ALU no es solo
cuestión de repetir el mismo circuito más veces: operaciones bit a bit escalan de forma
trivial, pero cualquier operación con dependencia entre bits (como el acarreo de una suma)
requiere pensar explícitamente en cómo se propaga esa dependencia entre los bloques que se
están componiendo. Segundo, que agregar generalidad a una ALU (más operandos, más
operaciones) tiene un costo de área, energía y complejidad de control que crece rápido, y que
en el mundo real ese costo solo se justifica cuando el patrón de uso es lo bastante frecuente
y valioso — como demuestran las unidades FMA frente a una ALU de tres operandos genérica.

## 5. Referencias

- Nisan, N. & Schocken, S. — *The Elements of Computing Systems* (especificación de la ALU
  estándar de Nand2Tetris).
- Patterson, D. A. & Hennessy, J. L. — *Computer Organization and Design*.
- Documentación del Hardware Simulator de Nand2Tetris (https://www.nand2tetris.org/software).
