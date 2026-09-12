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
[`objetivo1_alu32bits/diagramas/ALU32 Diagrama.pdf`](../objetivo1_alu32bits/diagramas/ALU32%20Diagrama.pdf).

### 2.2 Implementación

Las operaciones bit a bit (AND, OR, NOT) quedan correctas de inmediato al aplicar el mismo
control a ambas mitades, porque no dependen de bits vecinos. Las operaciones aritméticas sí
necesitan propagar un acarreo del bit 15 al bit 16, y ahí aparece la dificultad central del
objetivo: **el chip `ALU` no expone su acarreo de salida**. La señal existe dentro del chip,
pero su interfaz la descarta, así que no se puede leer. Hay que reconstruirla desde afuera.

La reconstrucción usa la identidad del sumador completo
(`carry_out = mayoría(a, b, carry_in)`), reescrita a partir de `suma = a XOR b XOR carry_in`
para no depender del carry-in, que tampoco es observable:

```
carry = (a15 AND b15) OR ((a15 XOR b15) AND NOT suma15)
```

Para que esta fórmula sea válida en las 18 operaciones estándar hacen falta dos precisiones:

**(a) `a15` y `b15` son los bits 15 de los operandos *efectivos*, no de los de entrada.**
Antes de sumar, la ALU aplica `zx`/`nx` sobre `x` y `zy`/`ny` sobre `y`. Toda operación que
ponga en cero o niegue un operando trabaja internamente con valores distintos a los que
entraron al chip. Son cinco las operaciones con `f=1, no=0` —`x+y`, `x-1`, `y-1`, la constante
`0` y la constante `-1`— y en cuatro de ellas los operandos efectivos difieren de los crudos.
El circuito replica ese preprocesamiento sobre un solo bit (`And` con `NOT zx`, luego `Xor`
con `nx`) antes de calcular el acarreo.

**(b) `suma15` es el bit de suma real, no siempre el bit visible.** Cuando `no=1` la ALU
expone `NOT(suma)`. Invertir el bit visible (un `Xor` contra `no`) recupera el bit de suma
verdadero, de modo que el acarreo también es reconstruible en esas operaciones.

La corrección de la mitad alta depende entonces de lo que esa mitad esté mostrando:

| | la mitad alta muestra | corrección aplicada |
|---|---|---|
| `no=0` | la suma `s` | `s + 1` mediante `Inc16` |
| `no=1` | `NOT(s)` | restar 1, ya que `NOT(s+1) = NOT(s) − 1` |

El decremento se obtiene con `Not16` + `Inc16` + `Not16`, y un `Mux16` selecciona entre la
mitad alta sin corregir y la corregida según el bit de acarreo. El archivo completo está en
[`objetivo1_alu32bits/hdl/ALU32.hdl`](../objetivo1_alu32bits/hdl/ALU32.hdl).

**Sobre el costo de este enfoque.** Que la reconstrucción funcione no significa que sea la
forma correcta de construir una ALU de 32 bits. Una implementación real encadena las etapas
con `carry_in`/`carry_out` explícitos, o usa un sumador con acarreo anticipado. Aquí se pagan
compuertas y retardo adicionales para recuperar por fuera una señal que el hardware ya calculó
por dentro y descartó, y el resultado sigue siendo un acarreo propagado en serie entre las dos
mitades. Esta distancia entre "funciona" y "es como se hace" es el mismo tipo de costo oculto
que se analiza para la ALU de tres operandos (ver sección 3 del análisis de viabilidad).

### 2.3 Resultados de las pruebas

`ALU32.tst` cubre **las 18 operaciones estándar de la ALU con 3 casos cada una (54 en
total)**. Para cada operación se prueban: ambos operandos en cero, un caso con la mitad baja
en el límite (`0xFFFF` / `0x0001`) que fuerza el acarreo a cruzar al bit 16, y un caso con
valores mixtos y el bit 15 activo en ambas mitades.

Los valores esperados en `ALU32.cmp` **se generaron ejecutando el circuito en el Hardware
Simulator**, no calculándolos a mano. La corrida termina con
`End of script - Comparison ended successfully`.

Además de esas 54 filas, el diseño se contrastó contra un modelo de referencia independiente
(una ALU de 32 bits ideal, calculada aritméticamente y no por composición de mitades) sobre
720 casos aleatorios y de frontera repartidos entre las 18 operaciones. El resultado fue
correcto en el 100 % de los casos, incluidas las banderas `zr` y `ng`.

Conviene dejar constancia de dos errores detectados y corregidos durante esta verificación,
porque ninguno se manifestaba en las pruebas iniciales:

1. **Acarreo calculado sobre los operandos crudos.** Las operaciones `x-1`, `y-1` y las
   constantes `0` y `-1` también cumplen `f=1, no=0`, y en ellas los operandos efectivos no
   coinciden con los de entrada. La constante `-1`, por ejemplo, devolvía `0x0000FFFF` en vez
   de `0xFFFFFFFF`.

2. **Correcciones bloqueadas cuando `no=1`.** Siete de las 18 operaciones quedaban sin
   corregir. El caso más visible era la constante `1`, que devolvía `0x00010001` en lugar de
   `0x00000001`: cada mitad calculaba `0xFFFF + 0xFFFF = 0xFFFE` y negaba a `0x0001`, sin que
   el acarreo perdido entre mitades se compensara nunca.

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
[`objetivo2_alu3entradas/diagramas/ALU de 3 Diagrama.drawio.pdf`](../objetivo2_alu3entradas/diagramas/ALU%20de%203%20Diagrama.drawio.pdf)
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
