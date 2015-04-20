# National Health Interview Survey download script
setwd("~/Capstone FW SPH/Capstone/H-SES/")
fromdir <- "~/Capstone FW SPH/Capstone/data"
todir <- fromdir

# Load dependencies
library(RCurl)
library(SAScii)
library(foreign)
library(data.table)
library(downloader)
# devtools::install_github("hadley/readr")
# Disable use of Internet Explorer for internet access
setInternet2(use=FALSE)

linkedFTP <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/"
# listFiles <- getURL(linkedFTP, ftp.use.epsv = FALSE, dirlistonly = TRUE)
# listFiles <- unlist(strsplit(listFiles, "\r*\n"))

# Files were moved # 
# datFiles <- tolower(unlist(lapply(listFiles, function(x){grep("NHIS", x, value=TRUE)})))

years <- seq(1986, 2004)
#exclude 2004
years <- years[-length(years)]
dataNHIS <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/"
# dlnames <- datFiles[sapply(yrs, function(x){grep(x, datFiles)})]


#' Download NHIS data from the CDC FTP site. 
#' @param begin integer
#' @param finish integer
#' @param todir character vector
#' @param docs logical
#' @export
#' @examples
#' getlinkedNHIS(begin=1990, finish=2000, todir = "./mydirectory", docs = TRUE)
getlinkedNHIS <- function(begin = 1986, finish = 2004, todir = NULL, docs = FALSE) {
        yrs <- seq(begin, finish, by=1)
        if(!is.numeric(begin)|!is.numeric(finish)){
                stop("Survey years must be four digit numbers!")
        } else if(begin < 1986 | finish > 2004){
                        stop("Years outside of survey collection period!")
                }
        # check directory path and create if non-existent
        if(!is.null(todir)){
                if(!class(todir)=="character"){
                        stop("Please enter a valid directory path!")
                } else if(!file.exists(file.path(todir))){
                        cat("Directory does not exist >> creating one...")
                        dir.create(todir, recursive=TRUE)
                }
                
        } else { todir <- getwd() }
        # download documentation if TRUE
        if(docs){
                download.file(file.path(linkedFTP,"archived_files","nhis_readme_mortality_2010.txt"), 
                        destfile = file.path(todir, "nhis_readme_mortality_2010.txt"), method="auto", mode="wb", quiet = FALSE)
        }
        # simple check for valid years
        if(identical(begin, finish)){
                        dfile <- grep(begin, datFiles, value=TRUE)
                        download.file(paste0(linkedFTP,dfile), destfile = file.path(todir, dfile), method = "auto", quiet = FALSE)
                } else {
                for (i in seq(dlnames)){
                        download.file(paste0(linkedFTP,dlnames[i]), destfile = file.path(todir, dlnames[i]), method="auto", quiet = FALSE)
                }
               }
        return(todir)
}


# NHIS Data ---------------------------------------------------------------

