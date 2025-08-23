#' @name deprecated_functions
#' @title Deprecated functions
#'
#' @description
#' These functions are deprecated and should no longer be used in new code. The
#' below table gives the replacement function to use instead. The function
#' arguments of the replacement function are the same as those of the deprecated
#' function if no arguments are given in the table.
#'
#' | **Deprecated function** | **Replacement function** | **Secheduled deletion** |
#' | ------------------- | -------------------- | -------------------- |
#' | slab()              | [slice()]            | October 2025         |
#'
#' The below functions have been permanently deleted and can no longer be
#' called:
#'
#' | **Deprecated function** | **Replacement function** |
#' | ------------------- | -------------------- |
#' | CFcomplete()        | [is_complete()]      |
#' | CFmonth_days()      | [month_days()]       |
#' | CFparse()           | [parse_timestamps()] |
#' | CFrange()           | [range()]            |
#' | CFsubset()          | [slice()]            |
#' | slab()              | [slice()]            |
#' | CFtimestamp()       | [as_timestamp()]     |
#'
#' @param x,extremes,rightmost.closed See replacement functions.
#'
#' @returns See replacement functions.

# nocov start

#' @rdname deprecated_functions
#' @export
slab <- function(x, extremes, rightmost.closed = FALSE) {
  warning("Function `slab()` is deprecated. Use function `slice()` instead", call. = FALSE)
  x$slice(extremes, rightmost.closed)
}

# nocov end
