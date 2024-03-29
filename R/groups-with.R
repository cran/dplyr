#' Perform an operation with temporary groups
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' This was an experimental function that allows you to modify the grouping
#' variables for a single operation; it is superseded in favour of using the
#' `.by` argument to individual verbs.
#'
#' @param .data A data frame
#' @param .groups <[`tidy-select`][dplyr_tidy_select]> One or more variables
#'   to group by. Unlike [group_by()], you can only group by existing variables,
#'   and you can use tidy-select syntax like `c(x, y, z)` to select multiple
#'   variables.
#'
#'   Use `NULL` to temporarily **un**group.
#' @param .f Function to apply to regrouped data.
#'   Supports purrr-style `~` syntax
#' @param ... Additional arguments passed on to `...`.
#' @keywords internal
#' @export
#' @examples
#' df <- tibble(g = c(1, 1, 2, 2, 3), x = runif(5))
#'
#' # Old
#' df %>%
#'   with_groups(g, mutate, x_mean = mean(x))
#' # New
#' df %>% mutate(x_mean = mean(x), .by = g)
with_groups <- function(.data, .groups, .f, ...) {
  lifecycle::signal_stage("experimental", "with_groups()")
  loc <- tidyselect::eval_select(enquo(.groups), data = tbl_ptype(.data))
  val <- syms(names(.data)[loc])
  out <- group_by(.data, !!!val)

  .f <- as_function(.f)
  out <- .f(out, ...)
  dplyr_reconstruct(out, .data)
}
