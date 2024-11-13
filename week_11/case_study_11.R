library(tidyverse)
library(spData)
library(sf)
library(mapview) 
library(foreach)
library(doParallel)
library(tidycensus)
registerDoParallel(4)
getDoParWorkers() 

#Get census API key
census_api_key("")

#Download block-level data by race 
race_vars <- c(
  "Total Population" = "P1_001N",
  "White alone" = "P1_003N",
  "Black or African American alone" = "P1_004N",
  "American Indian and Alaska Native alone" = "P1_005N",
  "Asian alone" = "P1_006N",
  "Native Hawaiian and Other Pacific Islander alone" = "P1_007N",
  "Some Other Race alone" = "P1_008N",
  "Two or More Races" = "P1_009N")
  options(tigris_use_cache = TRUE) #store the shapefiles

#Get 2020 block-level data by race in Erie County 
erie <- get_decennial(geography = "block", variables = race_vars, year=2020,
                      state = "NY", county = "Erie County", geometry = TRUE,
                      sumfile = "pl", cache_table=T) %>% #summary file that contains race data; cache for quick access
                      st_crop(c(xmin=-78.9,xmax=-78.85,ymin=42.888,ymax=42.92)) #crop the data 

#Organize categorical data by race
ErieRace <- as.factor(erie$variable)  

#For each category filter to include one race at a time
Foreach <- foreach(race = levels(ErieRace), .combine = rbind) %do% {
    filtered <- erie %>%
    filter(variable == race)
#Generate random points for each resident         
  points <- filtered %>%
    st_sample(size=.$value) %>% 
    st_as_sf() %>%
    mutate(variable = race)} #mutate to add a column set to race

mapview(Foreach, zcol = "variable", cex = 2)
