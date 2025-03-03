## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
library(CFtime)

## -----------------------------------------------------------------------------
# Setting up
library(ncdfCF)
fn <- list.files(path = system.file("extdata", package = "CFtime"), full.names = TRUE)[1]
(ds <- ncdfCF::open_ncdf(fn))

# The T axis, with name "time" has a CFTime instance
t <- ds[["time"]]$time()

# Create monthly factors for a baseline era and early, mid and late 21st century eras
baseline <- t$factor(era = 1991:2020)
future <- t$factor(era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
str(baseline)
str(future)

## -----------------------------------------------------------------------------
# Get the data for the "pr" data variable from the netCDF data set.
# The `CFData$array()` method ensures that data are in standard R orientation.
# Converts units of kg m-2 s-1 to mm/day.
pr <- ds[["pr"]]$data()$array() * 86400

# Get a global attribute from the file
experiment <- ds$attribute("experiment_id")

# Calculate the daily average precipitation per month for the baseline period
# and the three future eras.
pr_base <- apply(pr, 1:2, tapply, baseline, mean)                         # an array
pr_future <- lapply(future, function(f) apply(pr, 1:2, tapply, f, mean))  # a list of arrays

# Calculate the precipitation anomalies for the future eras against the baseline.
# Working with daily averages per month so we can simply subtract and then multiply by days 
# per month for each of the factor levels using the CF calendar.
ano <- mapply(function(pr, f) {(pr - pr_base) * t$factor_units(f)}, pr_future, future, SIMPLIFY = FALSE)

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
  ds <- ncdfCF::open_ncdf(fn)
  t <- ds[["time"]]$time()
  pr <- ds[["pr"]]$data()$array() * 86400

  baseline <- t$factor(era = 1991:2020)
  pr_base <- apply(pr, 1:2, tapply, baseline, mean)
  future <- t$factor(era = list(early = 2021:2040, mid = 2041:2060, late = 2061:2080))
  pr_future <- lapply(future, function(f) apply(pr, 1:2, tapply, f, mean))
  mapply(function(pr, f) {(pr - pr_base) * t$factor_units(f)}, pr_future, future, SIMPLIFY = FALSE)
})

# Era names
eras <- c("early", "mid", "late")
dim(eras) <- 3

# Build the ensemble for each era
# For each era, grab the data for each of the ensemble members, simplify to an array
# and take the mean per row (months, in this case)
ensemble <- apply(eras, 1, function(e) {
  rowMeans(sapply(ano, function(a) a[[e]], simplify = TRUE))})
colnames(ensemble) <- eras
rownames(ensemble) <- rownames(ano[[1]][[1]])
ensemble

## ----eval = FALSE-------------------------------------------------------------
#  library(ncdfCF)
#  library(abind)
#  
#  prepare_CORDEX <- function(fn, var, aoi) {
#    data <- vector("list", length(fn))
#    for (i in 1:length(fn)) {
#      ds <- ncdfCF::open_ncdf(fn[i])
#      if (i == 1) {
#        # Get a CFTime instance from the first file
#        t <- ds[["time"]]$time()
#      } else {
#        # Add offsets from the file and add to the CFTime instance
#        t <- t + ds[["time"]]$time()$offsets
#      }
#  
#      # Put the subsetted data array in the list
#      data[[i]] <- ds[[var]]$subset(aoi = aoi)$array()
#    }
#  
#    # Create a list for output with the CFTime instance and
#    # the data bound in a single 3-dimensional array
#    list(CFTime = t, data = abind(data, along = 3))
#  }

