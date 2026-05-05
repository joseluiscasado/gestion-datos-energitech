# Proyecto 4: Medición de la Calidad del Dato

## 1. Introducción

En este proyecto se afronta precisamente la siguiente cuestión: ¿los datos que manejan los procesos de EnergiTech presentan **niveles inadecuados de calidad**?, lo que puede generar desconfianza entre los trabajadores y provoca decisiones de negocio que frustran a los clientes.

Intentaremos resolver esta situación, desarrollando un **modelo de calidad del dato** que identifica y justifica las características de calidad más relevantes para el escenario de EnergiTech, alineado con la norma **UNE 0081** y un conjunto de **métodos de medición** para cada característica seleccionada, con métricas definidas, procedimientos de cálculo y umbrales acordes al **apetito de riesgo** de la organización.

---

## 2. Tarea 1: Modelo de Calidad del Dato

### 2.1 Selección y Justificación de las Características de Calidad

De entre las características definidas en **UNE 0081**, se han seleccionado **tres** como las más relevantes para el proceso de predicción de demanda energética de EnergiTech, basandonos en los requisitos de negocio planteados en proyectos anteriores.

#### 2.1.1 Características Seleccionadas

| ID Característica | Característica (UNE 0081) | Requisitos de Negocio | Requisitos de Calidad | Justificación de Selección |
|-------------------|--------------------------|----------------------|----------------------|---------------------------|
| **CAR-01** | **Completitud** | RP01, RP06 | RCD01 | Los modelos de IA/ML requieren series temporales sin huecos. Un registro de consumo ausente provoca que el modelo interpole valores incorrectos o descarte la ventana de entrenamiento, degradando la precisión de predicción por encima del 5% permitido. |
| **CAR-02** | **Exactitud** | RP01, RP04 | RCD02 | El dato de consumo (kWh) es la variable objetivo del modelo. Un error sistemático en las lecturas de contadores o en la producción de plantas introduce sesgo que se acumula en el entrenamiento y hace imposible cumplir la tolerancia de error del ±5% en predicción. |
| **CAR-03** | **Actualidad** | RP01, RP06, RP07 | RCD04 | El proceso requiere datos con una latencia máxima de 30 minutos para contadores. Si los datos llegan tarde, el modelo se ejecuta con información desfasada, tomando decisiones sobre un estado de la red que ya ha cambiado, con riesgo de cortes o sobrecargas. |

---

### 2.2 Modelo de Puntuación Agregada de Calidad

Para disponer de una visión consolidada del estado de la calidad, se define un **modelo de puntuación** que agrega las tres características en un indicador único por fuente de datos.

#### 2.2.1 Metodología de Puntuación

Cada característica se evalúa y normaliza a una escala **0-1** en función del umbral alcanzado:

| Nivel Alcanzado | Puntuación Normalizada |
|-----------------|----------------------|
| Óptimo | 1.00 |
| Aceptable | 0.75 |
| Crítico | 0.25 |
| Sin datos / No medible | 0.00 |

La **Puntuación de Calidad (PQ)** de cada dataset se calcula como una media ponderada de las tres características.

#### 2.2.2 Pesos por Dataset

Los pesos reflejan la importancia relativa de cada característica según el tipo de dato:

| Dataset | Completitud | Exactitud | Actualidad |
|---------|:-:|:-:|:-:|
| **D001** Consumo Cliente | 0.35 | 0.35 | 0.30 |
| **D002** Producción Planta | 0.35 | 0.35 | 0.30 |
| **D003** Datos Cliente CRM | 0.50 | 0.30 | 0.20 |
| **D004** Datos Climáticos | 0.35 | 0.35 | 0.30 |
| **D005** Calendarios Laborales | 0.50 | 0.30 | 0.20 |
| **D006** Mantenimiento Programado | 0.50 | 0.25 | 0.25 |
| **D007** Disponibilidad Equipos | 0.30 | 0.20 | 0.50 |
| **D009** Predicción de Demanda | 0.20 | 0.50 | 0.30 |

#### 2.2.3 Interpretación de la Puntuación

| Rango PQ | Estado | Acción |
|----------|--------|-------|
| PQ ≥ 0.95 | **Óptimo** | Sin acción. Monitorización periódica. |
| 0.85 ≤ PQ < 0.95 | **Aceptable** | Investigar causa raíz. Monitorización reforzada. |
| PQ < 0.85 | **Crítico** | Bloquear pipeline. Escalar al responsable del dato. Activar proceso de incidencia. |

