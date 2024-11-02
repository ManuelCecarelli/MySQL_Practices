/*
Práctica Nº 2: JOINS

Practica en Clase: 1 – 2 – 6 –7 – 10 – 11 – 12 – 14 – 15 – 16
Práctica Complementaria: 3 – 4 – 5 – 8 –9 – 13

BASE DE DATOS: AGENCIA_PERSONAL

INNER JOIN

1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
sueldo acordado en el contrato.
*/

USE agencia_personal;

SELECT
	P.nombre,
    P.apellido,
    C.dni,
    C.sueldo
FROM contratos C INNER JOIN personas P ON C.dni = P.dni
WHERE C.nro_contrato = 5;

/*
2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa.
*/

SELECT
	C.dni,
    C.nro_contrato,
    C.fecha_incorporacion,
    C.fecha_solicitud,
    IFNULL(C.fecha_caducidad, "Sin fecha")
    -- E.razon_social
FROM contratos C INNER JOIN empresas E ON C.cuit = E.cuit
WHERE E.razon_social = "Viejos Amigos" OR E.razon_social = "Tráigame Eso"
ORDER BY C.fecha_solicitud, E.razon_social;

/*
3) Listado de las solicitudes consignando razón social, dirección y e_mail de la
empresa, descripción del cargo solicitado y años de experiencia solicitados, ordenado por
fecha d solicitud y descripción de cargo.
*/

