
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
## Obtain SCC codes for coal combustion related surces using SCC.Level.Three variable
coal.scc = SCC.DT[grep("Coal", SCC.Level.Three), SCC]

## Aggregate Emissions for the above SCC by year
coal.emissions = NEI.DT[SCC %in% coal.scc, sum(Emissions), by = "year"]
colnames(coal.emissions) <- c("year", "Emissions")

# Open the PNG device
png(filename="plot4.png", width=480, height=480, units="px")

## Plot emissions per year using ggplot2 plotting system
## Emissions from coal combustion related sources decreased significantly from 1999-2008.

g = ggplot(coal.emissions, aes(year, Emissions))
g + geom_point(color = "red") + 
  geom_line(color = "green") +
  labs(x = "Year") + labs(y = expression("Total Emissions, PM"[2.5])) +
  labs(title = "Emissions from Coal Combustion for the US")
# Close the PNG device
dev.off()
