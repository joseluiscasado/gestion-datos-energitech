# Proyecto 2: Gestión de Metadatos y Ciclo de Vida del Dato

## 1. Introducción

En estos momentos, EnergiTech carece de un conocimiento democratizado sobre los datos que maneja en sus operaciones. Este proyecto aborda esta brecha mediante la creación de repositorios de metadatos alineados con la norma **UNE 0087** y el establecimiento de un ciclo de vida claramente definido para los datos del proceso de gestión de demanda energética.

## 2. Tarea 1: Creación de Repositorios de Metadatos

Los metadatos son fundamentales para garantizar que todos los trabajadores de la empresa que están en contacto con los datos compartan el mismo entendimiento de los datos. Implementaremos tres tipos de metadatos:

### 2.1. Metadatos de Negocio: Glosario de Términos

El glosario define qué significan los datos desde una perspectiva empresarial, facilitando la comunicación entre áreas técnicas y de negocio.

#### 2.1.1 Glosario de Términos - EnergiTech

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

| ID | Nombre | Fuente | Almacenamiento | Frecuencia | Volumen | Sensibilidad |
|----|--------|---------------|----|-----------|---------|---------------|
| **D001** | Consumo Cliente | Contadores inteligentes | HDFS Data Lake | 15 minutos | 500 GB/mes | PII.Sensitive |
| **D002** | Producción Planta | Sistemas SCADA | HDFS Data Lake | 15 minutos | 350 GB/mes | PII.NonSensitive |
| **D003** | Datos Cliente CRM | Salesforce CRM | PostgreSQL DW | Batch diario | 50 MB | PII.Sensitive |
| **D004** | Datos Climáticos | APIs meteorológicas | HDFS Data Lake | Horario | 100 GB/mes | PII.NonSensitive |
| **D005** | Calendarios Laborales | RR.HH. + Config | PostgreSQL DW | Semestral | 5 MB | PII.NonSensitive |
| **D006** | Mantenimiento Programado | Gestión de mantenimiento | PostgreSQL DW | Ad-hoc/Mensual | 10 MB | PII.NonSensitive |
| **D007** | Disponibilidad Equipos | CMDB | Service Management | PostgreSQL DW | 5 MB | PII.NonSensitive |
| **D008** | Consumo Anonimizado | Transformación de D001 | HDFS Data Lake | 15 minutos | 500 GB/mes | PII.Sensitive |
| **D009** | Predicción de Demanda | Modelo IA/ML | PostgreSQL + Redis | Post-modelo | 50 GB/mes | PII.NonSensitive |

En el siguiene documento adunto, se muestra la información del catálogo de datos en formato csv, que nos facilitará su publicación en OpenMetadata

- **Archivo**: [`auxiliares/catalogo-datos-energitech-openmetadata.csv`](../auxiliares/catalogo-datos-energitech-openmetadata.csv)


#### 2.2.2 Propiedades Ampliadas del Catálogo

Para cada dato se documenta:

- **Linaje de Datos**: Trazabilidad de transformaciones
- **Calidad Esperada**: Umbrales de completitud, exactitud, consistencia
- **SLA Técnico**: Disponibilidad esperada, RTO/RPO
- **Sensibilidad**: Clasificación de sensibilidad (público, interno, confidencial, secreto)
- **Ciclo de Vida**: Retención, archivado, eliminación
- **Cumplimiento**: Regulaciones aplicables (GDPR, sectorial)

### 2.3. Metadatos Operativos: Diccionario de Datos

El diccionario de datos documenta cómo se implementan técnicamente cada uno de los datos (campos, tipos, restricciones, transformaciones).

#### 2.3.1 Diccionario de Datos - Ejemplo: Consumo Cliente (D001)

**Tabla: `consumo`**  

