listCubes = function(host, db){
  con_str = listConnectionStrings[[host]]
  con_str = paste0(con_str, ";Initial Catalog=", db)
  OLAP_connection <- olapR::OlapConnection(con_str)

  query = "
    SELECT [CATALOG_NAME], [CUBE_NAME], [LAST_DATA_UPDATE]
    FROM $system.mdschema_cubes
    WHERE CUBE_SOURCE = 1
  "

  query_result <- olapR::execute2D(OLAP_connection, query)

  return(query_result)
}
