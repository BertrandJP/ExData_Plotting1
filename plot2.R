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

#Build Graph 2
plot(cons$DT, cons$Global_active_power, type="n", xlab="", ylab="Global Active Power (kilowatts)")
lines(cons$DT, cons$Global_active_power)
dev.copy(png, file="plot2.png")
dev.off()

