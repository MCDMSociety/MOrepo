# Notes for admin

To update MOrepo with a new contribution do

   1) Check the new contribution using `MOrepoTools::checkContribution()`.
   2) Add the contribution to the json file `contributions.json`.
   3) If a contribution has changed then modify `contributions.json`, e.g. with a space (so can commit).
   4) Push to GitHub and GitHub actions should do the rest.

library(gh)
my_repos <- gh::gh("GET /users/{username}/repos", username = "relund")
vapply(my_repos, "[[", "", "name")

