# Proyecto 2: Gestión de Metadatos y Ciclo de Vida del Dato

## 1. Introducción

En estos momentos, EnergiTech carece de un conocimiento democratizado sobre los datos que maneja en sus operaciones. Este proyecto aborda esta brecha mediante la creación de repositorios de metadatos alineados con la norma **UNE 0087** y el establecimiento de un ciclo de vida claramente definido para los datos del proceso de gestión de demanda energética.

## 2. Tarea 1: Creación de Repositorios de Metadatos

Los metadatos son fundamentales para garantizar que todos los trabajadores de la empresa que están en contacto con los datos compartan el mismo entendimiento de los datos. Implementaremos tres tipos de metadatos:

### 2.1. Metadatos de Negocio: Glosario de Términos

El glosario define qué significan los datos desde una perspectiva empresarial, facilitando la comunicación entre áreas técnicas y de negocio.

#### 2.1.1 Glosario de Términos

El glosario completo está disponible en el servidor OpenMetadata en la dirección:

🔗 **[http://172.20.48.127:8585/glossary/%22Grupo01.Glosario%22](http://172.20.48.127:8585/glossary/%22Grupo01.Glosario%22)**

El glosario incluye términos de negocio (Demanda Energética, Cliente Residencial, etc.), requisitos (RPB, RD, RCD, RCG) y conceptos de gobernanza (Anonimización, Trazabilidad, Validación, etc.).

Dependiendo de la conexión, puede que el servidor OpenMetadata no esté disponible, por lo que se los datos del glosario se pueden consultar en formato CSV, compatible con OpenMetadata:

- **Archivo**: [`auxiliares/glosario-energitech-openmetadata.csv`](../auxiliares/glosario-energitech-openmetadata.csv)

#### 2.1.2 Propósito y Beneficios del Glosario

- **Comunicación Efectiva**: Elimina ambigüedades en la interpretación de conceptos clave
- **Onboarding**: Facilita la incorporación de nuevos empleados
- **Compliance**: Demuestra gobierno de datos en auditorías normativas
- **Alineación Organizacional**: Garantiza que toda la empresa comprenda la misma definición de cada término

### 2.2. Metadatos Técnicos: Catálogo de Datos

El catálogo de datos documenta para toda la información manejada en los procesos de negocio, dónde se encuentran almacenados los datos, su estructura física y su ubicación en sistemas técnicos.

#### 2.2.1 Catálogo de Datos - EnergiTech


**Resumen del Catálogo:**

| ID | Nombre | Fuente | Frecuencia | Sensibilidad |
|----|--------|---------------|-----------|---------------|
| **D001** | Consumo Cliente | Contadores inteligentes | 15 minutos | PII.Sensitive |
| **D002** | Producción Planta | Sistemas SCADA | 15 minutos | PII.NonSensitive |
| **D003** | Datos Cliente CRM | Salesforce CRM | Batch diario | PII.Sensitive |
| **D004** | Datos Climáticos | APIs meteorológicas | Horario | PII.NonSensitive |
| **D005** | Calendarios Laborales | RR.HH. + Config | Semestral | PII.NonSensitive |
| **D006** | Mantenimiento Programado | Gestión de mantenimiento | Ad-hoc/Mensual | PII.NonSensitive |
| **D007** | Disponibilidad Equipos | Gestión de mantenimiento | Ad-hoc/Mensual | PII.NonSensitive |
| **D008** | Consumo Anonimizado | Transformación de D001 | 15 minutos | PII.Sensitive |
| **D009** | Predicción de Demanda | Modelo IA/ML | Post-modelo |PII.NonSensitive |

En el siguiente documento adjunto, se muestra la información del catálogo de datos en formato csv, que nos facilitará su publicación en OpenMetadata

- **Archivo**: [`auxiliares/catalogo-datos-energitech-openmetadata.csv`](../auxiliares/catalogo-datos-energitech-openmetadata.csv)


### 2.3. Metadatos Operativos: Diccionario de Datos

El diccionario de datos documenta cómo se implementan técnicamente cada uno de los datos (campos, tipos, restricciones, transformaciones).

#### 2.3.1 Diccionario de Datos - Ejemplo: Consumo Cliente

**Tabla consumo:**  

| Campo | Tipo Dato | Nulabilidad | Restricciones | Descripción | 
|-------|----------|-----------|----------------|-----------|
| **id_contador** | STRING | NOT NULL | Clave primaria | Identificador único del contador (anonimizado con hash SHA-256) | 
| **marca_tiempo** |  TIMESTAMP | NOT NULL | Índice temporal, precisión minuto | Marca temporal del registro con zona horaria UTC | 
| **consumo_kwh** | DECIMAL(18,4) | NOT NULL | ≥ 0, ≤ 50,000 | Consumo de energía en kilovatios-hora | 
| **voltaje** | DECIMAL(6,2) | NULL | 180-250 V | Voltaje medido en vatios | 
| **intensidad** | DECIMAL(8,4) | NULL | 0-80 A | Intensidad de corriente en amperios | 
| **estado** | STRING | NOT NULL | {'OK', 'ALERTA', 'ERROR'} | Estado de la medición |  
| **fecha_recepcion_raw** | TIMESTAMP | NOT NULL | > marca_tiempo | Timestamp de recepción en Data Lake | 
| **fecha_particion_datos** | DATE | NOT NULL | Clave de partición | Fecha para particionamiento Parquet (YYYY-MM-DD) | 


### 2.4. Matriz de Trazabilidad: Relaciones entre Tipos de Metadatos

La **trazabilidad** de los datos conecta los tres tipos de metadatos asegurando consistencia y su linaje, en la siguiente figura se muestra la trazabilidad de diferentes elementos del catalogo de datos por filas, desde el concepto de negocio, fuente y soporte técnico del mismo, hasta el propietario o responsable del dato.


<div align="center">

![Trazabilidad Metadatos - EnergiTech](../figuras/trazabilidad-metadatos.png)

</div>

La siguiente tabla establece la relación entre los tres tipos de metadatos para cada dato. Para cada activo de datos se vincula: su definición de negocio (glosario), su ubicación técnica (catálogo) y su implementación física (diccionario):

| Dato | Glosario | Catálogo | Diccionario |
|---|---|---|---|
| **Consumo Cliente** | Término: *Demanda Energética* — Cantidad de energía requerida por los clientes en un período determinado | Fuente: Contadores inteligentes — Almacenamiento: HDFS `/datos/brutos/energia/consumo` — Formato: CSV/Parquet, cada 15 min | Tabla: `consumo` — Campos: `id_contador` (STRING PK), `marca_tiempo` (TIMESTAMP), `consumo_kwh` (DECIMAL), `voltaje`, `intensidad`, `estado` |
| **Producción Planta** | Término: *Producción Renovable* — Energía generada a partir de fuentes renovables (solar, eólica, hidráulica, biomasa) | Fuente: Sistemas SCADA — Almacenamiento: HDFS `/datos/brutos/energia/produccion` — Formato: Time-series JSON, cada 15 min | Tabla: `produccion` — Campos: `id_planta` (STRING PK), `marca_tiempo` (TIMESTAMP), `produccion_kwh` (DECIMAL), `tipo_energia`, `temperatura_equipo` |
| **Datos Cliente CRM** | Términos: *Cliente Residencial*, *Cliente VIP* — Clasificación de clientes según tipo de consumo y acuerdos contractuales | Fuente: CRM — Almacenamiento: PostgreSQL `public.clientes` — Formato: Structured Data, batch diario | Tabla: `clientes` — Campos: `id_cliente` (STRING PK), `tipo_cliente` (STRING), `latitud_ubicacion` (DECIMAL), `longitud_ubicacion` (DECIMAL), `id_contrato` |
| **Datos Climáticos** | Término: *Datos Climáticos* — Variables meteorológicas: temperatura, humedad, viento, radiación, precipitación | Fuente: APIs meteorológicas — Almacenamiento: HDFS `/datos/brutos/meterologica` — Formato: JSON, cada hora | Tabla: `clima` — Campos: `id_estacion` (STRING PK), `marca_tiempo` (TIMESTAMP), `temperatura` (DECIMAL), `humedad`, `velocidad_viento`, `radiacion_solar` |
| **Calendarios Laborales** | Término: *Calendarios Laborales* — Festivos, fines de semana y períodos vacacionales por zona | Fuente: RR.HH. + Config — Almacenamiento: PostgreSQL `public.calendarios` — Formato: Structured Data, semestral | Tabla: `calendarios` — Campos: `id_zona` (STRING PK), `fecha` (DATE PK), `tipo_dia` (STRING), `es_festivo` (BOOLEAN) |
| **Mantenimiento Programado** | Término: *Mantenimiento Programado* — Fechas y duración de mantenimiento planificado en plantas | Fuente: Sistema gestión mantenimiento — Almacenamiento: PostgreSQL `public.mantenimiento_programado` — Formato: Structured Data | Tabla: `mantenimiento_programado` — Campos: `id_mantenimiento` (STRING PK), `id_planta` (STRING FK), `fecha_inicio` (TIMESTAMP), `duracion_horas` (DECIMAL) |
| **Disponibilidad Equipos** | Término: *Disponibilidad de Equipos* — Estado y ubicación de equipos de reparación ante emergencias | Fuente: Sistema gestión mantenimiento — Almacenamiento: PostgreSQL — Formato: Structured Data, real-time | Tabla: `disponibilidad_equipos` — Campos: `id_equipo` (STRING PK), `estado` (STRING), `tipo` (STRING), `ubicacion` (STRING) |
| **Consumo Anonimizado** | Términos: *Anonimización*, *Demanda Energética* — Datos de consumo con ID transformado mediante hash criptográfico irreversible | Fuente: Transformación post-validación de D001 — Almacenamiento: HDFS `/datos/procesados/energia/consumo_anonimizado` — Formato: Parquet | Tabla: `consumo_anonimizado` — Campos: `hash_cliente` (STRING PK), `fecha_periodo_consumo` (DATE), `consumo_diario_total_kwh`, `carga_horaria_promedio_kw`, `puntuacion_calidad` |
| **Predicción de Demanda** | Términos: *Análisis Predictivo*, *Ventana Temporal* — Previsión de demanda por ventana temporal (24h, 48h, 7d) | Fuente: Modelo IA/ML — Almacenamiento: PostgreSQL `public.prediccion_demanda` + Redis cache — Formato: JSON/Structured | Tabla: `prediccion_demanda` — Campos: `id_prediccion` (STRING PK), `id_zona` (STRING FK), `ventana_prediccion` (STRING), `kwh_predicho` (DECIMAL), `confianza` (DECIMAL) |

## 3. Tarea 2: Gestión del Ciclo de Vida del Dato

### Fases del Ciclo de Vida de Datos en EnergiTech

El ciclo de vida simplificado define cómo los datos se gestionan desde su origen hasta su explotación:


<div align="center">

![Ciclo de vida del dato - EnergiTech](../figuras/ciclo-vida-datos-energitech.png)

</div>

#### **Fase 1: INGESTA (Entrada del Dato)**

**Objetivo**: Capturar datos de fuentes heterogéneas de manera confiable y auditable

**Procesos:**
- Extracción de datos de fuentes (CRM, contadores inteligentes, APIs meteorológicas)
- Recepción y almacenamiento en "raw zone" del Data Lake

#### **Fase 2: TRANSFORMACIÓN (Procesamiento del Dato)**

**Objetivo**: Limpiar, validar, normalizar y enriquecer datos para uso analítico

**Procesos y Controles de Validación Detallados:**

- Validación de Datos (Reglas de Negocio)
- Limpieza de Datos (Corrección/Eliminación de Anomalías)
- Normalización (Estandarización de Formatos)
- Enriquecimiento (Cálculos Derivados)
- Anonimización (Protección de Datos Personales)

#### **Fase 3: ALMACENAMIENTO (Persistencia del Dato)**

**Objetivo**: Mantener datos transformados accesibles y asegurados

**Estrategia de Almacenamiento Multicapa:**

<div align="center">

![Almacenamiento multicapa - EnergiTech](../figuras/almacenamiento-multicapa.png)

</div>

#### **Fase 4: EXPLOTACIÓN (Uso del Dato)**

**Objetivo**: Poner datos a disposición de usuarios finales para análisis y toma de decisiones

**Métodos de Explotación:**

1. **BI Tools**
   - Herramienta: Tableau / Power BI
   - Dashboards: Predicción de demanda, análisis de consumo
   - Frecuencia: Real-time (actualización cada 15 min)
   - Usuarios: Jefes de operaciones, directivos

2. **Reportes Automáticos**
   - Reporte diario: Predicción vs. demanda real
   - Reporte semanal: Análisis de variaciones
   - Reporte mensual: Evaluación de calidad

### Políticas de Gobierno del Dato por Fase del Ciclo de Vida

Para regular qué se puede hacer y qué no se puede hacer con los datos en cada etapa, se definen las siguientes políticas:

#### Políticas de Ingesta

| ID | Política | Descripción |
|---|---|---|
| POL-ING-01 | Solo fuentes autorizadas | Únicamente se pueden ingestar datos de las fuentes registradas en el catálogo de datos. |
| POL-ING-02 | Registro de origen | Todo dato ingestado debe llevar metadatos de trazabilidad: fuente, timestamp de recepción y lote de carga |
| POL-ING-03 | Inmutabilidad de datos raw | Los datos recibidos en la raw zone no pueden ser modificados ni eliminados. |

#### Políticas de Transformación

| ID | Política | Descripción |
|---|---|---|
| POL-TRA-01 | Validación obligatoria | Ningún dato puede pasar a la capa procesada sin superar las reglas de validación definidas |
| POL-TRA-02 | Trazabilidad de transformaciones | Toda transformación aplicada debe quedar registrada para garantizar reproducibilidad |
| POL-TRA-03 | Anonimización antes de procesado | Los datos con información personal deben anonimizarse antes de cualquier otro procesamiento analítico |

#### Políticas de Almacenamiento

| ID | Política | Descripción |
|---|---|---|
| POL-ALM-01 | Cifrado obligatorio para PII | Todos los datos clasificados como PII.Sensitive deben almacenarse cifrados |
| POL-ALM-02 | Retención según tipo de dato | Contadores y climáticos: 24 meses. CRM: mientras el cliente esté activo. Logs de acceso: 24 meses. Superado el período, los datos deben archivarse o eliminarse |
| POL-ALM-03 | Copias de seguridad | Backup diario de la capa procesada y semanal de la raw zone, con verificación de integridad |

#### Políticas de Explotación

| ID | Política | Descripción |
|---|---|---|
| POL-EXP-01 | Acceso basado en roles | El acceso a datos en explotación se otorga según el rol: operadores (dashboards operativos), analistas (datos agregados), directivos (reportes ejecutivos) |
| POL-EXP-02 | Prohibición de exportación de PII | No se permite la descarga ni exportación de datos con información personal identificable desde las herramientas de BI |
| POL-EXP-03 | Registro de acceso | Todo acceso a datos en explotación queda registrado en el sistema de auditoría (quién, qué dato, cuándo, con qué propósito) |