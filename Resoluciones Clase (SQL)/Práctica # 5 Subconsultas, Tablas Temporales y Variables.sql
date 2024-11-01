-- Practica Nº 5: Subconsultas, Tablas Temporales y Variables
-- Practica en Clase: 1 – 2 – 3 – 4 – 7 – 9 – 10 – 11 – 12 – 16
-- Práctica Complementaria: 5 – 6 – 8 – 13 – 14 – 15 – 17

-- 1 )¿Qué personas fueron contratadas por las mismas empresas que Stefanía Lopez?
select distinct p.dni, p.apellido, p.nombre
from agencia_personal.personas p
inner join agencia_personal.contratos c on c.dni = p.dni
where c.cuit in (  
	select c.cuit from agencia_personal.contratos c
	inner join agencia_personal.personas p on c.dni = p.dni where p.nombre like 'Stefan%' and p.apellido = 'Lopez');

SET @DNIEstafania = (select dni from personas where nombre LIKE 'Stefan%' and apellido = 'Lopez');
SELECT DISTINCT p.dni, p.apellido, p.nombre 
FROM personas p
INNER JOIN contratos c
ON p.dni = c.dni
WHERE c.cuit IN (SELECT cuit FROM contratos WHERE dni = @DNIEstafania) and p.dni != @DNIEstafania;

-- 2) Encontrar a aquellos empleados que ganan menos que el máximo sueldo de los empleados de Viejos Amigos.
-- |dni               |concat( p.nombre, p.apellido )                      |sueldo                  |

SELECT P.dni "DNI", CONCAT(nombre, " ", apellido) "Nombre y apellido", C.sueldo 
FROM contratos C INNER JOIN personas P ON C.dni=P.dni
WHERE sueldo < (
	SELECT MAX(sueldo) from contratos C INNER JOIN empresas E ON C.cuit=E.cuit
    WHERE razon_social = "Viejos Amigos"
);

# resolución de un compañero que anda pero no sabemos de donde sale cuit
select
	p.dni,
	CONCAT(p.nombre, " ",p.apellido) as 'Nombre y Apellido',
	c.sueldo
from personas p
	inner join contratos c on c.dni	= p.dni
where c.sueldo < (Select max(sueldo) from contratos where cuit = '30-10504876-5');

# resolución de un compañero con cuestiones por corregir
select p.dni as 'DNI',
concat(p.nombre, '  ',p.apellido) as 'Nomb y Apellido',
c.sueldo as 'Sueldo'
from agencia_personal.personas p
inner join agencia_personal.contratos c on p.dni=c.dni
where c.sueldo < (
select Max(c2.sueldo)
from agencia_personal.personas p2 # no es necesario la unión con la tabla personas
inner join agencia_personal.contratos c2 on p2.dni = c2.dni
inner join agencia_personal.empresas e on c2.cuit = e.cuit
where e.razon_social = "viejos amigos");


-- 3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo
-- de aquellas cuyo promedio supere al promedio de Tráigame eso.
SELECT EMP.cuit, EMP.razon_social, ROUND(AVG(COM.importe_comision), 2) as "Promedio comisión" FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit 
-- where EMP.razon_social not like "Tr%igame eso"
GROUP BY EMP.cuit
HAVING AVG(COM.importe_comision) > (SELECT AVG(importe_comision) FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit where EMP.razon_social like "Tr%igame eso");

# solución de un compañero con errores
Select 
e.cuit,
e.razon_social,
avg(com.importe_comision)
from empresas e
inner join contratos con on con.cuit = e.cuit
inner join comisiones com on com.nro_contrato = con.nro_contrato
where com.importe_comision >  # compara con el importe de comision no con el promedio de importes
(select avg(com.importe_comision) from comisiones com
inner join contratos con on com.nro_contrato = con.nro_contrato
inner join empresas e on e.cuit = con.cuit
where e.razon_social = "Traigame eso")
group by e.cuit;

# Nico Romero Barrios (usar solo las uniones necesarias pero está bien el ejercicio)
select e.cuit as 'CUIT',
e.razon_social as 'Razón Social',
avg(comi.importe_comision) as 'Comisión'
from agencia_personal.empresas e
inner join agencia_personal.solicitudes_empresas se on e.cuit = se.cuit
inner join agencia_personal.contratos cont on se.cuit = cont.cuit and se.cod_cargo = cont.cod_cargo and se.fecha_solicitud = cont.fecha_solicitud
inner join agencia_personal.comisiones comi on cont.nro_contrato = comi.nro_contrato
group by e.cuit, e.razon_social
having avg(comi.importe_comision) > (
select avg(comi2.importe_comision)
from agencia_personal.empresas e2
inner join agencia_personal.solicitudes_empresas se2 on e2.cuit = se2.cuit
inner join agencia_personal.contratos cont2 on se2.cuit = cont2.cuit and se2.cod_cargo = cont2.cod_cargo and se2.fecha_solicitud = cont2.fecha_solicitud
inner join agencia_personal.comisiones comi2 on cont2.nro_contrato = comi2.nro_contrato 
where e2.razon_social = 'Tráigame eso');


-- 4) Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las
-- comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes
-- contrato, año contrato , nro. contrato, nombre y apellido del empleado.
SELECT distinct EMP.razon_social, PER.nombre, PER.apellido, CON.nro_contrato, month(CON.fecha_incorporacion), 
YEAR(CON.fecha_incorporacion), COM.importe_comision FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit 
INNER JOIN `personas` PER on PER.dni=CON.dni
where COM.fecha_pago is not null and 
COM.importe_comision < (SELECT AVG(importe_comision) FROM `comisiones`);

-- 5) Determinar las empresas que pagaron más que el promedio
SELECT EMP.razon_social, AVG(COM.importe_comision) 
from `contratos` CON
INNER JOIN `comisiones`COM ON CON.nro_contrato=COM.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit 
GROUP BY EMP.cuit
HAVING AVG(COM.importe_comision) > (SELECT AVG(importe_comision) FROM `comisiones`);

