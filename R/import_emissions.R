# Import emissions from WIOD
library(tidyverse)
library(dplyr)
library(lubridate)
library(readxl)
library(reshape2)

countries <- c("AUT",	"BEL",	"CZE",	"DEU",	"DNK",	
               "ESP",	"EST",	"FIN",	"FRA",	"GBR",	
               "GRC",	"HUN",	"IRL",	"ITA",	"LUX",	
               "POL",	"PRT",	"SWE",	"USA") #NLD is not in WIOD emissions

emissions <- list() # creates a list

for (k in 1:length(countries)){
  emissions[[k]] <- read_excel("data/excel/CO2_emissions_WIOD.xlsx", sheet = countries[[k]])
  emissions[[k]] <- emissions[[k]] %>% 
    rename(ind = ...1) %>%
    mutate(COU = countries[[k]])
  }


emissions_all <- melt(emissions[[1]], id.vars = c("ind","COU"))

for (k in 2:length(countries)){
emissions_all <- rbind(emissions_all, melt(emissions[[k]], id.vars = c("ind", "COU")))
}

emissions_all <- emissions_all %>%
  rename(year = variable,
         emissions = value)

save(emissions_all, file = "data/rdata/emissions_all.Rdata")