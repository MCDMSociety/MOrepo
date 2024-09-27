#' Create the \code{metaResults.json} file
#'
#' Must be run each time there is result modifications.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @import magrittr
#' @examples
#' \dontrun{
#' MOrepoTools:::setMetaResults()
#' }
setMetaResults<-function() {
   lst <- list()
   lst$desc = "Meta file - Results at MOrepo"

   # get all instances at GitHub
   dat <- tibble::tibble(files = getFileList(subdir = "results")) %>%
      dplyr::filter(stringr::str_detect(files, ".json"))
   dat <- dat %>%
      dplyr::mutate(resultName = stringr::str_remove(basename(files), ".json"),
         # instanceName = stringr::str_remove(basename(files), "_result.*json"),
         contributionName = stringr::str_replace(files, "^.*?-(.*?)/.*$", "\\1"),
         subfolder = stringr::str_replace(files, "^.*/results/(.*)$", "\\1"),
         subfolder = stringr::str_replace(subfolder, basename(subfolder), ""),
         subfolder = stringr::str_replace(subfolder, "^(.*)/$", "\\1")) %>%
      dplyr::select(-files)
   lst$results<-dat
   lst$colNames <- colnames(dat)
   str<-jsonlite::toJSON(lst, dataframe = "values", auto_unbox = TRUE, pretty = TRUE, digits = NA)
   readr::write_lines(str, "metaResults.json")
   message("Meta file with results for MOrepo saved to metaResults.json")
   return(TRUE)
}


#' Create the \code{metaInstances.json} file
#'
#' Must be run each time there is instance modifications.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @examples
#' \dontrun{
#' MOrepoTools:::setMetaInstances()
#' }
setMetaInstances<-function() {
   lst <- list()
   lst$desc = "Meta file - Instances at MOrepo"

   # get all instances at GitHub
   files <- getFileList(subdir = "instances")
   idx <- grep("ReadMe", files)
   if (length(idx)>0) files <- files[-idx] # remove ReadMe files
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
      idx1 <- grep(meta$contributionName, dat$instanceName)
      dat$contributionName[idx1] <- meta$contributionName
      for (j in 1:length(meta$instanceGroups$subfolder)) {
         idx2 <- grep(meta$instanceGroups$subfolder[j], dat$subfolder)
         idx3 <- intersect(idx1,idx2)
         dat$class[idx3] <- meta$instanceGroups$class[j]
         dat$tags[idx3] <- paste0(unlist(meta$instanceGroups$tags[j]), collapse = "; ")
      }
   }
   lst$instances<-dat
   lst$colNames <- colnames(dat)
   str<-jsonlite::toJSON(lst, dataframe = "values", auto_unbox = TRUE, pretty = TRUE, digits = NA)
   readr::write_lines(str, "metaInstances.json")
   message("Meta file with instances for MOrepo saved to metaInstances.json")
   return(TRUE)
}



#' Create the \code{metaContributions.json} file
#'
#' Note use the entry \code{repos} in \code{metaContributions.json} to find out which sub-repos to
#' scan and then overwrite the file.
#'
#' @param add Contribution to add (without the prefix `MOrepo-`) and then update.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @examples
#' \dontrun{
#' MOrepoTools:::setMetaContributions()
#' MOrepoTools:::setMetaContributions(add = "Adelgren16")
#' }
setMetaContributions<-function(add = NULL) {
   repos<-jsonlite::fromJSON("contributions.json")
   contrib <- repos$repos
   if (!is.null(add)) {
      contrib <- unique(c(contrib, add))
      repos$repos <- contrib
      str<-jsonlite::toJSON(repos, auto_unbox = TRUE, pretty = TRUE, digits = NA)
      readr::write_lines(str, "contributions.json")
   }
   repoInfo<-vector("list", length(contrib))
   names(repoInfo) <- contrib
   repos$repos <- contrib
   baseURL<-paste0("https://raw.githubusercontent.com/MCDMSociety/MOrepo-", contrib, "/master/")
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
   return(TRUE)
}



# setMetaResults<-function() {
#    lst <- list()
#    lst$desc = "Meta file - Results at MOrepo (stored as a list of contributions)"
#
#    files <- getFileList(subdir = "results")
#    files <- files[-grep("ReadMe", files)] # remove ReadMe files
#    # subfolders
#    folders <- sub("([^.]+/instances)/(.+)/.+$", "\\2", files)
#    idx <- grep("/", folders)
#    folders[-idx] <- ""
#    folders[idx] <- sub("(.+)/(.+)$", "\\2", folders[idx])
#    # instanceNames
#    fileN <- basename(files)
#    fileN <- sub("([^.]+)\\.[[:alnum:]]+$", "\\1", fileN) # remove file extension
#    dat <- data.frame(instanceName = fileN, contributionName = NA, class = NA, tags = "",
#                      subfolder = folders, stringsAsFactors = FALSE)
#    # import meta data
#    repoPaths <- getRepoPath()
#    for (i in 1:length(repoPaths)) {
#       meta<-jsonlite::fromJSON(paste0(repoPaths[i],"meta.json"))
#       idx1 <- grep(meta$contributionName, dat$instanceName)
#       dat$contributionName[idx1] <- meta$contributionName
#       for (j in 1:length(meta$instanceGroups$subfolder)) {
#          idx2 <- grep(meta$instanceGroups$subfolder[j], dat$subfolder)
#          idx3 <- intersect(idx1,idx2)
#          dat$class[idx3] <- meta$instanceGroups$class[j]
#          dat$tags[idx3] <- paste0(unlist(meta$instanceGroups$tags[j]), collapse = "; ")
#       }
#    }
#    lst$instances<-dat
#    lst$colNames <- colnames(dat)
#    str<-jsonlite::toJSON(lst, dataframe = "values", auto_unbox = TRUE, pretty = TRUE, digits = NA)
#    readr::write_lines(str, "metaInstances.json")
#    message("Meta data for MOrepo saved to metaInstances.json")
# }

