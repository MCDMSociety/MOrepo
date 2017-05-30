# files must be UTF-8 (ask for it)
#


checkMeta<-function(meta) {
   schema<-system.file("metaSchema.json", package = "MOrepoTools")
   jsonvalidate::json_validate(meta,schema, verbose = TRUE, error = TRUE)
}


yesno<-function (...)
{
   yeses <- c("Yes", "Yup", "Yeah")
   nos <- c("No", "Nope")
   message(paste0(..., collapse = ""))
   qs <- c(sample(yeses, 1), sample(nos, 1))
   rand <- sample(length(qs))
   menu(qs[rand]) == which(rand == 1)
}


checkContribution<-function() {
   # message("Your working directory is ", getwd())
   # if (!yesno("Is that the location of your contribution?")) {
   #    message("\n   Error: Change working directory!")
   #    return(invisible(FALSE))
   # }
   #
   # # Encoding
   # if (!yesno("\nAre files citation.bib and meta.json saved using encoding UTF-8?")) {
   #    message("\n   Error: You need to save them using UTF-8!")
   #    return(invisible(FALSE))
   # }

   message("Checking meta file content ...", appendLF = FALSE)
   if (!file.exists("meta.json")) {
      message("\n   Error: You need to add a file meta.json!")
      return(invisible(FALSE))
   }
   checkMeta("meta.json")
   meta<-jsonlite::fromJSON("meta.json")
   if (meta$folder != basename(getwd())) {
      message("\n   Error: The folder entry in meta.json is not equal the folder name of the contribution!")
      return(invisible(FALSE))
   }
   message(" ok.")

   message("Checking instance subfolders ...", appendLF = FALSE)
   # Subfolders for each file format
   if (!all(meta$instanceGroups$format[[1]] %in% list.dirs(full.names = FALSE, recursive = FALSE))) {
      message("\n   Error: Your contribution must have a subfolder for each instance file format (",
              paste0(meta$instanceGroups$format[[1]], collapse = ", "), ").")
      return(invisible(FALSE))
   }
   # Subfolders for each instance group
   for (f in meta$instanceGroups$format[[1]]) {
      if (!all(list.dirs(f, full.names = FALSE, recursive = FALSE) %in% meta$instanceGroups$subfolder)) {
         message("\n   Error: The folder ", f, " does not have subfolder(s) ",
                 paste0(meta$instanceGroups$subfolder, collapse = ", "), "!")
         return(invisible(FALSE))
      }
   }
   # Folder name used as prefix for all instances
   for (f in meta$instanceGroups$format[[1]]) {
      if (length(grep(meta$folder, basename(list.files(f, recursive = TRUE)), invert = TRUE))>0) {
         message("\n   Error: Files in folder ", f, " must all start with prefix ", meta$folder, "!")
         return(invisible(FALSE))
      }
   }
   # Only files with the file format suffix
   for (f in meta$instanceGroups$format[[1]]) {
      if (!all(f == tools::file_ext(basename(list.files(f, recursive = TRUE))))) {
         message("\n   Error: Files in folder ", f, " must end with file suffix ", f, "!")
         return(invisible(FALSE))
      }
   }
   message(" ok.")

   message("Checking for missing files ...", appendLF = FALSE)
   if (!file.exists("citation.bib")) {
      message("\n   Error: You need to add a file citation.bib!")
      return(invisible(FALSE))
   }
   if (!file.exists("ReadMe.md")) {
      message("\n   Error: You need to add a file ReadMe.md!")
      return(invisible(FALSE))
   }
   message(" ok.")

   message("Checking for citation.bib ...", appendLF = FALSE)
   RefManageR::ReadBib("citation.bib")
   message(" ok.")

   message("Everything seems to be okay :-)")
}
