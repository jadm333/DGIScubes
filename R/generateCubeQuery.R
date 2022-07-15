generateCubeQuery = function(olap_con){
  string = olap_con$cnn

  cube_name = stringr::str_match(string, "Cube=(\\w+);?")[1,2]
  members = listMembers(olap_con)

  rows = glue::glue_collapse(members, sep = "*")

  # measures = unique(listMeasures(olap_con)$MEASURE_UNIQUE_NAME)
  # columns = glue::glue_collapse(measures, sep = ",")

  query = glue::glue("
  SELECT
    NON EMPTY {
      [Measures].AllMembers
    } ON COLUMNS,
    NON EMPTY {
      << rows >>
    } ON ROWS
  FROM [<< cube_name >>]
", .open = "<<", .close = ">>")

  return(query)
}
