# Análisis de Arquitectura — Viabilidad de una ALU de tres operandos

**Responsable:** Persona 3

> ¿Por qué es práctico (o no) en el mundo real diseñar y fabricar una ALU con tres operandos
> de entrada? Evaluar el impacto en el conjunto de instrucciones, el consumo de energía y la
> complejidad de la unidad de control.

## 1. Impacto en el conjunto de instrucciones (ISA)

_TODO: analizar cómo cambiaría la codificación de instrucciones al necesitar direccionar tres
operandos fuente en lugar de dos (ancho de instrucción, formatos de registro-registro vs.
registro-memoria, comparación con arquitecturas reales de tres operandos como RISC-V/ARM que
solo usan tres *registros*, no un tercer operando combinado en la ALU)._

## 2. Consumo de energía y área de silicio

_TODO: discutir el crecimiento del área y la potencia dinámica al añadir un tercer bus de 16
bits, puertos de lectura adicionales en el banco de registros, y mayor profundidad lógica
(más niveles de compuertas → mayor retardo y/o mayor consumo)._

## 3. Complejidad de la unidad de control

_TODO: analizar el crecimiento del espacio de codificación de control (más bits de opcode),
el impacto en el diseño del decodificador y en el pipeline (más puertos de lectura en la etapa
de registro, posibles hazards adicionales)._

## 4. Conclusión

_TODO: sintetizar si, en el balance costo/beneficio, una ALU de tres operandos es viable para
propósito general o si su utilidad se limita a aceleradores especializados (p. ej. unidades
FMA — *fused multiply-add* — que sí usan tres operandos en hardware real)._

## Referencias

_TODO: citar fuentes usadas (libros de arquitectura de computadores, documentación de ISA,
papers sobre unidades FMA, etc.)._
