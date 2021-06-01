### Steps for updating the repository when new contributions arrive

## Update the metaContributions.json on GitHub with the new repo name in entry "repos"
MOrepoTools:::setMetaContributions()

## Update meta file with instances
MOrepoTools:::setMetaInstances()    # May get a Http 403 error!

## Knit ReadMe and push to GitHub
#rmarkdown::render("ReadMe.Rmd", output_format = "github_document", output_file = "ReadMe.md")

