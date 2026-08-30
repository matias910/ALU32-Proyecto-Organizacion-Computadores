# Objetivo 1 — ALU de 32 bits

**Responsable:** Persona 1

## Descripción

Escalado de la ALU estándar de 16 bits de Nand2Tetris para soportar operaciones con palabras
de **32 bits**, manteniendo el mismo conjunto de señales de control (`zx`, `nx`, `zy`, `ny`,
`f`, `no`).

## Contenido de esta carpeta

| Archivo | Descripción |
|---|---|
| `hdl/ALU32.hdl` | Implementación de la ALU de 32 bits en HDL. |
| `tests/ALU32.tst` | Script de prueba para el Hardware Simulator. |
| `tests/ALU32.cmp` | Salida esperada para validar la implementación. |
| `diagramas/` | Diagrama de bloques/lógico de la arquitectura escalada. |

## Interfaz del chip

```
CHIP ALU32 {
    IN
        x[32], y[32],
        zx, nx, zy, ny,
        f, no;
    OUT
        out[32],
        zr, ng;
}
```

## Notas de diseño

Se componen dos chips `ALU` estándar (mitad baja y mitad alta), compartiendo las mismas seis
señales de control. Las operaciones bit a bit (AND, OR, NOT) quedan correctas de inmediato al
replicar el control en ambas mitades. La suma (`x+y`) necesita propagar un acarreo del bit 15
al bit 16, que no está expuesto por el chip `ALU`; se recupera con:

```
carry = (x15 AND y15) OR ((x15 XOR y15) AND NOT sum15)
```

aplicado solo cuando `f=1, no=0` (la única de las 18 funciones estándar con esa combinación),
y se corrige la mitad alta con `Inc16` + `Mux16`. Ver el detalle completo en
[`docs/informe_final.md`](../docs/informe_final.md#21-diseño-del-circuito) y el diagrama en
[`diagramas/ALU32_diagrama.svg`](diagramas/ALU32_diagrama.svg).

**Limitación conocida:** para operaciones con `no=1` (`x+1`, `x-1`, `x-y`, etc.) el acarreo
no se corrige, porque la ALU niega su resultado internamente antes de exponerlo y no es
posible recuperar la suma previa a esa negación sin modificar el chip por dentro.

## Cómo probar

1. Abrir `tests/ALU32.tst` en el Hardware Simulator de Nand2Tetris.
2. Ejecutar (`Run`) y confirmar comparación exitosa contra `tests/ALU32.cmp`.
