-- ============================================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA - ENERGITECH DB
-- Generado: 2026-05-07
-- Registros totales aproximados: ~18,000
-- ============================================================

-- Deshabilitar checks de FK temporalmente para acelerar inserciones
SET FOREIGN_KEY_CHECKS=0;

-- ============================================================
-- 1. TABLA: zona (10 registros)
-- ============================================================
INSERT INTO zona (id_zona, nombre_zona, comunidad_autonoma, pais) VALUES
('ZONA_001', 'Zona Centro Madrid', 'Madrid', 'España'),
('ZONA_002', 'Zona Sur Madrid', 'Madrid', 'España'),
('ZONA_003', 'Zona Este Madrid', 'Madrid', 'España'),
('ZONA_004', 'Zona Oeste Madrid', 'Madrid', 'España'),
('ZONA_005', 'Zona Norte Madrid', 'Madrid', 'España'),
('ZONA_006', 'Alcalá de Henares', 'Madrid', 'España'),
('ZONA_007', 'Torrejón de Ardoz', 'Madrid', 'España'),
('ZONA_008', 'Getafe', 'Madrid', 'España'),
('ZONA_009', 'Móstoles',  'Madrid', 'España'),
('ZONA_010', 'Fuenlabrada', 'Madrid', 'España');

-- ============================================================
-- 2. TABLA: cliente_crm (150 registros)
-- ============================================================
INSERT INTO cliente_crm (id_cliente, tipo_cliente, latitud_ubicacion, longitud_ubicacion, id_contrato, id_zona) 
SELECT 
    CONCAT('CRM_', LPAD(id, 6, '0')) as id_cliente,
    ELT((id % 4) + 1, 'Residencial', 'PYME', 'Industrial', 'Administracion') as tipo_cliente,
    40.4168 + ((id % 100) - 50) * 0.01 as latitud_ubicacion,
    -3.7038 + ((id % 100) - 50) * 0.01 as longitud_ubicacion,
    CONCAT('CONT_', LPAD(id, 6, '0')) as id_contrato,
    ELT((id % 10) + 1, 'ZONA_001', 'ZONA_002', 'ZONA_003', 'ZONA_004', 'ZONA_005', 
                       'ZONA_006', 'ZONA_007', 'ZONA_008', 'ZONA_009', 'ZONA_010') as id_zona
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT @row:=0) init
) nums WHERE id <= 150;

-- ============================================================
-- 3. TABLA: contador (500 registros - múltiples por cliente)
-- ============================================================
INSERT INTO contador (id_contador, id_cliente, id_zona, estado, fecha_instalacion)
SELECT 
    CONCAT('CNTR_', LPAD(id, 7, '0')) as id_contador,
    CONCAT('CRM_', LPAD(((id-1) DIV 4) + 1, 6, '0')) as id_cliente,
    ELT((((id-1) DIV 40) % 10) + 1, 'ZONA_001', 'ZONA_002', 'ZONA_003', 'ZONA_004', 'ZONA_005',
                                      'ZONA_006', 'ZONA_007', 'ZONA_008', 'ZONA_009', 'ZONA_010') as id_zona,
    ELT((id % 3) + 1, 'Activo', 'Inactivo', 'En Mantenimiento') as estado,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY) as fecha_instalacion
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t4,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t5,
         (SELECT @row:=0) init
) nums WHERE id <= 500;

