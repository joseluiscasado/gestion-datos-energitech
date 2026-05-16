# Proyecto 6: Evaluación de Madurez Organizacional según MAMD


## 1. Introducción

Para finalizar, afrontaremos la evaluación del **nivel de madurez organizacional** que EnergiTech ha alcanzado en su iniciativa de gobierno de datos, utilizando como referencia el **Modelo Alarcos de Madurez de Datos (MAMD)**.

---

## 2. MAMD (Modelo Alarcos de Madurez de Datos)

El MAMD utiliza un **modelo bidimensional** que combina:

- Dimensión de Capacidad (5 + 1 Niveles - NC):

0. Incompleto
1. Realizado
2. Gestionado
3. Establecido 
4. Predecible
5. Innovado

- Dimensión de Procesos (5 Niveles de Madurez - NM):

1. Nivel Realizado
2. Nivel Gestionado
3. Nivel Establecido
4. Nivel Predecible
5. Nivel Innovado

La evaluación de cada proceso se realiza mediante **calificaciones ISO 33000**:

| Calificación  | Descripción |
|--------------|-------------|
| **F** | Proceso Completamente Implementado |
| **L** | Proceso Ampliamente Implementado |
| **P** | Proceso Parcialmente Implementado |
| **N** | Proceso No Implementado |

Para alcanzar un nivel de madurez, se deben cumplir:

| Nivel Madurez | Condiciones |
|---------------|-------------|
| **(1) Realizado** | Todos los procesos NM1 con calificación **F** |
| **(2) Gestionado** | Todos NM1 con **F** + Todos NM2 con al menos **L** |
| **(3) Establecido** | Todos NM1 y NM2 con **F** + Todos NM3 con al menos **L** |
| **(4) Predecible** | Todos NM1, NM2 y NM3 con **F** + Todos NM4 con al menos **L** |
| **(5) Innovado** | Todos NM1, NM2, NM3 y NM4 con **F** + Todos NM5 con al menos **L** |


## 3. Evaluación de Madurez de EnergiTech

### 3.1 Nivel 1 - Realizado

| Proceso | Código | Nivel Capacidad | Calificación | Evidencias |
|---------|--------|----------------|--------------|------------|
| Procesamiento del dato | ProcDat | NC2 | **F** | Scripts ETL implementados, pipelines automatizados, logs de ejecución |
| Gestión infraestructura tecnológica | InfraTec | NC2 | **F** | MySQL configurado, OpenMetadata desplegado |

**Análisis de Capacidad:**
- **AP.1.1 (Rendimiento)**: Ambos procesos alcanzan sus resultados definidos (F)
- **AP.2.1 (Gestión del Rendimiento)**: Objetivos identificados, planificación definida, monitorización activa (F)
- **AP.2.2 (Gestión Productos de Trabajo)**: Scripts documentados, bases de datos versionadas, cambios controlados (F)

**Conclusión NM1**: **Todos los procesos con calificación F**

---

#### 3.2.2 Nivel 2 - Gestionado

| Proceso | Código | Nivel Capacidad | Calificación | Evidencias |
|---------|--------|----------------|--------------|------------|
| Gestión de requisitos del dato | ReqDat | NC3 | **F** | Modelo E/R documentado, especificaciones de tablas, requisitos de calidad definidos |
| Gestión de configuración del dato | ConfDat | NC2 | **F** | Esquemas SQL versionados, configuración de tablas documentada |
| Gestión de datos históricos | DatHist | NC2 | **L** | Timestamps en tablas, pero sin política formal de retención |
| Gestión de seguridad del dato | SegDat | NC2 | **L** | Autenticación MySQL, pero falta cifrado y control de acceso granular |
| Gestión del metadato | MetDat | NC3 | **F** | Catálogo OpenMetadata, glosario de negocio, trazabilidad implementada |
| Control y monitorización calidad | CtrlDQ | NC3 | **F** | Test suites definidos, procedimientos de medición, dashboards de monitorización |
| Establecimiento de políticas | PolDat | NC2 | **L** | Políticas documentadas en proyectos, pero sin formalización corporativa |

**Análisis de Capacidad:**
- **AP.3.1 (Definición)**: Procesos estándar definidos para la mayoría (ReqDat, MetDat, CtrlDQ)
- **AP.3.2 (Despliegue)**: Procesos desplegados con roles asignados y competencias identificadas
- **Áreas de mejora**: Formalización de políticas de retención, seguridad avanzada, políticas corporativas

**Conclusión NM2**: **Todos los procesos con calificación L o superior**

---

#### 3.2.3 Nivel 3 - Establecido

**Procesos evaluados:**

