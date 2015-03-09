# National Health Interview Survey download script

# Load dependencies
library(RCurl)
library(SAScii)
library(foreign)
library(data.table)

# Disable use of Internet Explorer for internet access
setInternet2(use=FALSE)

linkedFTP <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/"
listFiles <- getURL(linkedFTP, ftp.use.epsv = FALSE, dirlistonly = TRUE)
listFiles <- unlist(strsplit(listFiles, "\r*\n"))
datFiles <- tolower(unlist(lapply(listFiles, function(x){grep("NHIS", x, value=TRUE)})))
# removing unmodified 1992 file due to oversampling of Hispanics in 1992 - MOD file is appropriate
# datFiles <- datFiles[!grepl("nhis92_mort", datFiles)]
# yrs <- sapply(seq(begin, finish, by=1), function(x){paste0(substr(x,3,4),"_")})
yrs <- seq(begin, finish, by=)
dlnames <- datFiles[sapply(yrs, function(x){grep(x, datFiles)})]


#' Download NHIS data from the CDC FTP site. 
#' @param begin integer
#' @param finish integer
#' @param todir character vector
#' @param docs logical
#' @export
#' @examples
#' getNHISdata(begin=1990, finish=2000, todir = "./mydirectory", docs = TRUE)
getNHISdata <- function(begin = 1986, finish = 2004, todir = NULL, docs = FALSE) {
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
                download.file(paste0(linkedFTP,"archived_files","nhis_readme_mortality_2010.txt"), 
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
procNHIS <- function(fromdir = todir){
        sasFile <- listFiles[grep("sas-read", listFiles, ignore.case=TRUE)]
        sasciistart <- grep("INPUT VARIABLES", readLines(paste0(linkedFTP, sasFile))) + 1
        mdat <- read.SAScii(file.path(fromdir, "nhis_2000_mort_2013_public.dat"),paste0(linkedFTP, sasFile), beginline = sasciistart )
        names(mdat) <- tolower(names(mdat))
        md <- subset(mdat, eligstat == 1)
        
}


dataNHIS <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/"
dataFiles <- getURL(dataNHIS, ftp.use.epsv = FALSE, dirlistonly = TRUE)
dataFiles <- unlist(strsplit(dataFiles, "\r*\n"))
dataFiles1 <- sapply(yrs, function(x) {grep(x, dataFiles, fixed=TRUE, value=TRUE)})
inc <- sapply(dataFiles1, FUN=function(files){ grep("income", files,ignore.case=TRUE, value=TRUE) })

imps <- substr(grep("imputed", dataFiles, value=T), 3,4)
subimp <- imps[imps %in% yrs1]


