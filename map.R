library(ggmap)
library(ggplot2)
library(dplyr)
library(reshape)
library(RColorBrewer)

setwd("/Users/newaesthetic/Desktop/data/Udacity/data_science_1/first_project")
dfrm <- read.csv(file="turnstile_weather_v2.csv",head=TRUE,sep=",")

dfrm$intraday <- ifelse(dfrm$hour == 16 |dfrm$hour == 20, "afternoon", ifelse(dfrm$hour == 0 |dfrm$hour == 4,"night","morning"))
dfrm$intraday <- factor(dfrm$intraday)
dfrm$rain <- ifelse(dfrm$rain == 0, "Rain", "No Rain")
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

group_units <- group_by(dfrm, UNIT, intraday)
SumForUnit <- summarise(group_units, Enter = mean(ENTRIESn_hourly), Exit = mean(EXITSn_hourly), Lat = mean(latitude), Lon = mean(longitude))
stacked <- data.frame(melt(data.frame(SumForUnit), id.vars=c("UNIT","Lat", "Lon", "intraday")))
names(stacked)[names(stacked) == 'variable'] <- 'use'

stackedmorning <- filter(stacked, intraday == "morning")
png(filename = "MapMorning.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, colour=use, size=value), alpha = 5/10,
                   data = stackedmorning) + scale_colour_manual(values=c("#0000FF", "#FF4040")) + scale_size_continuous(range = c(3, 7))
dev.off()

stackedafternoon <- filter(stacked, intraday == "afternoon")
png(filename = "MapAfternoon.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, colour=use, size=value), alpha = 5/10,
                   data = stackedafternoon) + scale_colour_manual(values=c("#0000FF", "#FF4040")) + scale_size_continuous(range = c(3, 7))
dev.off()

stackednight <- filter(stacked, intraday == "night")
png(filename = "MapEvening.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, colour=use, size=value), alpha = 5/10,
                   data = stackednight) + scale_colour_manual(values=c("#0000FF", "#FF4040")) + scale_size_continuous(range = c(3, 7))
dev.off()                        

png(filename = "Overall.png", width = 1080, height = 720)
NYmap + geom_point(aes(x = Lon, y = Lat, colour=use, size=value), alpha = 5/10,
                   data = stacked) + scale_colour_manual(values=c("#0000FF", "#FF4040")) + scale_size_continuous(range = c(3, 7)) + facet_wrap(~ intraday)
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
