##Read the tables
NEI<-readRDS("summarySCC_PM25.rds") ##nrow=6497651 
SCC<-readRDS("Source_Classification_Code.rds")  ##nrow=11717, ncol=15

NEI_B<-subset(NEI,fips=="24510")  ##nrow=2096

##Sum emissions by year and then scale for easy comprehension
NEI1_B<-with(NEI_B,tapply(Emissions,year,sum,na.rm=T))
NEI1_B<-data.frame(Year=names(NEI1_B),Emissions=NEI1_B)

##Create 'png' file
png("plot2.png")

barplot(height=NEI1_B$Emissions,names=NEI1_B$Year,
        ylab="Emissions",xlab="Year",
        main="Total PM2.5 Emissions in Baltimore")

dev.off()
