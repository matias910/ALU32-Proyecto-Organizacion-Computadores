# ALU Extendida — Proyecto Nand2Tetris

[![Plataforma](https://img.shields.io/badge/plataforma-Nand2Tetris-2E5590)](https://www.nand2tetris.org/)
[![Estado](https://img.shields.io/badge/estado-en%20desarrollo-yellow)]()
[![Licencia](https://img.shields.io/badge/uso-académico-lightgrey)]()

Proyecto académico que extiende la arquitectura estándar de la Unidad Aritmético Lógica (ALU)
del curso, implementada a nivel de compuertas en la plataforma **Nand2Tetris**, para resolver
dos problemas de diseño de hardware.

## 📋 Descripción del proyecto

Este proyecto desarrolla la comprensión de la arquitectura de la ALU y su implementación a
nivel de compuertas, extendiendo la ALU estándar de 16 bits del curso para resolver dos retos
de diseño específicos:

- **Objetivo 1:** Escalar la ALU estándar de 16 bits para soportar operaciones con palabras de
  **32 bits**.
- **Objetivo 2:** Diseñar una ALU no convencional con **tres operandos de entrada** de 16 bits
  (`X`, `Y`, `Z`), definiendo su conjunto de operaciones y evaluando su viabilidad real.

## 🎯 Objetivos

### Objetivo 1 — ALU de 32 bits
Tomando como base la ALU estándar de 16 bits, se escala la arquitectura para operar sobre
palabras de 32 bits.
- Diagrama de bloques/lógico detallando la adaptación de las señales de control a 32 bits.
- Archivo `.hdl` funcional, construido con las compuertas base de Nand2Tetris.

### Objetivo 2 — ALU de tres entradas (X, Y, Z)
Diseño de una ALU que acepta tres operandos de 16 bits.
- Definición explícita del conjunto de operaciones lógicas y aritméticas (p. ej. `X+Y+Z`,
  `(X AND Y) OR Z`) y de los bits de control para seleccionarlas.
- Diseño de circuito e implementación `.hdl` que integra la tercera entrada.
- Análisis arquitectónico escrito sobre la viabilidad real de una ALU de tres operandos: impacto
  en el conjunto de instrucciones, consumo de energía y complejidad de la unidad de control.

## 👥 Equipo y roles

| Integrante   | Rol principal                                  | Responsabilidad central |
|--------------|-------------------------------------------------|--------------------------|
| **Persona 1** | Líder Objetivo 1 (ALU 32 bits)                 | Diseño del circuito y desarrollo del `.hdl` de la ALU de 32 bits |
| **Persona 2** | Líder Objetivo 2 — Diseño (ALU de 3 entradas)  | Definición del conjunto de operaciones, bits de control y `.hdl` |
| **Persona 3** | Líder de Pruebas, Análisis y Documentación     | Scripts de prueba, análisis de viabilidad y consolidación del informe |

El cronograma detallado de 2 semanas y la distribución día a día están en
[`docs/plan_de_trabajo.md`](docs/plan_de_trabajo.md).

## 📁 Estructura del repositorio

```
alu-nand2tetris-proyecto/
├── README.md                          # Este archivo
├── .gitignore
├── docs/
│   ├── plan_de_trabajo.md             # Cronograma y asignación de tareas
│   ├── informe_final.md               # Informe: esquema, HDL y estrategia
│   └── video_sustentacion.md          # Enlace y guion del video (máx. 10 min)
├── objetivo1_alu32bits/
│   ├── README.md
│   ├── hdl/
│   │   └── ALU32.hdl                  # Implementación de la ALU de 32 bits
│   ├── tests/
│   │   ├── ALU32.tst                  # Script de prueba
│   │   └── ALU32.cmp                  # Salida esperada (comparación)
│   └── diagramas/                     # Diagrama de bloques/lógico (imagen o PDF)
└── objetivo2_alu3entradas/
    ├── README.md
    ├── hdl/
    │   └── ALU3.hdl                   # Implementación de la ALU de 3 entradas
    ├── tests/
    │   ├── ALU3.tst
    │   └── ALU3.cmp
    ├── diagramas/
    └── analisis_viabilidad.md         # Análisis arquitectónico (Objetivo 2)
```

## ⚙️ Requisitos

- [Nand2Tetris Software Suite](https://www.nand2tetris.org/software) (Hardware Simulator).
- Java 8+ (requerido por el simulador de Nand2Tetris).

## ▶️ Cómo ejecutar las pruebas

1. Abrir el **Hardware Simulator** de Nand2Tetris.
2. Cargar el script de prueba correspondiente:
   - Objetivo 1: `objetivo1_alu32bits/tests/ALU32.tst`
   - Objetivo 2: `objetivo2_alu3entradas/tests/ALU3.tst`
3. Ejecutar (`Run`) y verificar que la comparación contra el archivo `.cmp` sea exitosa
   (mensaje `End of script - Comparison ended successfully`).

## 🔀 Flujo de trabajo con Git

- `main`: rama estable, solo recibe *merges* revisados por el equipo.
- `objetivo1-alu32`: desarrollo de la ALU de 32 bits (Persona 1).
- `objetivo2-alu3entradas`: desarrollo de la ALU de 3 entradas (Persona 2).
- `docs-pruebas`: scripts de prueba, análisis y documentación (Persona 3).

Cada integrante trabaja en su rama y abre un *Pull Request* hacia `main` para revisión cruzada
antes de fusionar (ver plantilla en [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md)).

## 🎥 Entregables

- Video de sustentación (máx. 5 min por pregunta, 10 min en total) — enlace en
  [`docs/video_sustentacion.md`](docs/video_sustentacion.md).
- Documento con el esquema de chip, el código HDL y la estrategia —
  [`docs/informe_final.md`](docs/informe_final.md).
- Evidencia enviada individualmente por cada integrante en EAFIT Interactiva.

## 📄 Licencia

Proyecto desarrollado con fines académicos para el curso de Arquitectura de Computadores /
Organización de Computadores. Uso educativo únicamente.
