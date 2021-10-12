library(plyr)
library(dplyr)
library(reshape2)
library(stringr)
library(lubridate)

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

data_set$Global_active_power <- as.numeric(data_set$Global_active_power)
data_set$Sub_metering_1 <- as.numeric(data_set$Sub_metering_1)
data_set$Sub_metering_2 <- as.numeric(data_set$Sub_metering_2)
data_set$Sub_metering_3 <- as.numeric(data_set$Sub_metering_3)

data_set$newdate <- strptime(as.character(data_set$Date),"%d/%m/%Y")
data_set$newdate2 <- format(data_set$newdate, "%Y-%m-%d")

data_set$newtime <- strptime(as.character(data_set$Time),"%H:%M:%S")
data_set$newtime2 <- format(data_set$newtime, "%H:%M:%S")
complete_date <- with(data_set, ymd(newdate2) + hms(newtime2))

data_set <- cbind(complete_date, data_set)

png(filename = "plot3.png")
with(data_set, plot(data_set$complete_date, data_set$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering"))
lines(data_set$complete_date, data_set$Sub_metering_2, col = "red")
lines(data_set$complete_date, data_set$Sub_metering_3, col = "blue")
legend("topright", lty =1, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
dev.off()