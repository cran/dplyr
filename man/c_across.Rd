% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/across.R
\name{c_across}
\alias{c_across}
\title{Combine values from multiple columns}
\usage{
c_across(cols)
}
\arguments{
\item{cols}{<\code{\link[=dplyr_tidy_select]{tidy-select}}> Columns to transform.
You can't select grouping columns because they are already automatically
handled by the verb (i.e. \code{\link[=summarise]{summarise()}} or \code{\link[=mutate]{mutate()}}).}
}
\description{
\code{c_across()} is designed to work with \code{\link[=rowwise]{rowwise()}} to make it easy to
perform row-wise aggregations. It has two differences from \code{c()}:
\itemize{
\item It uses tidy select semantics so you can easily select multiple variables.
See \code{vignette("rowwise")} for more details.
\item It uses \code{\link[vctrs:vec_c]{vctrs::vec_c()}} in order to give safer outputs.
}
}
\examples{
df <- tibble(id = 1:4, w = runif(4), x = runif(4), y = runif(4), z = runif(4))
df \%>\%
  rowwise() \%>\%
  mutate(
    sum = sum(c_across(w:z)),
    sd = sd(c_across(w:z))
  )
}
\seealso{
\code{\link[=across]{across()}} for a function that returns a tibble.
}
