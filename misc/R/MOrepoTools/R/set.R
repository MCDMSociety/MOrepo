
#' Create the \code{metaInstances.json} file
#'
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @examples
#' setMetaInstances()
setMetaInstances<-function() {
   lst <- list()
   lst$desc = "Meta file - Instances at MOrepo"

   # get all instances at GitHub
   files <- getFileList(subdir = "instances")
   files <- files[-grep("ReadMe", files)] # remove ReadMe files
   # subfolders
   folders <- sub("([^.]+/instances)/(.+)/.+$", "\\2", files)
   idx <- grep("/", folders)
   folders[-idx] <- ""
   folders[idx] <- sub("(.+)/(.+)$", "\\2", folders[idx])
   # instanceNames
   fileN <- basename(files)
   fileN <- sub("([^.]+)\\.[[:alnum:]]+$", "\\1", fileN) # remove file extension
   dat <- data.frame(instanceName = fileN, contributionName = NA, class = NA, tags = "",
                     subfolder = folders, stringsAsFactors = FALSE)
   # import meta data
   repoPaths <- getRepoPath()
   for (i in 1:length(repoPaths)) {
      meta<-jsonlite::fromJSON(paste0(repoPaths[i],"meta.json"))
      idx <- grep(meta$contributionName, dat$instanceName)
      dat$contributionName[idx] <- meta$contributionName
      for (j in 1:length(meta$instanceGroups$subfolder)) {
         idx <- grep(meta$instanceGroups$subfolder[j], dat$subfolder)
         dat$class[idx] <- meta$instanceGroups$class[j]
         dat$tags[idx] <- paste0(unlist(meta$instanceGroups$tags[j]), collapse = "; ")
      }
   }
   lst$instances<-dat
   lst$colNames <- colnames(dat)
   str<-jsonlite::toJSON(lst, dataframe = "values", auto_unbox = TRUE, pretty = TRUE, digits = NA)
   readr::write_lines(str, "metaInstances.json")
   message("Meta data for MOrepo saved to metaInstances.json")
}




#' Create the \code{metaContributions.json} file
#'
#' Note use the entry \code{repos} in \code{metaContributions.json} to find out which sub-repos to
#' scan and then overwrite the file.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @examples
#' setMetaContributions()
setMetaContributions<-function() {
   repos<-jsonlite::fromJSON("https://raw.githubusercontent.com/MCDMSociety/MOrepo/master/metaContributions.json")
   baseURL<-paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo-", repos$repos, "/master/")
   repoInfo<-vector("list", length(baseURL))
   names(repoInfo) <- repos$repos
   for (i in 1:length(baseURL)) {
      repoInfo[[i]]<-jsonlite::fromJSON(paste0(baseURL[i],"meta.json"))
      bib<-paste0(baseURL[i], "citation.bib")
      repoInfo[[i]]$bib<-readr::read_file(bib)
      # if (download.file(bib, destfile = "tmp.bib", quiet = TRUE)>0) {
      #    stop(paste("File",basename(bib),"could not be downloaded!"))
      # } else {
      #    repoInfo[[i]]$bib <- unlist(RefManageR::ReadBib("tmp.bib"))
      #    class(repoInfo[[i]]$bib$author) <- "list"
      # }
   }
   repos$repoInfo <- repoInfo
   str<-jsonlite::toJSON(repos, auto_unbox = TRUE, pretty = TRUE, digits = NA)
   readr::write_lines(str, "metaContributions.json")
   message("Meta data for MOrepo saved to metaContributions.json")
}

