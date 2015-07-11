library(ggmap)
library(ggplot2)
library(dplyr)
library(reshape)
library(RColorBrewer)

setwd("/Users/newaesthetic/Desktop/data/Udacity/data_science_1/Project1_Matteo_Pallini")

dfrmAlt <- read.csv(file="turnstile_data_master_with_weather.csv",head=TRUE,sep=",")

group_units <- group_by(dfrmAlt, DATEn, rain)
SumForUnit <- summarise(group_units, Entries = mean(ENTRIESn_hourly))
SumForUnit$rain <- ifelse(SumForUnit$rain == 0, "No Rain", "Rain")

plot2 = ggplot(SumForUnit, aes( x = DATEn, y = Entries, fill=rain)) + geom_bar(stat = "identity") + 
ggtitle("Average Hourly Entries at Daily Level") + xlab("Date") + ylab("Entries") + 
scale_x_discrete(breaks=c("2011-05-01", "2011-05-08", "2011-05-15", "2011-05-22", "2011-05-29"), labels=c("2011-05-01", "2011-05-08", "2011-05-15", "2011-05-22", "2011-05-29"))
ggsave(filename="BarPlot.png")

dfrm <- read.csv(file="turnstile_weather_v2.csv",head=TRUE,sep=",")

dfrm$intraday <- ifelse(dfrm$hour == 16 |dfrm$hour == 20, "afternoon", ifelse(dfrm$hour == 0 |dfrm$hour == 4,"night","morning"))
dfrm$intraday <- factor(dfrm$intraday)
dfrm$rain <- ifelse(dfrm$rain == 0, "No Rain", "Rain")
dfrm$rain <- factor(dfrm$rain)

# dfrm$ENTRIESn <- dfrm$ENTRIESn / 1000
# dfrm$EXITSn <- dfrm$EXITSn / 1000

ValLat <- summary(dfrm$latitude)
ValLon <- summary(dfrm$longitude)

# Lon [-74.05, -73.73]
# Lan [40.55, 40.92]

Long <- - (73.73 + (74.04 - 73.73) / 2)
Lat <- 40.91 - (40.91 - 40.55) / 2

map <- get_map(location = c(lon = Long, lat = Lat),
        zoom = 11, scale = "auto",
        maptype = c("terrain"),
        messaging = FALSE, urlonly = FALSE,
        filename = "ggmapTemp", crop = TRUE,
        color = c("color", "bw"),
        source = c("google"),
        api_key)

NYmap <- ggmap(map)

# turn exits to negative number in order to have a diverging color palete showing the prevalence of exits or entries
dfrm$EXITSn_hourly <- sapply(dfrm$EXITSn_hourly, function(x) if(x > 0) -x else x)
group_units <- group_by(dfrm, UNIT, intraday)
SumForUnit <- summarise(group_units, Enter = mean(ENTRIESn_hourly), Exit = mean(EXITSn_hourly), Lat = mean(latitude), Lon = mean(longitude))
stacked <- data.frame(melt(data.frame(SumForUnit), id.vars=c("UNIT","Lat", "Lon", "intraday")))
group_units2 <- group_by(stacked, UNIT, intraday)
SumForUnit2 <- summarise(group_units2, value = mean(value), Lat = mean(Lat), Lon = mean(Lon))
names(SumForUnit2)[names(SumForUnit2) == 'value'] <- 'Frequency'

stackedmorning <- filter(SumForUnit2, intraday == "morning")
png(filename = "MapMorning.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, color = Frequency), alpha = 7/10, size=5, data=stackedmorning) +
                scale_colour_gradient(limits=c(-5000, 5000), low="#FF6666", high = "#000066") + scale_size(range = c(3, 7))
dev.off()

stackedafternoon <- filter(SumForUnit2, intraday == "afternoon")
png(filename = "MapAfternoon.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, color = Frequency), alpha = 7/10, size=5, data=stackedafternoon) +
        scale_colour_gradient( limits=c(-5000, 5000), low="#FF6666", high = "#000066") + scale_size(range = c(3, 7))
dev.off()

stackednight <- filter(SumForUnit2, intraday == "night")
png(filename = "MapNight.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, color = Frequency), alpha = 7/10, size=5, data=stackednight) +
        scale_colour_gradient(limits=c(-5000, 5000), low="#FF6666", high = "#000066") + scale_size(range = c(3, 7))
dev.off()                        

### alternative analysis

group_units <- group_by(dfrm, UNIT, rain)
SumForUnit <- summarise(group_units, Enter = mean(ENTRIESn_hourly), Exit = mean(EXITSn_hourly), Lat = mean(latitude), Lon = mean(longitude))
stacked <- data.frame(melt(data.frame(SumForUnit), id.vars=c("UNIT","Lat", "Lon", "rain")))
names(stacked)[names(stacked) == 'variable'] <- 'use'

png(filename = "Rain.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, colour=use, size=value), alpha = 5/10,
                   data = stacked) + scale_colour_manual(values=c("#0000FF", "#FF4040")) + scale_size_continuous(range = c(3, 7)) + facet_wrap(~ rain)
dev.off()  
