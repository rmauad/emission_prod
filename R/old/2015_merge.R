setwd("/Users/dmitriusrodriguezpro/UCSC/FCProject/Dmitrius/FDI_WIOD_merge")
library(tidyverse) #for data manipulation
library(haven) #to load dta/write files
library(readxl) #to load excel files
library(stringr) #to manipulate strings
require(foreign) #export


cross<- read_excel("crowsswalk_FDI_WIOD16-2-3.xlsx")

averages_2015 <- cross %>%
  filter(avg_ind_2015 == "The average of")

avgindicators <- averages_2015$vars_2015

#Loop through indicators 
for(i in 1:length(avgindicators)){ 
  #Get indices of comma positions in indicator
  comma_indices <- unlist(gregexpr(",", avgindicators[i]))
  #Loop through these indices, replace commas with spaces
  for (j in 1:length(comma_indices)){
    substring(avgindicators[i], comma_indices[j], comma_indices[j]) <- " "
  }
}

p = 1 #Growth variables
vars_2015 <- character(10000) #to store indicators 
ECOACT <- character(10000) #to store avg code, this is used later also
avg_codes2015 <- averages_2015$ECOACT #get avg codes
for (i in 1:length(avgindicators)) { #For each string of spaced indicators
  for (k in 1:19) { #for number big enough to capture all indicators
    vars_2015[p] <- word(avgindicators[i], k) #capture individual indicators
    ECOACT[p] <- avg_codes2015[i] #identify indicator with avg code
    p = p + 1 #grow variable to grow index
  }
}

#Create avg translation data set through cbind
avgcodes_translation2015<- as.data.frame(cbind(ECOACT, vars_2015))
#Remove unnecessary strings
avgcodes_translation2015 <- subset(avgcodes_translation2015, vars_2015 != "")

#Create non avg code translation data set- the complement of the previous
nonaverages_2015 <- cross[is.na(cross$avg_ind_2015),]
nonaverages_2015 <- nonaverages_2015 %>%
  select(ECOACT, vars_2015)
nonavgcodes_translation2015 <- na.omit(nonaverages_2015)

FINAL16 <- read_dta("Final16.dta")
FINAL16 <- FINAL16 %>%
  mutate(year = strtoi(year)) #reformat year to integer
FINAL16 <- FINAL16[-c(3,4)] #remove unnecessary variables

FINAL16_avgs <- FINAL16 #for averages
for (i in 1:length(avg_codes2015)) { #for the length of the avg codes
  check <- rep(NA, times = length(FINAL16$co2_code)) #to store indicators
  #take the subset of each avg code, this controls overlapping in indicators
  sub <- subset(avgcodes_translation2015, ECOACT == avg_codes2015[i])
  #for length of indicators of one avg code
  for (j in 1:length(sub$vars_2015)) { 
    for (k in 1:length(check)) { #for length of final16 entries
      #if entry matches indicator
      if (FINAL16$co2_code[k] == sub$vars_2015[j]){ 
        #assign avg code- this helps collapse later on
        check[k] = sub$ECOACT[j]
      }
    }
  }
  #Assign to individual column for each avg code for no overlapping in avgs
  FINAL16_avgs[paste(avg_codes2015[i])] <- check
}

first_half <- subset(FINAL16, year == "babble")
#add empty column that will store the OECD2020 code
first_half$OECD_2015_code <- character(0)

#for each OECD avg code
for (i in 1:length(avg_codes2015)) {
  #create a subset with only one avg code at a time
  sub2 <- FINAL16_avgs[c(1:33, 33+i)] #35 because thats the original number of columns
  #retrieve only those values for which we will take the average of
  sub2 <- sub2[!is.na(sub2[34]), ] #36 because thats the new number of columns
  #assign the avg code to a variable of the same name as previous to rbind
  sub2$OECD_2015_code <- sub2[34]
  #remove the avg code variable to rbind
  sub2 <- sub2[-c(34)]
  #rbind to empty set first then continuously
  first_half <- rbind(first_half, sub2)
}

first_half <- first_half %>%
  group_by(country, country_code, year, OECD_2015_code)%>%
  summarise(across(x1_coal_coke_crude:x3_co2, ~ mean(.x, na.rm = FALSE)))

#repeat similar process, starting with acquiring translation for nonavg codes
nonavgcodes_translation2015 <- cross[is.na(cross$avg_ind_2015), ]
nonavgcodes_translation2015 <- nonavgcodes_translation2015 %>%
  select(ECOACT, vars_2015)
nonavgcodes_translation2015 <- na.omit(nonavgcodes_translation2015)

nonavg_codes2015 <- nonavgcodes_translation2015$ECOACT

FINAL16_nonavgs <- FINAL16 #for averages
for (i in 1:length(nonavg_codes2015)) { #for the length of the avg codes
  check <- rep(NA, times = length(FINAL16$co2_code)) #to store indicators
  #take the subset of each avg code, this controls overlapping in indicators
  sub <- subset(nonavgcodes_translation2015, ECOACT == nonavg_codes2015[i])
  #for length of indicators of one avg code
  for (j in 1:length(sub$vars_2015)) { 
    for (k in 1:length(check)) { #for length of final16 entries
      #if entry matches indicator
      if (FINAL16$co2_code[k] == sub$vars_2015[j]){ 
        #assign avg code- this helps collapse later on
        check[k] = sub$ECOACT[j]
      }
    }
  }
  #Assign to individual column for each avg code for no overlapping in avgs
  FINAL16_nonavgs[paste(nonavg_codes2015[i])] <- check
}

second_half <- subset(FINAL16, year == "babble")
second_half$OECD_2015_code <- character(0)

#for each OECD avg code
for (i in 1:length(nonavg_codes2015)) {
  #create a subset with only one avg code at a time
  sub3 <- FINAL16_nonavgs[c(1:33, 33+i)] #35 because thats the original number of columns
  #retrieve only those values for which we will take the average of
  sub3 <- sub3[!is.na(sub3[34]), ] #36 because thats the new number of columns
  #assign the avg code to a variable of the same name as previous to rbind
  sub3$OECD_2015_code <- sub3[34]
  #remove the avg code variable to rbind
  sub3 <- sub3[-c(34)]
  #rbind to empty set first then continuously
  second_half <- rbind(second_half, sub3)
}

#The desired column is structured as a tibble - convert to vector for both halves
nontibble1 <- pull(first_half$OECD_2015_code)
first_half$nontibble <- nontibble1 #assign to half
first_half <- first_half[-c(4)] #remove tibble

#same down here
nontibble2 <- pull(second_half$OECD_2015_code)
second_half$nontibble <- nontibble2
#remove unecessary columns to rbind
second_half <- second_half[-c(3,34)]

#FINALLY rbind - this is the desired data set
OECD2015 <- rbind(first_half, second_half)
#rename, and finish for OECD2020
OECD2020 <- OECD2015 %>%
  rename(OECD2015_CODE = nontibble)
names(OECD2015)[names(OECD2015) == 'nontibble']<- 'industry'

write.dta(OECD2015, "OECD2015.dta")