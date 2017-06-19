
Multi-Objective Optimization Repository (MOrepo)
================================================

This repository is a response to the needs of researchers from the MCDM society to access multi-objective (MO) optimization instances. The repository contains instances, results, generators etc. for different MO problems and is continuously updated. The repository can be used as a test set for testing new algorithms, validating existing results and for reproducibility. All researchers within MO optimization are welcome to contribute.

The repository consists of a main repository [`MOrepo`](https://github.com/MCDMSociety/MOrepo) at GitHub and a set of sub-repositories, one for each contribution. Sub-repositories are named `MOrepo-<name>` where `name` normally is the surname of the first author and year of the study. All repositories are located within the [`MCDMSociety`](https://github.com/MCDMSociety/) organization at GitHub.

The main repository contains documentation about how to use and contribute to `MOrepo`. Moreover, a set of tools are given in the R package `MOrepoTools` which can be used to retrieve info about test instance groups, results and problem classes.

<!-- - `instances` - A folder containing the instance sets. Each instance set in contained in a subfolder for each paper using the instances the first time. -->
<!-- - `results` - A folder containing results for the instances. Results may be a set of nondominated points (or an approximation), upper and lower bounds etc. Results are not stored in the `instances` folder since different papers may have results for the same instances. -->
<!-- - `misc` - A folder with stuff that cannot be included into the two folders above such as R packages, generators, converters etc.  -->
Maintainers of `MOrepo` are Lars Relund Nielsen <larsrn@econ.au.dk>, Sune Gadegaard <sgadegaard@econ.au.dk>, Thomas Stridsen <thst@dta.dk> and Kim Allan Andersen <kia@econ.au.dk>.

Current maintainers of sub-repositories are Sune Lauth Gadegaard <sgadegaard@econ.au.dk> and Lars Relund <junk@relund.dk>.

Current contributors to the repository are S.L. Gadegaard, A. Klose, L.R. Nielsen, C.R. Pedersen, K.A. Andersen, D. Tuyttens, J. Teghem, Ph. Fortemps and K. Van Nieuwenhuyze.

Usage
-----

Instances can be downloaded in different ways depending on usage:

-   If you want the whole repository, download it as a zip file on GitHub.
-   Browse to a single instance and download it using the raw format at GitHub.
-   Use the R package `MOrepoTools` to download instances.

We recommend the last option and illustrate how it works. You don't need much knowledge about R to use the package. But of course it is preferable. You need [R](https://www.r-project.org/) and preferable [RStudio](https://www.rstudio.com/) installed on your computer. First you have to install the `MOrepoTools` package. From the R command line write:

``` r
library(devtools)  # if the package is missing see ?install.package 
install_github("MCDMSociety/MOrepo/misc/R/MOrepoTools")
```

To get an overview over the current probem classes run:

``` r
library(MOrepoTools)
getProblemClasses()  # current problem classes in MOrepo
```

    ## [1] "Facility location" "Assignment"

``` r
getInstanceInfo(class = "Assignment")  # info about instances for the assignment problem
```

    ## 
    ## ### Instance group Pedersen08:
    ## 
    ## Source: Pedersen, C, L. Nielsen and K. Andersen (2008). "The Bicriterion
    ## Multi Modal Assignment Problem: Introduction, Analysis, and
    ## Experimental Results". In: _Informs Journal on Computing_ 20.3, p.
    ## 400â411. DOI: 10.1287/ijoc.1070.0253.
    ## 
    ## Test classes: Assignment  
    ## Subfolders: AP and MMAP  
    ## Formats: xml  
    ## 
    ## ### Instance group Tuyttens00:
    ## 
    ## Source: Tuyttens, D, J. Teghem, P. Fortemps, et al. (2000). "Performance
    ## of the MOSA Method for the Bicriteria Assignment Problem". In:
    ## _Journal of Heuristics_ 6.3, pp. 295-310. DOI:
    ## 10.1023/A:1009670112978.
    ## 
    ## Test classes: Assignment  
    ## Formats: raw and xml

Now download the Tuyttens00 contribution as a zip file using

``` r
getContributionAsZip("Tuyttens00")
```

    ## Download MOrepo-Tuyttens00.zip ...

    ## finished.

Or download a selected instances

``` r
getInstance(name = "Tuyttens.*n10")
```

    ## Download Tuyttens00_AP_n10.raw ...finished
    ## Download Tuyttens00_AP_n100.raw ...finished

    ## [1] "Tuyttens00_AP_n10.raw"  "Tuyttens00_AP_n100.raw"

Problem classification
----------------------

Instances are classified into different classifications. The current classifications of MO optimization problems are:

-   Facility location
-   Assignment

The set of problem classes is expanded as new problem instances is added to the repository. For instance problem classes may be

-   Knapsack
-   Traveling salesman
-   Set covering
-   Set partitioning
-   Set packing
-   Shortest path
-   Transhipment
-   Multi-commodity flow
-   Minimum cost network flow
-   IP/MILP (general problems with a mixture of constraints)

How to contribute
-----------------

All researchers are welcome to contribute to `MOrepo`. The repository mainly contains MO test instances and results from various sources. However, also generators, format converters, algorithms etc. related to MO optimization are welcome. Have a look at the documentation file [`contribute.md`](contribute.md) which describes different ways to do it.

<!-- ## Instance format 

 
 - Free MPS format
 - Raw with desc









## Validators


R package

- check a contribution
- download a set of test instances
- download solutions and plot
- download citation
- merge ndsets



 

 
 
## Instance numbering


## Biblography










The MCDM society would benefit from a joint multi-objective optimization repository with MOO instances and algorithms. In this talk we will present our ideas about the open-source Multi-Objective Optimization Repository (MOPR) and give an overview over current features and progress. The talk is also open for discussion about feature requests etc.   -->
