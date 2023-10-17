library(dplyr)
library(data.table)
library(ggplot2)

load("data/rdata/hassler_et_al.Rdata") #saved from rep_hassler_et_al.R

data_directory <- "/Users/robertomauad/Dropbox/Emission_productivity/data/rdata/WIOTS_in_R"

# Get a list of all Rdata files in the directory
wiot_list <- list.files(data_directory, all.files = TRUE, full.names = TRUE)[3:17]

# Create an empty list to store the loaded objects
loaded_wiot <- list()

# Use a loop to load each Rdata file and assign it to a different name
for (i in 1:length(wiot_list)) {
  file_name <- wiot_list[i]
  wiot_name <- paste0("wiot_", i)  # Generate a unique name
  load(file_name)
  loaded_wiot[[wiot_name]] <- get(load(file_name))
}

e_share <- list()
  
for (i in 1:length(loaded_wiot)) {
  wiot_cur <- loaded_wiot[[i]]

  wiot_sel <- wiot_cur %>%
  filter(Country == 'USA') %>%
  select(!contains("57") & !contains("58") & !contains("59") & 
           !contains("60") & !contains("61") & !contains("62") &
         !contains("TOT"))

# FILTERING ONLY COLUMNS 10 AND 24 - THE ONES WITH FOSSIL FUELS ####

wiot_df <- as.data.frame(wiot_sel)
wiot_fossil <- wiot_df %>%
  select(contains("10") | contains("24")) %>%
  summarise_all(sum)

energy_use_usa <- sum(wiot_fossil)

# Calculate the value added in the US ####

value_added_usa <- wiot_sel %>%
  select(-c(1:5)) %>%
  summarise_all(sum)
  
value_added_usa <- sum(value_added_usa)

e_share_year <- paste0("e_share_", i)  # Generate a unique name
e_share[[e_share_year]] <- energy_use_usa/value_added_usa
}

e_share_usa <- data.table::transpose(as.data.frame(e_share)) %>%
  rename(wiod = V1) %>%
  mutate(year = 2000:2014)
  
# Plotting share of energy use in the US based on the WIOD ####

hassler_et_al <- hassler_et_al %>%
  select(year, ep_y) %>%
  rename(hassler_et_al = ep_y)
  
plot_e_share <- inner_join(hassler_et_al, e_share_usa, by = "year")

ggplot(plot_e_share, aes(x = year)) + 
  geom_line(aes(y = hassler_et_al, color = 'Hassler et al')) +
  geom_line(aes(y = wiod, color = 'WIOD')) +
  scale_x_continuous(name = "Year") +
  scale_y_continuous(name = "E_share") +
  labs(color = "Line") +
  scale_color_manual(values = c('blue', 'red'),
                     labels = c('Hassler et al', 'WIOD'))
# 
# 
# ggplot(e_share_usa, aes(x=year)) +
#   geom_line(aes(y=e_share), col="blue") +
#   scale_y_continuous(name="E_share") +
#   ggtitle("Energy use share from WIOD - US")
# 
# ggplot(hassler_et_al, aes(x=year)) +
#   geom_line(aes(y=ep_y), col="blue") +
#   scale_y_continuous(name="E_share") +
#   ggtitle("Energy use share from Hassler et al. - US")
