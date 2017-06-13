
#' Create the metaInstances.json file
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



