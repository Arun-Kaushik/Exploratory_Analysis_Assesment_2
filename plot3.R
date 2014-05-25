
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.

# load required libraries
library(plyr)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Aggregate Emissions by year and filter "24510"
NEI.24510 <- NEI[which(NEI$fips == "24510"), ]
total.emissions.baltimore <- with(NEI.24510, aggregate(Emissions, by = list(year), sum))
colnames(total.emissions.baltimore) <- c("year", "Emissions")

## Aggregate Emissions by year, county, type and filter "24510"
total.emissions.baltimore.type <- ddply(NEI.24510, .(type, year), summarize, Emissions = sum(Emissions))
total.emissions.baltimore.type$Pollutant_Type <- total.emissions.baltimore.type$type


# Open the PNG device
png(filename="plot3.png", width=480, height=480, units="px")

## Plot emissions per year grouped by source type using ggplot2 plotting system
## NON-ROAD, NONPOINT, ON-ROAD type sources have seen decreases in emissions.
## POINT type has seen increased emissions until year 2005 and then decreased.

qplot(year, Emissions, data = total.emissions.baltimore.type , group = Pollutant_Type, color = Pollutant_Type, 
      geom = c("point", "line"), ylab = expression("Total Emissions, PM"[2.5]), 
      xlab = "Year", main = "Total Emissions in U.S. by Type of Pollutant")

# Close the PNG device
dev.off()