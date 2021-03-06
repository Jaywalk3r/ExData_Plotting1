
# Load and Preprocess Data

library( dplyr)

fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

filePath = "./data.zip"

download.file( fileUrl, filePath)

unzip( filePath,  exdir = "./")

dataset = read.csv( "./household_power_consumption.txt", sep = ";", na.strings = "?")

unlink( filePath, "./household_power_consumption.txt")
	# delete data.zip and household_power_consumption.txt from working directory

dataset$Date = as.Date( dataset$Date, format = "%d/%m/%Y")
	# convert Date from factor to Date class

dataset = filter( dataset, Date == "2007-02-01" | Date == "2007-02-02")
	# subset data to days of interest

# Combine Date and time into single time variable
Timestamp = paste( dataset$Date, dataset$Time)
	# Timestamp class is character

Timestamp = strptime( Timestamp, "%Y-%m-%d %H:%M:%S")
	# Timestamp class is POSIXlt

Timestamp = as.POSIXct( Timestamp)
	# Changing class to POSIXct avoids Warning Message:
	#	In `[<-.data.frame`(`*tmp*`, is_list, value = list(Timestamp =
	#	c("<dbl[10]>",  :
	#	replacement element 1 has 11 rows to replace 10 rows
	#
	#	http://stackoverflow.com/questions/29584798/error-when-trying-to-convert
	#		-from-character-to-date-in-r
	
dataset = data.frame( Timestamp = Timestamp, dataset[ , -(1:2)])
	# replace Date and Time variables in dataset with Timestamp variable
	
dataset = tbl_df( dataset)
	# convert data frame to tbl_df object to prevent accidentally printing over
	#	2 million rows of data and simplify subsetting
	





# Plot 3

png( "plot3.png")
	# open png graphics device

plot( dataset$Timestamp, dataset$Sub_metering_1, ylab = "Energy sub metering", xlab = "", main = "", type = "l")

lines( dataset$Timestamp, dataset$Sub_metering_2, col = "red")
	# add second line to current plot

lines( dataset$Timestamp, dataset$Sub_metering_3, col = "blue")

legend( "topright", lty = c( 1, 1, 1), col = c( "black", "red", "blue"), legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
	# close graphics device
