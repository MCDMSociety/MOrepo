
#' Validate meta file based on schema.
#'
#' @param meta  Name of meta file.
#'
#' @return Warnings and errors (if any).
#' @author Lars Relund \email{lars@@relund.dk}
checkMeta<-function(meta) {
   schema<-system.file("metaSchema.json", package = "MOrepoTools")
   jsonvalidate::json_validate(meta,schema, verbose = TRUE, error = TRUE)
}


#' Function of asking questions.
#'
#' @param ...  Question string.
#'
#' @return True if yes and false otherwise.
#' @author Lars Relund \email{lars@@relund.dk}
yesno<-function (...)
{
   yeses <- c("Yes", "Yup", "Yeah")
   nos <- c("No", "Nope")
   message(paste0(..., collapse = ""))
   qs <- c(sample(yeses, 1), sample(nos, 1))
   rand <- sample(length(qs))
   menu(qs[rand]) == which(rand == 1)
}


#' Check if a contribution convey with the guidelines.
#'
#' You must run this function in the root of your contribution.
#'
#' @author Lars Relund \email{lars@@relund.dk}
#' @export
checkContribution<-function() {
   message("Your working directory is ", getwd())
   if (!yesno("Is that the location of your contribution?")) {
      message("\n   Error: Change working directory!")
      return(invisible(FALSE))
   }

   # Encoding
   if (!yesno("\nAre files citation.bib and meta.json saved using encoding UTF-8?")) {
      message("\n   Error: You need to save them using UTF-8!")
      return(invisible(FALSE))
   }

   message("Checking meta file content ...", appendLF = FALSE)
   if (!file.exists("meta.json")) {
      message("\n   Error: You need to add a file meta.json!")
      return(invisible(FALSE))
   }
   checkMeta("meta.json")
   meta<-jsonlite::fromJSON("meta.json")
   if (meta$folder != sub("MOrepo-", "", basename(getwd()))) {
      message("\n   Error: The folder entry in meta.json is not equal the folder name of the contribution!")
      return(invisible(FALSE))
   }
   message(" ok.")

   if ("instances" %in% list.dirs(full.names = FALSE, recursive = FALSE)) {
      message("Your contribution contains test instances. ")
      if (!file.exists("instances/ReadMe.md")) {
         message("\n   Error: You need to add a file ReadMe.md in the instances folder!")
         return(invisible(FALSE))
      }

      message("Checking instance subfolders ...", appendLF = FALSE)
      # Subfolders for each file format
      if (!all(meta$instanceGroups$format[[1]] %in% list.dirs(path = "./instances", full.names = FALSE, recursive = FALSE))) {
         message("\n   Error: The instances folder must have a subfolder for each instance file format (",
                 paste0(meta$instanceGroups$format[[1]], collapse = ", "), ") specified in the meta.json file.")
         return(invisible(FALSE))
      }
      # Subfolders for each file format contains the same file names except file extension
      fRoot <- basename(list.files(path = "./instances/", recursive = FALSE, full.names = FALSE))
      f <- basename(list.files(path = "./instances/", recursive = TRUE, full.names = FALSE))
      f<-f[!(f %in% fRoot)]
      f <- sub("\\..*.$","",f)
      if (!all(data.frame(table(f))$Freq >= length(meta$instanceGroups$format[[1]]))) {
         message("\n   Error: The each instance file folder (",
                 paste0(meta$instanceGroups$format[[1]], collapse = ", "),
                 ") must contain the same file names (with different file extension).")
         return(invisible(FALSE))
      }
      # Subfolders for each instance group
      for (f in meta$instanceGroups$format[[1]]) {
         if (!all(list.dirs(paste0("./instances/",f), full.names = FALSE, recursive = FALSE) %in% meta$instanceGroups$subfolder)) {
            message("\n   Error: The folder ", f, " does not have subfolder(s) ",
                    paste0(meta$instanceGroups$subfolder, collapse = ", "), "!")
            return(invisible(FALSE))
         }
      }
      # Folder name used as prefix for all instances
      for (f in meta$instanceGroups$format[[1]]) {
         if (length(grep(meta$folder, basename(list.files(paste0("./instances/",f), recursive = TRUE)), invert = TRUE))>0) {
            message("\n   Error: Files in folder ", f, " must all start with prefix ", meta$folder, "!")
            return(invisible(FALSE))
         }
      }
      # Subfolder name contained in filename for all instances
      for (f in meta$instanceGroups$format[[1]]) {
         for (d in meta$instanceGroups$subfolder)
         if (length(grep(d, list.files(paste0("./instances/",f,"/",d)), invert = TRUE))>0) {
            message("\n   Error: Files in subfolder ", d, " must all contain ", d, "!")
            return(invisible(FALSE))
         }
      }
      # Only files with the file format suffix
      for (f in meta$instanceGroups$format[[1]]) {
         if (!all(f == tools::file_ext(basename(list.files(paste0("./instances/",f), recursive = TRUE))))) {
            message("\n   Error: All files in folder ", f, " must end with file suffix ", f, "!")
            return(invisible(FALSE))
         }
      }
      message(" ok.")
   }

   message("Checking for missing files ...", appendLF = FALSE)
   if (!file.exists("citation.bib")) {
      message("\n   Error: You need to add a file citation.bib!")
      return(invisible(FALSE))
   }
   if (!file.exists("ReadMe.md")) {
      message("\n   Error: You need to add a file ReadMe.md in the root!")
      return(invisible(FALSE))
   }
   message(" ok.")

   message("Checking citation.bib ...", appendLF = FALSE)
   RefManageR::ReadBib("citation.bib")
   message(" ok.")

   message("Everything seems to be okay :-)")
}
