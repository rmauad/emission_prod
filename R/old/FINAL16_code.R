setwd("C:/Users/axvmo/Desktop/FDI Climate Project/Rcode")

library(tidyverse)
library(fs)
library(readxl) 
library(haven)
library(udpipe)
library(foreign)

#Create function to unpack EMREL data sets
tidy1 <- function(a, b, d){
  read_excel(a)
  
  path <- a
  
  #unpacks data sets
  mad <- path %>%
    excel_sheets() %>%
    set_names() %>%
    map_df(read_excel,
           path = path, .id = "sheets")
  #clean up
  true <- mad[-c(2:10)]
  true <- subset(true, sheets != "Codes" & sheets != "Notes" & 
                   sheets != "Sector")
  #rename
  true<-rename(true, year = sheets, #x2 because it comes from EMREL
               ind_code = ...1,
               x2_coal_coke_crude = COAL_COKE_CRUDE,
               x2_diesel = DIESEL,
               x2_electr_heatprod = ELECTR_HEATPROD,
               x2_fuel_oil = FUEL_OIL,
               x2_gasoline = GASOLINE,
               x2_jetfuel = JETFUEL,
               x2_liquid_gaseous_biofuels = LIQUID_GASEOUS_BIOFUELS,
               x2_natgas = NATGAS,
               x2_othgas = OTHGAS, 
               x2_othpetro = OTHPETRO, 
               x2_othsourc = OTHSOURC, 
               x2_renewables_nuclear = RENEWABLES_NUCLEAR,
               x2_waste = WASTE,
               x2_total = TOTAL)
  
  true$country <- rep(c(b), times = length(true$year)) #attach country name
  true$code <- rep(c(d), times = length(true$year)) #attach country code
  #translation from original codes to desired using translation data set
  #I created
  test_codes <- read_excel(
    "C:/Users/axvmo/Desktop/FDI Climate Project/Data/translation.xlsx")
  
  EM_GROSS <- test_codes$`Em/Gross`
  translation <- test_codes$FINAL
  test <- true$ind_code
  
  for (i in 1:length(EM_GROSS)){
    for (j in 1:length(test)){
      if (test[j] == EM_GROSS[i]){
        test[j] = translation[i]
      }
    }
  }
  true$ind_code_translation <- test

  true <<- true
}
#exact same structure as the previous
tidy2 <- function(a, b, d){
  read_excel(a)
  path <- a
  
  mad <- path %>%
    excel_sheets() %>%
    set_names() %>%
    map_df(read_excel,
           path = path, .id = "sheets")
  
  true <- mad[-c(2:10)]
  true <- subset(true, sheets != "Codes" & sheets != "Notes" & 
                   sheets != "Sector")
  
  true<-rename(true, year = sheets, #use x1 instead because GROSS
               ind_code = ...1,
               x1_coal_coke_crude = COAL_COKE_CRUDE,
               x1_diesel = DIESEL,
               x1_electr_heatprod = ELECTR_HEATPROD,
               x1_fuel_oil = FUEL_OIL,
               x1_gasoline = GASOLINE,
               x1_jetfuel = JETFUEL,
               x1_liquid_gaseous_biofuels = LIQUID_GASEOUS_BIOFUELS,
               x1_natgas = NATGAS,
               x1_othgas = OTHGAS, 
               x1_othpetro = OTHPETRO, 
               x1_othsourc = OTHSOURC, 
               x1_renewables_nuclear = RENEWABLES_NUCLEAR,
               x1_waste = WASTE,
               x1_total = TOTAL)
  
  true$country <- rep(c(b), times = length(true$year))
  true$code <- rep(c(d), times = length(true$year))
  
  test_codes <- read_excel(
    "C:/Users/axvmo/Desktop/FDI Climate Project/Data/translation.xlsx")
  
  EM_GROSS <- test_codes$`Em/Gross`
  translation <- test_codes$FINAL
  test <- true$ind_code
  
  for (i in 1:length(EM_GROSS)){
    for (j in 1:length(test)){
      if (test[j] == EM_GROSS[i]){
        test[j] = translation[i]
      }
    }
  }
  true$ind_code_translation <- test
  
  true <<- true
}
#utilize data set with country names and 3 char code to automate
#the process of compiling EMREL and GROSS
names_and_codes <- read_excel(
  "C:/Users/axvmo/Desktop/FDI Climate Project/Data/CountryNamesCodesBasic.xlsx")
names <- names_and_codes$`Country Name (usual)`
codes <- names_and_codes$`3char country code`
#This helps automate, using my own computer's path for where the data sets
#are stored.
pre1 <- "C:/Users/axvmo/Desktop/FDI Climate Project/Data/EmRel10/NAMEA_EREU5610_"
pre2 <- "C:/Users/axvmo/Desktop/FDI Climate Project/Data/Gross10/NAMEA_GEU5610_"
end <- ".xls"
#initial data sets to start automation process
EmRel10 <- tidy1(paste(pre1, codes[14], end, sep = ""),names[14],codes[14])
Gross10 <- tidy2(paste(pre2, codes[14], end, sep = ""),names[14],codes[14])
#automation for EMREL here
for (i in 15:length(names)) try({
  a = paste(pre1, codes[i], end, sep = "")
  b = names[i]
  d = codes[i]
  c = tidy1(a,b,d)
  EmRel10 = rbind(EmRel10,c)
})
#automation for GROSS here
for (i in 15:length(names)) try({
  a = paste(pre2, codes[i], end, sep = "")
  b = names[i]
  d = codes[i]
  c = tidy2(a,b,d)
  Gross10 = rbind(Gross10,c)
})
#remove unnecessary variables
EmRel10 <- subset(EmRel10, select = -c(1,2,17:19))
#c bind because exact same entries/aligns perfectly
FirstFINAL16 <- cbind(Gross10,EmRel10) #this is EMREL/GROSS compiled

