
## ----, eval = FALSE------------------------------------------------------
## src_postgres <- function(dbname = NULL, host = NULL, port = NULL, user = NULL,
##                          password = NULL, ...) {
## 
##   con <- dbi_connect(PostgreSQL(), host = host %||% "", dbname = dbname %||% "",
##     user = user, password = password %||% "", port = port %||% "", ...)
## 
##   src_sql("postgres", con)
## }


## ------------------------------------------------------------------------
#' @export
brief_desc.src_postgres <- function(x) {
  info <- db_info(x)
  host <- if (info$host == "") "localhost" else info$host

  paste0("postgres ", info$serverVersion, " [", info$user, "@",
    host, ":", info$port, "/", info$dbname, "]")
}


## ----, eval = FALSE------------------------------------------------------
## tbl.src_mssql <- function(src, from, ...) {
##   tbl_sql("mssql", src = src, from = from, ...)
## }


