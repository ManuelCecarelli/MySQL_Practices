# PRACTICA SQL 2TUP2/3 2024

# Practica en Clase: 1 – 3 – 4 – 6 – 7 – 11 – 15
# Práctica Complementaria: 2 – 5 – 8 – 9 – 10 – 12 – 14

USE agencia_personal;

# 1) Mostrar la estructura de la tabla Empresas. Seleccionar toda la información de la misma.
describe empresas;

SELECT * FROM empresas;

-- 3) Guardar el siguiente query en un archivo de extensión .sql, para luego correrlo.
-- Mostrar los títulos con el formato de columna: Código, Descripción y Tipo ordenarlo
-- alfabéticamente por descripción.

SELECT cod_titulo "Código", desc_titulo "Descripción", tipo_titulo "Tipo" 
FROM titulos order by desc_titulo;

SELECT cod_titulo "Código", desc_titulo "Descripción", tipo_titulo "Tipo" FROM titulos 
INTO OUTFILE 'C:\\Users\\Cristián\\Downloads\\titulos.SQL' # "/home/cgallo/titulos.sql" <-UBUNTU
FIELDS TERMINATED BY '|' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

-- Error Code: 1290. The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
-- indica que MySQL está configurado para permitir la exportación de archivos solo a un directorio específico por 
-- razones de seguridad. Este comportamiento está controlado por la opción --secure-file-priv, que restringe las 
-- operaciones de importación y exportación a una carpeta definida en la configuración de MySQL.
-- veamos donde se pueden escribir estos archivos...
SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM titulos 
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\titulos.txt'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

-- 4) Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de
-- nacimiento, teléfono, y su dirección. Las cabeceras de las columnas serán:
-- Apellido y Nombre (concatenados)  Fecha Nac. Teléfono Dirección
SELECT concat(apellido, ", ", nombre) as "Apellido y Nombre (concatenados)", 
date_format(fecha_nacimiento, "%d de %M de %Y") "Fecha Nac.", 
Telefono as "Teléfono", 
direccion as "Dirección" 
FROM personas WHERE dni = "28675888";




