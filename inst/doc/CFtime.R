## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
library(CFtime)
library(ncdf4)

## -----------------------------------------------------------------------------
# POSIXt calculations on a standard calendar - INCORRECT
as.Date("1949-12-01") + 43289

# CFtime calculation on a "360_day" calendar - CORRECT
# See below examples for details on the two functions
CFtimestamp(CFtime("days since 1949-12-01", "360_day", 43289))

## -----------------------------------------------------------------------------
# Create a CF time object from a definition string, a calendar and some offsets
cf <- CFtime("days since 1949-12-01", "360_day", 19830:90029)
cf

## -----------------------------------------------------------------------------
# Opening a data file that is included with the package and showing some attributes.
# Usually you would `list.files()` on a directory of your choice.
nc <- nc_open(list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1])
attrs <- ncatt_get(nc, "")
attrs$title

# "Conventions" global attribute must have a string like "CF-1.7" for this package to work reliably
attrs$Conventions

experiment <- attrs$experiment_id
experiment

# Create the CFtime instance from the metadata in the file.
cf <- CFtime(nc$dim$time$units, nc$dim$time$calendar, nc$dim$time$vals)
cf

## -----------------------------------------------------------------------------
library(RNetCDF)
nc <- open.nc(list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1])
att.get.nc(nc, -1, "Conventions")
cf <- CFtime(att.get.nc(nc, "time", "units"), att.get.nc(nc, "time", "calendar"), var.get.nc(nc, "time"))
cf

## -----------------------------------------------------------------------------
dates <- CFtimestamp(cf, format = "date")
dates[1:10]

## -----------------------------------------------------------------------------
CFrange(cf)

## -----------------------------------------------------------------------------
# Create a dekad factor for the whole `cf` time series that was created above
f_k <- CFfactor(cf, "dekad")
str(f_k)

# Create monthly factors for a baseline epoch and early, mid and late 21st century epochs
baseline <- CFfactor(cf, epoch = 1991:2020)
future <- CFfactor(cf, epoch = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
str(future)

## -----------------------------------------------------------------------------
# How many time units fits in a factor level?
CFfactor_units(cf, baseline)

# What's the absolute and relative coverage of our time series
CFfactor_coverage(cf, baseline, "absolute")
CFfactor_coverage(cf, baseline, "relative")

## -----------------------------------------------------------------------------
# 4 years of data on a `365_day` calendar, keep 80% of values
n <- 365 * 4
cov <- 0.8
offsets <- sample(0:(n-1), n * cov)

cf <- CFtime("days since 2020-01-01", "365_day", offsets)
cf
# Note that there are about 1.25 days between observations

mon <- CFfactor(cf, "month")
CFfactor_coverage(cf, mon, "absolute")
CFfactor_coverage(cf, mon, "relative")

## -----------------------------------------------------------------------------
# Days in January and February
cf <- CFtime("days since 2023-01-01", "360_day", 0:59)
cf_days <- CFtimestamp(cf, "date")
as.Date(cf_days)

