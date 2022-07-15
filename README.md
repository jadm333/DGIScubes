# DGIScubes

[English](README_en.md)

Librería en R para descargar/consultar  los cubos dinámicos de la Dirección General de Información en Salud (DGIS) [Cubos dinámicos](http://www.dgis.salud.gob.mx/contenidos/basesdedatos/BD_Cubos_gobmx.html)

## Motivación

La motivación principal de la creación de esta librería es que las opciones actuales para consultar los cubos son muy limitadas. El modo oficial para consulta es ingresar a la pagina mediante el navegador Internet Explorer el cual Microsoft ya retiro oficialmente e instalar unos plugins los cuales en poco tiempo ya no podrán ser ejecutados debido a compatibilidad con versiones nuevas de Windows

El motor de la base de datos de los cubos dinámicos es  [Microsoft SQL Server Analysis Services (SSAS)](https://en.wikipedia.org/wiki/Microsoft_Analysis_Services), esta tecnología en particular tiene muy limitada la forma en la que se puede consumir la base de datos.

## Limitaciones ⚠️

Debido a las limitaciones de SSAS existen muy pocas opciones para consumir la base de datos, en especifico para R solo se puede a través de la librería [`olapR`](https://docs.microsoft.com/en-us/sql/machine-learning/r/ref-r-olapr?view=sql-server-ver16), la cual es de código cerrado y esta desarrollada/mantenida por Microsoft. Esta librería solo estan pre-instalada a través de versiones que desarrolla Microsoft (🙄), para ver una lista completa de las versiones de R con la librería `olapR` consultar [link](https://docs.microsoft.com/en-us/sql/machine-learning/r/ref-r-olapr?view=sql-server-ver16)



## Instalación

### Pre-requisitos

Contar con una versión de R con la librería `olapR`. Descargar: [Microsoft R client](https://docs.microsoft.com/en-us/previous-versions/machine-learning-server/r-client/what-is-microsoft-r-client)

La librería usa más dependencias, pero estan pre-instaladas en las distribuciones de R de Microsoft, asi que no es necesario instalar nada extra

### Instalación

# Ejemplos

```r
library(DGIScubes)
```

Para hacer la conexión a la base de datos SSAS/olapR requiere una cadena de conexíon, existen diferentes servidores con SSAS dentro de los cubos de la DGIS para consultarlos con las siguientes funciones auxilares.
> Nota: se emiten urls y contraseñas en texto plano para evitar scrappeo automatizado, esto evita que no se sature la base de datos.

```r
listConnectionStrings
#$pwidgis03
#[1] "Data Source=<host>;Provider=MSOLAP;User ID=<User>;Password=<password>;Persist Security Info=True"
#
#$reportesdgis
#[1] "Data Source=<host>;Provider=MSOLAP;User ID=<User>;Password=<password>;Persist Security Info=True"
```
Tambien puedes crear tu cadena de conexión con la función `connectionString`
```r
library(DGIScubes)
```


# Licencia

Esta librería es gratis y de código abierto y esta licenciada bajo 
