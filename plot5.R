##Read the tables
NEI<-readRDS("summarySCC_PM25.rds") ##nrow=6497651 
SCC<-readRDS("Source_Classification_Code.rds")  ##nrow=11717, ncol=15

##Limit extract to Baltimore
NEI_B<-subset(NEI,fips=="24510")  ##nrow=2096

library(dplyr)

SCC1<-grep("Vehicles",SCC$EI.Sector,value = TRUE)  ##to get all 
  ##EI.Sectors with "Vehicles"
SCC2<-unique(SCC1)  ##to derive unique values.  Prepping for a merge
SCC3<-data.frame(SCC2)  
SCC4<-rename(SCC3,EI.Sector=SCC2) ##converting to data.frame 
  ##imparted vector name to column name.  Renaming since merge will be
  ##by this field
SCC5<-merge(SCC,SCC4,by ="EI.Sector")  ##Merge to get the SCC for all 
  ##EI.Sectors that are vehicles
SCC6<-data.frame(SCC5$SCC)
SCC7<-rename(SCC6,SCC=SCC5.SCC)

NEI_B1<-merge(NEI_B,SCC7,by ="SCC")

##Sum emissions by year and then scale for easy comprehension
NEI_B2<-with(NEI_B1,tapply(Emissions,year,sum,na.rm=T))
NEI_B2<-data.frame(Year=names(NEI_B2),Emissions=NEI_B2)

##Create 'png' file
png("plot5.png")

barplot(height=NEI_B2$Emissions,names=NEI_B2$Year,
        ylab="Emissions (in Tons)",xlab="Year",
        main="Total PM2.5 Emissions in Baltimore from Vehicle Sources")

dev.off()