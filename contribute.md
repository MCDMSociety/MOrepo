
Contributing to MPrepo
======================

All researchers are welcome to contribute to MOrepo. You may add instances and results.

Adding test instances to MOrepo
-------------------------------

Test instances are contained in folder `instances` which contains a subfolder for each contribution. A contribution is created for each study (paper/report/note) where the instances had been generated. Hence, if your study test instances used in previous studies that not yet are a part of MOrepo, then kindly ask the authors of the previous study if you can include them in MOrepo. For instance if your study Gadegaard et. al. 2016 use instances from Nielsen et. al. 2014. Then create two contribution subfolders `Gadegaard16` (if new instances) and `Nielsen14` (with the old instances). As a result dublicated instance sets will not be generated. We suggest to name the folder `<first_author><year>` e.g. `Gadegaard16`.

The structure of an instance folder is as follows:

-   A subfolder for each instance format. Each folder may contain subfolders for different instance groups.
-   A file `citation.bib` containing the citation details for the study generating the instances in BibTeX format.
-   A file `ReadMe.md` containing a presentation of the contribution (markdown format).
-   A file `meta.json` in [json format](https://en.wikipedia.org/wiki/JSON) with details about the instances. For instance:

``` json
{
   "folder" : "Gadegaard16",
   "maintainer" : "Lars Relund <junk@relund.dk>",
   "creator" : "Sune Gadegaard.",
   "instanceSet" : [
      {
         "subfolder" : "SSCFLP",
         "class" : "Facility location",
         "tags" : [ "singleSource", "capacitated", "singleSourceCapacitated", "SSCFLP" ],
         "format" : [ "raw" ],
         "desc" : "Instances for the single source capacitated facility location problem."
      },
      {
         "external" : "http://www.hi-lf.dk/wp/wp-admin/post.php?post=9776&action=edit"
      }
   ]
}
```

The file contains

-   `folder`: The name of the folder containing the contribution (string).
-   `maintainer`: Name and e-mail of the maintainer who have added the instances to MOrepo (string).
-   `creator`: Name and e-mail of the creator of the instances (string).
-   `rawDesc`: Short description of the raw format.
-   `instanceGroups`: An array with entries containing info about each group of instances (normally one entry for each subfolder). Each entry contains
    -   `subfolder`: Subfolder of an instance format folder (if none set it to an empty string '').
    -   `class`: Problem class.
    -   `tags`: An array with tags (use camel notation, not underscores).
    -   `format`: Array with file formats (the names of the instance format folders).
    -   `desc`: Description of the instance group.

The file contains fields

There are different ways to add the
