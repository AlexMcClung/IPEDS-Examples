Selecting Multiple Institutions in the IPEDS Data Center
=========

To facilitate pulling data on many schools at once, the [IPEDS data center](https://nces.ed.gov/ipeds/use-the-data
) uses a .uid file format which is simply a pipe-delimited text file with no header row and 4 columns: IPEDS Unit ID, Institution Name, City, and State:

    168546|Albion College|Albion|MI           
    210669|Allegheny College|Meadville|PA           
    143084|Augustana College|Rock Island|IL         
    174747|College of Saint Benedict|Saint Joseph|MN

An alternative way of entering multiple school schools at once is to cut and paste a comma-separated list directly into the search box.

![shot1](img/ipeds-institutions.PNG)

In R, with a data set of UnitIDs, you can `dput()` them to the console and paste them right in:
```r
require('tidyverse')

df <- read_csv('annapolis-group.csv')

dput(as.numeric(df$UnitID))

```
![shot2](img/ipeds-comma-sep.PNG)

Once you paste these in, the search tool will detect the schools and you can press *Select* and continue on with choosing your variables of interest.

## Bonus Tip
If you are interested in looking at a particular College/University relative to its peers, you can see a version of a peer group for any school by taking a peek at their IPEDS Data Feedback report.

This report can be found in the IPEDS data center by going to "Look up an institution" and then after following the link to the institution, you can change from the default institutional profile to either "Reported Data" or "Data Feedback Reports". The first page of the Feedback Report has a list of peer schools which can be customized by each school if they choose. 
