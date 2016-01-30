##Read the tables
NEI<-readRDS("summarySCC_PM25.rds") ##nrow=6497651 
SCC<-readRDS("Source_Classification_Code.rds")  ##nrow=11717, ncol=15

##Limit extract to Baltimore
NEI_B<-subset(NEI,fips=="24510")  ##nrow=2096

library(ggplot2)
library(reshape2) ##used to reshape dataframe (melt)

##Sum emissions by type and year
NEI1_B<-with(NEI_B,tapply(Emissions,list(type,year),sum,na.rm=T))

##Make the "long" dataset
NEI1_B<-melt(NEI1_B,id=c(1:5))

##Create 'png' file
png("plot3.png")
g<-ggplot(NEI1_B,aes(x=factor(Var2),y=value,fill=Var2)) ##Var2 = Year, value = Emissions
g<-g+geom_bar(stat="identity") +
  facet_grid(.~Var1) +
  theme(axis.text=element_text(size=8),legend.position='none') + 
  labs(title = expression ("Total PM 2.5 Emissions in Baltimore")) +  
  labs(x = "Year", y = expression("PM2.5 Emissions (Tons)")) 
print(g)
dev.off()