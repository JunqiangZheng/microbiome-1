## Standard data processing operations

The high-quality [phyloseq package](http://joey711.github.io/phyloseq/) provides a complete set of tools for data subsetting, aggregating and filtering.

Download example data from [O'Keefe et al. Nat. Comm. 6:6342, 2015](http://dx.doi.org/10.1038/ncomms7342) from [Data Dryad](http://dx.doi.org/10.5061/dryad.1mn1n). This is a two-week diet swap study between western (USA) and traditional (rural Africa) diets including microbiota profiling:


```r
library(microbiome)
#pseq <- download_microbiome("dietswap")
data("dietswap")
pseq <- dietswap
```


### Sample operations

Sample names and variables


```r
head(sample_names(pseq))
```

```
## [1] "Sample-1" "Sample-2" "Sample-3" "Sample-4" "Sample-5" "Sample-6"
```

Sample sums


```r
head(sample_sums(pseq))
```

```
## Sample-1 Sample-2 Sample-3 Sample-4 Sample-5 Sample-6 
##   533779  1330516  1822706   835998  1095023  1246234
```

Abundance of a given species in each sample


```r
head(get_sample(pseq, taxa_names(pseq)[1]))
```

```
## Sample-1 Sample-2 Sample-3 Sample-4 Sample-5 Sample-6 
##       11       67       21       42       16       20
```

Filter samples


```r
f1 <- filterfun_sample(topp(0.1))
taxa <- genefilter_sample(pseq, f1, A = round(0.5 * nsamples(pseq)))
```

Select samples by specific metadata fields:


```r
pseq.subset <- subset_samples(pseq, nationality == "AFR")
```


### Data transformations

The microbiome package provides a wrapper for standard sample/OTU transformations. For arbitrary transformations, use the transform_sample_counts function in the phyloseq package.

Log10 transformation (log(1+x) if the data contains zeroes)


```r
pseq.log <- transform_phyloseq(pseq, "log10")
```

Z transformation:


```r
# Z-transform OTUs
pseq.zotu <- transform_phyloseq(pseq, "Z", "OTU")
```

Relative abundances (the input data needs to be in absolute scale, not logarithmic!):


```r
pseq1 <- transform_phyloseq(pseq, "relative.abundance", "OTU")
pseq2 <- transform_sample_counts(pseq, function(x) x/sum(x))
```

Relative abundance for plain abundance matrix:


```r
dat <- otu_table(pseq)@.Data
rel <- relative.abundance(dat, det.th = 0)
```



### Variable operations

Sample variable names


```r
sample_variables(pseq)
```

```
## [1] "subject"                "sex"                   
## [3] "nationality"            "group"                 
## [5] "sample"                 "timepoint"             
## [7] "timepoint.within.group" "bmi_group"
```

Pick variable values for a given variable


```r
head(get_variable(pseq, sample_variables(pseq)[1]))
```

```
## [1] byn nms olt pku qjy riv
## 38 Levels: azh azl byn byu cxj dwc dwk eve fua fud gtd gty hsf irh ... zaq
```

```r
# Assign fields to sample metadata
# sample_data(GP)$human <- ..
```

### Taxa operations


Number of taxa


```r
ntaxa(pseq)
```

```
## [1] 130
```


Names


```r
ranks <- rank_names(pseq)
taxa <- taxa_names(pseq)
```


Prune taxa:


```r
taxa <- levelmap(NULL, "Phylum", "Genus", tax_table(pseq))$Bacteroidetes

# With given taxon names
ex2 <- prune_taxa(taxa, pseq)

# Taxa with positive sum across samples
ex3 <- prune_taxa(taxa_sums(pseq) > 0, pseq)
```


Subset taxa:


```r
pseq <- subset_taxa(pseq, Phylum == "Bacteroidetes")
```


Filter by user-specified function values (here variance):


```r
f <- filter_taxa(pseq, function(x) var(x) > 1e-05, TRUE)
```


List unique phylum-level groups: 


```r
head(get_taxa_unique(pseq, "Phylum"))
```

```
## [1] "Bacteroidetes"
```

Pick detected taxa by sample name:


```r
samplename <- sample_names(pseq)[[1]]
tax.abundances <- get_taxa(pseq, samplename)
```


Taxa sums


```r
head(taxa_sums(pseq))
```

```
##               Allistipes et rel.     Bacteroides fragilis et rel. 
##                          3513027                          2539567 
## Bacteroides intestinalis et rel.       Bacteroides ovatus et rel. 
##                           199684                          1516522 
##     Bacteroides plebeius et rel.  Bacteroides splachnicus et rel. 
##                           596972                           833871
```


### Merging operations

Aggregate OTUs to higher taxonomic levels, use (on HITChip we use L1/L2 instead of Phylum/Genus). See also [merge_samples and and merge_taxa](http://joey711.github.io/phyloseq/merge.html):


```r
pseq.L2 <- aggregate_taxa(pseq, level = "Genus")
```

Merging phyloseq objects


```r
merge_phyloseq(pseq1, pseq2)
```


### Rarification


```r
pseq.rarified <- rarefy_even_depth(pseq)
```


