# Análisis de Arquitectura — Viabilidad de una ALU de tres operandos

**Responsable:** Persona 3

> ¿Por qué es práctico (o no) en el mundo real diseñar y fabricar una ALU con tres operandos
> de entrada? Evaluar el impacto en el conjunto de instrucciones, el consumo de energía y la
> complejidad de la unidad de control.

## 1. Impacto en el conjunto de instrucciones (ISA)

Una instrucción binaria (dos operandos fuente) se codifica típicamente con dos campos de
registro fuente y uno de destino. Agregar un tercer operando fuente *combinado en la ALU*
(no solo un tercer registro, sino un tercer operando que la unidad aritmético-lógica debe
leer y procesar en el mismo ciclo) obliga a codificar un campo de registro adicional en cada
instrucción de este tipo. Con un banco de registros de 16 posiciones, por ejemplo, eso son 4
bits extra solo para nombrar el operando Z, sin contar los bits que ya harían falta para
seleccionar entre las 8 operaciones de nuestro `ALU3.hdl` (3 bits de opcode).

Esto es distinto de lo que hacen las arquitecturas reales de "tres operandos" como RISC-V o
ARM: ahí las instrucciones son de tres *registros* (`add rd, rs1, rs2`), pero la ALU interna
sigue operando sobre dos operandos a la vez — el tercer registro es simplemente el destino,
no una tercera entrada aritmética simultánea. Una ALU que combina tres entradas *dentro de la
misma operación* (como `X+Y+Z` en un solo paso) es mucho menos común porque no aparece de
forma natural en programas típicos: la mayoría del código se expresa como una secuencia de
operaciones binarias, no como sumas de tres operandos a la vez. Por eso el conjunto de
instrucciones tendría que crecer solo para dar cabida a un patrón de uso poco frecuente,
inflando el ancho de instrucción para todo el ISA aunque la mayoría de instrucciones nunca
use el tercer operando.

## 2. Consumo de energía y área de silicio

Añadir una tercera entrada de 16 bits implica: (a) un tercer bus de datos completo hacia la
ALU, (b) un puerto de lectura adicional en el banco de registros (los bancos de registros ya
son una de las estructuras más costosas en área y energía de un procesador, porque escalan
con el número de puertos, no solo con el número de registros), y (c) más profundidad lógica
dentro de la propia ALU. En nuestro diseño de `ALU3.hdl`, por ejemplo, la operación
`X+Y+Z` requiere encadenar dos sumadores de 16 bits (`Add16 → Add16`) en lugar de uno solo,
lo que duplica el retardo de propagación de esa ruta crítica.

Además, el enfoque de diseño elegido — calcular las 8 operaciones candidatas en paralelo y
seleccionar con un `Mux8Way16` — es simple de verificar y explicar, pero es costoso en área
y potencia dinámica precisamente porque *todas* las operaciones se calculan en cada ciclo,
aunque solo una se use. Un diseño más eficiente reconfiguraría las mismas compuertas para
cada operación (como hace la ALU estándar de Nand2Tetris con `zx/nx/zy/ny/f/no`), pero eso
exige una unidad de control bastante más sofisticada — es exactamente el trade-off que se
analiza en la siguiente sección.

## 3. Complejidad de la unidad de control

La ALU estándar de 16 bits se controla con 6 bits, suficientes para expresar 18 funciones
útiles reutilizando el mismo camino de datos (los mismos sumadores y compuertas AND, con
multiplexores que deciden qué se niega o se fuerza a cero antes y después). Una ALU de tres
operandos con un conjunto de operaciones igual de rico necesitaría, o bien: (a) un opcode más
ancho para seleccionar explícitamente entre muchas combinaciones (nuestro diseño usa solo 3
bits para 8 operaciones, pero cubre una fracción mucho menor del espacio de operaciones
posible que las 18 de la ALU estándar), o (b) una lógica de control mucho más elaborada que
combine señales tipo `zx/nx/zy/ny/f/no` para *tres* operandos en vez de dos, lo cual crece
más que linealmente porque las interacciones entre operandos (qué se suma con qué, qué se
niega antes o después) se multiplican.

Esto también complica el decodificador de instrucciones y, en un diseño segmentado
(*pipelined*), introduce más riesgos de dependencia de datos (*data hazards*): con tres
operandos fuente por instrucción hay más probabilidad de que alguno dependa de un resultado
que todavía no ha terminado de escribirse en el banco de registros, lo que puede forzar más
burbujas de espera (*stalls*) o una lógica de *forwarding* más compleja.

## 4. Conclusión

En el balance costo/beneficio, una ALU de propósito general con tres operandos de entrada no
resulta práctica: el costo en área, energía y complejidad de control crece más rápido que la
utilidad real, porque la gran mayoría de las operaciones de un programa son naturalmente
binarias. Sin embargo, el concepto no es inútil en general — existe precisamente en
*aceleradores especializados* donde el patrón de tres operandos sí es frecuente. El ejemplo
más conocido son las unidades **FMA (fused multiply-add)**, presentes en casi todas las CPUs
y GPUs modernas, que calculan `(A × B) + C` en una sola instrucción de hardware porque ese
patrón aparece constantemente en cómputo numérico (álgebra lineal, gráficos, redes
neuronales). La diferencia clave es que una unidad FMA no intenta ser una ALU de propósito
general con tres entradas arbitrarias: implementa *una* operación de tres operandos muy
específica y de alto valor, lo que justifica el costo adicional de área y energía porque el
beneficio en rendimiento para esa carga de trabajo es enorme. Nuestro `ALU3.hdl`, en cambio,
generaliza a 8 operaciones distintas — un buen ejercicio de diseño, pero exactamente el tipo
de generalidad que en silicio real casi nunca se paga.

## Referencias

- Patterson, D. A. & Hennessy, J. L. — *Computer Organization and Design* (capítulos sobre
  diseño de ALU y unidades de punto flotante con FMA).
- Especificación de la ISA RISC-V (formato de instrucciones tipo R, tres registros).
- Documentación pública de extensiones FMA en procesadores x86 (instrucción `VFMADD`) y en
  unidades de cómputo de GPU.
