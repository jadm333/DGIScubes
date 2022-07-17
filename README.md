# DGIScubes

[English](README_en.md)

Librería en R para descargar/consultar  los cubos dinámicos de la Dirección General de Información en Salud (DGIS) [Cubos dinámicos](http://www.dgis.salud.gob.mx/contenidos/basesdedatos/BD_Cubos_gobmx.html). Fue realizada en el 4ta edición del [desafío Data Mexico](https://www.gob.mx/se/acciones-y-programas/cuarta-edicion-del-desafio-data-mexico?state=published)

## Motivación

La motivación principal de la creación de esta librería es que las opciones actuales para consultar los cubos son muy limitadas. El modo oficial para consulta es ingresar a la pagina mediante el navegador Internet Explorer, el cual Microsoft ya retiro oficialmente, e instalar unos plugins los cuales en poco tiempo ya no podrán ser ejecutados debido a compatibilidad con versiones nuevas de Windows

El motor de la base de datos de los cubos dinámicos es [Microsoft SQL Server Analysis Services (SSAS)](https://en.wikipedia.org/wiki/Microsoft_Analysis_Services), esta tecnología en particular tiene muy limitada la forma en la que se puede consumir la base de datos.

## Limitaciones ⚠️

Debido a las limitaciones de SSAS existen muy pocas opciones para consumir la base de datos, en especifico para R solo se puede a través de la librería [`olapR`](https://docs.microsoft.com/en-us/sql/machine-learning/r/ref-r-olapr?view=sql-server-ver16), la cual es de código cerrado y esta desarrollada/mantenida por Microsoft. Esta librería solo esta pre-instalada a través de versiones que desarrolla Microsoft (🙄), para ver una lista completa de las versiones de R con la librería `olapR` consultar [link](https://docs.microsoft.com/en-us/sql/machine-learning/r/ref-r-olapr?view=sql-server-ver16)

## Instalación

### Pre-requisitos

Contar con una versión de R con la librería `olapR`. Descargar: [Microsoft R client](https://docs.microsoft.com/en-us/previous-versions/machine-learning-server/r-client/what-is-microsoft-r-client)

### Instalación

```r
devtools::install_github("jadm333/DGIScubes", ref = "main",dependencies = TRUE)
```

```

```

# Ejemplos

```r
library(DGIScubes)
```

Para hacer la conexión a la base de datos SSAS/olapR requiere una cadena de conexión, existen diferentes servidores con SSAS dentro de los cubos de la DGIS, no se incluyen todas, la base de `pwidgis03` es la que contiene la mayor parte de los cubos.

> Nota: se emiten urls y contraseñas en texto plano para evitar scrappeo automatizado, esto evita que no se sature la base de datos.

La jerarquía de las bases de datos son las siguiente:

Servidor(url) -> Databases -> Cubes

## Explorar los cubos

### Servidores

Para listar las cadenas de conexión de los servidores:

```r
listConnectionStrings
#$pwidgis03
#[1] "Data Source=<host>;Provider=MSOLAP;User ID=<User>;Password=<password>;Persist Security Info=True"
#
#$reportesdgis
#[1] "Data Source=<host>;Provider=MSOLAP;User ID=<User>;Password=<password>;Persist Security Info=True"
```

También puedes crear tu cadena de conexión con la función `connectionString`

```r
connectionString(url="database.com", provider="MSOLAP", user_id="user" , password="pass")
#> [1] "Data Source=database.com;Provider=MSOLAP;User ID=user;Password=pass;Persist Security Info=True"
```

### Bases de datos

Para listar las bases de datos dentro de un servidor:

```r
listDBs("pwidgis03")  # <--- Return Dataframe
#>                    CATALOG_NAME          DATE_MODIFIED
#> 1          Cubo solo sinba 2022   7/13/2022 3:28:34 PM
#> 2                Reporte_Diario   7/13/2022 3:27:25 PM
#> 3                Personal_Salud   7/13/2022 3:27:06 PM
#> 4                 Urgencias2022   7/4/2022 11:00:27 PM
...
#> 81                     Recursos  10/9/2018 12:40:34 AM
...
#> 88                      sis2016  6/13/2017 10:42:45 PM
#> 89                 SIS_2017_NEW    4/6/2017 1:54:12 AM
#> 90                      sis2015   8/20/2015 4:06:43 PM
```

### Cubos

Seleccionar el cubo y explorarlo:

```r
library(DGIScubes)

cube = "CuboAfecciones2022"
olap_con = selectCUbe("pwidgis03", "Egresos2022", cube) # <-- Return olapR::OlapConnection()

olapR::explore(olap_con) # List cubes
#> CuboAfecciones2022
#> CuboProcedimientos2022
#> CuboProductos2022
#> CubosEgresos2022

olapR::explore(olap_con, cube = cube) # List dimension in cube
#> Cat Afiliacion2020
#> Cat Cie10 AfeccionPrincipal
..
#> D Clues2020
#> Measures

olapR::explore(olap_con, cube = cube, dimension="D Clues2020") # List Hierarchies in dimension
#> Camas en área de hospitalización
#> CLUES
...
#> Unidad Médica
#> USMI

olapR::explore(olap_con, cube = cube, dimension="D Clues2020", hierarchy="Institución") # List levels in hierarchies
#> (All)
#> Institucion

olapR::explore(olap_con, cube = cube, dimension="D Clues2020", hierarchy="Institución", level="Institucion") # List levels in hierarchies
#> CENTROS DE INTEGRACION JUVENIL
#> CRUZ ROJA MEXICANA
...
#> SERVICIOS MEDICOS PRIVADOS
#> SISTEMA NACIONAL PARA EL DESARROLLO INTEGRAL DE LA FAMILIA
#> Unknown

listMeasures(olap_con) # List available measures
#>            CUBE_NAME            MEASURE_NAME                   MEASURE_UNIQUE_NAME   MEASUREGROUP_NAME
#> 1 CuboAfecciones2022           Días estancia            [Measures].[Días estancia]     Afecciones 2020
#> 2 CuboAfecciones2022          Comorbilidades           [Measures].[Comorbilidades]     Afecciones 2020
#> 3 CuboAfecciones2022 Máximo de días estancia  [Measures].[Máximo de días estancia]     Afecciones 2020
#> 4 CuboAfecciones2022             Total CLUES              [Measures].[Total CLUES]   Afecciones 2020 1
#> 5 CuboAfecciones2022                 Egresos                  [Measures].[Egresos]   Afecciones 2020 2
```

## Descargar datos

Para descargar datos existen dos opciones:

Opción 1:

```r
library(DGIScubes)

cubo = "CuboAfecciones2022"
olap_con = selectCUbe("pwidgis03", "Egresos2022", cubo)
qry <- olapR::Query()
olapR::cube(qry) <- cubo
olapR::columns(qry) <- c("[Measures].[Días estancia]", "[Measures].[Egresos]") # Measures
olapR::rows(qry) <- c("[D Clues2020].[Institución].[Institucion]") # DImensions
# Optional: Slicers are like filters/WHERE on querying cubes
# slicers(qry) <- c("[Sales Territory].[Sales Territory Country].[Australia]")

df_results = olapR::execute2D(olap_con, qry)
df_results
#>                      [D Clues2020].[Institución].[Institucion].[MEMBER_CAPTION] [Measures].[Días estancia] [Measures].[Egresos]
#> 1                                                CENTROS DE INTEGRACION JUVENIL                         NA                   NA
...
#> 13                                                          SECRETARIA DE SALUD                    6437822               916515
#> 14                                                  SERVICIOS MEDICOS ESTATALES                      20366                 3518
...
#> 18                                                                      Unknown                         NA                   NA
```

Opción 2:

```r
library(DGIScubes)

cubo = "CuboAfecciones2022"
olap_con = selectCUbe("pwidgis03", "Egresos2022", cubo)
mdx = "
SELECT
{
  [Measures].[Días estancia],[Measures].[Egresos]
} ON COLUMNS,
{
  [D Clues2020].[Institución].[Institucion]
} ON ROWS
FROM [CuboAfecciones2022]
"
df_results = olapR::execute2D(olap_con, mdx)
df_results
#>                      [D Clues2020].[Institución].[Institucion].[MEMBER_CAPTION] [Measures].[Días estancia] [Measures].[Egresos]
#> 1                                                CENTROS DE INTEGRACION JUVENIL                         NA                   NA
...
#> 13                                                          SECRETARIA DE SALUD                    6437822               916515
#> 14                                                  SERVICIOS MEDICOS ESTATALES                      20366                 3518
...
#> 18                                                                      Unknown                         NA                   NA
```

### Descargar cubo completo

En la librería se incluye una función para tratar de bajar el cubo al nivel granular más posible, debido al poco conocimiento que tengo de la tecnología de SSAS y MDX (SQL para cubos) no aseguro que la función funcione para cualquier cubo. COnsiderar que hay cubos en la DGIS que superan los GB una vez descargados

```r
library(DGIScubes)

cubo = "Recursos"
olap_con = selectCUbe("pwidgis03", "Recursos", cubo)
query = generateCubeQuery(olap_con)
query
#>   SELECT
#>     NON EMPTY {
#>       [Measures].AllMembers
#>     } ON COLUMNS,
#>     NON EMPTY {
#>       [Cat Clues2017].[CLUES].[Nombre]*[Cat Mpo Refer].[Desgloce frontera].[Desgloce frontera]*[Cat Mpo Refer].[Entidad de la unidad médica].[Municipio]*[Cat Mpo Refer].[Filtro frontera].[Filtro frontera]*[Cat Mpo Refer].[Grado de marginación].[Grado de marginación]*[Cat Mpo Refer].[Los 100 Municipios].[Los 100 Municipios]*[Cat Tipo Uni2006].[Tipo de unidad].[Tipo de unidad]*[Cat Variables].[Variable].[Recursos]*[Year].[Año].[Año]
#>     } ON ROWS
#>   FROM [Recursos]
df <- olapR::execute2D(olap_con, query)
```

# Licencia

Esta librería es gratis y de código abierto y esta licenciada bajo BSD 3
