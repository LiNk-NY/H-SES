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
listFiles <- getURL(linkedFTP, ftp.use.epsv = FALSE, dirlistonly = TRUE)
listFiles <- unlist(strsplit(listFiles, "\r*\n"))

# Files were moved # 
# datFiles <- tolower(unlist(lapply(listFiles, function(x){grep("NHIS", x, value=TRUE)})))
begin <- 1986
finish <- 2004
yrs <- seq(begin, finish, 1)
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
                for (i in 1:length(dlnames)){
                        download.file(paste0(linkedFTP,dlnames[i]), destfile = file.path(todir, dlnames[i]), method="auto", quiet = FALSE)
                }
               }
        return(todir)
}
# read sample file
readNHIS <- function(fromdir = todir){
        #sasFile <- listFiles[grep("sas-read", listFiles, ignore.case=TRUE)]
        sasprog <- "../H-SES/sasread/nhisreadin.sas"
        
        mdat2 <- read.SAScii(file.path(fromdir, "nhis_1999_mort_2013_public.dat"),sasprog, beginline=1)
        md <- subset(mdat, mdat$ELIGSTAT == 1)
        
}


getNHISdata <- function(begin = 1986, finish = 2004, todir = NULL){
        dataNHIS <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/"

        for(i in 1:length(yrs))
        if(yrs[i] %in% 1990:1996){
                lf <- getURL(paste0(dataNHIS, "1990-96_Family_Income/"),ftp.use.epsv = FALSE, dirlistonly = TRUE )
                lf <- unlist(strsplit(lf, "\r*\n"))
                lf <- grep("[^\\.txt]$", lf, value=TRUE)
        }
inco <- list()
for( i in 1:length(lf)){
        cachefile <- file.path(fromdir, grep(paste0(gsub(".zip","",lf[i],ignore.case=TRUE),".dat"), 
                                             dir(todir), ignore.case=TRUE, value=TRUE))        
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




codeLink <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Program_Code/NHIS/"
nhisyrs <- paste0(codeLink, yrs, "/")
saslist <- list()
for (j in seq(length(nhisyrs)-1)){
saslist[[j]] <- lapply(nhisyrs[j], FUN=function(link){tolower(strsplit(getURL(link, dirlistonly=TRUE), "\r*\n")[[1]])})        
}
lapply(saslist, FUN=function(sassy){grep("\\.sas", sassy, value=TRUE, ignore.case=TRUE)})

getprogsasfiles <- function(address, years, lists=TRUE){
        links <- paste0(codeLink, years, "/")
        filelists <- list()
        for(jj in 1:length(links)){
        filelists[[jj]] <- lapply(links[jj], FUN = function(link) {tolower(strsplit(getURL(link, dirlistonly=lists), "\r*\n")[[1]])})
        }
        return(filelists)
}

tolower(strsplit(getURL(file.path(codeLink, "2004", unlist(ab[[19]])[1]), dirlistonly=TRUE), "\r*\n")[[1]])
       
       c("person", "household", "familyfile")
sasref <- lapply(saslist, FUN=function(year){grep("\\.sas", year, ignore.case=TRUE, value=TRUE)})








dataFiles <- getURL(dataNHIS, ftp.use.epsv = FALSE, dirlistonly = TRUE)
dataFiles <- unlist(strsplit(dataFiles, "\r*\n"))
dataFiles1 <- sapply(yrs, function(x) {grep(x, dataFiles, fixed=TRUE, value=TRUE)})

inc <- sapply(dataFiles1, FUN=function(files){ grep("income", files,ignore.case=TRUE, value=TRUE) })

imps <- substr(grep("imputed", dataFiles, value=T), 3,4)
subimp <- imps[imps %in% yrs1]


sasRead <- "../H-SES/sasread/nhisreadin.sas"
op <- read.SAScii(file.path("~/Capstone FW SPH/Capstone/data", "nhis_2000_mort_2013_public.dat"), sasRead) 

sasRead[2:22]
