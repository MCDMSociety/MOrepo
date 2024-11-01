
# Multi-Objective Optimization Repository (MOrepo)

This repository is a response to the needs of researchers from the MCDM
society to access multi-objective (MO) optimization instances. The
repository contains instances, results, generators etc. for different MO
problems and is continuously updated. The repository can be used as a
test set for testing new algorithms, validating existing results and for
reproducibility. All researchers within MO optimization are welcome to
contribute.

The repository consists of a main repository
[`MOrepo`](https://github.com/MCDMSociety/MOrepo) at GitHub and a set of
sub-repositories, one for each contribution. Sub-repositories are named
`MOrepo-<name>` where `name` normally is the surname of the first author
and year of the study. All repositories are located within the
[`MCDMSociety`](https://github.com/MCDMSociety/) organization at GitHub.

The main repository contains documentation about how to use and
contribute to `MOrepo`. Moreover, a set of tools are given in the R
package `MOrepoTools` which can be used to retrieve info about test
instance groups, results and problem classes.

Maintainers of `MOrepo` are Lars Relund Nielsen <larsrn@econ.au.dk> and
Sune Gadegaard <sgadegaard@econ.au.dk>.

Current maintainers of sub-repositories are Sune Lauth Gadegaard
<sgadegaard@econ.au.dk>, Lars Relund <junk@relund.dk>, Thomas Stidsen
<thst@dtu.dk>, Nathan Adelgren <nadelgren@edinboro.edu> and Lars Relund
<lars@relund.dk>.

Current contributors to the repository are S.L. Gadegaard, A. Klose,
L.R. Nielsen, C.R. Pedersen, K.A. Andersen, D. Tuyttens, J. Teghem, Ph.
Fortemps, K. Van Nieuwenhuyze, M.P. Hansen, N. Adelgren, A. Gupte, N.
Forget, K. Klamroth, A. Przybylski, list(list(given = “M.”, family =
“Lyngesen”, role = NULL, email = NULL, comment = NULL), list(given =
“Gadegaard”, family = “S.L.”, role = NULL, email = NULL, comment =
NULL), list(given = “L.R.”, family = “Nielsen”, role = NULL, email =
NULL, comment = NULL)), list(list(given = “M.”, family = “Lyngesen”,
role = NULL, email = NULL, comment = NULL), list(given = c(“L.”, “R.”),
family = “Nielsen”, role = NULL, email = NULL, comment = NULL)),
list(list(given = “Duleabom”, family = “An”, role = NULL, email = NULL,
comment = NULL), list(given = c(“Sophie”, “N.”), family = “Parragh”,
role = NULL, email = NULL, comment = NULL), list(given = “Markus”,
family = “Sinnl”, role = NULL, email = NULL, comment = NULL), list(given
= “Fabien”, family = “Tricoire”, role = NULL, email = NULL, comment =
NULL)), list(list(given = “D.”, family = “An”, role = NULL, email =
NULL, comment = NULL), list(given = “S.N.”, family = “Parragh”, role =
NULL, email = NULL, comment = NULL), list(given = “N.”, family =
“Sinnl”, role = NULL, email = NULL, comment = NULL), list(given = “F.”,
family = “Tricoire”, role = NULL, email = NULL, comment = NULL)), G.
Kirlik and S. Sayın.

## Usage

Instances can be downloaded in different ways depending on usage:

- If you want a whole sub-repository, download it as a zip file or clone
  it on GitHub.
- Browse to a single instance and download it using the raw format at
  GitHub.
- Use the R package `MOrepoTools` to download instances.

All researchers are welcome to contribute to `MOrepo`. The repository
mainly contains MO test instances and results from various sources.
However, also generators, format converters, algorithms etc. related to
MO optimization are welcome. Have a look at the [contribute
file](contribute.md) which describes different ways to do it.

## Test instances @ MOrepo

MOrepo contains instances for different problem classes. The
contributions listed after class are:

| Problem class          | Repository                                                                                                                                                                                                                                   |
|:-----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Facility Location      | [Gadegaard16](https://github.com/MCDMSociety/MOrepo-Gadegaard16), [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20), [Forget21](https://github.com/MCDMSociety/MOrepo-Forget21), [An22](https://github.com/MCDMSociety/MOrepo-An22) |
| Assignment             | [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08), [Tuyttens00](https://github.com/MCDMSociety/MOrepo-Tuyttens00), [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20)                                                   |
| Traveling Salesman     | [Hansen00](https://github.com/MCDMSociety/MOrepo-Hansen00)                                                                                                                                                                                   |
| MILP                   | [Adelgren16](https://github.com/MCDMSociety/MOrepo-Adelgren16)                                                                                                                                                                               |
| Knapsack               | [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20), [Kirlik14](https://github.com/MCDMSociety/MOrepo-Kirlik14)                                                                                                                       |
| Production Planning    | [Forget21](https://github.com/MCDMSociety/MOrepo-Forget21)                                                                                                                                                                                   |
| Minkowski Sum - Subset | [Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)                                                                                                                                                                               |
| Minkowski Sum          | [Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)                                                                                                                                                                               |
| ILP                    | [Kirlik14](https://github.com/MCDMSociety/MOrepo-Kirlik14)                                                                                                                                                                                   |

### Detailed information

MOrepo contains instances for problem classes Facility Location,
Assignment, Traveling Salesman, MILP, Knapsack, Production Planning,
Minkowski Sum - Subset, Minkowski Sum and ILP. A detailed description of
the contributions are:

#### Contribution - [Gadegaard16](https://github.com/MCDMSociety/MOrepo-Gadegaard16)

Source: Gadegaard, S., A. Klose, and L. Nielsen (2016). “A bi-objective
approach to discrete cost-bottleneck location problems”. In: *Annals of
Operations Research*, pp. 1-23. DOI:
[10.1007/s10479-016-2360-8](https://doi.org/10.1007%2Fs10479-016-2360-8).

Test problem classes: Facility Location  
Subfolders: CFLP_UFLP and SSCFLP  
Formats: raw

#### Contribution - [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08)

Source: Pedersen, C., L. Nielsen, and K. Andersen (2008). “The
Bicriterion Multi Modal Assignment Problem: Introduction, Analysis, and
Experimental Results”. In: *Informs Journal on Computing* 20.3, pp.
400-411. DOI:
[10.1287/ijoc.1070.0253](https://doi.org/10.1287%2Fijoc.1070.0253).

Test problem classes: Assignment  
Subfolders: AP and MMAP  
Formats: xml

#### Contribution - [Tuyttens00](https://github.com/MCDMSociety/MOrepo-Tuyttens00)

Source: Tuyttens, D., J. Teghem, P. Fortemps, et al. (2000).
“Performance of the MOSA Method for the Bicriteria Assignment Problem”.
In: *Journal of Heuristics* 6.3, pp. 295-310. DOI:
[10.1023/A:1009670112978](https://doi.org/10.1023%2FA%3A1009670112978).

Test problem classes: Assignment  
Formats: raw and xml

#### Contribution - [Hansen00](https://github.com/MCDMSociety/MOrepo-Hansen00)

Source: Hansen, M. (2000). “Use of Substitute Scalarizing Functions to
Guide a Local Search Based Heuristic: The Case of moTSP”. In: *Journal
of Heuristics* 6.3, pp. 419-431. DOI:
[10.1023/A:1009690717521](https://doi.org/10.1023%2FA%3A1009690717521).

Test problem classes: Traveling Salesman  
Formats: raw

#### Contribution - [Adelgren16](https://github.com/MCDMSociety/MOrepo-Adelgren16)

Source: Adelgren, N. and A. Gupte (2016). *Branch-and-bound for
biobjective mixed-integer programming*. Optimization Online. Research
rep. URL:
<http://www.optimization-online.org/DB_HTML/2016/10/5676.html>.

Test problem classes: MILP  
Subfolders: LP_1, LP_2, LP_3, LP_4, LP_5 and LP_6  
Formats: lp

#### Contribution - [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20)

Source: Forget, N., S. Gadegaard, K. Klamroth, et al. (2020).
*Branch-and-bound and objective branching with three objectives*.
Optimization Online. URL:
<http://www.optimization-online.org/DB_FILE/2020/12/8158.pdf>.

Test problem classes: Assignment, Knapsack and Facility Location  
Subfolders: AP, KP and UFLP  
Formats: raw

#### Contribution - [Forget21](https://github.com/MCDMSociety/MOrepo-Forget21)

Source: Forget, N., S. Gadegaard, and L. Nielsen (2021). *Linear
relaxation based branch-and-bound for multi-objective integer
programming with warm-starting*. Optimizaton Online. URL:
<http://www.optimization-online.org/DB_HTML/2021/08/8531.html>.

Test problem classes: Production Planning and Facility Location  
Subfolders: PPP/3obj, PPP/4obj, PPP/5obj, UFLP/3obj, UFLP/4obj and
UFLP/5obj  
Formats: fgt

#### Contribution - [Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)

Source: Lyngesen, M., G. S.L., and L. Nielsen (2024). “Generator sets
for Minkowski Sums - Theory and Insights”. In: *??*.

Test problem classes: Minkowski Sum - Subset and Minkowski Sum  
Subfolders: sp/2obj, sp/3obj, sp/4obj, sp/5obj, msp/2obj, msp/3obj,
msp/4obj and msp/5obj  
Formats: json

#### Contribution - [An22](https://github.com/MCDMSociety/MOrepo-An22)

Source: An, D., S. N. Parragh, M. Sinnl, et al. (2024). “A matheuristic
for tri-objective binary integer linear programming”. In: *Computers &
Operations Research* 161, p. 106397. ISSN: 0305-0548. DOI:
[10.1016/j.cor.2023.106397](https://doi.org/10.1016%2Fj.cor.2023.106397).
URL: <http://dx.doi.org/10.1016/j.cor.2023.106397>.

Test problem classes: Facility Location  
Subfolders: CFLP  
Formats: fgt

#### Contribution - [Kirlik14](https://github.com/MCDMSociety/MOrepo-Kirlik14)

Source: Kirlik, G. and S. Sayın (2014). “A new algorithm for generating
all nondominated solutions of multiobjective discrete optimization
problems”. In: *European Journal of Operational Research* 232.3, pp.
479 - 488. DOI:
[10.1016/j.ejor.2013.08.001](https://doi.org/10.1016%2Fj.ejor.2013.08.001).

Test problem classes: ILP and Knapsack  
Subfolders: ILP/3obj, ILP/4obj, ILP/5obj, KP/3obj, KP/4obj and KP/5obj  
Formats: fgt

## Results @ MOrepo

MOrepo contains results for some of the instances in problem classes:

| Problem class          | Repository                                                                                                                 |
|:-----------------------|:---------------------------------------------------------------------------------------------------------------------------|
| Assignment             | [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08), [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20) |
| Knapsack               | [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20)                                                                 |
| Facility Location      | [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20)                                                                 |
| Minkowski Sum - Subset | [Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)                                                             |
| Minkowski Sum          | [Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)                                                             |

### Detailed information

MOrepo contains results for some of the instances in problem classes
Assignment, Knapsack, Facility Location, Minkowski Sum - Subset and
Minkowski Sum. The contributions are:

#### Contribution - [Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08)

Source: Pedersen, C., L. Nielsen, and K. Andersen (2008). “The
Bicriterion Multi Modal Assignment Problem: Introduction, Analysis, and
Experimental Results”. In: *Informs Journal on Computing* 20.3, pp.
400-411. DOI:
[10.1287/ijoc.1070.0253](https://doi.org/10.1287%2Fijoc.1070.0253).

Results given for contributions:
[Pedersen08](https://github.com/MCDMSociety/MOrepo-Pedersen08) and
[Tuyttens00](https://github.com/MCDMSociety/MOrepo-Tuyttens00)

#### Contribution - [Forget20](https://github.com/MCDMSociety/MOrepo-Forget20)

Source: Forget, N., S. Gadegaard, K. Klamroth, et al. (2020).
*Branch-and-bound and objective branching with three objectives*.
Optimization Online. URL:
<http://www.optimization-online.org/DB_FILE/2020/12/8158.pdf>.

Results given for contributions:
[Forget20](https://github.com/MCDMSociety/MOrepo-Forget20)

#### Contribution - [Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)

Source: Lyngesen, M., G. S.L., and L. Nielsen (2024). “Generator sets
for Minkowski Sums - Theory and Insights”. In: *??*.

Results given for contributions:
[Lyngesen24](https://github.com/MCDMSociety/MOrepo-Lyngesen24)

## How to cite

To cite use

    ## @Electronic{MOrepo,
    ##   title = {Multi-Objective Optimization Repository (MOrepo)},
    ##   author = {L. R. Nielsen},
    ##   url = {https://github.com/MCDMSociety/MOrepo},
    ##   year = {2017},
    ## }

## Use R to download instances

You may use the R package `MOrepoTools` to download instances. You don’t
need much knowledge about R to use the package. But of course it is
preferable. You need [R](https://www.r-project.org/) and preferable
[RStudio](https://www.rstudio.com/) installed on your computer. First
you have to install the `MOrepoTools` package. From the R command line
write:

``` r
library(devtools)   # if the package is missing see ?install.package 
install_github("MCDMSociety/MOrepo/misc/R/MOrepoTools")
```

To get an overview over the current problem classes run:

``` r
library(MOrepoTools)
getProblemClasses()  # current problem classes in MOrepo
## [1] "Facility Location"      "Assignment"             "Traveling Salesman"    
## [4] "MILP"                   "Knapsack"               "Production Planning"   
## [7] "Minkowski Sum - Subset" "Minkowski Sum"          "ILP"
getInstanceInfo(class = "Assignment")  # info about instances for the assignment problem
## 
## #### Contribution Pedersen08
## 
## Source: Pedersen, C., L. Nielsen, and K. Andersen (2008). "The Bicriterion
## Multi Modal Assignment Problem: Introduction, Analysis, and
## Experimental Results". In: _Informs Journal on Computing_ 20.3, pp.
## 400-411. DOI:
## [10.1287/ijoc.1070.0253](https://doi.org/10.1287%2Fijoc.1070.0253).
## 
## Test problem classes: Assignment  
## Subfolders: AP and MMAP  
## Formats: xml  
## 
## #### Contribution Tuyttens00
## 
## Source: Tuyttens, D., J. Teghem, P. Fortemps, et al. (2000). "Performance of
## the MOSA Method for the Bicriteria Assignment Problem". In: _Journal of
## Heuristics_ 6.3, pp. 295-310. DOI:
## [10.1023/A:1009670112978](https://doi.org/10.1023%2FA%3A1009670112978).
## 
## Test problem classes: Assignment  
## Formats: raw and xml  
## 
## #### Contribution Forget20
## 
## Source: Forget, N., S. Gadegaard, K. Klamroth, et al. (2020). _Branch-and-bound
## and objective branching with three objectives_. Optimization Online.
## URL:
## [http://www.optimization-online.org/DB_FILE/2020/12/8158.pdf](http://www.optimization-online.org/DB_FILE/2020/12/8158.pdf).
## 
## Test problem classes: Assignment, Knapsack and Facility Location  
## Subfolders: AP, KP and UFLP  
## Formats: raw
```

Now download the Tuyttens00 contribution as a zip file using

``` r
getContributionAsZip("Tuyttens00")
## Download MOrepo-Tuyttens00.zip ... finished.
```