#begin CO2
read_excel(
  "C:/Users/axvmo/Desktop/FDI Climate Project/Data/WIOD16 CO2 emissions with WIOD13 codes.xlsx")

path <-"C:/Users/axvmo/Desktop/FDI Climate Project/Data/WIOD16 CO2 emissions with WIOD13 codes.xlsx"
#same thing as before
mad <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map_df(read_excel,
         path = path, .id = "sheets")
true <- mad[-c(2:10)]
true <- subset(true, sheets != "Notes" & sheets != "Sector")
#create initial to start automation
CO2 <- true[c(1,2,3)]
years <- rep(c(2000), times = length(true$`2000`))
CO2$year <- years
CO2 <- rename(CO2, x3 = "2000", code = sheets)
#automation
for (i in 1:16) {
  year_count = 2000 + i
  column_count = 3 + i
  years <- rep(c(year_count), times = length(true$`2000`))
  running_set <- true[c(1,2,column_count)]
  
  running_set$year <- years
  running_set <- rename(running_set, x3 = as.character(year_count),
                        code = sheets)
  CO2 <- rbind(CO2, running_set)
}
#translation data set from before to translate CO2 codes
test_codes <- read_excel("C:/Users/axvmo/Desktop/FDI Climate Project/Data/translation.xlsx")
#translate
CO2_codes <- test_codes$CO2
translation <- test_codes$FINAL
type2 <- test_codes$original_desc
test <- CO2$...1
industry_x_original <- character(length(test))

for (i in 1:length(CO2_codes)){
  for (j in 1:length(test)){
    if (test[j] == CO2_codes[i]){
      test[j] = translation[i]
      #
      industry_x_original[j] <- type2[i] 
    }
  }
}
CO2$ind_code_translation <- test
CO2$industry_x_original <- industry_x_original
translation2 <- test_codes$FINAL2
type2 <- test_codes$desired_desc
industry_x <- character(length(test))

for (i in 1:length(translation2)) {
  for (j in 1:length(test)) {
    if (test[j] == translation2[i]){
      industry_x[j] = type2[i]
    }
  }
}
CO2$industry_x <- industry_x

#begin merge process
useful <- subset(FirstFINAL16, ind_code_translation != "total")
also <- subset(FirstFINAL16, ind_code_translation == "total")
#use ids to merge
CO2$id <- unique_identifier(CO2, 
                            fields = c(
                              "code", "year", "...1",
                              "ind_code_translation"))

for (i in 1:length(useful$year)) {
  if (useful$ind_code[i] == "vCONS_h_new"){
    useful$ind_code[i] = "vFC_HH"
  }
}
#use ids to merge
useful$id <- unique_identifier(useful, 
                               fields = c(
                                 "code", "year", "ind_code",
                                 "ind_code_translation"))
#merge here
FINAL16 <- merge(useful, CO2, by = c("id"), 
                 all.x = TRUE, all.y = TRUE)
#rearrange/rename
FINAL16 <- FINAL16[-c(35, 38, 39)]
FINAL16 <- rename(FINAL16, year = year.x, code = code.x, 
                  ind_code_translation = ind_code_translation.x,
                  )
FINAL16 <- FINAL16[-c(1)]
also$x3 <- rep(NA, times = length(also$year))
also$...1 <- rep("vTOTII_new", times = length(also$year))
also$industry_x_original <- rep(
  "Total industrial activities", times = length(also$year))
also$industry_x <- rep(
  "Grand Total", times = length(also$year))
FINAL16 <- rbind(FINAL16, also)

FINAL16 <- rename(FINAL16, emgross_code = ind_code,
                  country_code = code,
                  ind_code = ind_code_translation,
                  co2_code = ...1,
                  x3_co2 = x3)

FINAL16 <- FINAL16[,c(17,18,37,36,19,2,34,1,3:16,20:33,35)]

#order variables alphabetically
test <- FINAL16[order(FINAL16$country,
                      FINAL16$country_code,
                      FINAL16$ind_code),]
#last edits
FINAL16 <- as.data.frame(test)
for (i in 1:length(FINAL16$year)) {
  if (FINAL16$emgross_code[i] == "vFC_HH"){
    FINAL16$emgross_code[i] = "vCONS_h_new"
  }
  if (FINAL16$emgross_code[i] == "vD"){
    FINAL16$emgross_code[i] = "vD35"
  }
  if (FINAL16$emgross_code[i] == "vO"){
    FINAL16$emgross_code[i] = "vO84"
  }
  if (FINAL16$emgross_code[i] == "vP"){
    FINAL16$emgross_code[i] = "vP85"
  }
}
#export data set
write_dta(FINAL16, "C:/Users/axvmo/Desktop/FDI Climate Project/Data/FINAL16.dta")