-- ============================================================
-- 4. TABLA: planta_renovable (15 registros)
-- ============================================================
INSERT INTO planta_renovable (id_planta, nombre_planta, tipo_energia, capacidad_mw, latitud, longitud, id_zona)
VALUES
('PLANTA_001', 'Parque Solar Centro Madrid', 'solar', 50.000, 40.4168, -3.7038, 'ZONA_001'),
('PLANTA_002', 'Parque Solar Sur Madrid', 'solar', 75.500, 40.3600, -3.6900, 'ZONA_002'),
('PLANTA_003', 'Parque Eólico Este', 'eolica', 120.000, 40.4500, -3.5000, 'ZONA_003'),
('PLANTA_004', 'Parque Eólico Oeste', 'eolica', 150.000, 40.4200, -3.8500, 'ZONA_004'),
('PLANTA_005', 'Central Hidroeléctrica Norte', 'hidraulica', 200.000, 40.7000, -3.6000, 'ZONA_005'),
('PLANTA_006', 'Planta Biomasa Alcalá', 'biomasa', 25.500, 40.4820, -3.3580, 'ZONA_006'),
('PLANTA_007', 'Parque Solar Torrejón', 'solar', 40.000, 40.4500, -3.4500, 'ZONA_007'),
('PLANTA_008', 'Parque Eólico Getafe', 'eolica', 90.000, 40.3200, -3.7300, 'ZONA_008'),
('PLANTA_009', 'Parque Solar Móstoles', 'solar', 55.000, 40.3200, -3.8600, 'ZONA_009'),
('PLANTA_010', 'Central Híbrida Fuenlabrada', 'solar', 65.000, 40.2900, -3.8100, 'ZONA_010'),
('PLANTA_011', 'Parque Eólico Ampliación Centro', 'eolica', 100.000, 40.4300, -3.6800, 'ZONA_001'),
('PLANTA_012', 'Parque Solar Ampliación Sur', 'solar', 45.000, 40.3500, -3.7200, 'ZONA_002'),
('PLANTA_013', 'Planta Biomasa Ampliación', 'biomasa', 30.000, 40.5200, -3.5000, 'ZONA_005'),
('PLANTA_014', 'Parque Solar Flotante', 'solar', 35.000, 40.6000, -3.4000, 'ZONA_006'),
('PLANTA_015', 'Parque Eólico Marina', 'eolica', 180.000, 40.7500, -3.3500, 'ZONA_007');

-- ============================================================
-- 5. TABLA: estacion_meteorologica (20 registros)
-- ============================================================
INSERT INTO estacion_meteorologica (id_estacion, nombre_estacion, latitud, longitud, id_zona)
SELECT 
    CONCAT('EST_', LPAD(id, 4, '0')) as id_estacion,
    CONCAT('Estación Meteorológica ', id) as nombre_estacion,
    40.4168 + (RAND() * 0.5 - 0.25) as latitud,
    -3.7038 + (RAND() * 0.5 - 0.25) as longitud,
    ELT((id % 10) + 1, 'ZONA_001', 'ZONA_002', 'ZONA_003', 'ZONA_004', 'ZONA_005',
                       'ZONA_006', 'ZONA_007', 'ZONA_008', 'ZONA_009', 'ZONA_010') as id_zona
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t2,
         (SELECT @row:=0) init
) nums WHERE id <= 20;

-- ============================================================
-- 6. TABLA: cliente_maestro (150 registros)
-- ============================================================
INSERT INTO cliente_maestro 
(id_cliente_maestro, id_nacional, id_fiscal, primer_nombre, apellido_1, apellido_2, 
 nombre_legal, email_principal, email_secundario, telefono_principal, telefono_secundario,
 direccion_postal, codigo_postal, ciudad, comunidad_autonoma, pais, latitud, longitud,
 tipo_cliente, segmento_cliente, estado_contrato, metodo_contacto_preferido, idioma_comunicacion,
 id_crm, fecha_creacion, creado_por, fecha_ultima_actualizacion, actualizado_por, 
 razon_cambio, puntuacion_calidad_datos)
