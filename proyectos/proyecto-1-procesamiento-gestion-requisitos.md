# Proyecto 1: Procesamiento del Dato y Gestión de Requisitos

## Contexto del Proyecto

EnergiTech quiere implementar un nuevo sistema de análisis predictivo basado en técnicas de inteligencia artificial para la gestión de la demanda energética, especialmente para garantizar la satisfacción de las necesidades de los clientes más críticos.

## Descripción del Proceso de Negocio que implica el cálculo de la previsión de la demanda energética

El proceso de negocio de previsión de la demanda energética es un ciclo continuo diseñado para optimizar la gestión de la producción y distribución de energía renovable. Este proceso busca anticipar la demanda de energía con precisión para garantizar la disponibilidad de suministro, evitar cortes de servicio y optimizar la operación de las plantas de energía, especialmente para clientes críticos. El proceso integra información de múltiples fuentes (consumo histórico, producción actual, factores climatológicos y eventos externos) y genera predicciones que alimentan las decisiones operativas en tiempo real.

<div align="center">

![Diagrama del Proceso - EnergiTech](../figuras/proceso-energitech.png)

</div>

Las principales fases del proceso de negocio son:

- **Recopilación de Información**: El proceso inicia mediante la recopilación integral de información de múltiples fuentes relevantes para la predicción: datos históricos de consumo de clientes, producción actual de plantas renovables, condiciones climáticas, calendarios de eventos y planes de mantenimiento.

- **Análisis y Validación**: La información recopilada se valida y se somete a análisis para asegurar su confiabilidad y consistencia. Se aplican reglas de negocio para identificar anomalías o inconsistencias que puedan afectar la calidad de las predicciones.

- **Generación de Predicción**: Se genera una previsión de demanda para los periodos requeridos (24 horas, 48 horas y semanal).

- **Revisión y Aprobación**: Los resultados de la predicción se someten a validación de negocio para verificar su coherencia antes de su aplicación operativa.

- **Difusión y Operación**: La predicción aprobada se comunica al sistema de gestión de red, analistas de demanda y sistemas automáticos de balanceo para su implementación operativa.

- **Seguimiento y Mejora Continua**: Se monitorea el comportamiento de las predicciones respecto a la demanda real, y los aprendizajes se utilizan para mejorar continuamente el modelo predictivo.

## Identificación de Requisitos de Datos

Identificación exhaustiva de los requisitos para el proceso de análisis predictivo de demanda energética, estructurados en tres capas: requisitos del proceso de negocio, requisitos de datos y requisitos de calidad.

### Requisitos del Proceso de Negocio

El análisis predictivo de la producción y demanda de energía renovable en un sistema en tiempo real es un proceso bastante complejo en el que intervienen gran cantidad de factores y es bastante propenso a la aparición de incidencias inesperadas que pueden provocar la necesidad de reajustes temporales. Entre los requisitos a tener en cuenta a la hora de desarrollar un sistema de esta naturaleza, podemos destacar:

- **[RP01] Precisión en la predicción**: Es aceptable una tolerancia de error máximo del 5% en la previsión de demanda.
- **[RP02] Marco Temporal**: Debe ser capaz de realizar predicciones para 24 horas, 48 horas y semanal.
- **[RP03] Posibilidad de Actualización**: El modelo puede ser reajustado y actualizado diariamente con los últimos resultados y los nuevos datos.
- **[RP04] Ámbito Geográfico**: Debe ser válido para cubrir todo el ámbito geográfico de los clientes y proveedores de energía.
- **[RP05] Accesibilidad**: El sistema debe ser accesible tanto para los operadores de red, analistas de demanda, sistemas automáticos de balanceo.
- **[RP06] Disponibilidad**: Es necesario ofrecer una elevada disponibilidad, un 99%.
- **[RP07] Tiempo de Respuesta**: Ejecución del modelo en menos de 5 minutos.
- **[RP08] Integración**: Conexión automática con sistema de gestión de red.
- **[RP09] Flexibilidad**: Posible adaptación a nuevos operadores de red y a nuevas demandas de clientes.

### Requisitos de Datos

Como en todo sistema basado en datos, la calidad de los mismos suele ser un factor clave en el éxito final del proceso. Según la fuente, el tipo de dato y sus características, aplicaremos los siguientes requisitos:

