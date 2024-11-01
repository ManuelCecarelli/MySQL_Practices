# PRACTICA SQL 2TUP2/3 2024

-- Practica en Clase: 1 – 2 – 6 – 7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 – 9 – 13

USE agencia_personal;

-- 1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
-- sueldo acordado en el contrato
SELECT C.dni "DNI", CONCAT(apellido, ", ", nombre) "Apellido y Nombre", sueldo 
FROM contratos C inner join personas P ON C.dni=P.dni
WHERE nro_contrato=5;

-- Error Code: 1052. Column 'dni' in field list is ambiguous usamos alias para definir a que tabla pertenece el atributo.

-- 2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
-- Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
-- agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
-- ‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa.
SELECT P.dni, nro_contrato, fecha_incorporacion, fecha_solicitud, ifnull(fecha_caducidad, "Sin Fecha") "Fecha de caducidad" FROM 
empresas E inner join contratos C ON E.cuit=C.cuit inner join personas P ON P.dni=C.dni
where E.razon_social in ("Viejos Amigos", "Tráigame Eso")
order by C.fecha_incorporacion, E.razon_social;

SELECT P.dni, nro_contrato, fecha_incorporacion, fecha_solicitud, ifnull(fecha_caducidad, ifnull(fecha_caducidad, "Sigue siendo nulo")) "Fecha de caducidad" FROM 
personas P INNER JOIN contratos C ON P.dni=C.dni INNER JOIN empresas E ON C.cuit=E.cuit
where E.razon_social in ("Viejos Amigos", "Tráigame Eso")
order by C.fecha_incorporacion, E.razon_social;

-- 6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
-- Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
-- Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia
-- S.A
SELECT CONCAT(apellido, ", ", nombre, IFNULL(CONCAT(" tiene como referencia a ", persona_contacto), " no tiene referencia "), " cuando trabajo en ", LOWER(razon_social)) 
FROM personas P INNER JOIN antecedentes A ON P.dni=A.dni
INNER JOIN empresas E ON E.cuit=A.cuit
WHERE persona_contacto IS NULL OR persona_contacto = "Armando Esteban Quito" OR persona_contacto = "Felipe Rojas";


-- 7) Seleccionar para la empresa Viejos amigos, fechas de solicitudes, descripción del
-- cargo solicitado y edad máxima y mínima . Encabezado:
-- | Empresa                  | Fecha Solicitud           |Cargo        |Edad Mín  |Edad Máx   |
SELECT e.razon_social "Empresa", DATE_FORMAT(se.fecha_solicitud, "%d/%m/%Y") "Fecha Solicitud", c.desc_cargo "Cargo", 
ifnull(se.edad_minima, "Sin especificar") "Edad Mín", ifnull(se.edad_maxima, "Sin especificar") "Edad Máx"
FROM solicitudes_empresas se INNER JOIN empresas E ON se.cuit=e.cuit INNER JOIN cargos c ON se.cod_cargo=c.cod_cargo
WHERE e.razon_social = "Viejos amigos";


-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
-- y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
-- leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.
-- cuit razon_social Fecha Solicitud Cargo
SELECT e.cuit, razon_social, IFNULL(date_format(fecha_solicitud, "%d/%m/%y"), "Sin Solicitudes") "Fecha Solicitud", IFNULL(desc_cargo, "Sin Solicitudes") "Cargo"
FROM empresas e LEFT JOIN solicitudes_empresas se ON e.cuit=se.cuit LEFT JOIN cargos c ON se.cod_cargo=c.cod_cargo;

-- Error Code: 1052. Column 'cuit' in field list is ambiguous


-- 11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
-- y si se hubiese realizado un contrato los datos de la(s) persona(s).
-- |cuit     |razon_social    |desc_cargo    |DNI                       |Apellido Nombre
SELECT e.cuit, e.razon_social, c.desc_cargo, p.dni, CONCAT(p.apellido, ", ", p.nombre) "Apellido Nombre"
FROM solicitudes_empresas se INNER JOIN empresas e ON se.cuit=e.cuit
INNER JOIN cargos C ON se.cod_cargo=C.cod_cargo 
LEFT JOIN contratos con ON con.cuit=se.cuit and con.cod_cargo=se.cod_cargo and con.fecha_solicitud=se.fecha_solicitud
LEFT JOIN personas p ON P.dni=con.dni;

# registros que parecen duplicados es porque son distintos contratos para una misma empresa y empleado
# probar SELECT con.nro_contrato, con.fecha_incorporacion, e.cuit, e.razon_social, c.desc_cargo, p.dni, .....

-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
-- las solicitudes para las cuales no se haya realizado un contrato.
-- cuit razon_social desc_cargo
SELECT e.cuit, e.razon_social, c.desc_cargo
FROM solicitudes_empresas se INNER JOIN empresas e ON se.cuit=e.cuit
INNER JOIN cargos c ON se.cod_cargo=c.cod_cargo
left JOIN contratos con ON con.cuit=se.cuit and con.cod_cargo=se.cod_cargo and con.fecha_solicitud=se.fecha_solicitud
WHERE nro_contrato is null;

SELECT e.cuit, e.razon_social, c.desc_cargo
FROM contratos CON right JOIN solicitudes_empresas se ON con.cuit=se.cuit and con.cod_cargo=se.cod_cargo and con.fecha_solicitud=se.fecha_solicitud
INNER JOIN cargos c on se.cod_cargo=c.cod_cargo
INNER JOIN empresas e ON e.cuit=se.cuit
WHERE nro_contrato is null;


-- SELF JOIN
-- 14) Indicar todos los instructores que tengan un supervisor. Mostrar:
-- Cuil Instructor | Nombre Instructor| Apellido Instructor| Cuil Supervisor| Nombre Supervisor | Apellido Supervisor
use afatse;

SELECT I.cuil "Cuil Instructor", I.nombre, I.apellido, I.cuil_supervisor "Cuil Instructor", S.cuil "Cuil Supervisor", S.nombre, S.apellido
FROM instructores I INNER JOIN instructores S ON I.cuil_supervisor=S.cuil;



-- |cuit         |nombre    |apellido         |tele           |email          |cuit supervisor  |

-- |20-xxxxxxxx-1|Leoneal   |Di Giorgio       |341-xxx        |leonel@....    | null          |   <-- registro padre

-- |20-xxxxxxxx-0|Daniel    |Bustos           |341-xxx        |daniel@....    |20-xxxxxxxx-1  |   <-- registro hijo




-- Practica en Clase: 15 – 16
