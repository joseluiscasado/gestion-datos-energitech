# Proyecto 1: Procesamiento del Dato y Gestión de Requisitos

## Contexto del Proyecto

EnergiTech quiere implementar un nuevo sistema de análisis predictivo basado en técnicas de inteligencia artificial para la gestión de la demanda energética, especialmente para garantizar la satisfacción de las necesidades de los clientes más críticos.

## Descripción del Proceso de Negocio que implica el cálculo de la previsión de la demanda energética

El proceso de negocio para la previsión de la demanda energética abarca desde la captura de señales en campo de las diferentes fuentes de energía renovable, datos de agentes externos que afectan tanto a la producción como a la demanda de energía, tratamiento de los datos para su limpieza, filtrado y validación, desarrollo de modelos de datos basados en IA para  la toma de decisiones y validación de resultados. A continuación, se detalla el modelo de proceso y las instrucciones de procesamiento:

- Extracción y Captura: El proceso comienza con la extracción de datos históricos de consumo desde el CRM y contadores de medida, datos de producción de las diferentes plantas de energía renovable, datos externos climatológicos, calendarios laborales en zonas de suministro, previsiones de mantenimiento en plantas, disponibilidad de equipos de reparación ante emergencias de producción.

- Validación: La empresa debe contar con sistemas automáticos supervisados para verificar que los registros obtenidos de las diferentes fuentes, sobre todo los esenciales, estén siempre disponibles y superen las reglas de calidad impuestas.

- Tratamiento de datos: Normalización de fuentes, los datos de distintas regiones y formatos se estandarizan y adecúan al sistema, anonimización aplicando máscaras a los datos sensibles de los clientes y productores y limpieza de los datos erróneos.

- Entrenamiento y Ejecución del Modelo Predictivo: Lanzamiento del motor predictivo (IA) introduciendo los parámetros de ventana temporal requerida.

- Validación: Comprobar si el resultado tiene sentido antes de su aplicación y comparación de previsión con demanda real para ajustar el modelo.

- Publicación de Previsión: El resultado se vuelca al sistema de gestión de red para evitar cortes de suministro.

- Ajuste y retroalimentación: Comparación de previsión con demanda real para ajustar el modelo.

En definitiva, se trata de un proceso cíclico, alimentado por diferentes fuentes de datos, los cuales deben ser tratados antes de su procesado y utilización. Una vez obtenidos estos resultados se realimentará el sistema para acelerar su aprendizaje.

La labor de los actores de la empresa deberá ser la supervisión de la captura de datos, el tratamiento y limpieza de los mismos, revisión de los resultados del modelo predictivo y la publicación de los resultados para su uso y explotación.

## Identificación de Requisitos de Datos

Identificación exhaustiva de los requisitos para el proceso de análisis predictivo de demanda energética, estructurados en tres capas: requisitos del proceso de negocio, requisitos de datos y requisitos de calidad.

### Requisitos del Proceso de Negocio

El análisis predictivo de la producción y demanda de energía renovable en un sistema en tiempo real es un proceso bastante complejo en el que intervienen gran cantidad de factores y es bastante propenso a la aparición de incidencias inesperadas que pueden provocar la necesidad de reajustes temporales. Entre los requisitos a tener en cuenta a la hora de desarrollar un sistema de esta naturaleza, podemos destacar:

- **Precisión en la predicción**: Es aceptable una tolerancia de error máximo del 5% en la previsión de demanda.
- **Marco Temporal**: Debe ser capaz de realizar predicciones para 24 horas, 48 horas y semanal.
- **Posibilidad de Actualización**: El modelo puede ser reajustado y actualizado diariamente con los últimos resultados y los nuevos datos.
- **Ámbito Geográfico**: Debe ser válido para cubrir todo el ámbito geográfico de los clientes y proveedores de energía.
- **Accesibilidad**: El sistema debe ser accesible tanto para los operadores de red, analistas de demanda, sistemas automáticos de balanceo.
- **Disponibilidad**: Es necesario ofrecer una elevada disponibilidad, un 99%, sobre todo durante horas de mayor demanda (06:00 - 22:00).
- **Tiempo de Respuesta**: Ejecución del modelo en menos de 5 minutos.
- **Integración**: Conexión automática con sistema de gestión de red.
- **Flexibilidad**: Posible adaptación a nuevos operadores de red y a nuevas demandas de clientes.

### Requisitos de Datos

Como en todo sistema basado en datos, la calidad de los mismos suele ser un factor clave en el éxito final del proceso. Según la fuente, el tipo de dato y sus características, aplicaremos los siguientes requisitos:

