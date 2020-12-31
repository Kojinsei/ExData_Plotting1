# Header ----------------------------------------------------------------------
# Project: Exploratory Data Analysis Course Project 1
# File name:plot4.R
# Author: Koji Chono
# Start Date: Dec 30, 2020

## Assignment Description ------------------------------------------------------
## Exploratory Data Analysis

# Load the packages required and set the current working directory-------------
## Load the packages required
requiredPkgs <- c("tidyverse", "reshape2", "lubridate")
sapply(requiredPkgs, require, character.only=TRUE, quietly=FALSE)
rm(requiredPkgs)

### Get some parameters of the R session
wd <- getwd() # will default to your WD
si <- sessionInfo() # get session information

### Create `data` folder for organizing data sets
if(!file.exists("./data")){dir.create("./data")}

## Data
### Original data source is UC Irvine Machine Learning Repository (http://archive.ics.uci.edu/ml/index.php)
## write code here for loading data sets here after ---------------------------
## Load dataset from Coursera
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName <- "exdata-data-household_power_consumption.zip"
folderName <- "data"

### Checking archive
if (!file.exists(file.path(wd, folderName, fileName))){
      download.file(fileURL, file.path(wd, fileName), method="curl")
      unzip(fileName, exdir = file.path(wd, folderName))
}

## R script -------------------------------------------------------------------
### Use readr package as a part of tidyverse
### Filter the original dataset from "2007-02-01" to "2007-02-02" in Date column
plotData <- read_delim(
      "data/household_power_consumption.txt",
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
      # Convert the missing values ("?") to "NA"
      na = c("?", "NA") ) %>%
      filter(between(Date, as.Date("2007-02-01"), as.Date("2007-02-02")))

dateTime <- as_tibble_col(with(plotData, as.POSIXlt(paste(Date, Time), tz = "Europe/Paris")), column_name = "DateTime")

plotData <- plotData %>% add_column(dateTime, .before = "Date")

### Output
png(filename = "plot4.png")

par(mfcol = c(2,2))
with(plotData, {
      plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)", main = "")
      
      plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", main = "", col = "black")
      lines(DateTime, Sub_metering_2, col = "red")
      lines(DateTime, Sub_metering_3, col = "blue")
      legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = names(plotData[, 8:10]), bty = "n")
      
      plot(DateTime, Voltage, type = "l", col = "black", xlab = "datetime", ylab = "Voltage")
      
      plot(dateTime, Global_reactive_power, type = "l", col = "black", xlab = "datetime", ylab = "Global_reactive_power")
})

dev.off()
# End of Script ---------------------------------------------------------------