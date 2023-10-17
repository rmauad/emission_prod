# Mapping from NACE industry classification to ISIC rev 4 (not exactly ISIC rev 4 - the aggregation that we use in emission_agg.Rdata)
library(tidyverse)
library(dplyr)


load("data/rdata/emissions_agg.RData")
load("data/rdata/iea_pol_ind.RData")

