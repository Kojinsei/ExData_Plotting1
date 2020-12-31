# Header ----------------------------------------------------------------------
# Project: Exploratory Data Analysis Course Project 1
# File name:plot2.R
# Author: Koji Chono
# Start Date: Dec 30, 2020

## Assignment Description -----------------------------------------------------
## Exploratory Data Analysis

# Load the packages required and set the current working directory-------------
## Load the packages required
requiredPkgs <- c("tidyverse", "lubridate")
sapply(requiredPkgs,
       require,
       character.only = TRUE,
       quietly = FALSE)
rm(requiredPkgs)

### Get some parameters of the R session
wd <- getwd() # will default to your WD
si <- sessionInfo() # get session information

### Create `data` folder for organizing data sets
if (!file.exists("./data")) {
   dir.create("./data")
}

## Data
### Original data source is UC Irvine Machine Learning Repository (http://archive.ics.uci.edu/ml/index.php)
## write code here for loading data sets here after ---------------------------
## Load dataset from Coursera
fileURL <-
   "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName <- "exdata-data-household_power_consumption.zip"
folderName <- "data"
outputName <- "plot2.png"

### Checking archive
if (!file.exists(file.path(wd, folderName, fileName))) {
   download.file(fileURL, file.path(wd, fileName), method = "curl")
   unzip(fileName, exdir = file.path(wd, folderName))
}

## R script -------------------------------------------------------------------
### Use readr package as a part of tidyverse
### Filter the original dataset from "2007-02-01" to "2007-02-02" in Date column
plotData <- read_delim(
   file.path(folderName, "household_power_consumption.txt"),
   delim = ";",
   col_types = cols(
      Date = col_date(format = "%d/%m/%Y"),
      Time = col_time(format = "%H:%M:%S"),
      Global_active_power = col_double(),
      Global_reactive_power = col_double(),
      Voltage = col_number(),
      Global_intensity = col_double(),
      Sub_metering_1 = col_double(),
      Sub_metering_2 = col_double(),
      Sub_metering_3 = col_double()
   ),
   na = c("?", "NA")) %>%
   filter(between(Date, as.Date("2007-02-01"), as.Date("2007-02-02"))) %>%
   mutate(DateTime = as.POSIXlt(paste(Date, Time), tz = "Europe/Paris"), .before ="Date")

### Output
png(
   filename = outputName,
   width = 480,
   height = 480,
   units = "px"
)
par(mfcol = c(1, 1))
with(
   plotData,
   plot(
      DateTime,
      Global_active_power,
      type = "l",
      xlab = "",
      ylab = "Global Active Power (kilowatts)",
      main = ""
   )
)

dev.off()

cat("Output was saved as", outputName, "in", wd)
# End of Script ---------------------------------------------------------------