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
#' @examples
#' getInstance(name="Tuyttens", onlyList = T)
#' getInstance(name="Tuyttens")
#' getInstance(class="Facility location", onlyList = T)
getInstance <- function(name=NULL, class=NULL, fileFormat="raw", onlyList = FALSE) {
   if (is.null(name) & is.null(class)) stop("Error: name or class argument must be specified!")
   if (!is.null(name)) {
      instances<-getFileList(paste0("instances/.*",name,".*.",fileFormat))
   } else if (!is.null(class)) {
      info<-getInstanceInfo(class, silent = TRUE)
      instances <- plyr::llply(info, function(x){
         idx <- x$instanceGroups$class == class
         name <- x$instanceGroups$subfolder[idx]
         dat <- getFileList(name, subdir = paste0("instances/", fileFormat, "/"), contribution = x$contributionName)
      })
      instances <- unlist(instances)
   }

   if (onlyList) return(instances)
   if (length(instances)==0) warning("Your pattern match no instances!")
   urlName <- "https://raw.githubusercontent.com/MCDMSociety/"
   for (path in instances) {
      cat("Download", basename(path), "...")
      fName<-basename(path)
      if (download.file(paste0(urlName,path), destfile = basename(path), quiet = TRUE)>0) {
         warning(paste("File",basename(path),"could not be downloaded!"))
      }
      cat("finished\n")
   }
   return(basename(instances))
}



