-- ============================================================
-- DIAGRAMA ENTIDAD-INTERRELACIÓN — EnergiTech
-- Importar en Visual Paradigm:
--   Diagram > New Diagram > Entity Relationship Diagram
--   > Import from DDL > seleccionar este archivo
-- ============================================================

-- ============================================================
-- ENTIDAD: zona
-- Zona geográfica de suministro energético
-- ============================================================
CREATE TABLE zona (
    id_zona              VARCHAR(50)  NOT NULL,
    nombre_zona          VARCHAR(100) NOT NULL,
    comunidad_autonoma   VARCHAR(100) NOT NULL,
    pais                 VARCHAR(10)  NOT NULL DEFAULT 'ES',
    PRIMARY KEY (id_zona)
);

-- ============================================================
-- ENTIDAD: planta_renovable
-- Planta de generación de energía renovable (solar, eólica, etc.)
-- ============================================================
CREATE TABLE planta_renovable (
    id_planta      VARCHAR(50)   NOT NULL,
    nombre_planta  VARCHAR(100)  NOT NULL,
    tipo_energia   VARCHAR(50)   NOT NULL,   -- solar, eolica, hidraulica, biomasa
    capacidad_mw   DECIMAL(10,3),
    latitud        DECIMAL(8,6),
    longitud       DECIMAL(9,6),
    id_zona        VARCHAR(50)   NOT NULL,
    PRIMARY KEY (id_planta),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);

-- ============================================================
-- ENTIDAD: estacion_meteorologica
-- Estación que provee datos climáticos
-- ============================================================
CREATE TABLE estacion_meteorologica (
    id_estacion     VARCHAR(50)  NOT NULL,
    nombre_estacion VARCHAR(100),
    latitud         DECIMAL(8,6),
    longitud        DECIMAL(9,6),
    id_zona         VARCHAR(50)  NOT NULL,
    PRIMARY KEY (id_estacion),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);

-- ============================================================
-- ENTIDAD: cliente_crm
-- Cliente en el sistema CRM operacional (fuente de verdad para datos de identidad)
-- ============================================================
CREATE TABLE cliente_crm (
    id_cliente         VARCHAR(50)   NOT NULL,
    tipo_cliente       VARCHAR(50)   NOT NULL,   -- Residencial, PYME, Industrial, Administracion
    latitud_ubicacion  DECIMAL(8,6),
    longitud_ubicacion DECIMAL(9,6),
    id_contrato        VARCHAR(50),
    id_zona            VARCHAR(50)   NOT NULL,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);

-- ============================================================
-- ENTIDAD: contador
-- Contador inteligente de medida de consumo eléctrico
-- ============================================================
CREATE TABLE contador (
    id_contador        VARCHAR(50)  NOT NULL,
    id_cliente         VARCHAR(50)  NOT NULL,
    id_zona            VARCHAR(50)  NOT NULL,
    estado             VARCHAR(20)  NOT NULL,
    fecha_instalacion  DATE,
    PRIMARY KEY (id_contador),
    FOREIGN KEY (id_cliente) REFERENCES cliente_crm(id_cliente),
    FOREIGN KEY (id_zona)    REFERENCES zona(id_zona)
);

