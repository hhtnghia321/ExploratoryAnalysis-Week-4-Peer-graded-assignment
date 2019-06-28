#load R package
library(dplyr)

#download the data zip file 
if(file.exists("exdata-data-NEI_data.zip") == FALSE){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile =getwd(), method = "curl")
} else { 
  print("you already have the file")
}

#unzip the file
if(file.exists("exdata-data-NEI_data") == FALSE){
  funzip("exdata-data-NEI_data.zip")
} else { 
  print("you already have the folder")
}

#read the data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

#get the data of Baltimore City
Bal <- subset(NEI, fips == "24510")
Mean <- tapply(Bal$Emissions, Bal$year , mean )
Max <- tapply(Bal$Emissions, Bal$year, max)
Total <- tapply(Bal$Emissions, Bal$year, sum)

#ploting by Base plot system
par(mfrow = c(1,3))
plot(c("1999", "2002", "2005", "2008") , Mean, pch = 19, xlab = "Year", ylab = "Average PM2.5", main = "Average of PM2.5 Emission in Baltimore City" )
plot(c("1999", "2002", "2005", "2008") , Max, pch = 19, xlab = "Year", ylab = "Max PM2.5" , main = "Maximum value of PM2.5 Emission in Baltimore City")
plot(c("1999", "2002", "2005", "2008") , Total, pch = 19, xlab = "Year", ylab = "Total PM2.5" , main = "Total of PM2.5 Emission in Baltimore City")
dev.copy(png, file = "pLot2.png", width = 800)
dev.off()