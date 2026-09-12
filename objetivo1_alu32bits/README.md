# Objetivo 1 — ALU de 32 bits

**Responsable:** Persona 1

## Descripción

Escalado de la ALU estándar de 16 bits de Nand2Tetris para soportar operaciones con palabras
de **32 bits**, manteniendo el mismo conjunto de señales de control (`zx`, `nx`, `zy`, `ny`,
`f`, `no`). El chip `ALU` del curso se usa como caja negra: no se modifica por dentro.

## Contenido de esta carpeta

| Archivo | Descripción |
|---|---|
| `hdl/ALU32.hdl` | Implementación de la ALU de 32 bits en HDL. |
| `tests/ALU32.hdl` | Copia del chip. El simulador resuelve el `load` relativo a la carpeta del `.tst`, así que necesita el archivo aquí. **Si se modifica uno, hay que modificar el otro.** |
| `tests/ALU32.tst` | Script de prueba: 54 casos que cubren las 18 operaciones estándar. |
| `tests/ALU32.cmp` | Salida esperada, generada por ejecución real en el Hardware Simulator. |
| `diagramas/` | Diagrama de bloques/lógico de la arquitectura escalada. |

## Interfaz del chip

```
CHIP ALU32 {
    IN
        xLow[16], xHigh[16],
        yLow[16], yHigh[16],
        zx, nx, zy, ny,
        f, no;
    OUT
        outLow[16], outHigh[16],
        zr, ng;
}
```

Los operandos y el resultado de 32 bits se representan como dos pines de 16 bits cada uno
(mitad baja y mitad alta). Esto no es una decisión de diseño sino una restricción del
Hardware Simulator, que no admite pines de más de 16 bits: declarar `x[32]` provoca el error
`Index 16 out of bounds for length 16`.

## Notas de diseño

Se componen dos chips `ALU` estándar (mitad baja y mitad alta) compartiendo las mismas seis
señales de control. Las operaciones bit a bit (AND, OR, NOT) quedan correctas de inmediato al
replicar el control en ambas mitades, porque no dependen de bits vecinos.

Las operaciones aritméticas sí necesitan propagar un acarreo del bit 15 al bit 16. El chip
`ALU` no expone su acarreo de salida, así que no se puede leer: hay que **reconstruirlo desde
afuera** con la identidad del sumador completo, escrita para no depender del carry-in:

```
carry = (a15 AND b15) OR ((a15 XOR b15) AND NOT suma15)
```

Dos detalles hacen que esta reconstrucción valga para las 18 operaciones:

1. **`a15` y `b15` son los bits 15 de los operandos *efectivos***, no de los crudos: es decir,
   después de aplicar `zx`/`nx`/`zy`/`ny`. Cualquier operación que ponga en cero o niegue un
   operando (`x-1`, `y-1`, la constante `0`, la constante `-1`) trabaja internamente con
   valores distintos a los de entrada, y usar los crudos da un acarreo equivocado.

2. **`suma15` es el bit de suma real.** Cuando `no=1`, la ALU expone `NOT(suma)`, así que el
   bit visible se invierte (XOR contra `no`) para recuperar el bit de suma verdadero.

La corrección de la mitad alta depende de lo que esa mitad esté mostrando:

| | la mitad alta muestra | corrección |
|---|---|---|
| `no=0` | la suma `s` | `s + 1` (`Inc16`) |
| `no=1` | `NOT(s)` | restar 1, porque `NOT(s+1) = NOT(s) − 1` |

**Alcance:** correcto para las 18 operaciones estándar de la ALU. Verificado con 54 casos en
`tests/ALU32.tst` y con una prueba adicional de 720 casos aleatorios sobre las 18 operaciones.

## Limitación arquitectónica (documentada, no corregida)

La reconstrucción del acarreo funciona, pero existe únicamente porque el chip `ALU` del curso
no expone `carry_out` en su interfaz. Una ALU de 32 bits real no se construye así: se encadena
con `carry_in`/`carry_out` explícitos, o se usa un sumador con acarreo anticipado. Componer
dos ALU de 16 bits obliga a pagar compuertas y retardo adicionales para recuperar por fuera
una señal que el hardware ya calculó por dentro y descartó.

Esa diferencia entre "funciona" y "es como se hace en la práctica" es parte de la discusión de
viabilidad en [`docs/informe_final.md`](../docs/informe_final.md) y en
[`analisis_viabilidad.md`](../objetivo2_alu3entradas/analisis_viabilidad.md).

## Cómo probar

1. Abrir `tests/ALU32.tst` en el Hardware Simulator de Nand2Tetris.
2. Ejecutar (`Run`) y confirmar la comparación contra `tests/ALU32.cmp`.
3. La corrida debe terminar con `End of script - Comparison ended successfully`.