-- ============================================================
-- ENTIDAD: cliente_maestro
-- Registro maestro del cliente en el repositorio MDM
-- (fuente de verdad única — golden record)
-- ============================================================
CREATE TABLE cliente_maestro (
    id_cliente_maestro           VARCHAR(50)   NOT NULL,
    id_nacional                  VARCHAR(20)   NOT NULL,
    id_fiscal                    VARCHAR(20),
    primer_nombre                VARCHAR(100)  NOT NULL,
    apellido_1                   VARCHAR(100)  NOT NULL,
    apellido_2                   VARCHAR(100),
    nombre_legal                 VARCHAR(250)  NOT NULL,
    email_principal              VARCHAR(200)  NOT NULL,
    email_secundario             VARCHAR(200),
    telefono_principal           VARCHAR(20)   NOT NULL,
    telefono_secundario          VARCHAR(20),
    direccion_postal             VARCHAR(300)  NOT NULL,
    codigo_postal                VARCHAR(10)   NOT NULL,
    ciudad                       VARCHAR(100)  NOT NULL,
    comunidad_autonoma           VARCHAR(100)  NOT NULL,
    pais                         VARCHAR(10)   NOT NULL,
    latitud                      DECIMAL(8,6)  NOT NULL,
    longitud                     DECIMAL(9,6)  NOT NULL,
    tipo_cliente                 VARCHAR(50)   NOT NULL,   -- Residencial, PYME, Industrial
    segmento_cliente             VARCHAR(50)   NOT NULL,   -- VIP, Estandar, Bajo Valor
    estado_contrato              VARCHAR(50)   NOT NULL,   -- Activo, Suspendido, Cancelado, Pendiente
    metodo_contacto_preferido    VARCHAR(20)   NOT NULL,   -- Email, Telefono, SMS, Carta
    idioma_comunicacion          VARCHAR(5)    NOT NULL,   -- ES, EN, FR
    id_crm                       VARCHAR(50),
    fecha_creacion               TIMESTAMP     NOT NULL,
    creado_por                   VARCHAR(100)  NOT NULL,
    fecha_ultima_actualizacion   TIMESTAMP     NOT NULL,
    actualizado_por              VARCHAR(100)  NOT NULL,
    razon_cambio                 VARCHAR(100),             -- Update, Merge, Split, Verification
    puntuacion_calidad_datos     DECIMAL(4,2)  NOT NULL,
    PRIMARY KEY (id_cliente_maestro),
    FOREIGN KEY (id_crm) REFERENCES cliente_crm(id_cliente)
);

-- ============================================================
-- ENTIDAD: servicio
-- Contrato de servicio asociado a un cliente maestro (Luz, Gas, Mantenimiento)
-- ============================================================
CREATE TABLE servicio (
    id_servicio         VARCHAR(50)  NOT NULL,
    tipo_servicio       VARCHAR(50)  NOT NULL,   -- Luz, Gas, Mantenimiento
    estado              VARCHAR(50)  NOT NULL,   -- Activo, Suspendido, Cancelado
    fecha_inicio        DATE         NOT NULL,
    fecha_fin           DATE,
    id_cliente_maestro  VARCHAR(50)  NOT NULL,
    PRIMARY KEY (id_servicio),
    FOREIGN KEY (id_cliente_maestro) REFERENCES cliente_maestro(id_cliente_maestro)
);

-- ============================================================
-- ENTIDAD: consumo
-- Lecturas de consumo energético de contadores inteligentes
-- Fuente: D001 del catálogo de datos
-- ============================================================
CREATE TABLE consumo (
    id_contador          VARCHAR(50)   NOT NULL,
    marca_tiempo         TIMESTAMP     NOT NULL,
    consumo_kwh          DECIMAL(18,4) NOT NULL,
    voltaje              DECIMAL(6,2),
    intensidad           DECIMAL(8,4),
    estado               VARCHAR(10)   NOT NULL,   -- OK, ALERTA, ERROR
    fecha_recepcion_raw  TIMESTAMP     NOT NULL,
    fecha_particion_datos DATE         NOT NULL,
    PRIMARY KEY (id_contador, marca_tiempo),
    FOREIGN KEY (id_contador) REFERENCES contador(id_contador)
);

-- ============================================================
-- ENTIDAD: produccion_planta
-- Datos de producción energética de plantas renovables
-- Fuente: D002 del catálogo de datos (sistemas SCADA)
-- ============================================================
CREATE TABLE produccion_planta (
    id_planta          VARCHAR(50)   NOT NULL,
    marca_tiempo       TIMESTAMP     NOT NULL,
    produccion_kwh     DECIMAL(18,4) NOT NULL,
    tipo_energia       VARCHAR(50)   NOT NULL,
    temperatura_equipo DECIMAL(6,2),
    PRIMARY KEY (id_planta, marca_tiempo),
    FOREIGN KEY (id_planta) REFERENCES planta_renovable(id_planta)
);

