#load libraries
library(spData)
library(sf)
library(tidyverse)

#transform the data
world_transformed <- st_transform(world, "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
states_transformed <- st_transform(us_states, "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

#filter the data frames for Canada and NY 
Canada <- world_transformed %>% 
  filter(name_long == "Canada")%>%
  st_buffer(10000)

NY <- states_transformed %>% 
  filter(NAME == "New York") 
#create a 'border' object
Canada_NY<- st_intersection(Canada,NY)

#create map
ggplot()+
  geom_sf(data = NY)+
  geom_sf(data = Canada_NY, aes(fill="red"), show.legend = FALSE) +
  ggtitle("New York Land within 10km")