| Fuente de Datos | Datos Requeridos | Formato | Frecuencia | Periodo Histórico | 
|---|---|---|---|---|
| **Contadores de medida** | Consumo (kWh), voltaje, intensidad | CSV/JSON, agregación 15 min | 15 minutos | 24 meses |
| **Contadores de producción** | Producción (kWh), voltaje, intensidad | CSV/JSON, agregación 15 min | 15 minutos | 24 meses |
| **CRM** | ID Cliente, tipo (VIP/Estándar), ubicación, contrato | CSV/Base Datos | Diario | Activo | Encriptar datos sensibles |
| **Plantas Renovables** | Producción (kWh), tipo energía (solar/eólica), temperatura equipos | Time-series, 15 min | 15 minutos | 24 meses |
| **Datos Climáticos Externos** | Temperatura, humedad, velocidad viento, radiación solar, precipitación | JSON API, horario | Horario | 24 meses |
| **Calendarios Laborales** | Festivos, fines de semana, periodos vacacionales por zona | CSV | Semestral | 12 meses adelante |
| **Mantenimiento Programado** | Fecha, planta, equipos afectados, duración prevista | CSV/Eventos | Ad-hoc | 3 meses |
| **Disponibilidad de Equipos** | Estado (disponible/unavailable), tipo, ubicación | Real-time / API | Real-time | N/A |

**Requisitos Específicos de Fuentes:**

- **[RD01] Contadores de medida:** completitud, identificador único, sello temporal.  
- **[RD02] Contadores de producción:** completitud, identificador único, sello temporal.
- **[RD03] CRM:** clasificación de clientes actualizada, coordenadas geográficas precisas, información de contrato actualizada.
- **[RD04] Plantas Renovables:** identificador único, identificacion de tipo de energía, capacidad nominal.
- **[RD05] Datos Climáticos:** alta disponibilidad, cobertura geográfica, datos históricos con mínimo 2 años.
- **[RD06] Calendarios y Eventos:** calendarios por zona de suministro, información de periodos vacacionales.
- **[RD07] Mantenimiento Programado:** calendarios por planta e información fechas y tiempo exacto de ejecución.
- **[RD08] Disponibilidad de Equipos:** calendarios de disponibilidad de equipos de mantenimiento, tiempo de respuesta, distancia a cada planta de producción.

### Requisitos de Calidad de Datos

En función de la naturaleza, origen y criticidad de los datos, aplicaremos una serie de requisitos de calidad:

- **[RCD01] Completitud**:
  - Contadores de medida: Mínimo 99% de registros diarios.
  - CRM: 100% de clientes activos con datos básicos.
  - Plantas Renovables: 99% de mediciones horarias.
  - Datos Climáticos: 95% disponibilidad.

- **[RCD02] Exactitud**:
  - Consumo eléctrico: ±2% respecto a medida estándar.
  - Producción energética: ±3% respecto a especificación técnica.
  - Coordenadas geográficas: Máximo error de 100 metros.
  - Temperaturas: ±1°C respecto a estación meteorológica oficial.

- **[RCD03] Consistencia**:
  - Consumo total de zona ≤ Producción total disponible.
  - Datos de cliente en CRM coinciden con identificador en Contador de medida.
  - Ubicación de cliente coherente con zona de suministro.
  - Permisos de acceso consistentes en los 3 últimos meses.

- **[RCD04] Exactitud de Marcas temporales**:
  - Contador de medida: Datos con máximo 30 minutos de retraso.
  - Plantas Renovables: Retraso máximo 15 minutos.
  - Datos Climáticos: Retraso máximo 1 hora.
  - Calendarios: Publicados con mínimo 3 meses de anticipación.

- **[RCD05] Unicidad**:
  - Sin registros duplicados en Contador de medida para un cliente y periodo.
  - Identificadores únicos en todas las tablas (clave primaria).
  - Sin clientes duplicados en CRM.

### Aspectos Específicos de Calidad y Gobierno

Todos los datos tratados dentro de nuestro proyecto cumplirán otros aspectos tanto legales como de calidad relacionados con el gobierno del dato, como:

**[RCG01] Anonimización y Cumplimiento GDPR**  
**[RCG02] Detección y Resolución de Duplicados**  
**[RCG03] Trazabilidad de Acceso a Datos**  
**[RCG04] Política de Retención de Datos**
