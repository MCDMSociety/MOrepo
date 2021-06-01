library(MOrepoTools)
MOrepoTools:::setMetaContributions()
for(i in 1:10){
   try({
      MOrepoTools:::setMetaInstances()
      break
   }, silent = FALSE)
}

## rename/move files
a <- list.files(path = "./instances/", pattern = "*$_*$", recursive = T, full.names = T)
b <- basename(a)
b <- sub("biap","",b)
b <- sub("_0","",b)
b <- sub(".xml","",b)
b<-paste0("./instances/xml/Tuyttens_AP_n",b,".xml")
file.rename(a,b)



## add 0 to file names
a <- list.files(path = "./raw", pattern = "*._p[:digit:]*._..raw", recursive = T, full.names = T)
b<-sapply(a, FUN=function(x) {
   m <- regexpr("p.", x)
   y <- regmatches(x, m)
   y <- paste0("p", sprintf("%02d", as.numeric(substr(y,2,2))))
   sub('p.', y, x)
})
file.rename(a,b)



## rename/move files
a <- list.files(path = "results", pattern = ".*Pedersen08_.*_._result.json$", recursive = T, full.names = T)
b <- sub("(*)_(.)_(result*..json)$","\\1_0\\2_\\3",a)
file.rename(a,b)




a <- list.files(path = "results", pattern = "non", recursive = T, full.names = T)
b <- sub("(.*)/(.*.json)$","\\1/Pedersen08_\\2",a)
file.rename(a,b)







