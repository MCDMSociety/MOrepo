#' Download an instances and results
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
#' @example
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
#' @param name  Name of the instance(s) or only parts of the name. May be an regular expression for
#'   the instance name (excluding the file extension).
#' @param branch The branch at GitHub.
#' @param subdir Restricts search to a specific subfolder path at GitHub. The path must end with a
#'   slash (/).
#'
#' @return The names of the files (including file path at GitHub)
#' @author Lars Relund \email{lars@@relund.dk}
#' @example
#' getFileList("SSCFLP.*p6")
#' getFileList("inst")
#' getFileList(subdir = "instances/Gadegaard16/")
getFileList<-function(name = "", subdir = "", branch = "master") {
   req <- httr::GET(paste0("https://api.github.com/repos/relund/MOrepo/git/trees/",branch,"?recursive=1"))
   httr::stop_for_status(req)
   filelist <- unlist(lapply(httr::content(req)$tree, "[", "path"), use.names = F)
   grep(paste0(subdir,name), filelist, value = TRUE, ignore.case = TRUE)
}


#jsonlite::fromJSON()