-- ============================================================
-- ENTIDAD: datos_climaticos
-- Variables meteorológicas externas
-- Fuente: D004 del catálogo de datos (APIs meteorológicas)
-- ============================================================
CREATE TABLE datos_climaticos (
    id_estacion      VARCHAR(50)   NOT NULL,
    marca_tiempo     TIMESTAMP     NOT NULL,
    temperatura      DECIMAL(5,2),
    humedad          DECIMAL(5,2),
    velocidad_viento DECIMAL(6,2),
    radiacion_solar  DECIMAL(8,2),
    precipitacion    DECIMAL(6,2),
    PRIMARY KEY (id_estacion, marca_tiempo),
    FOREIGN KEY (id_estacion) REFERENCES estacion_meteorologica(id_estacion)
);

-- ============================================================
-- ENTIDAD: calendario_laboral
-- Festivos, fines de semana y periodos vacacionales por zona
-- Fuente: D005 del catálogo de datos
-- ============================================================
CREATE TABLE calendario_laboral (
    id_zona    VARCHAR(50)  NOT NULL,
    fecha      DATE         NOT NULL,
    tipo_dia   VARCHAR(50)  NOT NULL,   -- Laborable, Sabado, Domingo, Festivo, Vacacional
    es_festivo BOOLEAN      NOT NULL,
    PRIMARY KEY (id_zona, fecha),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);

-- ============================================================
-- ENTIDAD: mantenimiento_programado
-- Planificación de mantenimiento de plantas renovables
-- Fuente: D006 del catálogo de datos
-- ============================================================
CREATE TABLE mantenimiento_programado (
    id_mantenimiento  VARCHAR(50)   NOT NULL,
    id_planta         VARCHAR(50)   NOT NULL,
    fecha_inicio      TIMESTAMP     NOT NULL,
    duracion_horas    DECIMAL(6,2)  NOT NULL,
    descripcion       VARCHAR(500),
    estado            VARCHAR(50),   -- Planificado, En curso, Completado, Cancelado
    PRIMARY KEY (id_mantenimiento),
    FOREIGN KEY (id_planta) REFERENCES planta_renovable(id_planta)
);

-- ============================================================
-- ENTIDAD: disponibilidad_equipo
-- Estado y ubicación de equipos de reparación ante emergencias
-- Fuente: D007 del catálogo de datos
-- ============================================================
CREATE TABLE disponibilidad_equipo (
    id_equipo  VARCHAR(50)  NOT NULL,
    estado     VARCHAR(50)  NOT NULL,   -- Disponible, No disponible, En mantenimiento
    tipo       VARCHAR(100) NOT NULL,
    ubicacion  VARCHAR(200) NOT NULL,
    id_zona    VARCHAR(50),
    PRIMARY KEY (id_equipo),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);

-- ============================================================
-- ENTIDAD: consumo_anonimizado
-- Datos de consumo con identificador anonimizado (hash SHA-256)
-- Fuente: D008 del catálogo — derivado de la tabla consumo
-- ============================================================
CREATE TABLE consumo_anonimizado (
    hash_cliente               VARCHAR(64)   NOT NULL,
    fecha_periodo_consumo      DATE          NOT NULL,
    consumo_diario_total_kwh   DECIMAL(18,4),
    carga_horaria_promedio_kw  DECIMAL(12,4),
    puntuacion_calidad         DECIMAL(4,2),
    PRIMARY KEY (hash_cliente, fecha_periodo_consumo)
);

-- ============================================================
-- ENTIDAD: prediccion_demanda
-- Resultado del modelo IA/ML de previsión energética
-- Fuente: D009 del catálogo de datos
-- ============================================================
CREATE TABLE prediccion_demanda (
    id_prediccion      VARCHAR(50)   NOT NULL,
    id_zona            VARCHAR(50)   NOT NULL,
    ventana_prediccion VARCHAR(10)   NOT NULL,   -- 24h, 48h, 7d
    fecha_prediccion   TIMESTAMP     NOT NULL,
    kwh_predicho       DECIMAL(18,4) NOT NULL,
    confianza          DECIMAL(4,2)  NOT NULL,
    validada           BOOLEAN       DEFAULT FALSE,
    PRIMARY KEY (id_prediccion),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);
