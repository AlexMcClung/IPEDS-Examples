Stacking IPEDS Degree Completions Files
=========
IPEDS allows you to download national data sets for some of its surveys [here](https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx).

This is particularly handy for looking at field of degree completion trends when examining program development ideas. To do so requires stacking multiple years of completions data and combining it with information on CIPs and the institutions themselves.

### Files needed:
* IPEDS Degree Completions
* IPEDS Institutional Characteristics
* CIP lookup file - for CIP titles and descriptions
* Carnegie CIP Coding (optional) - for comparing mix of lib arts / pre professional

### Process
Save all completions files in one folder
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