SELECT 
    CONCAT('MAST_', LPAD(id, 6, '0')) as id_cliente_maestro,
    CONCAT(LPAD(id, 8, '0'), CHAR(65 + (RAND() * 25))) as id_nacional,
    CONCAT('VAT', LPAD(id, 8, '0')) as id_fiscal,
    ELT((id % 5) + 1, 'Juan', 'María', 'Carlos', 'Ana', 'Roberto') as primer_nombre,
    ELT((id % 7) + 1, 'García', 'López', 'Martínez', 'Rodríguez', 'Fernández', 'Pérez', 'Sánchez') as apellido_1,
    IF(RAND() > 0.3, ELT((id % 6) + 1, 'González', 'Hernández', 'Jiménez', 'Díaz', 'Ruiz', 'Moreno'), NULL) as apellido_2,
    CONCAT('Cliente Energía ', id) as nombre_legal,
    CONCAT('cliente', id, '@energitech.es') as email_principal,
    IF(RAND() > 0.5, CONCAT('alt', id, '@energitech.es'), NULL) as email_secundario,
    CONCAT('+34', LPAD(FLOOR(RAND() * 900000000 + 100000000), 9, '0')) as telefono_principal,
    IF(RAND() > 0.6, CONCAT('+34', LPAD(FLOOR(RAND() * 900000000 + 100000000), 9, '0')), NULL) as telefono_secundario,
    CONCAT('Calle Principal ', id % 100, ', ', id, 'A') as direccion_postal,
    LPAD(FLOOR(28000 + (id % 15000)), 5, '0') as codigo_postal,
    ELT((id % 10) + 1, 'Madrid', 'Alcalá de Henares', 'Torrejón de Ardoz', 'Getafe', 'Móstoles',
                       'Fuenlabrada', 'Leganés', 'Rivas-Vaciamadrid', 'San Sebastián de los Reyes', 'Coslada') as ciudad,
    'Madrid' as comunidad_autonoma,
    'España' as pais,
    40.4168 + ((id % 100) - 50) * 0.01 as latitud,
    -3.7038 + ((id % 100) - 50) * 0.01 as longitud,
    ELT((id % 3) + 1, 'Residencial', 'PYME', 'Industrial') as tipo_cliente,
    ELT((id % 3) + 1, 'VIP', 'Estándar', 'Bajo Valor') as segmento_cliente,
    ELT((id % 4) + 1, 'Activo', 'Suspendido', 'Cancelado', 'Pendiente') as estado_contrato,
    ELT((id % 4) + 1, 'Email', 'Teléfono', 'SMS', 'Carta') as metodo_contacto_preferido,
    'ES' as idioma_comunicacion,
    CONCAT('CRM_', LPAD(id, 6, '0')) as id_crm,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 1095) DAY) as fecha_creacion,
    'ADMIN_SYSTEM' as creado_por,
    NOW() as fecha_ultima_actualizacion,
    'BATCH_PROCESS' as actualizado_por,
    ELT((id % 3) + 1, 'Update', 'Merge', 'Verification') as razon_cambio,
    ROUND(70 + (RAND() * 30), 2) as puntuacion_calidad_datos
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT @row:=0) init
) nums WHERE id <= 150;

-- ============================================================
-- 7. TABLA: servicio (300 registros - múltiples servicios por cliente)
-- ============================================================
INSERT INTO servicio (id_servicio, tipo_servicio, estado, fecha_inicio, fecha_fin, id_cliente_maestro)
SELECT 
    CONCAT('SERV_', LPAD(id, 7, '0')) as id_servicio,
    ELT((id % 3) + 1, 'Luz', 'Gas', 'Mantenimiento') as tipo_servicio,
    IF(RAND() > 0.2, 'Activo', ELT((id % 3) + 1, 'Suspendido', 'Cancelado', 'Activo')) as estado,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 1095) DAY) as fecha_inicio,
    IF(RAND() > 0.3, DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY), NULL) as fecha_fin,
    CONCAT('MAST_', LPAD(((id - 1) DIV 2) + 1, 6, '0')) as id_cliente_maestro
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t4,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2) t5,
         (SELECT @row:=0) init
) nums WHERE id <= 300;

