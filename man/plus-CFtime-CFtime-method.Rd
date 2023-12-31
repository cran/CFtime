% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CFtime.R
\name{+,CFtime,CFtime-method}
\alias{+,CFtime,CFtime-method}
\alias{CFtime-merge}
\title{Merge two CFtime objects}
\usage{
\S4method{+}{CFtime,CFtime}(e1, e2)
}
\arguments{
\item{e1, e2}{CFtime. Instances of the \code{CFtime} class.}
}
\value{
A \code{CFtime} object with a set of offsets equal to the offsets of the
instances of \code{CFtime} that the operator operates on. If the datums of the \code{CFtime}
instances are not equivalent, an error is thrown.
}
\description{
Two \code{CFtime} instances can be merged into one with this operator, provided that
the datums of the two instances are equivalent.
}
\details{
The order of the two parameters is indirectly significant. The resulting \code{CFtime}
will have the offsets of both instances in the order that they are specified.
There is no reordering or removal of duplicates. This is because the time
series are usually associated with a data set and the correspondence between
the two is thus preserved. When merging the data sets described by this time
series, the order must be identical to the ordering here.
}
\examples{
e1 <- CFtime("days since 1850-01-01", "gregorian", 0:364)
e2 <- CFtime("days since 1850-01-01 00:00:00", "standard", 365:729)
e1 + e2
}
