/*
Práctica Nº 1: Sentencia SELECT
Practica en Clase: 1 – 3 – 4 – 6 – 7 – 11 – 15
Práctica Complementaria: 2 – 5 – 8 – 9 – 10 – 12 – 14
BASE DE DATOS: AGENCIA_PERSONAL
*/

USE agencia_personal;

/*
1) Mostrar la estructura de la tabla Empresas. Seleccionar toda la información de la
misma.
*/

DESCRIBE empresas;
SELECT * FROM empresas;

/*
2) Mostrar la estructura de la tabla Personas. Mostrar el apellido y nombre y la fecha de
registro en la agencia.
*/

DESCRIBE personas;
SELECT apellido, nombre, fecha_registro_agencia "FECHA INGRESO"
FROM personas;

/*
3) Guardar el siguiente query en un archivo de extensión .sql, para luego correrlo.
Mostrar los títulos con el formato de columna: Código Descripción y Tipo ordenarlo
alfabéticamente por descripción.
*/

SELECT
	cod_titulo "Codigo",
	desc_titulo "Descripcion",
    tipo_titulo "Tipo"
FROM titulos
ORDER BY desc_titulo;

/*
4) Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de
nacimiento, teléfono, y su dirección. Las cabeceras de las columnas serán:
Apellido y Nombre (concatenados) | Fecha Nac. | Teléfono | Dirección
*/

SELECT
	CONCAT(apellido, " ", nombre) "Apellido y Nombre",
    fecha_nacimiento "Fecha Nac.",
    Telefono "Teléfono",
    direccion "Dirección"
FROM personas
WHERE dni = 28675888;

/*
5) Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y
31345778. Ordenadas por fecha de Nacimiento
*/

SELECT
	CONCAT(apellido, " ", nombre) "Apellido y Nombre",
    fecha_nacimiento "Fecha Nac.",
    Telefono "Teléfono",
    direccion "Dirección"
FROM personas
WHERE dni IN (27890765, 29345777, 31345778)
ORDER BY fecha_nacimiento;

/*
6) Mostrar las personas cuyo apellido empiece con la letra ‘G’.
*/

SELECT *
FROM personas
WHERE apellido LIKE "G%";

/*
7) Mostrar el nombre, apellido y fecha de nacimiento de las personas nacidas entre 1980 y
2000
*/

SELECT
	nombre, 
    apellido, 
    fecha_nacimiento
FROM personas
WHERE YEAR(fecha_nacimiento) BETWEEN 1980 AND 2000;

/*
8) Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente
por fecha de solicitud.
*/

SELECT *
FROM solicitudes_empresas
ORDER BY fecha_solicitud;

/*
9) Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral
ordenados por fecha desde.
*/

SELECT *
FROM antecedentes
WHERE fecha_hasta IS NULL
ORDER BY fecha_desde;

/*
10)Mostrar aquellos antecedentes laborales que finalizaron y cuya fecha hasta no esté entre
junio del 2013 a diciembre de 2013, ordenados por número de DNI del empleado.
*/

SELECT *
FROM antecedentes
WHERE
	fecha_hasta IS NOT NULL
    AND
    NOT (fecha_hasta > DATE("2013-05-31") AND fecha_hasta < DATE("2014-01-01"))
ORDER BY dni;

/*
11) Mostrar los contratos cuyo salario sea mayor que 2000 y trabajen en las empresas 30-
10504876-5 o 30-21098732-4.Rotule el encabezado:
Nro Contrato | DNI | Salario | CUIL
*/

SELECT
	nro_contrato "Nro Contrato",
	dni "DNI",
    sueldo "Salario",
    cuit "CUIT"
FROM contratos
WHERE sueldo > 2000 AND (cuit = "30-10504876-5" OR cuit = "30-21098732-4");

/*
12) Mostrar los títulos técnicos.
*/
SELECT *
FROM titulos
WHERE desc_titulo LIKE "%Tecnico%";

/*
13) Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ y el código de cargo
sea 6; o hayan solicitado aspirantes de sexo femenino
*/

