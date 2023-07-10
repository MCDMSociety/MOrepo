#' Download instances from GitHub
#'
#' @param name  Name of the instance(s) or only parts of the name. May be an regular expression for
#'   the instance name (excluding the file extension).
#' @param class Problem class. Ignored if \code{name} used.
#' @param fileFormat The file format of the instance. That is, the file extension of the instance.
#' @param onlyList If true don't download the instances but only list the instances (including file
#'   path at GitHub). Useful for testing.
#'
#' @return The names of the instances.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @example inst/examples/examples.R
getInstance <- function(name=NULL, class=NULL, fileFormat="raw", onlyList = FALSE) {
   if (is.null(name) & is.null(class)) stop("Error: name or class argument must be specified!")
   if (!is.null(name)) {
      instances<-getFileList(paste0("instances/.*",name,".*.",fileFormat))
   } else if (!is.null(class)) {
      info<-getInstanceInfo(class, silent = TRUE)
      instances <- plyr::llply(info, function(x){
         idx <- x$instanceGroups$class == class
         name <- x$instanceGroups$subfolder[idx]
         dat <- getFileList(name, subdir = paste0("instances/", fileFormat, "/"),
                            contribution = x$contributionName)
      })
      instances <- unlist(instances)
      names(instances) <- NULL
   }

   if (onlyList) return(instances)
   if (length(instances)==0) warning("Your pattern match no instances!")
   urlName <- "https://raw.githubusercontent.com/MCDMSociety/"
   for (path in instances) {
      cat("Download", basename(path), "...")
      fName<-basename(path)
      if (utils::download.file(paste0(urlName,path), destfile = basename(path), quiet = TRUE)>0) {
         warning(paste("File",basename(path),"could not be downloaded!"))
      }
      cat("finished\n")
   }
   return(basename(instances))
}



#' Get instance files (use \code{metaInstances.json})
#'
#' @param name  Name of the file(s) or only parts of the name. May be an regular expression.
#' @param class Problem class. Ignored if \code{name} used.
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all
#'   folders.
#' @param local Use local repo.
#'
#' @return The names of the files (including file path)
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getInstanceList("SSCFLP.*p64")
#' getInstanceList(class = "Facility location")
#' getInstanceList(contribution="Tuyttens00")
getInstanceList<-function(name = "", class = NULL, contribution = NULL, local = FALSE) {
   baseURL <- ifelse(local, "",  "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/")
   files<-jsonlite::fromJSON(paste0(baseURL,"metaInstances.json"))
   colnames(files$instances) <- files$colNames
   options(stringsAsFactors = FALSE)
   files <- as.data.frame(files$instances)

   if (!is.null(contribution)) files <- files[files$contributionName %in% contribution,]
   if (!is.null(class)) files <- files[files$class %in% class,]
   if (name != "") files <- files[grep(name, files$instanceName), ]
   return(files$instanceName)
}




#' Get result files (use \code{metaResults.json})
#'
#' @param name  Name of the file(s) or only parts of the name. May be an regular expression.
#' @param class Problem class. Ignored if \code{name} used.
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all
#'   folders.
#'
#' @return The names of the files (including file path)
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getInstanceList("SSCFLP.*p64")
#' getInstanceList(class = "Facility location")
#' getInstanceList(contribution="Tuyttens00")
getResultList<-function(name = "", class = NULL, contribution = NULL) {
   baseURL <- "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/"
   files<-jsonlite::fromJSON(paste0(baseURL, "metaResults.json"))
   colnames(files$results) <- files$colNames
   files <- tibble::as_tibble(files$results)

   if (!is.null(contribution)) files <- files[files$contributionName %in% contribution,]
   if (!is.null(class)) files <- files[files$class %in% class,]
   if (name != "") files <- files[grep(name, files$instanceName), ]
   return(files$instanceName)
}