#' Search repos and get a list of files
#'
#' @param name  Name of the file(s) or only parts of the name. May be an regular expression.
#' @param subdir Restricts search to a specific subfolder in each repo. The path must end with a
#'   slash (/).
#' @param class Problem class. Ignored if \code{name} used.
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all folders.
#' @param local Use local repo.
#'
#' @return The names of the files (including file path)
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getFileList("SSCFLP.*p6")
#' getFileList(".json")
#' getFileList(".json", class = "Facility location")
#' getFileList(c(".json","ReadMe"))
#' getFileList("ReadMe", contribution=c("Gadegaard16", "Tuyttens00"))
#' getFileList("ReadMe", contribution=c("Gadegaard16", "Tuyttens00"), subdir = "instances/")
#' getFileList(".xml", contribution="Tuyttens00")
#' getFileList(".xml", contribution="Tuyttens00", local = T)
#' getFileList(".json", local =T)
getFileList<-function(name = "", subdir = "", class = NULL, contribution = NULL, local = FALSE) {
   if (is.null(contribution)) {
      baseURL <- ifelse(local, "contributions.json",
                        paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/contributions.json") )
      repos<-jsonlite::fromJSON(baseURL)$repos
      if (local) {
         contribution<-paste0("../MOrepo-", repos, "/")
      } else {
         contribution<-paste0("https://api.github.com/repos/MCDMSociety/MOrepo-", repos, "/git/trees/master?recursive=1")
      }
   } else {
      repos <- contribution
      if (local) {
         contribution <- paste0("../MOrepo-",contribution,"/")
      } else {
         contribution <- paste0("https://api.github.com/repos/MCDMSociety/MOrepo-", contribution, "/git/trees/master?recursive=1")
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
      unlist(lapply(paste0(subdir,name), grep, filelist, value = TRUE, ignore.case = TRUE))
      #grep(paste0(subdir,name), filelist, value = TRUE, ignore.case = TRUE)
   }

   unlist(lapply(1:length(contribution), getF))
}



#' Get all the problem classes
#'
#' @param local Use local repo.
#'
#' @return All problem classes.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getProblemClasses()
#' getProblemClasses(local = T)
getProblemClasses<-function(local = FALSE) {
   path<-getFileList("meta.json", local = local)
   baseURL <- ifelse(local, "",  paste0("https://raw.githubusercontent.com/MCDMSociety/") )
   dat<-NULL
   for (f in path) {
      meta<-paste0(baseURL, f)
      meta<-jsonlite::fromJSON(meta)
      dat<-c(dat, meta$instanceGroups$class)
   }
   return(unique(dat[!is.na(dat)]))
}




#' Get info about the instances.
#'
#' @param class Problem class of interest (if NULL consider all classes).
#' @param contribution Name of the contribution (without prefix MOrepo-). If NULL consider all folders.
#' @param local Use local repos. Assume that repositories are placed in the father folder of the
#'   current working dir.
#' @param silent If true no output.
#'
#' @return A list (invisible).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getInstanceInfo()
#' getInstanceInfo(class="Facility location")
getInstanceInfo<-function(class = NULL, contribution = NULL, local = FALSE, silent = FALSE) {
   RefManageR::BibOptions(sorting = "none", bib.style = "authoryear")
   if (is.null(contribution)) {
      contribution<-getRepoPath(local)
   } else {
      if (local) {
         contribution <- paste0("../MOrepo-",contribution,"/")
      } else {
         contribution <- paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo-", contribution, "/master/")
      }
   }

   metaList<-NULL
   for (f in contribution) {
      bib<-paste0(f, "citation.bib")
      if (local) bib <- paste0("file://",bib)
      if (download.file(bib, destfile = "tmp.bib", quiet = TRUE)>0) {
         stop(paste("File",basename(bib),"could not be downloaded!"))
      } else {
         bib<-RefManageR::ReadBib("tmp.bib")
      }
      meta<-jsonlite::fromJSON(paste0(f,"meta.json"))
      meta$bib <- bib
      metaList<-c(metaList,list(meta))
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
      cat(paste0('\n### Instance group ',x$contributionName,':\n\n'))
      cat("Source: ")
      print(x$bib[1])
      cat("\n")
      cat(paste0("Test classes: ", paste0(unique(x$instanceGroups$class[!is.na(x$instanceGroups$class)]), collapse = ", "), "  \n"))
      if (!all(x$instanceGroups$subfolder=="")) {
         cat(paste0("Subfolders: ", paste0(unique(x$instanceGroups$subfolder[!is.na(x$instanceGroups$subfolder)]), collapse = ", "), "  \n"))
      }
      cat(paste0("Formats: ", paste0(unique(unlist(x$instanceGroups$format)), collapse = ", "), "  \n"))
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
#' getContributors()
#' getContributors(local = T)
getContributors<-function(local = FALSE) {
   fileN<-getFileList("citation.bib", local = local)
   baseURL <- ifelse(local, "file://./",  "https://raw.githubusercontent.com/MCDMSociety/" )
   RefManageR::BibOptions(sorting = "none", bib.style = "authoryear")

   metaList<-NULL
   for (f in fileN) {
      bib<-paste0(baseURL, f)
      if (download.file(bib, destfile = "tmp.bib", quiet = TRUE)>0) {
         stop(paste("File",basename(bib),"could not be downloaded!"))
      } else {
         bib<-RefManageR::ReadBib("tmp.bib")
      }
      metaList<-c(metaList,list(bib))
   }
   lst<-lapply(metaList, FUN = function(x) paste(x$author))
   lst<-unique(unlist(lst))
   return(lst)
}




#' Get maintainers of all sub-repos at MOrepo (read from the meta.json file).
#'
#' @param local Use local repo.
#'
#' @return A vector of maintainers.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getMaintainers()
#' getMaintainers(local = T)
getMaintainers<-function(local = FALSE) {
   fileN<-getFileList("meta.json", local = local)
   baseURL1 <- ifelse(local, "", "https://raw.githubusercontent.com/MCDMSociety/")
   metaList<-NULL
   for (f in fileN) {
      meta<-paste0(baseURL1, f)
      meta<-jsonlite::fromJSON(meta)
      metaList<-c(metaList,list(meta))
   }
   lst<-lapply(metaList, FUN = function(x) paste(x$maintainer))
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
   baseURL <- ifelse(local, "contributions.json",
                     paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/contributions.json") )
   repos<-jsonlite::fromJSON(baseURL)$repos
   if (local) {
      repos<-paste0("../MOrepo-", repos, "/")
   } else {
      repos<-paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo-", repos, "/master/")
   }
   return(repos)
}



#' Download a contribution as a zip file.
#'
#' @param contributionName Contribution name(s) (without the MOrepo prefix).
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getContributionAsZip(c("Tuyttens00", "Template"))
getContributionAsZip<-function(contributionName) {
   path <- paste0("https://github.com/MCDMSociety/MOrepo-", contributionName, "/archive/master.zip")
   for (i in 1:length(path)) {
      message("Download MOrepo-", contributionName[i], ".zip ... ", appendLF = FALSE)
      if (download.file(path[i], destfile = paste0("MOrepo-", contributionName[i], ".zip"), quiet = TRUE)>0) {
         warning("The contribution could not be downloaded! ")
      }
      message("finished.")
   }
}



