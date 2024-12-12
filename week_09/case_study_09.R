library(sf)
library(tidyverse)
library(ggmap)
library(spData)
library(dplyr)
library(ggplot2)
data(world)
data(us_states)

#Download a csv 
dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r01/access/csv/ibtracs.NA.list.v04r01.csv"
storm_data <- read_csv(dataurl)

#Wrangle the data 
storm_data2 <- storm_data %>%
mutate(year = year(ISO_TIME)) %>%
filter(year >= 1950) %>%
mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x)) %>%
mutate(decade=(floor(year/10)*10)) %>%
st_as_sf(coords=c("LON","LAT"),crs=4326) 

region <- storm_data2 %>%
  st_bbox()

#Make the first plot
ggplot(world) +
  geom_sf() + 
  facet_wrap(~decade) +
  stat_bin2d(data=storm_data2, aes(y=st_coordinates(storm_data2)[,2], x=st_coordinates(storm_data2)[,1]),bins=100) +
  scale_fill_distiller(palette="YlOrRd", trans="log", direction=-1, breaks = c(1,10,100,1000)) +
  coord_sf(ylim=region[c(2,4)], xlim=region[c(1,3)])+
  xlab(NULL)+
  ylab(NULL)
  

#Five states with the most storms
states <- st_transform(us_states, st_crs(storm_data2)) %>%
  select(state=NAME)
storm_states <- st_join(storm_data2, states, join = st_intersects, left = FALSE) %>%
  group_by(state) %>% 
  summarize(storms=length(unique(NAME))) %>% 
  arrange(desc(storms)) %>%
  slice(1:5)

print(storm_states)