| Proceso | Código | Nivel Capacidad | Calificación | Evidencias |
|---------|--------|----------------|--------------|------------|
| Gestión arquitectura y diseño | ArqDat | NC3 | **F** | Arquitectura MDM diseñada, modelo de capas documentado, diagramas técnicos |
| Compartición e integración | CIIDat | NC2 | **L** | ETL implementado, pero falta APIs y servicios de datos |
| Gestión del dato maestro | MDM | NC3 | **F** | Sistema MDM implementado, reglas de coincidencia, golden records |
| Gestión de recursos humanos | RRHH | NC2 | **P** | Roles definidos, pero sin programa formal de capacitación |
| Gestión del ciclo de vida | CVidDat | NC3 | **F** | Modelo de ciclo de vida documentado, trazabilidad de metadatos |
| Análisis del dato | AnaDat | NC2 | **L** | Análisis de calidad implementado, pero sin analítica avanzada predictiva |
| Planificación de calidad | PlanDQ | NC3 | **F** | ISO 25012 aplicado, métricas definidas, plan de medición estructurado |
| Establecimiento de estrategia | EstDat | NC3 | **L** | Estrategia documentada en proyectos, pero sin roadmap a largo plazo |
| Establecimiento de estructuras | EstOrg | NC3 | **L** | Roles documentados (Data Steward, Owner), pero sin comité formal de gobierno |
| Optimización de riesgos | RiesDat | NC2 | **P** | Riesgos identificados, pero sin gestión formal de riesgos |

**Análisis de Capacidad:**
- **Fortalezas**: ArqDat, MDM, CVidDat, PlanDQ completamente implementados
- **Áreas de mejora**: Falta programa de capacitación (RRHH), gestión formal de riesgos (RiesDat), comité de gobierno (EstOrg)
- **Nivel alcanzado**: No todos los procesos alcanzan "L", algunos en "P"

**Conclusión NM3**: **No todos los procesos con calificación L o superior**

---

El resto de niveles no han sido evaluados ya que no se alcanza el nivel 3.

---

### 3.3 Nivel de Madurez de la Organización

**Evaluación por Niveles:**

| Nivel | Condición Requerida | Cumplimiento | Estado |
|-------|-------------------|--------------|--------|
| **NM1 - Realizado** | Todos NM1 con F | 2/2 procesos con F | **ALCANZADO** |
| **NM2 - Gestionado** | Todos NM1 con F + NM2 con L o superior | 7/7 procesos con L+ | **ALCANZADO** |
| **NM3 - Establecido** | Todos NM1-2 con F + NM3 con L o superior | 8/10 procesos con L+ (RRHH=P, RiesDat=P) | **NO ALCANZADO** |
| **NM4 - Predecible** | - | No evaluado | - |
| **NM5 - Innovado** | - | No evaluado | - |

Nivel de Madurez Alcanzado: **NM2 - GESTIONADO**

---

## 4. Plan de Mejora para Alcanzar NM3

### 4.1 Objetivo del Plan

Fortalecer los procesos deficientes identificados en la evaluación para alcanzar el **Nivel de Madurez 3 - Establecido** según MAMD, completando la implementación de todos los procesos de NM3 con al menos calificación "L".

### 4.2 Procesos Prioritarios a Fortalecer

#### 4.2.1 Gestión de RRHH (RRHH) - Actual: P → Objetivo: L

**Tareas:**

**1. Crear Academia de Datos EnergiTech** para establecer programa estructurado de capacitación en gestión de datos.

**2. Definir Marco de Competencias de Datos**para documentar competencias requeridas por rol.

**3. Implementar Evaluación de Competencias** para evaluar y hacer seguimiento del desarrollo de competencias.

---

#### 4.2.2 Optimización de Riesgos (RiesDat) - Actual: P → Objetivo: L

**Tareas:**

**1. Establecer Registro de Riesgos del Dato** en el que dentificar y documentar riesgos relacionados con datos.

**2. Definir Proceso de Gestión de Riesgos** para establecer metodología sistemática de gestión de riesgos.

**3. Implementar Estrategias de Mitigación** donde definir e implementar controles para riesgos críticos.

---

#### 4.2.3 Establecimiento de Estructuras Organizativas (EstOrg) - Actual: L → Objetivo: F

**Tareas:**

**1. Crear Comité de Gobierno de Datos** para establecer estructura formal de toma de decisiones.

**2. Definir Procedimiento de Escalado** donde establecer flujo de escalado de conflictos y decisiones.

**3. Implementar Reuniones Estructuradas de Gobierno** y realmente ejecutar gobierno de datos de forma sistemática.

---

#### 4.2.4 Establecimiento de Estrategia (EstDat) - Actual: L → Objetivo: F

**Tareas:**

**1. Desarrollar Estrategia de Datos a 3 Años** y formalizar estrategia de datos con visión a largo plazo.

**2. Comunicar Estrategia a la Organización** para asegurar comprensión y compromiso organizacional.

**3. Revisar y Actualizar Estrategia Anualmente** para mantener la estrategia alineada con evolución del negocio.

---