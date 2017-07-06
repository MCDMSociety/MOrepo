
Multi-Objective Optimization Repository (MOrepo)
================================================

This repository is a response to the needs of researchers from the MCDM society to access multi-objective (MO) optimization instances. The repository contains instances, results, generators etc. for different MO problems and is continuously updated. The repository can be used as a test set for testing new algorithms, validating existing results and for reproducibility. All researchers within MO optimization are welcome to contribute.

The repository consists of a main repository [`MOrepo`](https://github.com/MCDMSociety/MOrepo) at GitHub and a set of sub-repositories, one for each contribution. Sub-repositories are named `MOrepo-<name>` where `name` normally is the surname of the first author and year of the study. All repositories are located within the [`MCDMSociety`](https://github.com/MCDMSociety/) organization at GitHub.

The main repository contains documentation about how to use and contribute to `MOrepo`. Moreover, a set of tools are given in the R package `MOrepoTools` which can be used to retrieve info about test instance groups, results and problem classes.

Maintainers of `MOrepo` are Lars Relund Nielsen <larsrn@econ.au.dk>, Sune Gadegaard <sgadegaard@econ.au.dk>, Thomas Stidsen <thst@dtu.dk> and Kim Allan Andersen <kia@econ.au.dk>.

Current maintainers of sub-repositories are Sune Lauth Gadegaard <sgadegaard@econ.au.dk> and Lars Relund <junk@relund.dk>.

Current contributors to the repository are S.L. Gadegaard, A. Klose, L.R. Nielsen, C.R. Pedersen, K.A. Andersen, D. Tuyttens, J. Teghem, Ph. Fortemps and K. Van Nieuwenhuyze.

Usage
-----

Instances can be downloaded in different ways depending on usage:

-   If you want a whole sub-repository, download it as a zip file on GitHub.
-   Browse to a single instance and download it using the raw format at GitHub.
-   Use the R package `MOrepoTools` to download instances.

We recommend the last option and illustrate how it works. You don't need much knowledge about R to use the package. But of course it is preferable. You need [R](https://www.r-project.org/) and preferable [RStudio](https://www.rstudio.com/) installed on your computer. First you have to install the `MOrepoTools` package. From the R command line write:

``` r
library(devtools)  # if the package is missing see ?install.package 
install_github("MCDMSociety/MOrepo/misc/R/MOrepoTools")
```

To get an overview over the current problem classes run:

``` r
library(MOrepoTools)
getProblemClasses()  # current problem classes in MOrepo
## [1] "Facility location" "Assignment"
getInstanceInfo(class = "Assignment")  # info about instances for the assignment problem
## 
## #### Contribution Pedersen08
## 
## Source: Pedersen, C, L. Nielsen and K. Andersen (2008). "The Bicriterion
## Multi Modal Assignment Problem: Introduction, Analysis, and
## Experimental Results". In: _Informs Journal on Computing_ 20.3,
## pp. 400-411. DOI: 10.1287/ijoc.1070.0253.
## 
## Test problem classes: Assignment  
## Subfolders: AP and MMAP  
## Formats: xml  
## 
## #### Contribution Tuyttens00
## 
## Source: Tuyttens, D, J. Teghem, P. Fortemps, et al. (2000). "Performance
## of the MOSA Method for the Bicriteria Assignment Problem". In:
## _Journal of Heuristics_ 6.3, pp. 295-310. DOI:
## 10.1023/A:1009670112978.
## 
## Test problem classes: Assignment  
## Formats: raw and xml
```

Now download the Tuyttens00 contribution as a zip file using

``` r
getContributionAsZip("Tuyttens00")
## Download MOrepo-Tuyttens00.zip ...
## finished.
```

Or download selected instances

``` r
getInstance(name = "Tuyttens.*n10")
## Download Tuyttens00_AP_n10.raw ...finished
## Download Tuyttens00_AP_n100.raw ...finished
## [1] "Tuyttens00_AP_n10.raw"  "Tuyttens00_AP_n100.raw"
```

How to contribute
-----------------

All researchers are welcome to contribute to `MOrepo`. The repository mainly contains MO test instances and results from various sources. However, also generators, format converters, algorithms etc. related to MO optimization are welcome. Have a look at the documentation file [`contribute.md`](contribute.md) which describes different ways to do it.

Test instances @ MOrepo
-----------------------

Currently MOrepo contains instances for problem classes Facility location and Assignment. The contributions listed after class are:

### Problem class Facility location

#### Contribution - [Gadegaard16](https://github.com/MCDMSociety/MOrepo-Gadegaard16)

Source: Gadegaard, S, A. Klose and L. Nielsen (2016). "A bi-objective approach to discrete cost-bottleneck location problems". In: *Annals of Operations Research*, pp. 1-23. DOI: 10.1007/s10479-016-2360-8.

Test problem classes: Facility location
Subfolders: CFLP\_UFLP and SSCFLP
Formats: raw

### Problem class Assignment

#### Contribution - [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08)

Source: Pedersen, C, L. Nielsen and K. Andersen (2008). "The Bicriterion Multi Modal Assignment Problem: Introduction, Analysis, and Experimental Results". In: *Informs Journal on Computing* 20.3, pp. 400-411. DOI: 10.1287/ijoc.1070.0253.

Test problem classes: Assignment
Subfolders: AP and MMAP
Formats: xml

#### Contribution - [Tuyttens00](https://github.com/MCDMSociety/MOrepo-Tuyttens00)

Source: Tuyttens, D, J. Teghem, P. Fortemps, et al. (2000). "Performance of the MOSA Method for the Bicriteria Assignment Problem". In: *Journal of Heuristics* 6.3, pp. 295-310. DOI: 10.1023/A:1009670112978.

Test problem classes: Assignment
Formats: raw and xml

Results @ MOrepo
----------------

Currently MOrepo contains results for instances in problem classes Assignment. The contributions listed after class are:

### Problem class Assignment

#### Contribution - [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08)

Source: Pedersen, C, L. Nielsen and K. Andersen (2008). "The Bicriterion Multi Modal Assignment Problem: Introduction, Analysis, and Experimental Results". In: *Informs Journal on Computing* 20.3, pp. 400-411. DOI: 10.1287/ijoc.1070.0253.

Results given for contributions: [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08) and [Tuyttens00](https://github.com/MCDMSociety/MOrepo-Tuyttens00)
