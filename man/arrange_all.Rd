% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/colwise-arrange.R
\name{arrange_all}
\alias{arrange_all}
\alias{arrange_at}
\alias{arrange_if}
\title{Arrange rows by a selection of variables}
\usage{
arrange_all(.tbl, .funs = list(), ..., .by_group = FALSE, .locale = NULL)

arrange_at(.tbl, .vars, .funs = list(), ..., .by_group = FALSE, .locale = NULL)

arrange_if(
  .tbl,
  .predicate,
  .funs = list(),
  ...,
  .by_group = FALSE,
  .locale = NULL
)
}
\arguments{
\item{.tbl}{A \code{tbl} object.}

\item{.funs}{A function \code{fun}, a quosure style lambda \code{~ fun(.)} or a list of either form.}

\item{...}{Additional arguments for the function calls in
\code{.funs}. These are evaluated only once, with \link[rlang:dyn-dots]{tidy dots} support.}

\item{.by_group}{If \code{TRUE}, will sort first by grouping variable. Applies to
grouped data frames only.}

\item{.locale}{The locale to sort character vectors in.
\itemize{
\item If \code{NULL}, the default, uses the \code{"C"} locale unless the
\code{dplyr.legacy_locale} global option escape hatch is active. See the
\link{dplyr-locale} help page for more details.
\item If a single string from \code{\link[stringi:stri_locale_list]{stringi::stri_locale_list()}} is supplied, then
this will be used as the locale to sort with. For example, \code{"en"} will
sort with the American English locale. This requires the stringi package.
\item If \code{"C"} is supplied, then character vectors will always be sorted in the
C locale. This does not require stringi and is often much faster than
supplying a locale identifier.
}

The C locale is not the same as English locales, such as \code{"en"},
particularly when it comes to data containing a mix of upper and lower case
letters. This is explained in more detail on the \link[=dplyr-locale]{locale}
help page under the \verb{Default locale} section.}

\item{.vars}{A list of columns generated by \code{\link[=vars]{vars()}},
a character vector of column names, a numeric vector of column
positions, or \code{NULL}.}

\item{.predicate}{A predicate function to be applied to the columns
or a logical vector. The variables for which \code{.predicate} is or
returns \code{TRUE} are selected. This argument is passed to
\code{\link[rlang:as_function]{rlang::as_function()}} and thus supports quosure-style lambda
functions and strings representing function names.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#superseded}{\figure{lifecycle-superseded.svg}{options: alt='[Superseded]'}}}{\strong{[Superseded]}}

Scoped verbs (\verb{_if}, \verb{_at}, \verb{_all}) have been superseded by the use of
\code{\link[=pick]{pick()}} or \code{\link[=across]{across()}} in an existing verb. See \code{vignette("colwise")} for
details.

These \link{scoped} variants of \code{\link[=arrange]{arrange()}} sort a data frame by a
selection of variables. Like \code{\link[=arrange]{arrange()}}, you can modify the
variables before ordering with the \code{.funs} argument.
}
\section{Grouping variables}{


The grouping variables that are part of the selection participate
in the sorting of the data frame.
}

\examples{
df <- as_tibble(mtcars)
arrange_all(df)
# ->
arrange(df, pick(everything()))

arrange_all(df, desc)
# ->
arrange(df, across(everything(), desc))
}
\keyword{internal}
