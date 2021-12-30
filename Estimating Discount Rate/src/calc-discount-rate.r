
library(tidyverse)

df <- read_csv('../data/ipeds-ivyplus-inst-grant-tufe_12-30-2021.csv') %>% 
  # IPEDS download always has an extra column
  select(-last_col()) %>% 
  janitor::clean_names()


df %>% 
  pivot_longer(-c(unit_id, institution_name),
               names_to = 'items', 
               values_to = 'values')

