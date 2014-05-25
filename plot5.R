
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.

# load required libraries
library(plyr)
library(ggplot2)
library(data.table)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")



NEI.DT = data.table(NEI)
SCC.DT = data.table(SCC)


## Obtain SCC codes for motor vehicle sources using EI.Sector variable
motor.vehicle.scc = SCC.DT[grep("[Mm]obile|[Vv]ehicles", EI.Sector), SCC]

## Aggregate Emissions for the above SCC by year and county and filter Baltimore City
motor.vehicle.emissions.baltimore = NEI.DT[SCC %in% motor.vehicle.scc, sum(Emissions), by=c("year", "fips")][fips == "24510"]
colnames(motor.vehicle.emissions.baltimore) <- c("year","fips", "Emissions")

# Open the PNG device
png(filename="plot5.png", width=480, height=480, units="px")

## Plot emissions per year using ggplot2 plotting system
## Emissions from motor vehicle sources decreased from 1999-2008 in Baltimore City, even though there was a blip in the year 2008.

g = ggplot(motor.vehicle.emissions.baltimore, aes(year, Emissions))
g + 
  geom_point(color = "red") + 
  geom_line(color = "green") +
  labs(x = "Year") + labs(y = expression("Total Emissions, PM"[2.5]) ) +
  labs(title = "Total Emissions from Motor Vehicle Sources in Baltimore City")


# Close the PNG device
dev.off()