#' Download instances from GitHub
#'
#' @param name  Name of the instance(s) or only parts of the name. May be an regular expression for
#'   the instance name (excluding the file extension).
#' @param class Problem class. Ignored if \code{name} used.
#' @param fileFormat The file format of the instance. That is, the file extension of the instance.
#' @param branch The branch at GitHub.
#' @param onlyList If true don't download the instances but only list the instances (including file
#'   path at GitHub). Useful for testing.
#'
#' @return The names of the instances.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getInstance(name="SSCFLP")
#' getInstance(name="SSCFLP.*p6")
getInstance <- function(name=NULL, class=NULL, fileFormat="raw", branch = "master", onlyList = FALSE) {
   if (!is.null(name)) {
      instances<-getFileList(paste0("instances/.*",name,".*.",fileFormat))
   } else if (!is.null(class)) {

   }

   if (onlyList) return(instances)
   if (length(instances)==0) warning("Your pattern match no instances!")
   urlName <- paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/")
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



#' Get list of files at GitHub
#'
#' @param name  Name of the file(s) or only parts of the name. May be an regular expression.
#' @param branch The branch at GitHub.
#' @param subdir Restricts search to a specific subfolder path at GitHub. The path must end with a
#'   slash (/).
#' @param local Use local repo.
#'
#' @return The names of the files (including file path at GitHub)
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getFileList("SSCFLP.*p6")
#' getFileList("inst")
#' getFileList(subdir = "instances/Gadegaard16/")
getFileList<-function(name = "", subdir = "", branch = "master", local = FALSE) {
   if (!local) {
      req <- httr::GET(paste0("https://api.github.com/repos/relund/MOrepo/git/trees/",branch,"?recursive=1"))
      httr::stop_for_status(req)
      filelist <- unlist(lapply(httr::content(req)$tree, "[", "path"), use.names = F)
   } else {
      filelist <- list.files(full.names = TRUE, recursive = TRUE)
      filelist <- sub("./","",filelist)
   }
   grep(paste0(subdir,name), filelist, value = TRUE, ignore.case = TRUE)
}


#' Get instance folders (subfolders in the instances folder)
#'
#' @param class Problem classes considered (if NULL then all).
#' @param branch The branch at GitHub.
#' @param local Use local repo.
#'
#' @return The folder names.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getInstanceFolders()
#' getInstanceFolders(local = TRUE)
#' getInstanceFolders(class = "TSP")
getInstanceFolders<-function(class = NULL, branch = "master", local = FALSE) {
   if (is.null(class)) {
      if (!local) {
         dir <- getFileList(subdir = "instances/", branch = branch)
         dir <- sub("instances/", "", dir)
         dir <- dir[-grep("/",dir)]
      }
      if (local) dir <- list.dirs("./instances/", full.names = FALSE, recursive = FALSE)
   } else {
      dat <- getInstanceInfo(class = class, branch = branch, local = local, raw = TRUE)
   }
   return(dir)
}


#' Get the problem classes
#'
#' @param branch The branch at GitHub.
#' @param local Use local repo.
#'
#' @return All problem classes.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getProblemClasses()
getProblemClasses<-function(branch = "master", local = FALSE) {
   folders<-getInstanceFolders(class=NULL, branch, local)
   baseURL <- ifelse(local, "instances/",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/instances/") )
   dat<-NULL
   for (f in folders) {
      meta<-paste0(baseURL, f,"/meta.json")
      meta<-jsonlite::fromJSON(meta)
      dat<-c(dat, meta$instanceGroups$class)
   }
   return(dat[!is.na(dat)])
}




#' Get info about the instances.
#'
#' @param class Problem class of interest (if NULL consider all classes).
#' @param folder Folder(s) of interest (if NULL consider all folders).
#' @param branch The branch at GitHub.
#' @param local Use local repo.
#'
#' @return A list (invisible).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getInstanceInfo(local = T)
#' getInstanceInfo(local = F)
getInstanceInfo<-function(class = NULL, folder = NULL, branch = "master", local = FALSE) {
   if (is.null(folder)) folders<-getInstanceFolders(class, branch, local)
   baseURL <- ifelse(local, "file://./instances/",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/instances/") )
   baseURL1 <- ifelse(local, "instances/",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/instances/") )
   RefManageR::BibOptions(sorting = "none", bib.style = "authoryear")

   metaList<-NULL
   for (f in folders) {
      bib<-paste0(baseURL, f, "/citation.bib")
      if (download.file(bib, destfile = "tmp.bib", quiet = TRUE)>0) {
         stop(paste("File",basename(bib),"could not be downloaded!"))
      } else {
         bib<-RefManageR::ReadBib("tmp.bib")
      }
      meta<-paste0(baseURL1, f,"/meta.json")
      meta<-jsonlite::fromJSON(meta)
      meta$bib <- bib
      metaList<-c(metaList,list(meta))
   }
   if (!is.null(class)) {
      metaList<-plyr::llply(metaList, .fun = function(x) {
         if (class %in% x$instanceSet$class) {
            lst<-x
            lst$instanceSet <- lst$instanceSet[!is.na(lst$instanceSet$class),]
            return(lst)
         }
      }
      )
      metaList<-metaList[!sapply(metaList, is.null)]  # remove NULL entries
   }
   for (i in 1:length(metaList)) {
      x <- metaList[[i]]
      cat(paste0('\n### Instance set ',x$folder,':\n\n'))
      cat("Source: ")
      print(metaList[[1]]$bib[1])
      cat("\n")
      cat(paste0("Test classes: ", unique(x$instanceGroups$class[!is.na(x$instanceGroups$class)]), "  \n"))
      cat(paste0("Subfolders: ", unique(x$instanceGroups$subfolder[!is.na(x$instanceGroups$subfolder)]), "  \n"))
      cat(paste0("Formats: ", unique(unlist(x$instanceGroups$format)), "  \n"))
   }
   invisible(metaList)
}




#' Get info about contributors (authors in citation BibTeX files)
#'
#' @param branch The branch at GitHub.
#' @param local Use local repo.
#'
#' @return A vector with unique contributors.
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getContributors()
#' getContributors(local = F)
getContributors<-function(branch = "master", local = FALSE) {
   fileN<-getFileList("citation.bib", subdir = "", branch, local)
   baseURL <- ifelse(local, "file://./",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/") )
   baseURL1 <- ifelse(local, "/",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/") )
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




#' Get maintainers of stuff at MOrepo.
#'
#' @param branch The branch at GitHub.
#' @param local Use local repo.
#'
#' @return A vector of maintainers (invisible).
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
#' @examples
#' getMaintainers()
getMaintainers<-function(branch = "master", local = FALSE) {
   fileN<-getFileList("meta.json", subdir = "", branch, local)
   baseURL <- ifelse(local, "file://./",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/") )
   baseURL1 <- ifelse(local, "/",  paste0("https://raw.githubusercontent.com/relund/MOrepo/", branch, "/") )
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




