selectCUbe = function(host, db, cube){
  con_str = listConnectionStrings[[host]]
  con_str = paste0(con_str, ";Initial Catalog=", db, ";Cube=", cube)
  OLAP_connection <- olapR::OlapConnection(con_str)
  return(OLAP_connection)
}
