% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/conditions.R
\name{last_dplyr_warnings}
\alias{last_dplyr_warnings}
\title{Show warnings from the last command}
\usage{
last_dplyr_warnings(n = 5)
}
\arguments{
\item{n}{Passed to \code{\link[=head]{head()}} so that only the first \code{n} warnings are
displayed.}
}
\description{
Warnings that occur inside a dplyr verb like \code{mutate()} are caught
and stashed away instead of being emitted to the console. This
prevents rowwise and grouped data frames from flooding the console
with warnings. To see the original warnings, use
\code{last_dplyr_warnings()}.
}
\keyword{internal}
