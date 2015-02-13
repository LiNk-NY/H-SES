# National Health Interview Survey download script

# Load dependencies
library(RCurl)
library(SAScii)
library(foreign)

# Disable use of Internet Explorer for internet access
setInternet2(use=FALSE)

getNHISdata <- function(begin = 1986, finish = 2004, todir = NULL, docs = FALSE) {
        if(!is.numeric(begin)|!is.numeric(finish)){
                stop("Survey years must be four digit numbers!")
        } else if(begin < 1986 | finish > 2004){
                        stop("Years outside of survey collection period!")
                }
        linkedFTP <- "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/"
        listFiles <- getURL(linkedFTP, ftp.use.epsv = FALSE, dirlistonly = TRUE)
        datFiles <- strsplit(listFiles, "\r*\n")
        datFiles <- tolower(unlist(lapply(datFiles, function(x){grep("NHIS", x, value=TRUE)})))
        #removing unmodified 1992 file due to oversampling of Hispanics in 1992 - MOD file is appropriate
        datFiles <- datFiles[-grep("nhis92_mort", datFiles)]
        
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
                        destfile = file.path(todir, "nhis_readme_mortality_2010.txt"), method="auto", quiet = FALSE)
        }
        # simple check for valid years
        if(identical(begin, finish)){
                        dfile <- grep(paste0("NHIS", substr(begin,3,4)), datFiles, value=TRUE)
                        download.file(paste0(linkedFTP,dfile), destfile = file.path(todir, dfile), method = "auto", quiet = FALSE)
                } else {
                yrs <- sapply(seq(begin, finish, by=1), function(x){paste0(substr(x,3,4),"_")})
                dlnames <- datFiles[sapply(yrs, function(x){grep(x, datFiles)})]
                for (i in 1:length(dlnames)){
                        download.file(paste0(linkedFTP,dlnames[i]), destfile = file.path(todir, dlnames[i]), method="auto", quiet = FALSE)
                }
               }
}