---

## 3. Tarea 2: Métodos de Medición de Calidad del Dato

Para cada característica seleccionada se definen las **medidas de calidad**, el **procedimiento de cálculo**, la **frecuencia de medición** y los **umbrales** acordes al apetito de riesgo de EnergiTech.

---

### 3.1 Característica CAR-01: Completitud

#### 3.1.1 Definición y Ámbito

La **Completitud** (UNE 0081 / ISO 25012) mide el grado en que los datos tienen valores para todos los atributos esperados y el grado en que los registros esperados están presentes.

Esta característica responde directamente al requisito **[RCD01]**, que fija un mínimo del 99% de registros diarios para contadores y del 95% para datos climáticos.

#### 3.1.2 Medidas Definidas

| ID Medida | Nombre | Fórmula | Unidad | Fuente de Datos |
|-----------|--------|---------|--------|-----------------|
| **MED-COM-01** | Tasa de Completitud Temporal | $\frac{\text{Registros recibidos}}{\text{Registros esperados}} \times 100$ | % | D001, D002, D004 |
| **MED-COM-02** | Tasa de Completitud de Atributos | $\frac{\text{Campos NOT NULL}}{\text{Campos NOT NULL esperados}} \times 100$ | % | D001, D002, D003, D004 |
| **MED-COM-03** | Tasa de Clientes CRM con Datos Básicos | $\frac{\text{Clientes con datos completos}}{\text{Total clientes activos}} \times 100$ | % | D003 |

**Procedimiento de medición:**

- **MED-COM-01**: Se determina el número de registros esperados según la frecuencia de cada fuente y se compara con el número de registros efectivamente recibidos en el período.
- **MED-COM-02**: Para cada registro recibido, se verifica que los campos declarados como NOT NULL en el diccionario de datos no sean nulos ni cadenas vacías.
- **MED-COM-03**: Tras la sincronización batch del CRM, un cliente activo se considera completo si tiene rellenos: `id_cliente`, `tipo_cliente`, `latitud_ubicacion`, `longitud_ubicacion` e `id_contrato`.

#### 3.1.3 Umbrales y Apetito de Riesgo

| Dataset | Riesgo | Umbral Óptimo | Umbral Aceptable | Umbral Crítico | Frecuencia |
|---------|--------|:-------------:|:----------------:|:--------------:|------------|
| D001 Consumo (MED-COM-01) | Alto | ≥ 99,5% | ≥ 99,0% | < 99,0% | Cada 15 min |
| D001 Consumo (MED-COM-02) | Alto | 100% | ≥ 99,5% | < 99,5% | Cada 15 min |
| D002 Producción (MED-COM-01) | Alto | ≥ 99,5% | ≥ 99,0% | < 99,0% | Cada 15 min |
| D003 CRM (MED-COM-03) | Alto | 100% | ≥ 99,0% | < 99,0% | Diario |
| D004 Climáticos (MED-COM-01) | Medio | ≥ 98,0% | ≥ 95,0% | < 95,0% | Horario |

**Impacto en el proceso de negocio**: Un déficit de completitud en D001 o D002 provoca huecos en la serie temporal de entrenamiento del modelo predictivo. Si el gap supera 2 intervalos consecutivos (30 minutos), el modelo no puede interpolar con seguridad y debe descartar esa ventana, reduciendo la calidad de la predicción por encima del umbral del 5% establecido en **[RP01]**.

---

### 3.2 Característica CAR-02: Exactitud

#### 3.2.1 Definición y Ámbito

La **Exactitud** (UNE 0081 / ISO 25012) mide el grado en que los datos representan correctamente los hechos del mundo real. Esta característica responde al requisito **[RCD02]**, que exige un error máximo del ±2% en consumo eléctrico, ±3% en producción energética y ±1°C en temperatura.

#### 3.2.2 Medidas Definidas

| ID Medida | Nombre | Fórmula | Unidad | Fuente de Datos |
|-----------|--------|---------|--------|-----------------|
| **MED-EXA-01** | Error Relativo Promedio de Consumo | $\frac{1}{n}\sum_{i=1}^{n} \frac{v_{medido,i} - v_{referencia,i}}{v_{referencia,i}} \times 100$ | % | D001 |
| **MED-EXA-02** | Tasa de Valores Fuera de Rango | $\frac{\text{Registros con valores fuera del rango físico válido}}{\text{Total registros}} \times 100$ | % | D001, D002, D004 |
| **MED-EXA-03** | Error Medio Absoluto de Temperatura | $\frac{1}{n}\sum_{i=1}^{n}T_{sensor,i} - T_{referencia,i}$ | °C | D004 |
| **MED-EXA-04** | Tasa de Exactitud de Coordenadas CRM | $\frac{\text{Clientes con coordenadas coherentes con su zona de suministro}}{\text{Total clientes activos}} \times 100$ | % | D003 |

