listMeasures = function(con_str){
  string = olap_con$cnn

  cube_name = stringr::str_match(string, "Cube=(\\w+);?")[1,2]

  query = glue::glue("
    SELECT [CUBE_NAME], [MEASURE_NAME], [MEASURE_UNIQUE_NAME], [MEASUREGROUP_NAME]
    FROM $system.mdschema_measures
    WHERE [CUBE_NAME]='{cube_name}'
  ")
  query_result <- olapR::execute2D(con_str, query)

  return(query_result)
}
