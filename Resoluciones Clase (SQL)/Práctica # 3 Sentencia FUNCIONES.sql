-- Práctica Nº 3: Funciones de presentación de datos
-- Practica Complementaria: 1 – 2 – 3 – 4 – 5
-- BASE DE DATOS: AGENCIA_PERSONAL
use agencia_personal;

-- 1) Para aquellos contratos que no hayan terminado calcular la fecha de caducidad
-- como la fecha de solicitud más 30 días (no actualizar la base de datos). Función ADDDATE
SELECT nro_contrato "Nro contrato", DATE_FORMAT(fecha_incorporacion, "%d/%m/%Y") "fecha_incorporacion", 
DATE_FORMAT(fecha_finalizacion_contrato, "%d/%m/%Y") "fecha_finalizacion_contrato", 
DATE_FORMAT(adddate(fecha_solicitud, INTERVAL 30 day ), "%d/%m/%Y") "fecha_solicitud"
FROM contratos
WHERE fecha_caducidad is null; 

-- 2) Mostrar los contratos. Indicar nombre y apellido de la persona, razón social de la
-- empresa fecha de inicio del contrato y fecha de caducidad del contrato. Si el contrato no ha
-- terminado mostrar “Contrato Vigente”. Función IFNULL
SELECT nro_contrato, CONCAT(nombre, " ", apellido) "Nombre y apellido", razon_social "Razón Social",
DATE_FORMAT(fecha_incorporacion, "%d/%m/%Y") "Fecha inicio", 
IFNULL(DATE_FORMAT(fecha_caducidad, "%d/%m/%Y"), "Contrato vigente") "Fecha caducidad" 
FROM contratos C INNER JOIN personas P ON C.dni=P.dni
INNER JOIN empresas E ON C.cuit=E.cuit;

-- 3) Para aquellos contratos que terminaron antes de la fecha de finalización, indicar la
-- cantidad de días que finalizaron antes de tiempo. Función DATEDIFF
-- 

SELECT nro_contrato, DATE_FORMAT(fecha_incorporacion, "%d/%m/%Y") "fecha_incorporacion", 
DATE_FORMAT(fecha_finalizacion_contrato, "%d/%m/%Y") "fecha_finalizacion_contrato", 
DATE_FORMAT(fecha_caducidad, "%d/%m/%Y") "fecha_caducidad", sueldo,
porcentaje_comision, dni, cuit, cod_cargo, DATE_FORMAT(fecha_solicitud, "%d/%m/%Y") "fecha_solicitud", 
DATEDIFF(fecha_finalizacion_contrato, fecha_caducidad) "Días antes"
FROM contratos 
WHERE fecha_caducidad < fecha_finalizacion_contrato;


-- 4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, razón social de la
-- empresa y dirección, año y mes de la comisión, importe y la fecha de vencimiento que se
-- calcula como la fecha actual más dos meses. Función ADDDATE con INTERVAL

select ADDDATE(date(now()), INTERVAL 2 MONTH);

SELECT E.cuit, E.razon_social, E.direccion, anio_contrato, mes_contrato, importe_comision,
DATE_FORMAT(ADDDATE(date(now()), INTERVAL 2 MONTH), "%d/%m/%Y") "fecha de vencimiento"
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN empresas E ON CON.cuit=E.cuit
WHERE COM.fecha_pago is null;

-- 5) Mostrar en qué día, mes y año nacieron las personas (mostrarlos en columnas
-- separadas) y sus nombres y apellidos concatenados. Funciones DAY, YEAR, MONTH y CONCAT
SELECT CONCAT(nombre, " ", apellido) "Nombre y apellido", DATE_FORMAT(fecha_nacimiento, "%d/%m/%Y") "fecha_nacimiento",
DAY(fecha_nacimiento) "Día", MONTH(fecha_nacimiento) "Mes", YEAR(fecha_nacimiento) "Año"
FROM personas;