**Procedimiento de medición:**

- **MED-EXA-01**: Se calcula mensualmente cruzando una muestra estadísticamente representativa de lecturas de contadores inteligentes (D001) con lecturas de referencia certificadas de contadores de control. 
- **MED-EXA-02**: Se aplican las restricciones de dominio del diccionario de datos (Proyecto 2): `consumo_kwh` ∈ [0, 50.000], `voltaje` ∈ [180, 250], `intensidad` ∈ [0, 80]. 
- **MED-EXA-03**: Se comparan las temperaturas reportadas por las APIs meteorológicas (D004) con los datos de la red de estaciones meteorológicas oficiales de AEMET para las mismas coordenadas y marcas temporales.
- **MED-EXA-04**: Se verifica que la `latitud_ubicacion` y `longitud_ubicacion` del cliente en CRM corresponden a la zona de suministro declarada en su contrato, con un margen de error máximo de 100 metros conforme a **[RCD02]**.

#### 3.2.3 Umbrales y Apetito de Riesgo

| Medida | Dataset | Riesgo | Umbral Óptimo | Umbral Aceptable | Umbral Crítico | Frecuencia |
|--------|---------|--------|:-------------:|:----------------:|:--------------:|------------|
| MED-EXA-01 | D001 Consumo | Alto | Error < 1,0% | Error < 2,0% | Error ≥ 2,0% | Mensual (muestra) |
| MED-EXA-02 | D001 Consumo | Alto | < 0,1% fuera de rango | < 0,5% fuera de rango | ≥ 0,5% fuera de rango | Cada 15 min |
| MED-EXA-02 | D002 Producción | Alto | < 0,1% fuera de rango | < 0,5% fuera de rango | ≥ 0,5% fuera de rango | Cada 15 min |
| MED-EXA-02 | D004 Climáticos | Medio | < 0,5% fuera de rango | < 1,0% fuera de rango | ≥ 1,0% fuera de rango | Horario |
| MED-EXA-03 | D004 Climáticos | Medio | Error < 0,5°C | Error < 1,0°C | Error ≥ 1,0°C | Diario |
| MED-EXA-04 | D003 CRM | Alto | ≥ 99,5% coherentes | ≥ 98,0% coherentes | < 98,0% coherentes | Diario |

**Impacto en el proceso de negocio**: Un error sistemático en las lecturas de consumo (D001) introduce sesgo en el dataset de entrenamiento del modelo predictivo. Dado que el modelo se actualiza diariamente **[RP03]**, un error sostenido del 2% en la exactitud de entrada puede degradar la predicción hasta superar el umbral del 5% establecido en **[RP01]** en un plazo de pocas semanas si no se detecta y corrige.

---

### 3.3 Característica CAR-03: Actualidad

#### 3.3.1 Definición y Ámbito

La **Actualidad** (UNE 0081 / ISO 25012) mide el grado en que los datos están disponibles y actualizados en el momento en que se necesitan.

#### 3.3.2 Medidas Definidas

| ID Medida | Nombre | Fórmula | Unidad | Fuente de Datos |
|-----------|-------|-----------------|-------|----------|
| **MED-ACT-01** | Latencia Media de Ingesta | $\overline{L} = \frac{1}{n}\sum_{i=1}^{n}(t_{recepcion,i} - t_{generacion,i})$ | minutos | D001, D002, D004 |
| **MED-ACT-02** | Tasa de Puntualidad | $\frac{\text{Registros con latencia correcta}}{\text{Total registros esperados}} \times 100$ | % | D001, D002, D004 |
| **MED-ACT-03** | Tasa de Datos Obsoletos en Ejecución | $\frac{\text{Registros consumidos con antigüedad excesiva}}{\text{Total registros consumidos}} \times 100$ | % | D001, D002 |


**Procedimiento de medición:**