#' Search repos and get a list of files
#'
#' @param name  Name of the file(s) or only parts of the name. May be an regular expression.
#' @param subdir Restricts search to a specific subfolder in each repo. The path must end with a
#'   slash (/).
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all
#'   folders.
#' @param local Use local repo (assumed to be placed one folder up).
#'
#' @return The names of the files (including file path)
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getFileList("SSCFLP.*p6")
#' getFileList(c("meta.json","ReadMe"))
#' getFileList("ReadMe", contribution=c("Gadegaard16", "Tuyttens00"))
#' getFileList("n10", contribution=c("Gadegaard16", "Tuyttens00"), subdir = "instances/")
#' getFileList(".xml", contribution="Tuyttens00")
getFileList<-function(name = "", subdir = "", contribution = NULL, local = FALSE) {
   if (is.null(contribution)) {
      baseURL <- ifelse(local, "metaContributions.json",
         paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/metaContributions.json") )
      repos<-jsonlite::fromJSON(baseURL)$repos
      if (local) {
         contribution<-paste0("../MOrepo-", repos, "/")
      } else {
         contribution<-paste0("https://api.github.com/repos/MCDMSociety/MOrepo-", repos,
                              "/git/trees/master?recursive=1")
      }
   } else {
      repos <- contribution
      if (local) {
         contribution <- paste0("../MOrepo-",contribution,"/")
      } else {
         contribution <- paste0("https://api.github.com/repos/MCDMSociety/MOrepo-", contribution,
                                "/git/trees/master?recursive=1")
      }
   }

   getF<-function(i) {
      if (!local) {
         req <- httr::GET(contribution[i])
         httr::stop_for_status(req)
         tree <- httr::content(req)$tree
         idx <- sapply(tree, "[", "type") == "blob"
         filelist <- unlist(lapply(tree, "[", "path"), use.names = F)
         filelist <- paste0("MOrepo-", repos[i], "/master/", filelist[idx])  # remove dirs
      } else {
         filelist <- list.files(path = contribution[i], full.names = TRUE, recursive = TRUE)
      }
      if (subdir!="") filelist <- unlist(lapply(subdir, grep, filelist, value = TRUE,
                                                ignore.case = TRUE))
      unlist(lapply(name, grep, filelist, value = TRUE, ignore.case = TRUE))
      #grep(paste0(subdir,name), filelist, value = TRUE, ignore.case = TRUE)
   }

   unlist(lapply(1:length(contribution), getF))
}



#' Get all the problem classes
#'
#' @param local Use local repo.
#' @param contribution Consider a specific contribution.
#' @param results If TRUE return only problem classes with results.
#'
#' @return All problem classes.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @example inst/examples/examples.R
getProblemClasses<-function(local = FALSE, contribution = NULL, results = FALSE) {
   baseURL <- ifelse(local, "",  "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/")
   repos<-jsonlite::fromJSON(paste0(baseURL,"metaContributions.json"))
   repos <- repos$repoInfo
   if (results) repos <- repos[!sapply(repos, function(x) is.null(x$resultContributions))]
   if (is.null(contribution)) {
      lst <- lapply(repos, function(x) x$instanceGroups$class)
      lst <- unlist(lst)
   } else {
      lst <- repos[[contribution]]$instanceGroups$class
   }
   return(unique(lst))
}




#' Get info about the instances.
#'
#' @param class Problem class of interest (if NULL consider all classes).
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all
#'   folders.
#' @param local Use local repos. Assume that repositories are placed in the father folder of the
#'   current working dir.
#' @param silent If true no output.
#' @param withLinks Output will be with markdown links.
#'
#' @return A list (invisible).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @example inst/examples/examples.R
getInstanceInfo<-function(class = NULL, contribution = NULL, local = FALSE,
                          silent = FALSE, withLinks = FALSE) {
   RefManageR::BibOptions(sorting = "none", bib.style = "authoryear", style = "markdown")
   baseURL <- ifelse(local, "",  "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/")
   repos<-jsonlite::fromJSON(paste0(baseURL,"metaContributions.json"))
   repos <- repos$repoInfo
   if (!is.null(contribution)) {
      repos <- repos[contribution]
      repos <- repos[!sapply(repos, is.null)]       #repos[!is.na(names(repos))]
   }
   repos <- repos[!sapply(repos, function(x) is.null(x$instanceGroups))]

   metaList<-repos
   for (i in 1:length(metaList)) {
      readr::write_file(metaList[[i]]$bib, "tmp.bib")
      bib<-RefManageR::ReadBib("tmp.bib")
      metaList[[i]]$bib <- bib
   }

   if (!is.null(class)) {
      metaList<-plyr::llply(metaList, .fun = function(x) {
         if (class %in% x$instanceGroups$class) {
            lst<-x
            lst$instanceGroups <- lst$instanceGroups[!is.na(lst$instanceGroups$class),]
            return(lst)
         }
      }
      )
      metaList<-metaList[!sapply(metaList, is.null)]  # remove NULL entries
   }

   if (length(metaList)==0) stop("Error: no match for class ", paste0(class, collapse = ", "), "!")
   if (silent) return(invisible(metaList))
   for (i in 1:length(metaList)) {
      x <- metaList[[i]]
      if (!withLinks) {
         cat(paste0('\n#### Contribution ',x$contributionName,'\n\n'))
      } else {
         cat(paste0('\n#### Contribution - [', x$contributionName,
                    '](https://github.com/MCDMSociety/MOrepo-', x$contributionName, ')\n\n'))
      }
      cat("Source: ")
      print(x$bib[1])
      cat("\n")
      cat(paste0("Test problem classes: ", vec2String(unique(
         x$instanceGroups$class[!is.na(x$instanceGroups$class)]
      )), "  \n"))
      if (!all(x$instanceGroups$subfolder == "")) {
         cat(paste0("Subfolders: ", vec2String(unique(
            x$instanceGroups$subfolder[!is.na(x$instanceGroups$subfolder)]
         )), "  \n"))
      }
      cat(paste0("Formats: ", vec2String(unique(
         unlist(x$instanceGroups$format)
      )), "  \n"))
   }
   invisible(metaList)
}



#' Get info about the results.
#'
#' @param class Problem class of interest (if NULL consider all classes).
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all
#'   folders.
#' @param local Use local repos. Assume that repositories are placed in the father folder of the
#'   current working dir.
#' @param silent If true no output.
#' @param withLinks Output will be with markdown links.
#'
#' @return A list (invisible).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @example inst/examples/examples.R
getResultInfo<-function(class = NULL, contribution = NULL,
                        local = FALSE, silent = FALSE, withLinks = FALSE) {
   RefManageR::BibOptions(sorting = "none", bib.style = "authoryear", style = "markdown")
   baseURL <- ifelse(local, "",  "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/")
   repos<-jsonlite::fromJSON(paste0(baseURL,"metaContributions.json"))
   repos <- repos$repoInfo
   reposAll <- repos
   if (!is.null(contribution)) {
      repos <- repos[contribution]
      repos <- repos[!sapply(repos, is.null)]       #repos[!is.na(names(repos))]
   }
   repos <- repos[!sapply(repos, function(x) is.null(x$resultContributions))]

   metaList<-repos
   for (i in 1:length(metaList)) {
      readr::write_file(metaList[[i]]$bib, "tmp.bib")
      bib<-RefManageR::ReadBib("tmp.bib")
      metaList[[i]]$bib <- bib
   }

   if (!is.null(class)) {
      idx<-plyr::llply(metaList, .fun = function(x) {
         for (r in x$resultContributions) {
            if (class %in% getProblemClasses(contribution = r)) return(TRUE)
         }
         return(FALSE)
      })
      metaList<-metaList[unlist(idx)]
   }

   if (length(metaList)==0) stop("Error: no match for class ", paste0(class, collapse = ", "), "!")
   if (silent) return(invisible(metaList))
   for (i in 1:length(metaList)) {
      x <- metaList[[i]]
      if (!withLinks) {
         cat(paste0('\n#### Contribution ', x$contributionName, '\n\n'))
      } else {
         cat(
            paste0(
               '\n#### Contribution - [',
               x$contributionName,
               '](https://github.com/MCDMSociety/MOrepo-',
               x$contributionName,
               ')\n\n'
            )
         )
      }
      cat("Source: ")
      print(x$bib[1])
      cat("\n")
      if (!withLinks) {
         cat(paste0(
            "Results given for contributions: ",
            vec2String(x$resultContributions),
            "  \n"
         ))
      } else {
         cat(paste0(
            "Results given for contributions: ",
            vec2String(
               paste0(
                  "[",
                  x$resultContributions,
                  "](https://github.com/MCDMSociety/MOrepo-",
                  x$resultContributions,
                  ")"
               )
            ),
            "  \n"
         ))
      }
   }
   invisible(metaList)
}



#' Get info about contributors (authors in citation BibTeX files)
#'
#' @param local Use local repo.
#'
#' @return A vector with unique contributors (read from citation.bib).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getContributorNames()
getContributorNames<-function(local = FALSE) {
   RefManageR::BibOptions(sorting = "none", bib.style = "authoryear")
   baseURL <- ifelse(local, "",  "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/")
   repos<-jsonlite::fromJSON(paste0(baseURL,"metaContributions.json"))
   authors <- NULL
   for (i in 1:length(repos$repoInfo)) {
      readr::write_file(repos$repoInfo[[i]]$bib, "tmp.bib")
      bib<-RefManageR::ReadBib("tmp.bib")
      authors<-c(authors, paste(bib$author))
   }
   return(unique(authors))
   # fileN<-getFileList("citation.bib", local = local)
   # baseURL <- ifelse(local, "file://./",  "https://raw.githubusercontent.com/MCDMSociety/" )
   # RefManageR::BibOptions(sorting = "none", bib.style = "authoryear")
   #
   # metaList<-NULL
   # for (f in fileN) {
   #    bib<-paste0(baseURL, f)
   #    if (utils::download.file(bib, destfile = "tmp.bib", quiet = TRUE)>0) {
   #       stop(paste("File",basename(bib),"could not be downloaded!"))
   #    } else {
   #       bib<-RefManageR::ReadBib("tmp.bib")
   #    }
   #    metaList<-c(metaList,list(bib))
   # }
   # lst<-lapply(metaList, FUN = function(x) paste(x$author))
   # lst<-unique(unlist(lst))
   # return(lst)
}




#' Get maintainers of all sub-repos at MOrepo (read from the metaContributions.json file).
#'
#' @param local Use local repo.
#'
#' @return A vector of maintainers.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getMaintainers()
getMaintainers<-function(local = FALSE) {
   baseURL <- ifelse(local, "",  "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/")
   meta<-jsonlite::fromJSON(paste0(baseURL, "metaContributions.json"))
   lst<-lapply(meta$repoInfo, FUN = function(x) paste(x$maintainer))
   lst<-unique(unlist(lst))
   return(lst)
}



#' Get urls of the sub-repositories of MOrepo.
#'
#' @param local Use local repo (urls becomes paths).
#'
#' @return A vector of strings.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getRepoPath()
getRepoPath<-function(local = FALSE) {
   baseURL <- ifelse(local, "metaContributions.json",
      paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/metaContributions.json"))
   repos<-jsonlite::fromJSON(baseURL)$repos
   if (local) {
      repos<-paste0("../MOrepo-", repos, "/")
   } else {
      repos<-paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo-", repos, "/master/")
   }
   return(repos)
}


#' File path of a specific file at MOrepo.
#'
#' @param file Relative file path within the contribution.
#' @param local Use local repo (urls becomes paths).
#' @param contribution Contribution name.
#'
#' @return A vector of strings.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getFilePath("instances/raw/SSCFLP/Gadegaard16_SSCFLP_Holmberg_p64_0.raw",
#'              contribution = "Gadegaard16")
getFilePath<-function(file, contribution, local = FALSE) {
   if (length(contribution)>1) stop("Contribution must have length of one.")
   if (local) {
      p <- paste0("../MOrepo-", contribution, "/", file)
   } else {
      p<-paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo-",
                contribution, "/master/", file)
   }
   return(p)
}



#' Download a contribution as a zip file.
#'
#' @param contributionName Contribution name(s) (without the MOrepo prefix).
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @example inst/examples/examples.R
getContributionAsZip<-function(contributionName) {
   path <-
      paste0(
         "https://github.com/MCDMSociety/MOrepo-",
         contributionName,
         "/archive/master.zip"
      )
   for (i in 1:length(path)) {
      message("Download MOrepo-", contributionName[i], ".zip ... ", appendLF = FALSE)
      if (utils::download.file(
         path[i],
         destfile = paste0("MOrepo-", contributionName[i], ".zip"),
         quiet = TRUE
      ) > 0) {
         warning("The contribution could not be downloaded! ")
      }
      message("finished.")
   }
}



#' Get data frame with all instances at MOrepo
#'
#' Use \code{metaInstances.json} as source.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getMetaInstances()
getMetaInstances<-function() {
   instances <- jsonlite::fromJSON(
      "https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/metaInstances.json")
   instances$instances <- as.data.frame(instances$instances)
   colnames(instances$instances) <- instances$colNames
   instances <- instances$instances
}



#' Convert a vector to a string with an 'and' at the second last (if needed).
#'
#' @param v A vector.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' vec2String("Test")
#' vec2String(1:2)
#' vec2String(1:5)
vec2String<-function(v) {
   if (length(v)==1) return(v)
   str <- paste0(v[1:(length(v)-1)], collapse = ", ")
   str <- paste0(str, " and ", v[length(v)])
   return(str)
}
