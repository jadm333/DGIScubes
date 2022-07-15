listMembers = function(olap_con){
  string = olap_con$cnn

  cube_name = stringr::str_match(string, "Cube=(\\w+);?")[1,2]
  query = glue::glue("
    SELECT [LEVEL_UNIQUE_NAME]
    FROM $system.MDSCHEMA_MEMBERS
    WHERE [CHILDREN_CARDINALITY]=0 AND [DIMENSION_UNIQUE_NAME]<>'[Measures]' AND [CUBE_NAME]='{cube_name}' AND [LEVEL_NUMBER]<>0
  ")
  query_result <- olapR::execute2D(olap_con, query)

  return(unique(query_result$LEVEL_UNIQUE_NAME))
}
