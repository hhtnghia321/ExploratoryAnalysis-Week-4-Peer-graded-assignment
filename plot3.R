#load R package
library(dplyr)
library(ggplot2)
library(reshape2)

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

#extract and arrange the data for ggplot function
group <- group_by(Bal, year, type)
plotsum <-as.data.frame(summarise(group, Max = max(Emissions), 
                                         Average = mean(Emissions), 
                                         Total = sum(Emissions)))
plotsum1 <- melt(plotsum, id.vars = c("year", "type"))

#ploting by Base plot system
g <- ggplot(plotsum1, aes(year, value))
g + geom_line(aes(col =  variable)) + 
                facet_grid(.~type) + 
                geom_smooth(method = lm, color = "yellow") +
                labs(title = "PM2.5 Emissions by Each Type of Point") 
  
#save the plot
dev.copy(png, file = "pLot3.png", width= 800)
dev.off()



