-- Practica Nº 4: GROUP BY - HAVING
-- Practica en Clase: 1 – 2 – 4 – 8 – 9 – 13 – 14 – 15
-- Práctica Complementaria: 3 – 5 – 6 –7 – 10 – 11 – 12
-- BASE DE DATOS: AGENCIA_PERSONAL

use agencia_personal;

-- 1) Mostrar las comisiones pagadas por la empresa Tráigame eso
SELECT *
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN empresas E ON CON.cuit=E.cuit;

SELECT concat("$", SUM(importe_comision)) "comisiones", razon_social
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN empresas E ON CON.cuit=E.cuit
WHERE razon_social = "Tráigame eso" and fecha_pago is not null
group by CON.cuit;

-- 2) Ídem 1) pero para todas las empresas.
SELECT concat("$", SUM(importe_comision)) "comisiones", razon_social
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN empresas E ON CON.cuit=E.cuit
WHERE fecha_pago is not null 
group by CON.cuit 
order by SUM(importe_comision);

-- 3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
-- evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
-- en forma ascendente y luego por desviación estándar en forma descendente.
SELECT nombre_entrevistador, EVAL.cod_evaluacion, AVG(resultado) "Promedio", STD(resultado) "Desvío STD", VARIANCE(resultado) "Varianza"
FROM agencia_personal.evaluaciones EVAL INNER JOIN agencia_personal.entrevistas_evaluaciones EE ON EVAL.cod_evaluacion=EE.cod_evaluacion
INNER JOIN agencia_personal.entrevistas E ON EE.nro_entrevista=E.nro_entrevista
GROUP BY EVAL.cod_evaluacion, nombre_entrevistador
order by 3, 4 DESC;

-- error en el orden del having
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL 
-- server version for the right syntax to use near 'GROUP BY EVAL.cod_evaluacion, nombre_entrevistador 
-- order by 3, 4 DESC' at line 5

-- si no agrupo correctamente...
-- Error Code: 1055. Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated 
-- column 'agencia_personal.E.nombre_entrevistador' which is not functionally dependent on columns in 
-- GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

-- Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated 
-- column 'agencia_personal.EVAL.cod_evaluacion' which is not functionally dependent on columns 
-- in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

# funciones de agregacion sin group by son sobre una columna para todos los registros
# funciones de agregacion con group by son sobre una columna pero para los registros que tienen una columna con el mismo valor

-- 4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
-- de evaluación.
SELECT nombre_entrevistador, EVAL.cod_evaluacion, AVG(resultado) "Promedio", STD(resultado) "Desvío STD", VARIANCE(resultado) "Varianza"
FROM agencia_personal.evaluaciones EVAL INNER JOIN agencia_personal.entrevistas_evaluaciones EE ON EVAL.cod_evaluacion=EE.cod_evaluacion
INNER JOIN agencia_personal.entrevistas E ON EE.nro_entrevista=E.nro_entrevista
WHERE nombre_entrevistador = "Angélica Doria" 
GROUP BY EVAL.cod_evaluacion, nombre_entrevistador
HAVING AVG(resultado) > 71
order by EVAL.cod_evaluacion;

-- 5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014.
SELECT nombre_entrevistador, count(*) "Cantidad de Entrevistas" FROM entrevistas
-- WHERE fecha_entrevista between "2014-10-01" and "2014-10-31";
-- WHERE YEAR(fecha_entrevista) = 2014 and MONTH(fecha_entrevista) = 10;
WHERE fecha_entrevista >= "2014-10-01" and fecha_entrevista <= "2014-10-31"
group by nombre_entrevistador;

-- 6) Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad.
-- Ordenado por cantidad de entrevistas.


-- 7) Ídem 6) para aquellos cuya cantidad de entrevistas por código de evaluación
-- sea mayor que 1. Ordenado por nombre en forma descendente y por código de
-- evaluación en forma ascendente


-- 8) Mostrar para cada contrato cantidad total de las comisiones, cantidad pagas,
-- cantidad a pagadar.
-- | nro_contrato Total |pagadas |a pagar|
SELECT COM.nro_contrato, COUNT(*) "TOTAL", count(fecha_pago) "pagadas", 
COUNT(*) - count(fecha_pago) "a pagar"
FROM contratos CON INNER JOIN comisiones COM ON CON.nro_contrato=COM.nro_contrato
group by CON.nro_contrato;


-- 9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
-- el % de impagas.
SELECT COM.nro_contrato, COUNT(*) "cantidad de comisiones", ROUND(count(fecha_pago) / COUNT(*) * 100, 2) "% comisiones pagas", 
(COUNT(*) - count(fecha_pago)) / COUNT(*) * 100 "% comisiones a pagas"
FROM contratos CON INNER JOIN comisiones COM ON CON.nro_contrato=COM.nro_contrato
group by CON.nro_contrato;

-- 10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
-- diferencia respecto al total de solicitudes.


-- 11) Cantidad de solicitudes por empresas.


-- 12) Cantidad de solicitudes por empresas y cargos.


-- LEFT/RIGHT JOIN
-- 13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
-- que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
-- mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.
-- | cuit | razon_social          | Cant de Personas|

SELECT E.cuit, E.razon_social, count(A.dni) 
FROM empresas E LEFT JOIN antecedentes A on E.cuit=A.cuit
GROUP BY E.cuit
order by 3 desc;

SELECT E.cuit, E.razon_social, count(A.dni) 
FROM empresas E INNER JOIN antecedentes A on E.cuit=A.cuit
GROUP BY E.cuit
order by 3 desc; -- pierdo las empresas que no están mencionadas como antedecente

SELECT E.cuit, E.razon_social, count(A.dni) 
FROM antecedentes A RIGHT JOIN empresas E on A.cuit=E.cuit
GROUP BY E.cuit
order by 3 desc;


-- 14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
-- forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
-- 0. Agregar algún cargo que nunca haya sido solicitado
-- |cod_cargo desc_cargo Cant de Solicitudes
SELECT C.cod_cargo, C.desc_cargo, count(SE.cod_cargo) "Cant. de Solicitudes"
FROM cargos C LEFT JOIN solicitudes_empresas SE ON C.cod_cargo=SE.cod_cargo
group by C.cod_cargo order by 3 desc;

-- 15) Indicar los cargos que hayan sido solicitados menos de 2 veces
SELECT C.cod_cargo, C.desc_cargo, count(SE.cod_cargo) "Cant. de Solicitudes"
FROM cargos C LEFT JOIN solicitudes_empresas SE ON C.cod_cargo=SE.cod_cargo
group by C.cod_cargo 
HAVING count(SE.cod_cargo) < 2  -- uso HAVING porque tengo que comparar con una función de agregación/agrupación
order by 3 desc;
