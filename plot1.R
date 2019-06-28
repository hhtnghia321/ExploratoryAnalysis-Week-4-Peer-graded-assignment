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

#the Total PM2.5 of each years
Total <- tapply(NEI$Emissions, NEI$year , sum )

#ploting by Base plot system
plot(c("1999", "2002", "2005", "2008") , Total, pch = 19, xlab = "Year", ylab = "Total PM2.5"
     , main = "Total Value of PM2.5 Emission from 1999 to 2008 ")
dev.copy(png, file = "pLot1.png")
dev.off()