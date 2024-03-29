% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deprec-context.R
\name{deprec-context}
\alias{deprec-context}
\alias{cur_data}
\alias{cur_data_all}
\title{Information about the "current" group or variable}
\usage{
cur_data()

cur_data_all()
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

These functions were deprecated in dplyr 1.1.0.
\itemize{
\item \code{cur_data()} is deprecated in favor of \code{\link[=pick]{pick()}}.
\item \code{cur_data_all()} is deprecated but does not have a direct replacement as
selecting the grouping variables is not well-defined and is unlikely to
ever be useful.
}
}
\keyword{internal}
