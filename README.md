Working with IPEDS Data
=========

To facilitate pulling data on many schools at once, the [IPEDS data center](https://nces.ed.gov/ipeds/use-the-data
) uses .uid files which are simply pipe-delimited text files with no header row and 4 columns: IPEDS Unit ID, Institution Name, City, and State.

An alternative way of entering multiple school schools at once is to cut and paste a comma-separated list directly into the search box.

![shot](ipeds-institutions.PNG)

```r
require('tidyverse')

df <- read_csv('data-set.csv')

```



