library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

directory <- getwd()
directory <- setwd("C:/Users/Val/Documents/R/Assignments/Exploratory Data Analysis")

con <- file("./household_power_consumption.txt", "rt")
lines <- c()
while(TRUE){
        line = readLines(con, 1)
        if(length(line) == 0) break
        else if (grepl("^1/2/2007|^2/2/2007", line)) lines <-c(lines, line)
}

data_set <- data.frame()
rdim <- length(lines)
cdim <- 9
for (i in 1:rdim)
{for (j in 1:cdim) {
        data_set[i,j] <- strsplit(lines[i], ";")[[1]][j]
}
        
}

data_set <- rename(data_set, Date = "V1", Time = "V2", Global_active_power = "V3", Global_reactive_power = "V4", Voltage ="V5", Global_intensity = "V6", Sub_metering_1 = "V7", Sub_metering_2 = "V8", Sub_metering_3 = "V9")

data_set$Date <- as.Date(data_set$Date)
data_set$Time <- strptime(data_set$Time, "%H:%M:%S")

data_set$Global_active_power <- as.numeric(data_set$Global_active_power)

png(filename = "plot1.png")
with(data_set, hist(data_set$Global_active_power, col = "red", breaks = 6, main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
dev.off