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

- Documentar aquí cómo se adaptan/replican las señales de control al escalar de 16 a 32 bits
  (p. ej. extensión de los sumadores, multiplexores y compuertas de negación/enmascarado).
- Incluir capturas o exportar el diagrama de bloques a `diagramas/` antes de la entrega final.

## Cómo probar

1. Abrir `tests/ALU32.tst` en el Hardware Simulator de Nand2Tetris.
2. Ejecutar (`Run`) y confirmar comparación exitosa contra `tests/ALU32.cmp`.