getNHISdata <- function(begin = 1986, finish = 2004, todir = NULL){
        dataNHIS <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/"

        for(i in seq(years))
        if(years[i] %in% 1990:1996){
                lf1 <- getURL(paste0(dataNHIS, "1990-96_Family_Income/"),ftp.use.epsv = FALSE, dirlistonly = TRUE )
                lf1 <- unlist(strsplit(lf1, "\r*\n"))
                lf1 <- grep("[^\\.txt]$", lf1, value=TRUE)
        } else if(years[i] %in% 1997:2004){
                lf2 <- inc[grep("9[7-9]_|0[0-4]_", inc)]
                lflinks <- paste0(dataNHIS, lf2, "/")
                files <- lapply(lflinks, FUN= function(y){ getURL(y, ftp.use.epsv=FALSE, dirlistonly=TRUE)})
                files <- lapply(files, FUN = function(y) {unlist(strsplit(y, "\r*\n"))})
                files <- lapply(files, "[", c(1:2))
        }
inco <- list()
for( i in seq(lf1)){
        cachefile <- file.path(fromdir, "Faminc/", grep(paste0(gsub(".zip","",lf1[i],ignore.case=TRUE),".dat"), 
                                             dir(file.path(todir, "Faminc/")), ignore.case=TRUE, value=TRUE))        
        if(file.exists(cachefile) & file.info(cachefile) > 0){
        message("Loading downloaded files...")
        inco[[i]] <- read.SAScii(cachefile, # insert read in SAS prog #)
        } else {
        download(url=paste0(dataNHIS, "1990-96_Family_Income/", lf[i]), 
                      destfile = file.path(todir, lf[i]), mode="wb", quiet = FALSE)
        unzip(file.path(fromdir, lf[i]), exdir=file.path(fromdir))
        file.remove(file.path(fromdir,lf[i]))
        inco[[i]] <- read.SAScii(cachefile, # insert read in SAS prog #)
        inco <- lapply(inco, FUN=function(year){ year <- subset(year, year$ELIGSTAT == 1) })                
                }
        }
        
} # function close


# SAS Program Files -------------------------------------------------------

linked <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Program_Code/NHIS/"

readFiles <- function(linked, years=NULL, lists=TRUE){
        if(is.null(years)){
                links <- linked
        } else if(is.numeric(years)) {
        links <- paste0(linked, years, "/")
        } else {
                stop("Please provide numeric years!")
        }
        
        filelists <- list()
        for(jj in seq(links)){
        filelists[jj] <- lapply(links[jj], FUN = function(link) {tolower(strsplit(getURL(link, dirlistonly=lists), "\r*\n")[[1]])})
        }
        return(filelists)
}

saslist <- readFiles(linked, years)

saslist2 <- lapply(saslist, FUN=function(sassy){grep("\\.sas", sassy, value=TRUE, ignore.case=TRUE)})

tomatch <- c("person", "health", "household", "family", "samadult", "accessxx")
saslist3 <- lapply(saslist2, FUN=function(sassy){grep(paste(tomatch, collapse="|"), sassy, value=TRUE, ignore.case=TRUE)})

#2004 

sapply(years, FUN= function(var) {dir.create(file.path(todir, var))})

# downloading files
for (i in seq(years)){
lapply(saslist3[[i]], FUN= function(file) { download(paste(linked, years[i], file, sep="/"), destfile=paste(todir, years[i], file, sep="/"), mode="wb", quiet=FALSE)})
}

# 2004
prog04 <- readFiles(linked, 2004)
progdirs <- grep(paste(tomatch, collapse="|"), unlist(prog04), value=TRUE)
proglinks <- file.path(linked, 2004, progdirs, "/")
progfiles <- unlist(lapply(proglinks, readFiles))
progfiles <- grep("\\.sas", progfiles, value=TRUE)
dlprogs <- paste0(proglinks, progfiles)

for(l in seq(dlprogs)){
        download(url=dlprogs[l], destfile=paste(2004, progfiles[l], sep="/"), mode="wb", quiet=FALSE)
}


# Data Files --------------------------------------------------------------

dataFold <- getURL(dataNHIS, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf=TRUE)
dataFold <- unlist(strsplit(dataFold, "\r*\n"))
dataFolders <- sapply(years, function(x) {grep(x, dataFold, fixed=TRUE, value=TRUE)})


yearfolders <- lapply(dataFolders, FUN=function(x){grep("[0-9]{4}$", x, value=TRUE)})
exefiles <- readFiles(dataNHIS, as.numeric(unlist(yearfolders)))
exefiles2 <- lapply(exefiles, FUN=function(exec){grep(paste(tomatch, collapse="|"), exec, value=TRUE, ignore.case=TRUE)})

dlinks <- lapply(seq(yearfolders), FUN= function(x){ paste0(dataNHIS, yearfolders[x], "/", unlist(exefiles2[x]))})


destinations <- paste0(todir, unlist(lapply(strsplit(unlist(dlinks), "NHIS"), "[", 2)))
for(j in seq(unlist(dlinks))){
        download(url=unlist(dlinks)[j], destfile = destinations[j], mode="wb", quiet=FALSE)
}

# 2004 

oneout <- readFiles(dataNHIS, 2004)
oneoutdirs <- grep(paste(tomatch, collapse="|"), unlist(oneout), value=TRUE)
oneoutlinks <- file.path(dataNHIS, 2004, oneoutdirs, "/")
files4 <- unlist(lapply(oneoutlinks, readFiles))
dllinks <- paste0(oneoutlinks, files4)

for (l in seq(dllinks)){
        download(url=dllinks[l], destfile=paste(2004, files4[l], sep="/"), mode="wb", quiet=FALSE)
}


# Income Files ------------------------------------------------------------

svyyrs <- c(years, 2004)
inc <- grep("income", dataFold, ignore.case=TRUE, value=TRUE)
inc <- grep(paste(paste0(substr(svyyrs, 3, 4), "_"), collapse="|"), inc, value=TRUE)
inc1 <- inc[!grepl("94_|96_I", inc, ignore.case=TRUE)]
inc2 <- inc[grepl("94_|96_I", inc, ignore.case=TRUE)]

inclinks1 <- paste0(dataNHIS, inc1, "/")
inclinks2 <- paste0(dataNHIS, inc2, "/")
# handle first line differently
inclinks1 <- inclinks1[-1]

inclinks3 <- sort(rep(inclinks1,2))

incomefiles <- readFiles(inclinks1)
incomefiles <- lapply(incomefiles, "[", c(1:2))
names(incomefiles) <- seq(1997, 2004)

dlinksinc <- paste0(inclinks3, unlist(incomefiles))

dir.create(file.path("./2004/"))

for (k in seq(dlinksinc)){
        download(url=dlinksinc[k], destfile=file.path(todir, sort(rep(seq(1997,2004),2))[k], "/", unlist(incomefiles)[k]), mode="wb", quiet=FALSE) 
}


