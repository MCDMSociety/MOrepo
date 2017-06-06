
Contributing to MOrepo
======================

All researchers are welcome to contribute to MOrepo with instances, results etc. Each contribution will be added as a sub-repository to the [MCDMSociety](https://github.com/MCDMSociety) organization at GitHub. Name the repository MO-repo-`<first_author><year>` e.g. `MOrepo-Gadegaard16`.

As maintainers of MOrepo we will do our best to help you in the process. That is, you are always welcome to contact us if you have problems following the steps below. The best way to do this is to file an [issue](https://github.com/MCDMSociety/MOrepo/issues) at GitHub and we will try to resolve your issues asap.

Step 1 - Download the template repository
-----------------------------------------

We have created a [template repository](https://github.com/MCDMSociety/MOrepo-Template) which have a specific file structure. You can download the repository as a zip file and afterwards start modifying/adding files.

The structure of an contribution folder is as follows:

-   If you contribute with new instances, an `instances` folder (see [Step2](#step-2---adding-test-instances-to-morepo)).
-   If you contribute with results, a `results` folder (see [Step 3](step-3---adding-results-to-morepo).
-   A file `citation.bib` containing the citation details for the study in BibTeX format. The study could e.g. be a paper where the instances have been used or the results calculated. We do not recommend to add instances before you at least have written a report/note where the instances have been used.
-   A file `ReadMe.md` containing a presentation of the contribution. It must be written in [markdown](https://en.wikipedia.org/wiki/Markdown) which is just a plain text format.
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
       ]
    }

The file contains

-   `contributionName` (required): The name of the the contribution (string). We recommend to use the first author of the study and year.
-   `maintainer` (required): Name and e-mail of the maintainer of the sub-repository at GitHub (string).
-   `rawDesc` (optional): Short description of the raw format (string).
-   `algorithm` (optional): URL to the source code of the algorithm used in the study (string). It may be placed in this repository or somewhere else.
-   `instanceGroups` (required - if new instances): An array with entries containing info about each group of instances (normally one entry for each sub-folder). Each entry contains
    -   `subfolder` (required): Sub-folder of an instance format folder (if none set it to an empty string '').
    -   `class` (required): Problem class (string). Have a look at the current problem classes ???. If your instances don't fit here add a new one.
    -   `objectives` (required): Number of objectives (number).
    -   `tags` (optional): An array with tags (use camel notation, not underscores).
    -   `format` (required): Array with file formats. The names must be equal the instance format folders, e.g. if have a raw and xml format then the `instances` folder must have two sub-folders named `raw` and `xml`.
    -   `creator` (required): Name and e-mail of the creator of the instances (string). Normally, the authors of the study.
    -   `desc` (required): Description of the instance group (string).

Step 2 - Adding test instances to MOrepo
----------------------------------------

If your study contains new test instances they should be added to the `instances` folder (remove it if you don't have any new instances). Instances are created for each study (paper/report/note) where the instances had been generated. Hence, if your study test instances used in previous multi-objective studies that not yet are a part of MOrepo, then kindly ask the authors of the previous study if you can include them in MOrepo (in a separate sub-repository). For instance if your study Gadegaard et. al. 2016 use instances from Nielsen et. al. 2014. Then create two contributions `MOrepo-Gadegaard16` (if new instances) and `MOrepo-Nielsen14` (with the old instances). As a result duplicated instance sets will not be generated.

The structure of the `instances` folder is as follows:

-   A file `ReadMe.md` containing a description of the instances and formats (markdown). You may browse the [sub-repositories](https://github.com/MCDMSociety) for examples.
-   A folder for each file format (e.g. `raw` and `xml`). That is, different file formats may be used. If you have used a plain text/raw format then name this format `raw` and add a description to the `ReadMe.md` file. Each file format folder contains the sub-folders defined in the `instanceGroups` entry of the `meta.json` file. That is, if we consider the `meta.json` file above then folders `AP` and `MMAP`.
-   Instance file names must start with the contribution name and end with the file format suffix.

The `instances` folder should not contain any compressed files.

Step 3 - Adding results to MOrepo
---------------------------------

Step 4 - Adding other stuff
---------------------------

Step 5 - Checking and submitting your contribution
--------------------------------------------------

When your contribution is ready, we recormmend to check if it is valid using the `MOrepoTools` R package and run:

``` r
library(MOrepoTools)
checkContribution()
```

We you contribution is okay inform Lars Relund Nielsen <larsrn@econ.au.dk>. He will create the sub-repository at GitHub and inform you (you may also do this before Step 1, if you would like to work with git in the start). You can then add the files to git and GitHub using git from the commandline inside the contribution folder:

    git init
    git add --all
    git commit -am "First commit"
    git remote add origin https://github.com/MCDMSociety/MOrepo-<contributionName>.git
    git push -u origin master
