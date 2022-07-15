listDBs = function(db){
  con_Str = listConnectionStrings[[db]]
  print(con_Str)
  OLAP_connection <- olapR::OlapConnection(con_Str)

  query = "
    SELECT [CATALOG_NAME], [DATE_MODIFIED]
    FROM $system.dbschema_catalogs
    ORDER BY [DATE_MODIFIED] DESC
  "

  query_result <- olapR::execute2D(OLAP_connection, query)

  return(query_result)
}
