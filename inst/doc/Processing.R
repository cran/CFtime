## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
library(CFtime)
library(ncdf4)

## -----------------------------------------------------------------------------
# Setting up
fn <- list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1]
nc <- nc_open(fn)
cf <- CFtime(nc$dim$time$units, 
             nc$dim$time$calendar, 
             nc$dim$time$vals)

# Create monthly factors for a baseline era and early, mid and late 21st century eras
baseline <- CFfactor(cf, era = 1991:2020)
future <- CFfactor(cf, era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
str(baseline)
str(future)

## -----------------------------------------------------------------------------
# Read the data from the netCDF file.
# Keep degenerate dimensions so that we have a predictable data structure: 3-dimensional array.
# Converts units of kg m-2 s-1 to mm/day.
pr <- ncvar_get(nc, "pr", collapse_degen = FALSE) * 86400

# Assign dimnames(), optional.
dimnames(pr) <- list(nc$dim$lon$vals, nc$dim$lat$vals, as_timestamp(cf))

# Get a global attribute from the file
experiment <- ncatt_get(nc, "")$experiment_id

nc_close(nc)

# Calculate the daily average precipitation per month for the baseline period
# and the three future eras.
pr_base <- apply(pr, 1:2, tapply, baseline, mean)                         # an array
pr_future <- lapply(future, function(f) apply(pr, 1:2, tapply, f, mean))  # a list of arrays

# Calculate the precipitation anomalies for the future eras against the baseline.
# Working with daily averages per month so we can simply subtract and then multiply by days 
# per month for each of the factor levels using the CF calendar.
ano <- mapply(function(pr, f) {(pr - pr_base) * CFfactor_units(cf, f)}, pr_future, future, SIMPLIFY = FALSE)

# Plot the results
plot(1:12, ano$early[,1,1], type = "o", col = "blue", ylim = c(-50, 40), xlim = c(1, 12), 
     main = paste0("Hamilton, New Zealand\nExperiment: ", experiment), 
     xlab = "month", ylab = "Precipitation anomaly (mm)")
lines(1:12, ano$mid[,1,1], type = "o", col = "green")
lines(1:12, ano$late[,1,1], type = "o", col = "red")

## -----------------------------------------------------------------------------
# Get the list of files that make up the ensemble members, here:
# GFDL ESM4 and MRI ESM2 models for experiment SSP2-4.5, precipitation, CMIP6 2015-01-01 to 2099-12-31
lf <- list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)

# Loop over the files individually
# ano is here a list with each element holding the results for a single model
ano <- lapply(lf, function(fn) {
  nc <- nc_open(fn)
  cf <- CFtime(nc$dim$time$units, nc$dim$time$calendar, nc$dim$time$vals)
  pr <- ncvar_get(nc, "pr", collapse_degen = FALSE) * 86400
  nc_close(nc)

  baseline <- CFfactor(cf, era = 1991:2020)
  pr_base <- apply(pr, 1:2, tapply, baseline, mean)
  future <- CFfactor(cf, era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
  pr_future <- lapply(future, function(f) apply(pr, 1:2, tapply, f, mean))
  mapply(function(pr, f) {(pr - pr_base) * CFfactor_units(cf, f)}, pr_future, future, SIMPLIFY = FALSE)
})

# Era names
eras <- c("early", "mid", "late")
dim(eras) <- 3

# Build the ensemble for each era
# For each era, grab the data for each of the ensemble members, simplify to an array
# and take the mean per row (months, in this case)
ensemble <- apply(eras, 1, function(e) {
  rowMeans(sapply(ano, function(a) a[[e]], simplify = T))})
colnames(ensemble) <- eras
rownames(ensemble) <- rownames(ano[[1]][[1]])
ensemble

## ----eval = FALSE-------------------------------------------------------------
#  library(ncdf4)
#  library(abind)
#  
#  prepare_CORDEX <- function(fn, var) {
#    offsets <- vector("list", length(fn))
#    data <- vector("list", length(fn))
#    for (i in 1:length(fn)) {
#      nc <- nc_open(fn[i])
#      if (i == 1)
#        # Create an "empty" CFtime object, without elements
#        cf <- CFtime(nc$dim$time$units, nc$dim$time$calendar)
#  
#      # Make lists of all datum offsets and data arrays
#      offsets[[i]] <- as.vector(nc$dim$time$vals)
#      data[[i]] <- ncvar_get(nc, var,
#                             start = c(10, 10, 1), count = c(100, 100, -1), # spatial subsetting
#                             collapse_degen = FALSE)
#  
#      nc_close(nc)
#    }
#  
#    # Create a list for output with the CFtime instance assigned the offsets and
#    # the data bound in a single 3-dimensional array
#    list(CFtime = cf + unlist(offsets), data = abind(data, along = 3))
#  }