| Campo | Tipo Dato | Nulabilidad | Restricciones | Descripción | Ejemplo | Transformaciones Aplicadas |
|-------|----------|-----------|----------------|-----------|---------|---------------------------|
| **meter_id** | STRING | NOT NULL | Clave primaria | Identificador único del contador (anonimizado con hash SHA-256) | a7f3c9e2d1b4 | Hash de ID original mediante SHA-256 |
| **timestamp** | TIMESTAMP | NOT NULL | Índice temporal, precisión minuto | Marca temporal del registro con zona horaria UTC | 2024-04-10T14:30:00Z | Normalización a UTC desde zona local |
| **consumption_kwh** | DECIMAL(18,4) | NOT NULL | ≥ 0, ≤ 50,000 | Consumo de energía en kilovatios-hora | 12.3456 | Redondeo a 4 decimales |
| **voltage** | DECIMAL(6,2) | NULL | 180-250 V | Voltaje medido en vatios | 230.50 | Valores fuera de rango marcan como NULL |
| **intensity** | DECIMAL(8,4) | NULL | 0-80 A | Intensidad de corriente en amperios | 23.4500 | Captura de sensor o NULL si no disponible |
| **status** | STRING | NOT NULL | {'OK', 'ALERT', 'ERROR'} | Estado de la medición | OK | Reporte del contador o derivado de validación |
| **raw_received_at** | TIMESTAMP | NOT NULL | > timestamp | Timestamp de recepción en Data Lake | 2024-04-10T14:31:35Z | Registrado por sistema de ingesta |
| **data_partition_date** | DATE | NOT NULL | Clave de partición | Fecha para particionamiento Parquet (YYYY-MM-DD) | 2024-04-10 | Derivado del timestamp |

**Reglas de Validación en D001:**
1. `meter_id` no nulo y único por día
2. `timestamp` monótono creciente (sin saltos > 20 minutos)
3. `consumption_kwh` ≥ valor anterior (no puede decrecer en período corto)
4. `voltage` dentro de 180-250V; si fuera de rango = alerta
5. `consumption_kwh` o `intensity` deben estar presentes (no ambos NULL)

#### 2.3.2 Diccionario de Datos - Tabla Maestra: Consumo Anonimizado (D008)

**Tabla**: `consumo_anonymized`  

| Campo | Tipo Dato | Nulabilidad | Restricciones | Descripción | Transformación |
|-------|----------|-----------|----------------|-----------|-----------------|
| **customer_hash** | STRING | NOT NULL | Clave primaria | ID cliente anonimizado con hash SHA-256 irreversible | Hash SHA-256(ID original) |
| **consumption_period_date** | DATE | NOT NULL | Formato YYYY-MM-DD | Período de consumo (inicio de día) | Derivado de timestamp |
| **total_daily_consumption_kwh** | DECIMAL(15,2) | NOT NULL | ≥ 0 | Suma de consumo del día | SUM(consumption_kwh) agrupar por día |
| **avg_hourly_load_kw** | DECIMAL(10,4) | NOT NULL | ≥ 0 | Carga promedio horaria | AVG(consumption_kwh) en ventana 1h |
| **peak_load_kw** | DECIMAL(10,4) | NOT NULL | ≥ 0 | Pico máximo de carga en el día | MAX(intensity * voltage / 1000) |
| **availability_flag** | DECIMAL(5,2) | NOT NULL | 0-100 | Porcentaje de registros válidos en el día | COUNT(status='OK') / COUNT(*) * 100 |
| **quality_score** | DECIMAL(4,2) | NOT NULL | 0-1 | Score de calidad general: completitud × exactitud | (completitud × exactitud) / 100 |
| **processed_timestamp** | TIMESTAMP | NOT NULL | - | Cuándo se procesó el registro | CURRENT_TIMESTAMP |

### 2.4. Matriz de Trazabilidad: Relaciones entre Tipos de Metadatos

La **trazabilidad** de los datos conecta los tres tipos de metadatos asegurando consistencia y su linaje, en la siguiente figura se muestra la trazabilidad de diferentes elementos del catalogo de datos por filas, desde el concepto de negocio, fuente y soporte técnico del mismo, hasta el propietario o responsable del dato.


<div align="center">

![Trazabilidad Metadatos - EnergiTech](../figuras/trazabilidad-metadatos.png)

</div>

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

**Procesos:**
1. **Validación de Datos** (agrupa reglas de negocio)
2. **Limpieza de Datos** (corrección/eliminación de anomalías)
3. **Normalización** (estandarización de formatos)
4. **Enriquecimiento** (cálculos derivados, unión con dimensiones)
5. **Anonimización** (aplicación de NePII protecciones)


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
