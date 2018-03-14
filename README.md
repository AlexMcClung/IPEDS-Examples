Working with IPEDS Data
=========

To facilitate pulling data on many schools at once, the IPEDS data center uses .uid files which are simply pipe-delimited text files with no header row and 4 columns: IPEDS Unit ID, Institution Name, City, and State.

An alternative way of entering multiple school schools at once is to cut and paste a comma-separated list directory into the search box.

```r
require('tidyverse')

df <- read_csv('data-set.csv')

```

https://nces.ed.gov/ipeds/use-the-data


![shot](ipeds-institutions.PNG)
