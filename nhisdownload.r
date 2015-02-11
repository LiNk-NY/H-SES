# National Health Interview Survey download script

# Load dependencies
library(RCurl)
library(SAScii)
library(foreign)

# Disable use of Internet Explorer for internet access
setInternet2(use=FALSE)

# Change working directory for data download
setwd("~/Capstone FW SPH/Capstone/Data/Rdownload/")

todir <- getwd()

getNHISdata <- (start = 1986, end = 2004, todir = NULL, docs = FALSE) {
        linkedFTP <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/"
        # check directory path and create if non-existent
        if(!is.null(todir)){
                if(!class(todir)=="character"){
                        stop("Please enter a valid directory path!")
                } else if(!file.exists(todir)){
                        cat("Directory does not exist >> creating one...")
                        dir.create(todir, recursive=TRUE)
                }
                if(!grepl("\\/$", todir)){
                        todir <- paste(todir,"/",sep="")
                }
        } else {
                todir <- getwd()
                }
        # download documentation if TRUE
        if(docs){
                download.file(paste0(linkedFTP,"nhis_readme_mortality_2010.txt"), 
                        destfile=paste0(todir,"/","nhis_readme_mortality_2010.txt"), method="auto", quiet = FALSE)
        }
        # simple check for valid years
        if(start < 1986 | end > 2004){
                stop("Year outside of collection boundary")
        } else {
                listFiles <- 
        }
}


