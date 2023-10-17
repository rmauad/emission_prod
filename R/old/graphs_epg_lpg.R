# Plotting emission productivity growth vs. labor productivity growth
library(ggplot2)
library(tidyverse)

load('data/rdata/df.RData')

# Across industries ####

df_ae <- df %>% filter(EME == 0) %>%
  group_by(ind) %>%
  mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
  mutate(med_epg = median(epg, na.rm = TRUE))

df_eme <- df %>% filter(EME == 1) %>%
  group_by(ind) %>%
  mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
  mutate(med_epg = median(epg, na.rm = TRUE))

ggplot(df_ae, aes(ind, y = median, color = variable)) + 
  geom_point(aes(y = med_lpg, col = "med_lpg")) + 
  geom_point(aes(y = med_epg, col = "med_epg")) +
  ggtitle("Advanced Economies") +
  scale_x_discrete(guide = guide_axis(angle = 90))

ggplot(df_eme, aes(ind, y = median, color = variable)) + 
  geom_point(aes(y = med_lpg, col = "med_lpg")) + 
  geom_point(aes(y = med_epg, col = "med_epg")) +
  ggtitle("Emerging Markets") +
  scale_x_discrete(guide = guide_axis(angle = 90))
  
# Trends over time ####

df_ae <- df %>% filter(EME == 0 & ind == "10-12") %>%
  group_by(year) %>%
  mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
  mutate(med_epg = median(epg, na.rm = TRUE))

df_eme <- df %>% filter(EME == 1 & ind == "10-12") %>%
  group_by(year) %>%
  mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
  mutate(med_epg = median(epg, na.rm = TRUE))

ggplot(df_ae, aes(year, y = value, color = variable)) + 
  geom_point(aes(y = med_lpg, col = "med_lpg")) + 
  geom_point(aes(y = med_epg, col = "med_epg"))

ggplot(df_eme, aes(year, y = value, color = variable)) + 
  geom_point(aes(y = med_lpg, col = "med_lpg")) + 
  geom_point(aes(y = med_epg, col = "med_epg"))

# Trends over time for groups of industries with high and low epg ####

df_ae <- df %>% filter(EME == 0) %>%
  group_by(year) %>%
  mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
  mutate(med_epg = median(epg, na.rm = TRUE)) %>%
  mutate(hepg = ifelse(epg >= med_epg, 1,0)) %>%
  group_by(year, hepg) %>%
  mutate(med_epg1 = median(epg, na.rm = TRUE)) %>%
  mutate(med_lpg1 = median(lpg, na.rm = TRUE)) %>%
  filter(hepg == 0)
  
  
df_eme <- df %>% filter(EME == 1) %>%
  group_by(year) %>%
  mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
  mutate(med_epg = median(epg, na.rm = TRUE)) %>%
  mutate(hepg = ifelse(epg >= med_epg, 1,0)) %>%
  group_by(year, hepg) %>%
  mutate(med_epg1 = median(epg, na.rm = TRUE)) %>%
  mutate(med_lpg1 = median(lpg, na.rm = TRUE)) %>%
  filter(hepg == 0)

ggplot(df_ae, aes(year, y = median, color = variable)) + 
  geom_point(aes(y = med_lpg1, col = "med_lpg1")) + 
  geom_point(aes(y = med_epg1, col = "med_epg1")) +
  ggtitle("Advanced Economies - low emissions productivity") +
  scale_x_discrete(guide = guide_axis(angle = 90))

ggplot(df_eme, aes(year, y = median, color = variable)) + 
  geom_point(aes(y = med_lpg1, col = "med_lpg1")) + 
  geom_point(aes(y = med_epg1, col = "med_epg1")) +
  ggtitle("Emerging Markets - low emissions productivity") +
  scale_x_discrete(guide = guide_axis(angle = 90))


# df_ae <- df %>% filter(EME == 0) %>%
#   group_by(year) %>%
#   mutate(med_lpg = median(lpg, na.rm = TRUE)) %>%
#   mutate(med_epg = median(epg, na.rm = TRUE)) %>%
#   #group_by(COU) %>%
#   mutate(hlpg = ifelse(lpg >= med_lpg, 1,0)) %>%
#   mutate(hepg = ifelse(epg >= med_epg, 1,0)) %>%
#   group_by(hlpg) %>%
#   mutate(med_lpg1 = median(lpg, na.rm = TRUE)) %>%
#   ungroup() %>%
#   group_by(year, hepg) %>%
#   mutate(med_epg1 = median(epg, na.rm = TRUE)) %>%
#   filter