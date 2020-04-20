library(tidyverse)
library(leaflet) 
library(magrittr)
library(stringr)

# download.file("https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv?accessType=DOWNLOAD",destfile="data.csv",method="libcurl")

# Base R
# starbucks1 <- read.csv("data.csv")

# readr
starbucks <- read_csv("starbucks.csv")

# is this needed? as_tibble(starbucks)

# rename(starbucks, `StoreNumber` =  `Store Number` )

#Make State a factor for later on
#starbucks$State.f <- factor(starbucks$State)
#is.factor(starbucks$State.f)

class(starbucks)

#View(starbucks2)

starbucks

# Base R
# starbucks <- starbucks1[ which(starbucks1$State=='VA' & starbucks1$Country== 'US'), ]

# Dplyr
# Without pipes
# starbucks_MO <- filter(starbucks, Country== 'US', State=='VA')

starbucks_OH <- starbucks %>%
  filter(Country== 'US', State=='OH')%>% 
  select(Brand, `Store Number`, `Ownership Type`, City,	State,	Zip, Country, Coordinates,	Latitude,	Longitude, Name)


leaflet() %>% addTiles() %>% setView(-84.312759, 39.345051, zoom = 12) %>% 
  
  addMarkers(data = starbucks_OH, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks_OH$Name) %>%
  addPopups(-84.312759, 39.345051, 'the <b> spot</b>')
