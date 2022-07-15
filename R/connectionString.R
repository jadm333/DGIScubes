#' Generate connection string
#'
#' @param url
#' @param provider
#' @param user_id
#' @param password
#'
#' @return
#' @export
#'
#' @examples
connectionString <- function(url, provider, user_id , password ) {
  return(
    paste0(
      'Data Source=', url, ';',
      'Provider=', provider, ';',
      'User ID=', user_id, ';',
      'Password=', password, ';',
      'Persist Security Info=', "True"
    )
  )
}
