

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.

# load required libraries
library(plyr)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Aggregate Emissions by year and county and filter "24510"
NEI.24510 <- NEI[which(NEI$fips == "24510"), ]
total.emissions.baltimore <- with(NEI.24510, aggregate(Emissions, by = list(year), sum))
colnames(total.emissions.baltimore) <- c("year", "Emissions")

# Open the PNG device
png(filename="plot2.png", width=480, height=480, units="px")


## Total emissions from PM2.5 on average decreased in the Baltimore City, Maryland from 1999 to 2008
plot(total.emissions.baltimore$year, total.emissions.baltimore$Emissions, type = "b", pch = 18, col = "green", ylab = "Emissions", xlab = "Year", main = "Baltimore Emissions")

# Close the PNG device
dev.off()