-- ============================================================
-- 8. TABLA: consumo (5000 registros - lecturas diarias de contadores)
-- ============================================================
INSERT INTO consumo (id_contador, marca_tiempo, consumo_kwh, voltaje, intensidad, estado, fecha_recepcion_raw, fecha_particion_datos)
SELECT 
    CONCAT('CNTR_', LPAD((id % 500) + 1, 7, '0')) as id_contador,
    DATE_SUB(NOW(), INTERVAL FLOOR((id - 1) / 5) HOUR) as marca_tiempo,
    ROUND(5 + RAND() * 45, 4) as consumo_kwh,
    ROUND(220 + RAND() * 20, 2) as voltaje,
    ROUND(5 + RAND() * 30, 4) as intensidad,
    ELT((id % 50) + 1, IF(RAND() > 0.92, 'ALERTA', 'OK'), 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 
        IF(RAND() > 0.98, 'ERROR', 'OK'), 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 
        'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK') as estado,
    DATE_SUB(NOW(), INTERVAL (FLOOR((id - 1) / 5) * 60 + FLOOR(RAND() * 60)) MINUTE) as fecha_recepcion_raw,
    DATE_SUB(CURDATE(), INTERVAL (id - 1) DIV 120 DAY) as fecha_particion_datos
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t4,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t5,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t6,
         (SELECT @row:=0) init
) nums WHERE id <= 5000;

-- ============================================================
-- 9. TABLA: produccion_planta (3000 registros - producción horaria)
-- ============================================================
INSERT INTO produccion_planta (id_planta, marca_tiempo, produccion_kwh, tipo_energia, temperatura_equipo)
SELECT 
    CONCAT('PLANTA_', LPAD((id % 15) + 1, 3, '0')) as id_planta,
    DATE_SUB(NOW(), INTERVAL FLOOR((id - 1) / 15) HOUR) as marca_tiempo,
    CASE 
        WHEN (id % 15) + 1 IN (1, 2, 7, 9, 12, 14) THEN ROUND((RAND() * 50 + 20), 4)  -- Solar
        WHEN (id % 15) + 1 IN (3, 4, 8, 11, 15) THEN ROUND((RAND() * 150 + 80), 4)  -- Eólica
        WHEN (id % 15) + 1 = 5 THEN ROUND((RAND() * 200 + 100), 4)  -- Hidráulica
        ELSE ROUND((RAND() * 30 + 15), 4)  -- Biomasa
    END as produccion_kwh,
    ELT(((id % 15) % 4) + 1, 'solar', 'eolica', 'hidraulica', 'biomasa') as tipo_energia,
    ROUND(20 + RAND() * 30, 2) as temperatura_equipo
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2) t5,
         (SELECT @row:=0) init
) nums WHERE id <= 3000;

-- ============================================================
-- 10. TABLA: datos_climaticos (2000 registros - observaciones cada 6 horas)
-- ============================================================
INSERT INTO datos_climaticos (id_estacion, marca_tiempo, temperatura, humedad, velocidad_viento, radiacion_solar, precipitacion)
SELECT 
    CONCAT('EST_', LPAD((id % 20) + 1, 4, '0')) as id_estacion,
    DATE_SUB(NOW(), INTERVAL FLOOR((id - 1) / 20) * 6 HOUR) as marca_tiempo,
    ROUND(10 + RAND() * 25, 2) as temperatura,
    ROUND(30 + RAND() * 50, 2) as humedad,
    ROUND(0 + RAND() * 35, 2) as velocidad_viento,
    ROUND(IF(HOUR(NOW()) BETWEEN 6 AND 18, RAND() * 800, 0), 2) as radiacion_solar,
    ROUND(IF(RAND() > 0.7, RAND() * 50, 0), 2) as precipitacion
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT @row:=0) init
) nums WHERE id <= 2000;

