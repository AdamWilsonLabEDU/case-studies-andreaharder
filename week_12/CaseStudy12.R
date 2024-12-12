library(tidyverse)
library(htmlwidgets)
library(widgetframe)
library(xts)
library(dygraphs)
library(openmeteo)

#Download weather data for Buffalo, NY
d<- weather_history(c(43.00923265935055, -78.78494250958327),start = "2023-01-01",end=today(),
                    daily=list("temperature_2m_max","temperature_2m_min","precipitation_sum")) %>%
  mutate(daily_temperature_2m_mean=(daily_temperature_2m_max+daily_temperature_2m_min)/2)

#Order the variables
xts <- select(d, daily_temperature_2m_min,daily_temperature_2m_mean, daily_temperature_2m_max)%>%
  xts(order.by=d$date)

Precip <- select(d, daily_precipitation_sum)%>%
  xts(order.by=d$date)

#Make the graphs
dygraph(xts, main = "Daily Maximum Temperature in Buffalo, NY") %>%
  dySeries("daily_temperature_2m_mean")%>%
dyRangeSelector(dateWindow = c("2023-01-01", "2024-10-31"))

dygraph(Precip, main = "Daily Precipitation in Buffalo, NY")%>%
dyRangeSelector(dateWindow = c("2023-01-01", "2024-10-31"))

