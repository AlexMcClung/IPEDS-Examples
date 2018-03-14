Working with IPEDS Degree Completions Files
=========
IPEDS allows you to download national data sets for some of its surveys [here](https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx).

This is particularly handy for looking at field of degree completion trends when examining program development ideas. To do so requires stacking multiple years of completions data and combining it with information on CIPs and the institutions themselves.

### Files Needed
* IPEDS Degree Completions
* IPEDS Institutional Characteristics
* [CIP lookup file](https://nces.ed.gov/ipeds/cipcode/resources.aspx?y=55) - CIPCode2010 file for CIP titles and descriptions
* Carnegie CIP Coding (optional) - for comparing mix of lib arts / pre professional

### Process
Save all completions csv files into one dedicated folder. The code below assumes they are all named 'c_YYYY' as they are when you download and unzip them from IPEDS. This code subsets files based on Bachelors degrees and throws out the summation rows. These steps can obviously be modified depending on the purpose of the analysis. The end product is a set of 'cYYYY' data sets in your R workspace.
```r
require('tidyverse')

lst <- list.files()

# function to load & subset files
comp <- function(fn){
  yr <- substr(fn, 1, 5)
  
  x <- read_csv(fn) %>% 
    filter(AWLEVEL == '05' & CIPCODE != '99') # change parameters as needed
    # add %>% select() %>% mutate() etc as needed
  
  assign(yr, x, envir = .GlobalEnv)
}

map(lst, comp)

```
Once you have the data sets in your workspace, you can aggregate by institution, by CIP, etc. and combine years. This snippet aggregates by school and CIP and then combines all years together.
```r
# run for each year
AY12 <- c2012 %>% 
  group_by(UNITID, CIPCODE) %>% 
  summarize(AY12 = sum(CTOTALT))

# combine all years into one data frame
df <- reduce(list(AY12, AY13, AY14, AY15, AY16), full_join, by = c('UNITID', 'CIPCODE'))

```