-- ============================================================
-- 11. TABLA: calendario_laboral (3650 registros - 10 años)
-- ============================================================
INSERT INTO calendario_laboral (id_zona, fecha, tipo_dia, es_festivo)
SELECT 
    ELT((id % 10) + 1, 'ZONA_001', 'ZONA_002', 'ZONA_003', 'ZONA_004', 'ZONA_005',
                       'ZONA_006', 'ZONA_007', 'ZONA_008', 'ZONA_009', 'ZONA_010') as id_zona,
    DATE_SUB(CURDATE(), INTERVAL (id - 1) DIV 10 DAY) as fecha,
    CASE DAYOFWEEK(DATE_SUB(CURDATE(), INTERVAL (id - 1) DIV 10 DAY))
        WHEN 1 THEN 'Domingo'
        WHEN 7 THEN 'Sábado'
        WHEN 2 THEN 'Laborable'
        WHEN 3 THEN 'Laborable'
        WHEN 4 THEN 'Laborable'
        WHEN 5 THEN 'Laborable'
        WHEN 6 THEN 'Laborable'
    END as tipo_dia,
    CASE DAYOFWEEK(DATE_SUB(CURDATE(), INTERVAL (id - 1) DIV 10 DAY))
        WHEN 1 THEN TRUE
        WHEN 7 THEN TRUE
        ELSE FALSE
    END as es_festivo
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t4,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t5,
         (SELECT @row:=0) init
) nums WHERE id <= 3650;

-- ============================================================
-- 12. TABLA: mantenimiento_programado (100 registros)
-- ============================================================
INSERT INTO mantenimiento_programado (id_mantenimiento, id_planta, fecha_inicio, duracion_horas, descripcion, estado)
SELECT 
    CONCAT('MANT_', LPAD(id, 6, '0')) as id_mantenimiento,
    CONCAT('PLANTA_', LPAD((id % 15) + 1, 3, '0')) as id_planta,
    DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 180) DAY) as fecha_inicio,
    ROUND(4 + RAND() * 20, 2) as duracion_horas,
    ELT((id % 6) + 1, 'Revisión general', 'Cambio de aceite', 'Limpieza de paneles', 
        'Inspección de turbina', 'Mantenimiento preventivo', 'Reparación de componentes') as descripcion,
    ELT((id % 4) + 1, 'Planificado', 'En curso', 'Completado', 'Cancelado') as estado
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t3,
         (SELECT @row:=0) init
) nums WHERE id <= 100;

-- ============================================================
-- 13. TABLA: disponibilidad_equipo (50 registros)
-- ============================================================
INSERT INTO disponibilidad_equipo (id_equipo, estado, tipo, ubicacion, id_zona)
SELECT 
    CONCAT('EQUIP_', LPAD(id, 5, '0')) as id_equipo,
    ELT((id % 3) + 1, 'Disponible', 'No disponible', 'En mantenimiento') as estado,
    ELT((id % 8) + 1, 'Transformador', 'Disyuntor', 'Cable de transmisión', 'Panel de control',
                      'Alternador', 'Compresor', 'Bomba de agua', 'Sensor de temperatura') as tipo,
    CONCAT('Almacén ', ELT((id % 4) + 1, 'Central', 'Sur', 'Este', 'Oeste'), ' - Zona ', (id % 100)) as ubicacion,
    ELT((id % 10) + 1, 'ZONA_001', 'ZONA_002', 'ZONA_003', 'ZONA_004', 'ZONA_005',
                       'ZONA_006', 'ZONA_007', 'ZONA_008', 'ZONA_009', 'ZONA_010') as id_zona
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT @row:=0) init
) nums WHERE id <= 50;

