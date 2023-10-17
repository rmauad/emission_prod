#Replicate productivity from Hassler et al.(2021)
library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(ggplot2)

prices <- read_excel("data/excel/energy_price.xlsx", sheet = "prices")
energy_use <- read_excel("data/excel/energy_use.xlsx", sheet = "data")
gdp <- read_excel("data/excel/GDPA.xls", sheet = "data")
labor <- read_excel("data/excel/labor.xlsx", sheet = "data")
capital <- read_excel("data/excel/capital.xls", sheet = "data")

# Energy use is in quadrillion BTU but price is $ per million BTU. Convert use to million BTU
qtm <- 1000000000

energy_use <- energy_use %>%
  mutate(coal_use = coal_use*qtm,
         ng_use = ng_use*qtm,
         oil_use = oil_use*qtm,
         total_use = total_use*qtm,
         total_use_hassler = coal_use + 3.82*oil_use + 1.63*ng_use) #equation 1 appendix

btd <- 1000000000
  
# Create the aggregate price according to Hassler et al. (2021) - appendix
agg <- inner_join(prices, energy_use, by = 'year')
agg <- inner_join(agg, gdp, by = 'year')
agg <- agg %>%
  mutate(p = (coal_price*coal_use + ng_price*ng_use + oil_price*oil_use)/total_use_hassler,
         e = total_use_hassler,
         ep = p*e,
         y = gdp_2005_nx*btd, #converting GDP from billion dollars to dollars
         ep_y = ep/y)

hassler_et_al <- agg %>% filter(year >= 2000 & year <= 2014)
  
# Plots ####
scaleFactor <- max(agg$ep_y) / max(agg$p)

ggplot(agg, aes(x=year)) +
  geom_line(aes(y=ep_y), col="blue") +
  geom_line(aes(y=p * scaleFactor), col="red") +
  scale_y_continuous(name="E_share", sec.axis=sec_axis(~./scaleFactor, name="Fossil fuel price")) +
  theme(
    axis.title.y.left=element_text(color="blue"),
    axis.text.y.left=element_text(color="blue"),
    axis.title.y.right=element_text(color="red"),
    axis.text.y.right=element_text(color="red")
  )


# Energy-saving technology ####
agg <- inner_join(agg, labor, by = 'year')
agg <- full_join(agg, capital, by = 'year')

gamma <- 0.5
alpha <- 0.4
epsilon <- 0.02

agg <- agg %>%
  filter(year != 1949) %>%
  mutate(y = y/btd, #converting GDP back to billions of dollars
         ae = (y/e)*(ep_y/gamma)^(epsilon/(epsilon -1)),
         ae = ae/ae[1],
         l_share = comp/y,
         at = (y/(k^alpha*emp^(1-alpha)))*(l_share/((1-alpha)*(1-gamma)))^(epsilon/(epsilon -1)),
         at = at/at[1])

ggplot(agg, aes(x = year)) + 
  geom_line(aes(y = ae, color = 'AE')) +
  geom_line(aes(y = at, color = 'AT')) +
  scale_x_continuous(name = "Year") +
  scale_y_continuous(name = "Productivity") +
  labs(color = "Line") +
  scale_color_manual(values = c('blue', 'red'),
                     labels = c('AE', 'AT'))

save(hassler_et_al, file = "data/rdata/hassler_et_al.Rdata")
