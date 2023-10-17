#Import emissions productivity from industry.csv
library(tidyverse)

emissions <- read.csv("data/csv/industry.csv")

emissions_agg <- emissions %>%
  mutate(em = (1/va_em)*VA) %>%
  subset(select = -c(va_em)) %>%
  filter(!(industry == "B06_09")) %>%
  mutate(ind = ifelse(industry == "C20" | industry == "C21", "20-21",
                      ifelse(industry == "C29" | industry == "C30", "29-30",
                       ifelse(industry == "D35" | industry == "E36" | industry == "E37T39", "D-E",
                       ifelse(industry == "H49" | industry == "H50" | industry == "H51" | industry == "H52", "49-52",
                       ifelse(industry == "J59_60" | industry == "J58_62_63", "58-60_62-63",
                       ifelse(industry == "K64" | industry == "K65" | industry == "K66" | industry == "ATUXFPRV", "K",
                       ifelse(industry == "L" | industry == "PRV_RE", "L",
                       ifelse(industry == "M69" | industry == "M70" | industry == "M71" | industry == "M72" | industry == "M73" | industry == "M74_75" | industry == "N", "M-N",
                       ifelse(industry == "P85", "P",
                       ifelse(industry == "C10T12", "10-12",
                       ifelse(industry == "C13_14", "13-15",
                       ifelse(industry == "C16T18", "16-18",
                       ifelse(industry == "C19", "19",
                       ifelse(industry == "C22", "22-23",
                       ifelse(industry == "C24_25", "24-25",
                       ifelse(industry == "C26", "26-27",
                       ifelse(industry == "C28", "28",
                       ifelse(industry == "G45", "45",
                       ifelse(industry == "G46", "46",
                       ifelse(industry == "G47", "47",
                       ifelse(industry == "H53", "53", 
                       ifelse(industry == "J61", "61",
                       ifelse(industry == "J61", "61",
                              industry)))))))))))))))))))))))) %>%
  group_by(COU, year, ind, EME) %>%
  summarize_at(c("VA","em"),sum) %>%
  mutate(va_em = VA/em) %>%
  filter(!is.na(va_em) & va_em > 0) %>%
  ungroup() %>%
  group_by(COU, ind) %>%
  mutate(epg = log(va_em) - lag(log(va_em))) %>%
  filter(!is.na(epg))


  
save(emissions_agg, file = "emissions_agg.RData")
            


#Commands that didn't work but are worth saving ####

#aggregate(case_when(aux == "C" ~ sum(VA, na.rm = TRUE), is.na(aux) ~ VA)) #%>%
#aggregate(VA ~ country + year, FUN = sum)
#sum(which(industry == "B" | industry == "B06_09"), VA & em)
#  mutate(ind = case_when(aux == "C" ~ "20-21", is.na(aux) ~ industry))

#mutate(sumVA = case_when(aux == "C" ~ sum(VA, na.rm = TRUE), is.na(aux) ~ VA)) #%>%


#ungroup() %>%
# group_by(aux == "C") %>%
# filter(!duplicated(emissions_test$sumVA))
# 
# filter(case_when(!is.na(sumVA) & sumVA != 0 ~ !duplicated(!emissions_test$sumVA)))
# #filter(!duplicated(!is.na(emissions_test$sumVA)))
# 
# em_dropped <- emissions_test[!duplicated(!is.na(emissions_test$sumVA))]

# To summarize using different operations:

# group_by(Species) %>% 
#   summarize(
#     # I want the sum over the first two columns, 
#     across(c(1,2), sum),
#     #  the mean over the third 
#     across(3, mean),
#     # the first value for all remaining columns (after a group_by(Species))
#     across(-c(1:3), first)
#   )

