
library(tidyverse)


## Import data from IPEDS Data Center
df <- read_csv('../data/ipeds-ivyplus-inst-grant-tufe_12-30-2021.csv') %>% 
  # delete extra column added in the IPEDS download
  select(-last_col()) %>% 
  janitor::clean_names()


## Calculate discount rate and net tuition revenue
dff <- df %>% 
  mutate(institution_name = ifelse(str_starts(institution_name, 'Colum'),
                                   'Columbia University',
                                   institution_name)) %>% 
  pivot_longer(-c(unit_id, institution_name),
               names_to = 'item', 
               values_to = 'value') %>% 
  mutate(Year = str_extract(item, '(?!20)\\d{2}(_)?\\d{2}'),
         Year = str_remove(Year, '_'),
         Item = case_when(str_detect(item, 'pub') ~ 'Tuition',
                          str_detect(item, 'grant') ~ 'Grant',
                          TRUE ~ 'CohortN')) %>% 
  select(institution_name, Year, Item, value) %>% 
  pivot_wider(names_from = Item, values_from = value) %>% 
  mutate(GrossTuition = CohortN*Tuition,
         DiscountRate = Grant/GrossTuition,
         AvgNetTuitionRev = (GrossTuition-Grant)/CohortN) %>% 
  rename(School = institution_name)


## Add group average
df_avgs <- dff %>% 
  group_by(Year) %>% 
  summarise(DiscountRate = mean(DiscountRate),
            AvgNetTuitionRev = mean(AvgNetTuitionRev)) %>% 
  mutate(School = 'Group Avg')


df_plot <- dff %>% 
  select(School, Year, DiscountRate, AvgNetTuitionRev) %>% 
  bind_rows(df_avgs) %>% 
  arrange(Year)


## Setting school colors => modify reference school using Dartmouth in this example 

my_school <- 'Dartmouth'

colrs <- df_plot %>% 
  count(School) %>% 
  mutate(colr = ifelse(School == 'Group Avg', 'red', 'lightgrey'),
         colr = ifelse(str_starts(School, my_school), 'green', colr)) %>% 
  pull(colr)


## Example Linegraph - better in plotly or highcharts
df_plot %>% 
  ggplot(aes(x = Year, y = DiscountRate, group = School)) + 
  geom_line(aes(col = School)) +
  scale_color_manual(values = colrs) + 
  scale_y_continuous('',
                     labels = scales::percent) + 
  theme_minimal() +
  theme(legend.position = 'none') +
  labs(x = 'Academic Year', 
       title = str_glue('Discount Rates Over Time: {my_school} vs. Peer Group Average (in Red)'),
       caption = 'SOURCE: IPEDS Student Financial Aid Survey')


## Example saved in "outputs" folder