- **MED-ACT-01 y MED-ACT-02**: El campo `fecha_recepcion_raw` registrado en la tabla `consumo` menos la `marca_tiempo` de generación del dato proporciona la latencia de cada registro. Se agrega por batch de ingesta y por fuente.
- **MED-ACT-03**: En cada ejecución del modelo predictivo, se registra la antigüedad del dato más reciente disponible por fuente.

#### 3.3.3 Umbrales y Apetito de Riesgo

| Dataset | Riesgo | Latencia Máx. | Umbral Óptimo (MED-ACT-02) | Umbral Aceptable (MED-ACT-02) | Umbral Crítico (MED-ACT-02) | Frecuencia |
|---------|--------|:----:|:----:|:----:|:----:|------------|
| D001 Consumo | Alto | 30 min | ≥ 99,5% | ≥ 98,0% | < 98,0% | Cada 15 min |
| D002 Producción SCADA | Alto | 15 min | ≥ 99,5% | ≥ 98,0% | < 98,0% | Cada 15 min |
| D004 Datos Climáticos | Medio | 60 min | ≥ 98,0% | ≥ 95,0% | < 95,0% | Horario |
| D005 Calendarios Laborales | Bajo | 90 días (anticipación mínima) | Publicado > 3 meses antes | Publicado > 1 mes antes | Publicado < 1 mes antes | Semestral |

**Impacto en el proceso de negocio**: El incumplimiento de la actualidad en D001 o D002 compromete la ventana de decisión del operador de red. Si el modelo se ejecuta con datos que reflejan un estado de la red de hace más de 30 minutos, las acciones de balanceo pueden activarse demasiado tarde o de forma innecesaria, vulnerando el requisito de disponibilidad del 99% **[RP06]** y el tiempo de respuesta de 5 minutos **[RP07]**.

---

## 4. Resumen: Cuadro de Mandos de Calidad del Dato

### 4.1 Tabla Consolidada de Medidas

La siguiente tabla resume todas las medidas definidas, su relación con las características UNE 0081 y con los requisitos del proceso de negocio:

| ID Medida | Característica | Datasets Aplicables | Requisi­tos Asociados | Frecuencia | Acción ante Nivel Crítico |
|-----------|---------------|---------------------|----------------------|-----------|--------------------------|
| MED-COM-01 | Completitud | D001, D002, D004 | RCD01, RP01 | 15 min / Horario | Bloquear pipeline, investigar fuente |
| MED-COM-02 | Completitud | D001, D002, D003, D004 | RCD01 | Cada ingesta | Rechazar registro, registrar incidencia |
| MED-COM-03 | Completitud | D003 | RCD01, RP04 | Diario | Alertar propietario CRM |
| MED-EXA-01 | Exactitud | D001 | RCD02, RP01 | Mensual | Auditoría de contadores, recalibración |
| MED-EXA-02 | Exactitud | D001, D002, D004 | RCD02 | 15 min / Horario | Cuarentena del registro, revisión manual |
| MED-EXA-03 | Exactitud | D004 | RCD02 | Diario | Cambiar fuente API meteorológica |
| MED-EXA-04 | Exactitud | D003 | RCD02, RP04 | Diario | Corrección manual, geocodificación |
| MED-ACT-01 | Actualidad | D001, D002, D004 | RCD04, RP07 | Cada ingesta | Investigar latencia de red / fuente |
| MED-ACT-02 | Actualidad | D001, D002, D004 | RCD04, RP06 | Cada ingesta | Escalar a operaciones, activar failover |
| MED-ACT-03 | Actualidad | D001, D002 | RCD04, RP07 | Cada ejecución modelo | Retrasar ejecución modelo, alarma |
| MED-CON-01 | Consistencia | D001, D002 | RCD03 | Cada ingesta | Rechazar registro huérfano, alerta |
| MED-CON-02 | Consistencia | D001, D002 | RCD03, RP01 | Horario | Bloquear pipeline, revisión operativa |
| MED-CON-03 | Consistencia | D001, D003 | RCD03 | Diario | Alertar propietario CRM y MDM |
| MED-CON-04 | Consistencia | D003 | RCD03, RP04 | Diario | Corrección de geolocalización |
| MED-UNI-01 | Unicidad | D001, D002 | RCD05, RP01 | Cada ingesta | Deduplicar automáticamente, registrar |
| MED-UNI-02 | Unicidad | D003 (MDM) | RCD05, RP01 | Diario | Activar proceso Merge MDM |
| MED-UNI-03 | Unicidad | D004 | RCD05 | Horario | Deduplicar por clave primaria |
