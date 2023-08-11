## ---- include = FALSE---------------------------------------------------------
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
# Create a CF time object from a definition strinmg, a calendar and some offsets
cf <- CFtime("days since 1949-12-01", "360_day", 19830:90029)
cf

## -----------------------------------------------------------------------------
# Opening a data file that is included with the package and showing some attributes.
# Usually you would `list.files()` on a directory of your choice.
nc <- nc_open(list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1])
attrs <- ncatt_get(nc, "")
attrs$title
experiment <- attrs$experiment_id
experiment

# Create the CFtime instance from the metadata in the file.
cf <- CFtime(nc$dim$time$units, nc$dim$time$calendar, nc$dim$time$vals)
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

# Create four monthly factors for a baseline epoch and early, mid and late 21st century epochs
f_ep <- CFfactor(cf, epoch = list(baseline = 1991:2020, early = 2021:2040,
                                  mid = 2041:2060, late = 2061:2080))
str(f_ep)

## -----------------------------------------------------------------------------
# Read the data from the netCDF file.
# Keep degenerate dimensions so that we have a predictable data structure: 3-dimensional array.
# Converts units of kg m-2 s-2 to mm/day.
pr_d <- ncvar_get(nc, "pr", collapse_degen = FALSE) * 86400
str(pr_d)
# Note that the data file has two degenerate dimensions for longitude and latitude, to keep
# the example data shipped with this package small.

# Assign dimnames(), optional.
dimnames(pr_d) <- list(nc$dim$lon$vals, nc$dim$lat$vals, CFtimestamp(cf))

nc_close(nc)

# Calculate the daily average precipitation per month for the baseline period
# and the three future epochs.
# `aperm()` rearranges dimensions after `tapply()` mixed them up.
pr_d_ave <- lapply(f_ep, function(f) aperm(apply(pr_d, 1:2, tapply, f, mean), c(2, 3, 1)))

# Calculate the precipitation anomalies for the future epochs against the baseline.
# Working with daily averages per month so we can simply subtract and then multiply by days 
# per month for the CF calendar.
baseline <- pr_d_ave$baseline
pr_d_ave$baseline <- NULL
ano <- lapply(pr_d_ave, function(x) (x - baseline) * CFmonth_days(cf))

# Plot the results
plot(1:12, ano$early[1,1,], type = "o", col = "blue", ylim = c(-50, 40), xlim = c(1, 12), 
     main = paste0("Hamilton, New Zealand\n", experiment), 
     xlab = "month", ylab = "Precipitation anomaly (mm)")
lines(1:12, ano$mid[1,1,], type = "o", col = "green")
lines(1:12, ano$late[1,1,], type = "o", col = "red")

## -----------------------------------------------------------------------------
nc <- nc_open(list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[2])
cf <- CFtime(nc$dim$time$units, nc$dim$time$calendar, nc$dim$time$vals)
# Note that `cf` has a different CF calendar

f_ep <- CFfactor(cf, epoch = list(baseline = 1991:2020, early = 2021:2040,
                                  mid = 2041:2060, late = 2061:2080))

pr_d <- ncvar_get(nc, "pr", collapse_degen = FALSE) * 86400
nc_close(nc)

pr_d_ave <- lapply(f_ep, function(f) aperm(apply(pr_d, 1:2, tapply, f, mean), c(2, 3, 1)))
baseline <- pr_d_ave$baseline
pr_d_ave$baseline <- NULL
ano <- lapply(pr_d_ave, function(x) (x - baseline) * CFmonth_days(cf))

## ----eval = FALSE-------------------------------------------------------------
#  library(ncdf4)
#  library(abind)
#  
#  prepare_CORDEX <- function(fn, var) {
#    cf <- NA
#    offsets <- vector("list")
#    data <- vector("list")
#    lapply(fn, function(f) {
#      nc <- nc_open(f)
#      if (is.na(cf))
#        # Create an "empty" CFtime object, without elements
#        cf <- CFtime(nc$dim$time$units, nc$dim$time$calendar)
#  
#      # Make a list of all datum offsets and data arrays
#      offsets <- append(offsets, as.vector(nc$dim$time$vals))
#      data <- append(data, ncvar_get(nc, var, collapse_degen = FALSE)
#  
#      nc_close(nc)
#    })
#  
#    # Create a list for output with the CFtime instance assigned the offsets and
#    # the data bound in a single 3-dimensional array
#    list(CFtime = cf + unlist(offsets), data = abind(data, along = 3))
#  }

