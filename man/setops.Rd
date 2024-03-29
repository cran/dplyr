% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sets.R
\name{setops}
\alias{setops}
\alias{intersect}
\alias{union}
\alias{union_all}
\alias{setdiff}
\alias{setequal}
\alias{symdiff}
\title{Set operations}
\usage{
intersect(x, y, ...)

union(x, y, ...)

union_all(x, y, ...)

setdiff(x, y, ...)

setequal(x, y, ...)

symdiff(x, y, ...)
}
\arguments{
\item{x, y}{Pair of compatible data frames. A pair of data frames is
compatible if they have the same column names (possibly in different
orders) and compatible types.}

\item{...}{These dots are for future extensions and must be empty.}
}
\description{
Perform set operations using the rows of a data frame.
\itemize{
\item \code{intersect(x, y)} finds all rows in both \code{x} and \code{y}.
\item \code{union(x, y)} finds all rows in either \code{x} or \code{y}, excluding duplicates.
\item \code{union_all(x, y)} finds all rows in either \code{x} or \code{y}, including duplicates.
\item \code{setdiff(x, y)} finds all rows in \code{x} that aren't in \code{y}.
\item \code{symdiff(x, y)} computes the symmetric difference, i.e. all rows in
\code{x} that aren't in \code{y} and all rows in \code{y} that aren't in \code{x}.
\item \code{setequal(x, y)} returns \code{TRUE} if \code{x} and \code{y} contain the same rows
(ignoring order).
}

Note that \code{intersect()}, \code{union()}, \code{setdiff()}, and \code{symdiff()} remove
duplicates in \code{x} and \code{y}.
}
\section{Base functions}{
\code{intersect()}, \code{union()}, \code{setdiff()}, and \code{setequal()} override the base
functions of the same name in order to make them generic. The existing
behaviour for vectors is preserved by providing default methods that call
the base functions.
}

\examples{
df1 <- tibble(x = 1:3)
df2 <- tibble(x = 3:5)

intersect(df1, df2)
union(df1, df2)
union_all(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)
symdiff(df1, df2)

setequal(df1, df2)
setequal(df1, df1[3:1, ])

# Note that the following functions remove pre-existing duplicates:
df1 <- tibble(x = c(1:3, 3, 3))
df2 <- tibble(x = c(3:5, 5))

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
symdiff(df1, df2)
}
