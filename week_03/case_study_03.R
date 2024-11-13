#Load necessary packages
library(ggplot2)
library(gapminder)
library(dplyr)

#Plot 1
Filtered <- filter(gapminder, country != "Kuwait")
ggplot(Filtered, aes(lifeExp, gdpPercap, color = continent, size = pop/100000)) + 
  geom_point() +
  facet_wrap(~year,nrow=1) +
  scale_y_continuous(trans = "sqrt") +
  theme_bw() + 
  labs(x = "Life Expectancy", y = "GDP per capita", color = "Continent", size = "Population(100k)")
ggsave(filename = "plot1.png", plot = last_plot(), width = 15, height = 5, units = "in")

#Plot2
gapminder_continent <- group_by(Filtered, continent, year) %>%
  summarize(gdpPercapweighted = weighted.mean(x = gdpPercap, y = pop), pop = sum(as.numeric(pop)))

ggplot(Filtered, x = year, y = gdpPercap)+
  geom_line(data = Filtered, aes(x= year, y = gdpPercap, group = country, color = continent))+
  geom_point(data = Filtered, aes(x= year, y = gdpPercap, color = continent))+
  geom_line(data = gapminder_continent, aes(x= year, y = gdpPercapweighted))+
  geom_point(data= gapminder_continent, aes(x= year, y = gdpPercapweighted, size = pop/100000))+
  facet_wrap(~continent,nrow=1)+
  theme_bw()+
  labs(x = "Year", y = "GDP per capita", size = "Population(100k)", color = "Continent" )
ggsave(filename = "plot2.png", plot = last_plot(), width = 15, height = 5, units = "in")


