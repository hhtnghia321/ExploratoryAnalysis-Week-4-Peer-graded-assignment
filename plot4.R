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

#extract the SCC code from SCC object with coal related 
coalpos1 <- grep("[Cc]oal", SCC$SCC.Level.Three)
coalpos2 <- grep("[Cc]oal", SCC$SCC.Level.Four)
coalpos <- unique(c(coalpos1,coalpos2))
#coalpos <- grep("[Cc]oal", SCC$EI.Sector)
SCCcode <- SCC[coalpos,]$SCC



#extract the data with the coal related SCC code
coaldata <- NEI[NEI$SCC %in% SCCcode,]


#extract and arrange the data for ggplot function
group <- group_by(coaldata, year)
plotsum <-as.data.frame(summarise(group, Max = max(Emissions), 
                                         Average = mean(Emissions), 
                                         Total = sum(Emissions)))
plotsum1 <- melt(plotsum, id.vars = c("year"))

#ploting by Base plot system
g <- ggplot(plotsum1, aes(year, value))
g + geom_line(aes(col =  variable)) + 
                geom_smooth(method = lm, color = "yellow") +
                labs(title = "PM2.5 Emissions by Coal combrusted-related") 
  
#save the plot
dev.copy(png, file = "pLot4.png" )
dev.off()



