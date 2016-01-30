##Read the tables
NEI<-readRDS("summarySCC_PM25.rds") ##nrow=6497651 
SCC<-readRDS("Source_Classification_Code.rds")  ##nrow=11717, ncol=15

NEI_1<-subset(NEI,fips == "24510" | fips =="06037")

library(ggplot2)
library(reshape2) ##used to reshape dataframe (melt)
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

NEI_2<-merge(NEI_1,SCC7,by ="SCC")

##Sum emissions by year and fips
NEI_3<-with(NEI_2,tapply(Emissions,list(year,fips),sum,na.rm=T))

##Make the "long" dataset
NEI_4<-melt(NEI_3,id=c(2:3))

##Convert fips to name of cities
NEI_4$Var2[NEI_4$Var2==6037]<-"Los Angeles"
NEI_4$Var2[NEI_4$Var2==24510]<-"Baltimore"

##Create 'png' file
png("plot6.png")
g<-ggplot(NEI_4,aes(x=factor(Var1),y=value,fill=Var1)) ##Var1 = Year, value = Emissions
g<-g+geom_bar(stat="identity") +
  facet_grid(.~Var2) +
  theme(axis.text=element_text(size=8),legend.position='none') + 
  labs(title = expression ("Total PM 2.5 Emissions in Baltimore and Los Angeles")) +  
  labs(x = "Year", y = expression("PM 2.5 Emissions (Tons)")) 
print(g)
dev.off()