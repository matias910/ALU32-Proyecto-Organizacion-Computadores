# Objetivo 2 — ALU de tres entradas (X, Y, Z)

**Responsables:** Persona 2 (diseño e implementación) · Persona 3 (pruebas y análisis de viabilidad)

## Descripción

Diseño de una ALU no convencional que acepta **tres** operandos de entrada de 16 bits
(`X`, `Y`, `Z`) y ejecuta una de 8 operaciones lógicas y aritméticas combinadas, seleccionada
por un `opcode` de 3 bits.

## Contenido de esta carpeta

| Archivo | Descripción |
|---|---|
| `hdl/ALU3.hdl` | Implementación de la ALU de 3 entradas en HDL. |
| `tests/ALU3.tst` | Script de prueba para el Hardware Simulator. |
| `tests/ALU3.cmp` | Salida esperada para validar la implementación. |
| `diagramas/ALU3_diagrama.svg` | Diagrama de bloques/lógico de la arquitectura. |
| `analisis_viabilidad.md` | Análisis escrito de viabilidad arquitectónica. |

## Interfaz del chip

```
CHIP ALU3 {
    IN
        x[16], y[16], z[16],
        opcode[3];
    OUT
        out[16],
        zr, ng;
}
```

## Conjunto de operaciones

| `opcode` | Operación | Descripción |
|---|---|---|
| `000` | `X + Y + Z` | Suma de los tres operandos |
| `001` | `(X AND Y) OR Z` | Combinación lógica |
| `010` | `(X OR Y) AND Z` | Combinación lógica |
| `011` | `X AND Y AND Z` | AND de los tres operandos |
| `100` | `X OR Y OR Z` | OR de los tres operandos |
| `101` | `X + Y - Z` | Suma con resta (complemento a dos) |
| `110` | `(NOT X) AND Y AND Z` | Combinación lógica con negación |
| `111` | `-(X + Y + Z)` | Negación de la suma total |

## Estrategia de diseño

Las 8 operaciones se calculan **en paralelo** reutilizando subexpresiones compartidas
(`X AND Y`, `X OR Y`, `X + Y`), y el resultado final se elige con un `Mux8Way16` controlado
por `opcode`. Es una decisión de diseño intencionalmente simple de verificar y explicar,
aunque más costosa en área que una ALU reconfigurable — ese trade-off se discute a fondo en
[`analisis_viabilidad.md`](analisis_viabilidad.md).

## Análisis de viabilidad

El documento [`analisis_viabilidad.md`](analisis_viabilidad.md) responde de forma analítica
y detallada por qué (o no) es práctico en el mundo real diseñar y fabricar una ALU con tres
operandos de entrada, evaluando el impacto en el conjunto de instrucciones, el consumo de
energía y la complejidad de la unidad de control. Este análisis también se sustenta oralmente
en el video de entrega (dentro de los 5 minutos asignados a esta pregunta).

## Cómo probar

1. Abrir `tests/ALU3.tst` en el Hardware Simulator de Nand2Tetris.
2. Ejecutar (`Run`) y confirmar comparación exitosa contra `tests/ALU3.cmp`.
