USE afatse;

/*
9) Alumnos que se hayan inscripto a más cursos que Antoine de Saint-Exupery. Mostrar
todos los datos de los alumnos, la cantidad de cursos a la que se inscribió y cuantas
veces más que Antoine de Saint-Exupery.
*/

-- DESCRIBE alumnos;
-- SELECT * FROM alumnos;
-- SELECT * FROM alumnos A INNER JOIN inscripciones I ON A.dni = I.dni;

drop temporary table if not exists cant_inscrip
SELECT dni, COUNT(dni) FROM inscripciones GROUP BY dni;

/*
10) En el año 2014, qué cantidad de alumnos se han inscripto a los Planes de Capacitación
indicando para cada Plan de Capacitación la cantidad de alumnos inscriptos y el
porcentaje que representa respecto del total de inscriptos a los Planes de Capacitación
dictados en el año.
*/

/*
https://www.w3schools.com/quiztest/quiztest.asp?qtest=MySQL
*/

select * from `plan_capacitacion`;
