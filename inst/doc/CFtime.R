## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
library(CFtime)
library(ncdfCF)

## -----------------------------------------------------------------------------
# POSIXt calculations on a standard calendar - INCORRECT
as.Date("1949-12-01") + 43289

# CFtime calculation on a "360_day" calendar - CORRECT
# See below examples for details on the two functions
as_timestamp(CFtime("days since 1949-12-01", "360_day", 43289))

## -----------------------------------------------------------------------------
# Create a CFTime object from a definition string, a calendar and some offsets
(t <- CFtime("days since 1949-12-01", "360_day", 19830:90029))

## -----------------------------------------------------------------------------
# Opening a data file that is included with the package.
# Usually you would `list.files()` on a directory of your choice.
fn <- list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1]
(ds <- ncdfCF::open_ncdf(fn))

# "Conventions" global attribute must have a string like "CF-1.*" for this package to work reliably

# Look at the "time" axis
(time <- ds[["time"]])

# Get the CFTime instance from the "time" axis
(t <- time$time())

## ----eval = FALSE-------------------------------------------------------------
#  library(RNetCDF)
#  nc <- open.nc(fn)
#  att.get.nc(nc, -1, "Conventions")
#  t <- CFtime(att.get.nc(nc, "time", "units"),
#              att.get.nc(nc, "time", "calendar"),
#              var.get.nc(nc, "time"))
#  
#  library(ncdf4)
#  nc <- nc_open(fn)
#  nc_att_get(nc, 0, "Conventions")
#  t <- CFtime(nc$dim$time$units,
#              nc$dim$time$calendar,
#              nc$dim$time$vals)

## -----------------------------------------------------------------------------
dates <- t$as_timestamp(format = "date")
dates[1:10]

## -----------------------------------------------------------------------------
t$range()

## -----------------------------------------------------------------------------
# Create a dekad factor for the whole `t` time series that was created above
f_k <- t$factor("dekad")
str(f_k)

# Create monthly factors for a baseline era and early, mid and late 21st century eras
baseline <- t$factor(era = 1991:2020)
future <- t$factor(era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
str(future)

## -----------------------------------------------------------------------------
  (new_time <- attr(f_k, "CFTime"))

## -----------------------------------------------------------------------------
# Is the time series complete?
is_complete(t)

# How many time units fit in a factor level?
t$factor_units(baseline)

# What's the absolute and relative coverage of our time series
t$factor_coverage(baseline, "absolute")
t$factor_coverage(baseline, "relative")

## -----------------------------------------------------------------------------
# 4 years of data on a `365_day` calendar, keep 80% of values
n <- 365 * 4
cov <- 0.8
offsets <- sample(0:(n-1), n * cov)

(t <- CFtime("days since 2020-01-01", "365_day", offsets))
# Note that there are about 1.25 days between observations

mon <- t$factor("month")
t$factor_coverage(mon, "absolute")
t$factor_coverage(mon, "relative")

## -----------------------------------------------------------------------------
# 1970-01-01 is the origin of POSIXt
difftime(as.POSIXct("2024-01-01"), as.POSIXct("1970-01-01"), units = "sec")

# Leap seconds in UTC
.leap.seconds

## -----------------------------------------------------------------------------
# Days in January and February
t <- CFtime("days since 2023-01-01", "360_day", 0:59)
ts_days <- t$as_timestamp("date")
as.Date(ts_days)