-- ============================================================
-- 14. TABLA: consumo_anonimizado (1000 registros)
-- ============================================================
INSERT INTO consumo_anonimizado (hash_cliente, fecha_periodo_consumo, consumo_diario_total_kwh, carga_horaria_promedio_kw, puntuacion_calidad)
SELECT 
    SHA2(CONCAT('cliente_', id % 500), 256) as hash_cliente,
    DATE_SUB(CURDATE(), INTERVAL (id % 365) DAY) as fecha_periodo_consumo,
    ROUND(15 + RAND() * 85, 4) as consumo_diario_total_kwh,
    ROUND(0.6 + RAND() * 3.5, 4) as carga_horaria_promedio_kw,
    ROUND(75 + RAND() * 25, 2) as puntuacion_calidad
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT @row:=0) init
) nums WHERE id <= 1000;

-- ============================================================
-- 15. TABLA: prediccion_demanda (1000 registros)
-- ============================================================
INSERT INTO prediccion_demanda (id_prediccion, id_zona, ventana_prediccion, fecha_prediccion, kwh_predicho, confianza, validada)
SELECT 
    CONCAT('PRED_', LPAD(id, 7, '0')) as id_prediccion,
    ELT((id % 10) + 1, 'ZONA_001', 'ZONA_002', 'ZONA_003', 'ZONA_004', 'ZONA_005',
                       'ZONA_006', 'ZONA_007', 'ZONA_008', 'ZONA_009', 'ZONA_010') as id_zona,
    ELT((id % 3) + 1, '24h', '48h', '7d') as ventana_prediccion,
    DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 7) DAY) as fecha_prediccion,
    ROUND(1000 + RAND() * 5000, 4) as kwh_predicho,
    ROUND(0.75 + RAND() * 0.25, 2) as confianza,
    IF(RAND() > 0.3, TRUE, FALSE) as validada
FROM (
    SELECT @row := @row + 1 as id
    FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3,
         (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4,
         (SELECT @row:=0) init
) nums WHERE id <= 1000;

-- ============================================================
-- Reabilitar checks de FK
-- ============================================================
SET FOREIGN_KEY_CHECKS=1;

-- ============================================================
-- RESUMEN DE INSERCIONES
-- ============================================================
-- Zona:                    10 registros
-- Cliente CRM:             150 registros
-- Contador:                500 registros
-- Planta Renovable:        15 registros
-- Estación Meteorológica:  20 registros
-- Cliente Maestro:         150 registros
-- Servicio:                300 registros
-- Consumo:               5,000 registros
-- Producción Planta:     3,000 registros
-- Datos Climáticos:      2,000 registros
-- Calendario Laboral:    3,650 registros
-- Mantenimiento:          100 registros
-- Disponibilidad Equipo:   50 registros
-- Consumo Anonimizado:   1,000 registros
-- Predicción Demanda:    1,000 registros
-- ============================================================
-- TOTAL APROXIMADO:     18,945 REGISTROS
-- ============================================================

-- Validación final
SELECT 
    (SELECT COUNT(*) FROM zona) as total_zona,
    (SELECT COUNT(*) FROM cliente_crm) as total_cliente_crm,
    (SELECT COUNT(*) FROM contador) as total_contador,
    (SELECT COUNT(*) FROM planta_renovable) as total_planta_renovable,
    (SELECT COUNT(*) FROM estacion_meteorologica) as total_estacion,
    (SELECT COUNT(*) FROM cliente_maestro) as total_cliente_maestro,
    (SELECT COUNT(*) FROM servicio) as total_servicio,
    (SELECT COUNT(*) FROM consumo) as total_consumo,
    (SELECT COUNT(*) FROM produccion_planta) as total_produccion,
    (SELECT COUNT(*) FROM datos_climaticos) as total_climaticos,
    (SELECT COUNT(*) FROM calendario_laboral) as total_calendario,
    (SELECT COUNT(*) FROM mantenimiento_programado) as total_mantenimiento,
    (SELECT COUNT(*) FROM disponibilidad_equipo) as total_equipos,
    (SELECT COUNT(*) FROM consumo_anonimizado) as total_anonimizado,
    (SELECT COUNT(*) FROM prediccion_demanda) as total_prediccion;
