##Read the tables
NEI<-readRDS("summarySCC_PM25.rds") ##nrow=6497651 
SCC<-readRDS("Source_Classification_Code.rds")  ##nrow=11717, ncol=15

library(dplyr)

SCC1<-grep("Coal",SCC$EI.Sector,value = TRUE)  ##to get all EI.Sectors with "coal"
SCC2<-unique(SCC1)  ##to derive unique values.  Prepping for a merge
SCC3<-data.frame(SCC2)  
SCC4<-rename(SCC3,EI.Sector=SCC2) ##converting to data.frame 
  ##imparted vector name to column name.  Renaming since merge will be
  ##by this field
SCC5<-merge(SCC,SCC4,by ="EI.Sector")  ##Merge to get the SCC for all 
  ##EI.Sectors that are coal
SCC6<-data.frame(SCC5$SCC)
SCC7<-rename(SCC6,SCC=SCC5.SCC)

NEI1<-merge(NEI,SCC7,by ="SCC")

##Sum emissions by year and then scale for easy comprehension
NEI2<-with(NEI,tapply(Emissions,year,sum,na.rm=T))
NEI2<-data.frame(Year=names(NEI2),Emissions=NEI2)
NEI2$NewEmissions<-NEI2$Emissions/1000000

##Create 'png' file
png("plot4.png")

barplot(height=NEI2$NewEmissions,names=NEI2$Year,
        ylab="Emissions (in Million Tons)",xlab="Year",
        main="Total PM2.5 Emissions in USA from Coal Combustion Sources")

dev.off()

