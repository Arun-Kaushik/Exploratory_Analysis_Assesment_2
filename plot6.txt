
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

## Aggregate Emissions for the above SCC by year and county
motor.vehicle.emissions = NEI.DT[SCC %in% motor.vehicle.scc, sum(Emissions), by=c("year", "fips")]
colnames(motor.vehicle.emissions) <- c("year", "Emissions")

# Open the PNG device
 png(filename="plot6.png", width=480, height=480, units="px")

## Plot emissions per year grouped by fips using ggplot2 plotting system
## Use log scale to plot rate of change.
## Observe steeper slopes for Baltimore City, indicating it has seen greater changes.

g = ggplot(motor.vehicle.emissions[fips == "24510" | fips == "06037"], aes(year, log(V1)))
g + geom_point() + 
  geom_line(aes(color = fips)) +
  scale_color_discrete(name = "County", breaks = c("06037", "24510"), labels = c("Los Angeles", "Baltimore")) +
  labs(x = "Year") + labs(y = expression("Total Emissions, PM"[2.5])) +
  labs(title = "Annual Motor Vehicle Emissions")


# Close the PNG device
dev.off()