library(tidyverse)
library(nycflights13)
library(dplyr)

#Rename faa column in airports table to match dest column in flights table
colnames(airports)[1] = "dest"

#Join airports and flights table by dest 
Flights_airports<- flights %>%
  left_join(airports, by = "dest")

#Arrange by distance to find furthest airport
farthest_airport<- Flights_airports %>%
  filter(distance == max(distance)) %>%
  select(name) %>% 
  distinct() %>%
  as.character()

head(farthest_airport)
