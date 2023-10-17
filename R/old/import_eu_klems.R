#Import EU KLEMS
#install.packages("matlab")
library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(matlab)
#eu_klems <- read_excel("AT_output_17ii.xlsx", sheet = "LP1_Q")

eu_klems <- list() # creates a list
listxlsx <- dir(pattern = "*.xlsx") # creates the list of all the csv files in the directory
for (k in 1:length(listxlsx)){
  eu_klems[[k]] <- read_excel(listxlsx[k], sheet = "LP1_Q")
}

#Cleaning the databases
names <- c("AUT",	"BEL",	"CZE",	"DNK",	"EST",	"FIN",	"FRA",	"DEU",	
           "GRC",	"HUN",	"IRL",	"ITA",	"LVA",	"LTU",	"LUX",	"NLD",	
           "POL",	"PRT",	"SVK",	"SVN",	"ESP",	"SWE",	"GBR",	"USA")
#eu_klems_comp <- matrix(,ncol = 4)
eu_klems_comp <- list()

for(i in 1:length(names)){ 

lp <- melt(eu_klems[[i]], id = c("desc", "code"))
lp_cur <- lp %>% dplyr::select("code", "variable", "value") %>%
  filter(code != "TOT", code != "MARKT", code != "C", code != "G", code != "H", code != "J", code != "O-U", code != "R-S", !is.na(value))

COU <- repmat(names[[i]],length(lp_cur[[1]]),1)
lp_cur <- cbind(lp_cur,COU)
# col_names = list('ind','year','lpg','COU')
# colnames(lp_cur) <- c(col_names)
year <- lp_cur[["variable"]]
year <- str_sub(year,-4,-1)
lp_cur <- lp_cur %>% select(-c(variable)) 
lp_cur <- cbind(lp_cur,year)
#lp_matrix <- matrix(unlist(lp_cur), ncol = length(lp_cur))
#colnames(lp_matrix) <- col_names
eu_klems_comp <- rbind(eu_klems_comp, lp_cur)
}

col_names = list('ind','lpg','COU','year')
colnames(eu_klems_comp) <- col_names
#eu_klems_full <- tail(eu_klems_comp,-1)

save(eu_klems_comp, file = 'eu_klems.Rdata')
#eu_klems[[1]]