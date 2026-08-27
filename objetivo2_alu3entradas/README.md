# Objetivo 2 — ALU de tres entradas (X, Y, Z)

**Responsables:** Persona 2 (diseño e implementación) · Persona 3 (pruebas y análisis de viabilidad)

## Descripción

Diseño de una ALU no convencional que acepta **tres** operandos de entrada de 16 bits
(`X`, `Y`, `Z`) y ejecuta un conjunto definido de operaciones lógicas y aritméticas
combinadas (p. ej. `X+Y+Z`, `(X AND Y) OR Z`).

## Contenido de esta carpeta

| Archivo | Descripción |
|---|---|
| `hdl/ALU3.hdl` | Implementación de la ALU de 3 entradas en HDL. |
| `tests/ALU3.tst` | Script de prueba para el Hardware Simulator. |
| `tests/ALU3.cmp` | Salida esperada para validar la implementación. |
| `diagramas/` | Diagrama de bloques/lógico de la arquitectura. |
| `analisis_viabilidad.md` | Análisis escrito de viabilidad arquitectónica (obligatorio). |

## Interfaz del chip

```
CHIP ALU3 {
    IN
        x[16], y[16], z[16],
        opcode[?];    // TODO: definir el número de bits de control necesarios
    OUT
        out[16],
        zr, ng;
}
```

## Conjunto de operaciones (a definir por Persona 2)

| `opcode` | Operación | Descripción |
|---|---|---|
| `000` | `X + Y + Z` | Suma de los tres operandos |
| `001` | `(X AND Y) OR Z` | Combinación lógica |
| ... | ... | Completar según diseño final |

> Documentar aquí la tabla completa de bits de control → operación antes de la entrega final.

## Análisis de viabilidad

El documento [`analisis_viabilidad.md`](analisis_viabilidad.md) debe responder de forma
analítica y detallada: ¿por qué es práctico (o no) en el mundo real diseñar y fabricar una ALU
con tres operandos de entrada? Se debe evaluar el impacto en el conjunto de instrucciones, el
consumo de energía y la complejidad de la unidad de control. Este análisis también se sustenta
oralmente en el video de entrega (dentro de los 5 minutos asignados a esta pregunta).

## Cómo probar

1. Abrir `tests/ALU3.tst` en el Hardware Simulator de Nand2Tetris.
2. Ejecutar (`Run`) y confirmar comparación exitosa contra `tests/ALU3.cmp`.
