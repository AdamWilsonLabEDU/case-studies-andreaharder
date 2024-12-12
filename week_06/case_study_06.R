library(terra)
library(spData)
library(tidyverse)
library(sf)
library(dplyr)
library(ncdf4)
library(knitr)

download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc", method="curl")

#Prepare Climate Data
tmean=rast("crudata.nc")

#Calculate the max temp observed in each country
MaxObserved <- max(tmean)
plot(MaxObserved)
extract <- terra::extract(MaxObserved, world, fun=max, na.rm=1, small=1)
world_clim <- bind_cols(world, extract)

#Map the results
ggplot(world_clim)+
  geom_sf(aes(fill = max))+
  scale_fill_viridis_c(name="Maximum\nTemperature (C)")+
  theme(legend.position = 'bottom')

#Create a summary table
world_clim_group <- world_clim %>% 
  group_by(continent)
Top <- top_n(world_clim_group, 1, max)

hottest_continents <- as_tibble(Top) %>%
  select(2,3,13) %>% 
  arrange(desc(max))

kable(hottest_continents, file = "html", col.name = c("Name", "Continent", "Max Temp"))
