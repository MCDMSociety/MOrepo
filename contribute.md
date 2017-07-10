
Contributing to MOrepo
======================

All researchers are welcome to contribute to MOrepo with instances, results etc. Each contribution will be added as a sub-repository to the [MCDMSociety](https://github.com/MCDMSociety) organization at GitHub. Name the repository `MOrepo-<first_author><year>` e.g. `MOrepo-Gadegaard16`.

As maintainers of MOrepo we will do our best to help you in the process. That is, you are always welcome to contact us if you have problems following the steps below. The best way to do this is to file an [issue](https://github.com/MCDMSociety/MOrepo/issues) at GitHub and we will try to resolve your issues asap.

Step 1 - Download the template repository
-----------------------------------------

We have created a [template repository](https://github.com/MCDMSociety/MOrepo-Template) which have a specific file structure. You can download the repository as a zip file and afterwards start modifying/adding files.

The structure of an contribution folder is as follows:

-   If you contribute with new instances, an `instances` folder (see [Step2](#step-2---adding-test-instances-to-morepo)).
-   If you contribute with results, a `results` folder (see [Step 3](step-3---adding-results-to-morepo)).
-   A file `citation.bib` containing the citation details for the study in BibTeX format. The study could e.g. be a paper where the instances have been used or the results calculated. We do not recommend to add instances before you at least have written a report/note where the instances have been used.
-   A file `ReadMe.md` containing a presentation of the contribution. It must be written in [markdown](https://en.wikipedia.org/wiki/Markdown) which is just a plain text format. It must contain as description of the test instances (including formats) and results (if any). You may browse the [sub-repositories](https://github.com/MCDMSociety) for examples.
-   A file `meta.json` in [json format](https://en.wikipedia.org/wiki/JSON) with details about the contribution. For instance:

<!-- -->

    {
       "contributionName": "Pedersen08",
       "maintainer" : "Lars Relund <junk@relund.dk>",
       "instanceGroups": [
          {
             "subfolder": "AP",
             "class": "Assignment",
             "objectives": 2,
             "tags": [ "ap", "assignmentProblem", "bi-AP"],
             "format": [ "xml" ],
             "desc": "Instances for the bi-objective assignment problem.",
             "creator" : "Lars Relund <junk@relund.dk>"
          },
          {
             "subfolder": "MMAP",
             "class": "Assignment",
             "objectives": 2,
             "tags": [ "bi-MMAP", "MMAP", "multi-modal" ],
             "format": [ "xml" ],
             "desc": "Instances for the bi-objective multi-modal assignment problem.",
             "creator" : "Lars Relund <junk@relund.dk>"
          }
       ],
       "resultContributions": ["Pedersen08", "Tuyttens00"]
    }

The file contains

-   `contributionName` (required): The name of the the contribution (string). We recommend to use the first author of the study and year.
-   `maintainer` (required): Name and e-mail of the maintainer of the sub-repository at GitHub (string).
-   `rawDesc` (optional): Short description of the raw format (string).
-   `algorithm` (optional): URL to the source code of the algorithm used in the study (string). It may be placed in this repository or somewhere else.
-   `resultContributions` (required - if results): An array with entries of the contributions that results have been calculated from.
-   `instanceGroups` (required - if new instances): An array with entries containing info about each group of instances (normally one entry for each sub-folder). Each entry contains
    -   `subfolder` (required): Sub-folder of an instance format folder (if none set it to an empty string '').
    -   `class` (required): Problem class (string). Use the [currrent problem classes](#problem-classes). If your instances don't fit here add a new one.
    -   `objectives` (required): Number of objectives (number).
    -   `tags` (optional): An array with tags (use camel notation, not underscores).
    -   `format` (required): Array with file formats. The names must be equal the instance format folders, e.g. if have a raw and xml format then the `instances` folder must have two sub-folders named `raw` and `xml`.
    -   `creator` (required): Name and e-mail of the creator of the instances (string). Normally, the authors of the study.
    -   `desc` (required): Description of the instance group (string).

Step 2 - Adding test instances to MOrepo
----------------------------------------

If your study contains new test instances they should be added to the `instances` folder (remove it if you don't have any new instances). Instances are created for each study (paper/report/note) where the instances had been generated. Hence, if your study use instances from a previous multi-objective study not yet part of MOrepo, then kindly ask the authors of the previous study if you can include them in MOrepo (in a separate sub-repository). For instance if your study Gadegaard et. al. 2016 use instances from Nielsen et. al. 2014. Then create two contributions `MOrepo-Gadegaard16` (if new instances) and `MOrepo-Nielsen14` (with the old instances). As a result duplicated instance sets will not be generated.

The structure of the `instances` folder is as follows:

-   A folder for each file format (e.g. `raw` and `xml`). That is, different file formats may be used for the same instance. If you have used a plain text/raw format then name this format `raw` and add a description to the `ReadMe.md` file. Each file format folder should contain the sub-folders defined in the `instanceGroups` entry of the `meta.json` file. That is, if we consider the `meta.json` file above then folders `AP` and `MMAP`.
-   Instance file names must start with the contribution name and end with the file format suffix.

The `instances` folder should not contain any compressed files.

Step 3 - Adding results to MOrepo
---------------------------------

Results of applying an algorithm to the test instances at MOrepo can be added to your contribution. If your study contains results they should be added to the `results` folder (remove it if you don't have any results). For the moment only solutions in the objective space (e.g. the nondominated set) can be stored. Results must be saved in json format with file name `<instanceName>_result_<other>.json` where `<other>` is optional an may be a string as you like e.g. `<other>` may be useful if want to store different approximations of the nondominated set. `<instanceName>` must be equal to the full instance name used at MOrepo (not including the file extension). The result file has the following structure:

-   `version` (required): Result format version (string). Currently version must be set to 1.0.
-   `instanceName` (required): Name of instance not including the file extension (string).
-   `contributionName` (required): The name of the the contribution (string).
-   `objectives` (required): Number of objectives (number).
-   `objectiveType` (required): Array with strings `int`, `float` or `null` (unknown) giving the numeric types of the objectives. Must have the same length as the number of objectives (array, null).
-   `direction` (required): Array with strings `min` or `max` giving the direction of the objectives. Must have the same length as the number of objectives (array).
-   `comments` (optional): Misc comments about the results (string).
-   `optimal` (required): `true` if an exact optimal solution, `false` is know an approximation, `null` if unknown, i.e. may be optimal (boolean, null).
-   `suppCard` (optional): Number of supported nondominated points (number). This is with respect to the solution found.
-   `extCard` (optional): Number of extreme supported nondominated points (number)
-   `card` (required): Number of points
-   `cpu` (optional): In general you cannot compare cpu times for different machines. But you may create plots of results run on the same machine. An object with
    -   `sec`: Cpu time in seconds (number).
    -   `machineSpec`: Machine specification, e.g. Intel Xeon 2.67 GHz, 6 GB RAM, Red Hat Enterprise Linux v4.0 OS (string).
-   `points` (required): Array with nondominated points objects (array). Each point object consists of
    `{"z1":1,"z2":4,"type":"se"}` with the objective values (i.e. extend to `z3` if three objectives) and type which may be either `us` (unsupported), `se` (supported extreme), `s` (supported - may be extreme or nonextreme), `sne` (supported nonextreme), `null` (unknown). The type entry
-   `valid` (required): If true the results are considered valid. If false the results may be in conflict with results on the same instance from other contributions.
-   `misc` (optional): An entry you may use as you like. It could e.g. contain an object with more detailed entries about the experiment.

An example could be:

    {
      "contributionName": "Pedersen08",
      "objectives": 2,
      "objectiveType": ["int", "int"],
      "direction": ["min", "min"],
      "comments": "Results from the paper by Pedersen et. al (2008)",
      "optimal": true,
      "cpu": {
        "sec": 0,
        "machineSpec": "Intel Xeon 2.67 GHz, 6 GB RAM, Red Hat Enterprise Linux v4.0 OS"
      },
      "valid": true,
      "version": "1.0",
      "instanceName": "Tuyttens00_AP_n05",
      "suppCard": 3,
      "extCard": 3,
      "card": 8,
      "points": [
        {
          "z1": 27,
          "z2": 56,
          "type": "se"
        },
        {
          "z1": 30,
          "z2": 53,
          "type": "us"
        },
        {
          "z1": 31,
          "z2": 36,
          "type": "se"
        },
        {
          "z1": 34,
          "z2": 33,
          "type": "us"
        },
        {
          "z1": 42,
          "z2": 30,
          "type": "us"
        },
        {
          "z1": 43,
          "z2": 25,
          "type": "us"
        },
        {
          "z1": 49,
          "z2": 23,
          "type": "us"
        },
        {
          "z1": 51,
          "z2": 9,
          "type": "se"
        }
      ]
    }

You may create the json result files using tools you like. If you use R and MOrepoTools an easy way to do it is to use the function `createResultFile`. For further information see the documentation of the package:

``` r
library(MOrepoTools)
`?`(createResultFile)
```

Step 4 - Adding other stuff
---------------------------

You are very welcome to add other stuff to MOrepo. For instance, for reproducibility it is a good idea to add the source code of your algorithm (you may even ask for a sub-repository while you develop it - see Step 5). Source code can be put in a folder `algorithm`. Moreover, an instance generator can be put in a folder `generator`.

Step 5 - Checking and submitting your contribution
--------------------------------------------------

When your contribution is ready, we recommend to check if it is valid using the `MOrepoTools` R package. Install [R](https://cran.r-project.org/index.html) and run:

``` r
library(MOrepoTools)  # if not installed see the check.R file
checkContribution()
```

Remark: It may be easier if you also download [RStudio](https://www.rstudio.com/products/rstudio/) and rename the file `MOrepo-Template.Rproj` to `MOrepo-<contributionName>.Rproj`. You now just open this project file in RStudio and run the above code.

When you contribution is okay inform Lars Relund Nielsen <larsrn@econ.au.dk> together with your GitHub username. He will create the sub-repository at GitHub and inform you (you may also do this before Step 1, if you would like to work with git from the start). You can then add the files to git and GitHub using git from the command line inside the contribution folder:

    git init
    git add --all
    git commit -am "First commit"
    git remote add origin https://github.com/MCDMSociety/MOrepo-<contributionName>.git
    git push -u origin master

Remark: If you use [RStudio](https://www.rstudio.com/products/rstudio/) go to `Tools -> Project  Options -> Git/SVN` and type in `https://github.com/MCDMSociety/MOrepo-<contributionName>.git`. You can now do all [git stuff](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN) from within RStudio.

Problem classes
---------------

Instances are classified into problem classes. The current classifications of MO optimization problems are

-   Facility Location
-   Assignment
-   Traveling Salesman.

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
