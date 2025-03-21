# Import capital from EUK and add it to the WIOD-EUK database.

library(tidyverse)
library(dplyr)
library(readxl)
library(reshape2)
library(matlab)


load("data/rdata/wiod_euk.rdata") #generated from merge_euk_wiod.R

eu_klems_cap <-list() # creates a list

directory_path <- "data/excel_euklems"
all_files <- list.files(directory_path)

for (k in 1:length(all_files)){
  eu_klems_cap[[k]] <- read_excel(paste("data/excel_euklems/", all_files[k], sep = ""), sheet = "II")
}

########################
# Cleaning the database
########################

names <- c("AUT",	"BEL",	"CZE",	"DEU",	"DNK",	"ESP",	"EST",	
           "FIN",	"FRA",	"GBR",	"GRC",	"HUN",	"IRL",	"ITA",	
           "LTU",	"LUX",	"LVA",	"NLD",	"POL",	"PRT",	"SVK",	
           "SVN",	"SWE",	"USA")
eu_klems_cap_comp <- list()

for(i in 1:length(names)){ 
  
  cap <- melt(eu_klems_cap[[i]], id = c("desc", "code"))
  cap_cur <- cap %>% dplyr::select("code", "variable", "value") %>%
    filter(code != "TOT", code != "MARKT", code != "C", code != "G", code != "H", code != "J", code != "O-U", code != "R-S", !is.na(value))
  
  COU <- matlab::repmat(names[[i]],length(cap_cur[[1]]),1)
  cap_cur <- cbind(cap_cur,COU)
  # col_names = list('ind','year','lpg','COU')
  # colnames(lp_cur) <- c(col_names)
  year <- cap_cur[["variable"]]
  year <- str_sub(year,-4,-1)
  cap_cur <- cap_cur %>% select(-c(variable)) 
  cap_cur <- cbind(cap_cur,year)
  #lp_matrix <- matrix(unlist(lp_cur), ncol = length(lp_cur))
  #colnames(lp_matrix) <- col_names
  eu_klems_cap_comp <- rbind(eu_klems_cap_comp, cap_cur)
}

eu_klems_cap_comp <- eu_klems_cap_comp %>%
  rename(cap = value, ind = code) %>%
  mutate(ind = ifelse(ind == "R" | ind == "S", "R-S",ind)) %>%
  group_by(COU, year, ind) %>%
  summarise(cap = sum(cap)) %>%
  ungroup() %>%
  mutate(cou_ind_year = paste(COU, "_", ind, "_", year)) #%>%
 # select(-c(COU, ind, year))
  
save(eu_klems_cap_comp, file = "data/rdata/eu_klems_cap.rdata")


#####################################
# Merging with the complete database
#####################################
source("code/emission_prod/R/calculate_capital_stock.R")

wiod_euk_cap <- inner_join(wiod_euk, eu_klems_cap_comp, by = "cou_ind_year")

wiod_euk_cap <- wiod_euk_cap %>%
  mutate(cap_usd = cap*er) %>%
  group_by(COU, ind) %>%
  mutate(cap_stock_usd = calculate_capital_stock(cap_usd, depreciation_rate = 0.055, growth_rate = 0.02)) %>%
  ungroup()


save(wiod_euk_cap, file = "data/rdata/wiod_euk_cap.rdata")






