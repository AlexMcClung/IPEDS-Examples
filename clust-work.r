suppressMessages(require('tidyverse'))

# items downloaded from IPEDS data center - population = carnegie bacca a&s
d1 <- read_csv('G:/Benchmarking/Comparison Tool/ipeds-raw1.csv')
d2 <- read_csv('G:/Benchmarking/Comparison Tool/ipeds-raw-dr.csv')

d <- d2 %>% select(-X6, -`Institution Name`) %>% 
  inner_join(d1, by = 'UnitID')

rm(d1, d2)

# clean names
nm <- c('UnitID', 'InstAid', 'ftft', 'tufe', 'name', 'revenue',
        'endow', 'expenses', 'pell', 'completers', 'grsCohort',
        'applications', 'admits', 'enrolled', 'fteUG', 'fteGrad', 
        'engn', 'cohort', 'retention', 'stufac')

names(d) <- nm

## 
## create vars
## 

df <- d %>% filter(!(is.na(applications)|is.na(grsCohort)|is.na(endow))) %>% 
  mutate(disc = InstAid / (ftft * tufe), # est. discount rate
         fteGrad = ifelse(is.na(fteGrad), 0, fteGrad), endowFTE = endow / (fteUG + fteGrad), # endowment per FTE
         gradRate = completers / grsCohort, # 6 yr grad rate
         admitRate = admits / applications, # admit rate
         yield = enrolled / admits, # yield rate
         eng = ifelse(!is.na(engn),1,0)) %>% # has engineering 
  select(UnitID, name, tufe, expenses, pell, cohort, retention, stufac, disc, 
         endowFTE, gradRate, admitRate, yield, eng)


# fix st john, wheaton , westminster
df$name[df$UnitID == 149781] <- 'Wheaton College IL'
df$name[df$UnitID == 245652] <- "St. John's College NM"
df$name[df$UnitID == 179946] <- 'Westminster College MO'


# scale all vars
df2 <- df %>% select(-UnitID, -name) %>% 
  map_df(scale)


# get rownames for hclust use
nms <- df %>% 
  pull(name)

df2 <- as.data.frame(df2)
row.names(df2) <- nms


# PCA - nothing too interesting


# hierarchical clustering
h <- hclust(dist(df2))

plot(h, cex = .7) # dendrogram

rect.hclust(h, h = 3, border = "red")

# find out who is in same cluster
grp <- cutree(h, h = 3)

grp[grp==22] # print school names

(n <- names(grp[grp==22]))

# get group averages on all vars
df %>% filter(name %in% n) %>% 
  summarize_all(funs(mean))