| Fuente de Datos | Datos Requeridos | Formato | Frecuencia | Periodo Histórico | Seguridad | Almacenamiento |
|---|---|---|---|---|---|---|
| **Contadores de medida** | Consumo (kWh), voltaje, intensidad | CSV/JSON, agregación 15 min | 15 minutos | 24 meses | Anonimizar cliente | HDFS / DataLake |
| **Contadores de producción** | Producción (kWh), voltaje, intensidad | CSV/JSON, agregación 15 min | 15 minutos | 24 meses | Anonimizar cliente | HDFS / DataLake |
| **CRM** | ID Cliente, tipo (VIP/Estándar), ubicación, contrato | CSV/Base Datos | Diario | Activo | Encriptar datos sensibles | Data Warehouse |
| **Plantas Renovables** | Producción (kWh), tipo energía (solar/eólica), temperatura equipos | Time-series, 15 min | 15 minutos | 24 meses | Acceso restringido | HDFS |
| **Datos Climáticos Externos** | Temperatura, humedad, velocidad viento, radiación solar, precipitación | JSON API, horario | Horario | 24 meses | Público / Abierto | DataLake |
| **Calendarios Laborales** | Festivos, fines de semana, periodos vacacionales por zona | CSV | Semestral | 12 meses adelante | Público | Data Warehouse |
| **Mantenimiento Programado** | Fecha, planta, equipos afectados, duración prevista | CSV/Eventos | Ad-hoc | 3 meses | Interno | Data Warehouse |
| **Disponibilidad de Equipos** | Estado (disponible/unavailable), tipo, ubicación | Real-time / API | Real-time | N/A | Interno | Data Warehouse |

**Requisitos Específicos de Fuentes:**

- **Contadores de medida**:
  - Completitud: Registros para todos los clientes activos.
  - Identificador único por cliente (anonimizado).
  - Sellos de tiempo con precisión de minuto.

- **Contadores de producción**:
  - Completitud: Registros para todos los proveedores activos.
  - Identificador único por proveedor / planta.
  - Sellos de tiempo con precisión de minuto.

- **CRM**:
  - Clasificación de clientes actualizada mensualmente.
  - Coordenadas geográficas precisas (máximo error 100 metros).
  - Información de contrato con vigencia actualizada.

- **Plantas Renovables**:
  - Identificador único por planta y por equipos generadores.
  - Separación de tipos de energía (solar, eólica, hidráulica, biomasa)
  - Capacidad nominal documentada.

- **Datos Climáticos**:
  - API confiable con SLA de disponibilidad.
  - Cobertura geográfica que cubra todas las zonas de suministro.
  - Datos históricos con mínimo 2 años de antigüedad.

- **Calendarios y Eventos**:
  - Calendarios por zona de suministro (pueden variar regional y localmente).
  - Información de periodos vacacionales estacionales.

- **Mantenimiento Programado**:
  - Calendarios por planta de ejecuciones de mantenimiento en planta.
  - Información fechas y tiempo exacto de ejecución.

- **Disponibilidad de Equipos**:
  - Calendarios de disponibilidad de equipos de mantenimiento.
  - Información de tiempo de respuesta, distancia, ... a cada planta de producción.

### Requisitos de Calidad de Datos

En función de la naturaleza, origen y criticidad de los datos, aplicaremos una serie de requisitos de calidad:

- **Completitud**:
  - Contadores de medida: Mínimo 99% de registros diarios.
  - CRM: 100% de clientes activos con datos básicos.
  - Plantas Renovables: 99% de mediciones horarias.
  - Datos Climáticos: 95% disponibilidad.

- **Exactitud**:
  - Consumo eléctrico: ±2% respecto a medida estándar.
  - Producción energética: ±3% respecto a especificación técnica.
  - Coordenadas geográficas: Máximo error de 100 metros.
  - Temperaturas: ±1°C respecto a estación meteorológica oficial.

- **Consistencia**:
  - Consumo total de zona ≤ Producción total disponible.
  - Datos de cliente en CRM coinciden con identificador en Contador de medida.
  - Ubicación de cliente coherente con zona de suministro.
  - Permisos de acceso consistentes en los 3 últimos meses.

- **Exactitud de Marcas temporales**:
  - Contador de medida: Datos con máximo 30 minutos de retraso.
  - Plantas Renovables: Retraso máximo 15 minutos.
  - Datos Climáticos: Retraso máximo 1 hora.
  - Calendarios: Publicados con mínimo 3 meses de anticipación.

- **Unicidad**:
  - Sin registros duplicados en Contador de medida para un cliente y periodo.
  - Identificadores únicos en todas las tablas (clave primaria).
  - Sin clientes duplicados en CRM.

### Aspectos Específicos de Calidad y Gobierno

Todos los datos tratados dentro de nuestro proyecto cumplirán otros aspectos tanto legales como de calidad relacionados con el gobierno del dato, como:

**Anonimización y Cumplimiento GDPR**

- **Punto de Anonimización**: Inmediatamente después de validación inicial, antes de entrada a Data Lake.
- **Técnica**: Hash irreversible.
- **Datos Anonimizados**: Identificador de cliente.
- **Acceso a Datos Reales**: Solo usuarios autorizados con registro.

**Detección y Resolución de Duplicados**

- **Entidades**: Contador de medida, Entidades CRM, Plantas renovables.
- **Procedimiento**: Investigación mensual.

**Trazabilidad de Acceso a Datos**

- **Registro centralizado**: Sistema de auditoría para todos los accesos a datos.
- **Datos Críticos**: Contador de medida, CRM.

**Política de Retención de Datos**

- **Contador de medida**: 24 meses.
- **CRM**: Indefinido.
- **Datos climáticos**: 24 meses.
- **Logs de acceso**: 24 meses.
