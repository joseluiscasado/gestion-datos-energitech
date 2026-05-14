# Gestión de Datos en EnergiTech

Repositorio para versionado y desarrollo del proyecto de gestión de datos de la empresa EnergiTech.

## Descripción del Proyecto

### Contexto

**EnergiTech** es una multinacional dedicada a la distribución de energía renovable que actualmente se enfrenta a graves problemas operativos. Estos problemas tienen su raíz en los datos que se usan y explotan en los procesos de negocio de la organización.

### Problemas Identificados

Entre los principales problemas de calidad y acceso de datos se incluyen:

- **Duplicación de datos**: Los datos se encuentran duplicados en varios sistemas.
- **Errores de cálculo**: Los informes de consumo y predicción de la demanda presentan inconsistencias.
- **Falta de trazabilidad**: No existe un registro claro de quién accede a los datos sensibles ni con qué propósito.
- **Dificultad de reutilización**: Los problemas de calidad dificultan la explotación efectiva de los datos.

### Solución

La dirección de la organización ha decidido lanzar una **iniciativa de gobierno de datos** para mejorar la explotación del negocio y resolver estos problemas estructurales.

El equipo de gobierno del dato ha diseñado una estrategia del dato que incluye distintos programas de gobierno del dato; a su vez, estos incluyen proyectos específicos que, como responsables de la gestión de datos de EnergiTech, se nos ha pedido ejecutar siguiendo los procesos de gestión de datos especificados en la especificación **UNE 0078**.

## Proyectos

Este repositorio contiene los siguientes proyectos de gobierno de datos:

- ### [Proyecto 1: Procesamiento del Dato y Gestión de Requisitos](proyectos/proyecto-1-procesamiento-gestion-requisitos.md)

Implementación de un sistema de análisis predictivo basado en inteligencia artificial para la gestión de la demanda energética de EnergiTech. Este proyecto incluye la especificación completa de requisitos de datos, requisitos del proceso de negocio, y requisitos de calidad de datos.

- ### [Proyecto 2: Gestión de Metadatos y Ciclo de Vida del Dato](proyectos/proyecto-2-metadatos-ciclo-vida.md)

Creación de un marco integral de metadatos (glosario de términos, catálogo de datos, diccionario de datos) alineado con la norma UNE 0087, y definición del ciclo de vida completo del dato (Ingesta → Transformación → Almacenamiento → Explotación) con políticas de gobernanza y controles de validación. 

- ### [Proyecto 3: Gestión de Datos Maestros y Arquitectura y Diseño de Datos](proyectos/proyecto-3-datos-maestros-arquitectura.md)

Diseño e implementación de un repositorio centralizado de datos maestros (Master Data Management - MDM) para resolver el problema de silos de datos y duplicación de registros de clientes. Este proyecto incluye el modelo de datos maestros para la entidad Cliente, arquitectura de integración para sincronización entre sistemas, y políticas de gobernanza para garantizar la consistencia de datos.


- ### [Proyecto 4: Medición de la Calidad del Dato](proyectos/proyecto-4-calidad-del-dato.md)

Definición de un modelo de calidad del dato alineado con la norma UNE 0081, con selección y justificación de al menos tres características de calidad (Completitud, Exactitud, Actualidad, Consistencia o Unicidad), métodos de medición con fórmulas, procedimientos y umbrales acordes al apetito de riesgo de EnergiTech.


- ### [Proyecto 5: Control y Monitorización de Calidad del Dato](proyectos/proyecto-5-control-monitorizacion-calidad.md)

Establecimiento de un entorno operativo de monitorización continua de la calidad del dato. Este proyecto implementa procedimientos estandarizados de medición para cada característica de calidad definida anteriormente, crea un cuadro de mandos integral para visualizar el estado de calidad en tiempo real, e integra herramientas como OpenMetadata para enriquecer el catálogo de datos con métricas de calidad y linaje.


- ### [Proyecto 6: Evaluación de Madurez Organizacional](proyectos/proyecto-6-evaluacion-madurez.md)

Evaluación del nivel de madurez organizacional que EnergiTech ha alcanzado en su iniciativa de gobierno de datos, utilizando como marco de referencia la especificación **UNE 0080**. Incluye un análisis exhaustivo exploratorio de evidencias en diseño, implantación y ejecución de procesos de gobierno, gestión y calidad del dato, derivando el nivel de madurez alcanzado, y propone un plan de mejora.
