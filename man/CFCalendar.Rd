% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CFCalendar.R
\docType{class}
\name{CFCalendar}
\alias{CFCalendar}
\title{Basic CF calendar}
\description{
This class represents a basic CF calendar. It should not be
instantiated directly; instead, use one of the descendant classes.

This internal class stores the information to represent date and time
values using the CF conventions. An instance is created by the exported
\link{CFTime} class, which also exposes the relevant properties of this class.

The following calendars are supported:

\itemize{
\item \code{\link[=CFCalendarStandard]{gregorian\\standard}}, the international standard calendar for civil use.
\item \code{\link[=CFCalendarProleptic]{proleptic_gregorian}}, the standard calendar but extending before 1582-10-15
when the Gregorian calendar was adopted.
\item \code{\link[=CFCalendarTAI]{tai}}, International Atomic Time clock with dates expressed using the Gregorian calendar.
\item \code{\link[=CFCalendarUTC]{utc}}, Coordinated Universal Time clock with dates expressed using the Gregorian calendar.
\item \code{\link[=CFCalendarJulian]{julian}}, every fourth year is a leap year (so including the years 1700, 1800, 1900, 2100, etc).
\item \code{\link[=CFCalendar365]{noleap\\365_day}}, all years have 365 days.
\item \code{\link[=CFCalendar366]{all_leap\\366_day}}, all years have 366 days.
\item \code{\link[=CFCalendar360]{360_day}}, all years have 360 days, divided over 12 months of 30 days.
}
}
\references{
https://cfconventions.org/Data/cf-conventions/cf-conventions-1.12/cf-conventions.html#calendar
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{name}}{Descriptive name of the calendar, as per the CF Metadata
Conventions.}

\item{\code{definition}}{The string that defines the units and the origin, as
per the CF Metadata Conventions.}

\item{\code{unit}}{The numeric id of the unit of the calendar.}

\item{\code{origin}}{\code{data.frame} with fields for the origin of the calendar.}
}
\if{html}{\out{</div>}}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{origin_date}}{(read-only) Character string with the date of the
calendar.}

\item{\code{origin_time}}{(read-only) Character string with the time of the
calendar.}

\item{\code{timezone}}{(read-only) Character string with the time zone of the
origin of the calendar.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-CFCalendar-new}{\code{CFCalendar$new()}}
\item \href{#method-CFCalendar-print}{\code{CFCalendar$print()}}
\item \href{#method-CFCalendar-valid_days}{\code{CFCalendar$valid_days()}}
\item \href{#method-CFCalendar-add_day}{\code{CFCalendar$add_day()}}
\item \href{#method-CFCalendar-POSIX_compatible}{\code{CFCalendar$POSIX_compatible()}}
\item \href{#method-CFCalendar-is_compatible}{\code{CFCalendar$is_compatible()}}
\item \href{#method-CFCalendar-is_equivalent}{\code{CFCalendar$is_equivalent()}}
\item \href{#method-CFCalendar-parse}{\code{CFCalendar$parse()}}
\item \href{#method-CFCalendar-offsets2time}{\code{CFCalendar$offsets2time()}}
\item \href{#method-CFCalendar-clone}{\code{CFCalendar$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-new"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-new}{}}}
\subsection{Method \code{new()}}{
Create a new CF calendar.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$new(nm, definition)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{nm}}{The name of the calendar. This must follow the CF Metadata
Conventions.}

\item{\code{definition}}{The string that defines the units and the origin, as
per the CF Metadata Conventions.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-print"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-print}{}}}
\subsection{Method \code{print()}}{
Print information about the calendar to the console.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$print(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Ignored.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{self}, invisibly.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-valid_days"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-valid_days}{}}}
\subsection{Method \code{valid_days()}}{
Indicate which of the supplied dates are valid.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$valid_days(ymd)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{ymd}}{\code{data.frame} with dates parsed into their parts in columns
\code{year}, \code{month} and \code{day}. Any other columns are disregarded.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL}. A warning will be generated to the effect that a
descendant class should be used for this method.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-add_day"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-add_day}{}}}
\subsection{Method \code{add_day()}}{
Add a day to the supplied dates.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$add_day(ymd)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{ymd}}{\code{data.frame} with dates parsed into their parts in columns
\code{year}, \code{month} and \code{day}. Any other columns are disregarded.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A \code{data.frame} like argument \code{ymd} but with a day added for every
row.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-POSIX_compatible"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-POSIX_compatible}{}}}
\subsection{Method \code{POSIX_compatible()}}{
Indicate if the time series described using this calendar
can be safely converted to a standard date-time type (\code{POSIXct},
\code{POSIXlt}, \code{Date}).

Only the 'standard' calendar and the 'proleptic_gregorian' calendar
when all dates in the time series are more recent than 1582-10-15
(inclusive) can be safely converted, so this method returns \code{FALSE} by
default to cover the majority of cases.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$POSIX_compatible(offsets)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{offsets}}{The offsets from the CFtime instance.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{FALSE} by default.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-is_compatible"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-is_compatible}{}}}
\subsection{Method \code{is_compatible()}}{
This method tests if the \code{CFCalendar} instance in argument
\code{cal} is compatible with \code{self}, meaning that they are of the same
class and have the same unit. Calendars "standard", and "gregorian" are
compatible, as are the pairs of "365_day" and "no_leap", and "366_day"
and "all_leap".
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$is_compatible(cal)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{cal}}{Instance of a descendant of the \code{CFCalendar} class.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{TRUE} if the instance in argument \code{cal} is compatible with
\code{self}, \code{FALSE} otherwise.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-is_equivalent"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-is_equivalent}{}}}
\subsection{Method \code{is_equivalent()}}{
This method tests if the \code{CFCalendar} instance in argument
\code{cal} is equivalent to \code{self}, meaning that they are of the same class,
have the same unit, and equivalent origins. Calendars "standard", and
"gregorian" are equivalent, as are the pairs of "365_day" and
"no_leap", and "366_day" and "all_leap".

Note that the origins need not be identical, but their parsed values
have to be. "2000-01" is parsed the same as "2000-01-01 00:00:00", for
instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$is_equivalent(cal)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{cal}}{Instance of a descendant of the \code{CFCalendar} class.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{TRUE} if the instance in argument \code{cal} is equivalent to
\code{self}, \code{FALSE} otherwise.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-parse"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-parse}{}}}
\subsection{Method \code{parse()}}{
Parsing a vector of date-time character strings into parts.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$parse(d)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{d}}{character. A character vector of date-times.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A \code{data.frame} with columns year, month, day, hour, minute,
second, time zone, and offset. Invalid input data will appear as \code{NA}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-offsets2time"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-offsets2time}{}}}
\subsection{Method \code{offsets2time()}}{
Decompose a vector of offsets, in units of the calendar, to
their timestamp values. This adds a specified amount of time to the
origin of a \code{CFTime} object.

This method may introduce inaccuracies where the calendar unit is
"months" or "years", due to the ambiguous definition of these units.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$offsets2time(offsets = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{offsets}}{Vector of numeric offsets to add to the origin of the
calendar.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A \code{data.frame} with columns for the timestamp elements and as
many rows as there are offsets.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CFCalendar-clone"></a>}}
\if{latex}{\out{\hypertarget{method-CFCalendar-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CFCalendar$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
