#function to install and load a list of packages
test_and_load.packages = function (packagesList, load=TRUE) {
  for (pkg in packagesList) {
    if (!is.element(pkg, installed.packages()[,1])) {
      install.packages(pkg)
    }
    if (load) { library(pkg, character.only=TRUE) }
  }
}

#load useful packages
test_and_load.packages(c("data.table"), TRUE)

#Read file, and transform columns
cons = read.table("household_power_consumption.txt", sep=";", dec=".", header=TRUE)
cons$Date=as.Date(cons$Date, format= "%d/%m/%Y" )
cons=subset(cons, cons$Date>=as.Date("2007-02-01", "%Y-%m-%d") & cons$Date<=as.Date("2007-02-02", "%Y-%m-%d"))
cons$DT=strptime(paste(cons$Date, cons$Time), "%Y-%m-%d %H:%M:%S")
for (i in 3:8) {
  cons[i]=as.numeric(levels(cons[,i])[cons[,i]])
}

#Build Graph 4

par(mfrow=c(2,2))

plot(cons$DT, cons$Global_active_power, type="n", xlab="", ylab="Global Active Power (kilowatts)")
lines(cons$DT, cons$Global_active_power)

plot(cons$DT, cons$Voltage, type="n", xlab="datetime", ylab="Global Active Power (kilowatts)")
lines(cons$DT, cons$Voltage)

plot(cons$DT, cons$Sub_metering_1, type="n", xlab="", ylab="Energy sub metering")
lines(cons$DT, cons$Sub_metering_1)
lines(cons$DT, cons$Sub_metering_2, col="red")
lines(cons$DT, cons$Sub_metering_3, col="blue")
legend("topright", pch = ".", lwd=2, col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

plot(cons$DT, cons$Global_reactive_power, type="n", xlab="datetime", ylab="Global_reactive_power")
lines(cons$DT, cons$Global_reactive_power)
dev.copy(png, file="plot4.png")
dev.off()
