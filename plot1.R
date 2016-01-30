##Read the tables
NEI<-readRDS("summarySCC_PM25.rds") ##nrow=6497651 
SCC<-readRDS("Source_Classification_Code.rds")  ##nrow=11717, ncol=15

##Sum emissions by year and then scale for easy comprehension
NEI1<-with(NEI,tapply(Emissions,year,sum,na.rm=T))
NEI1<-data.frame(Year=names(NEI1),Emissions=NEI1)
NEI1$NewEmissions<-NEI1$Emissions/1000000

##Create 'png' file
png("plot1.png")

barplot(height=NEI1$NewEmissions,names=NEI1$Year,
        ylab="Emissions (in Million Tons)",xlab="Year",
        main="Total PM2.5 Emissions in USA")

dev.off()
