# Loading mortality data from file
# setwd("/media/mr148/MR_USB30/Capstone/datanew/")
library(SAScii)
library(readr)
mortloc <- "/media/mr148/MR_USB30/Capstone/data/Mortality/"
mortloc <- "~/Capstone FW SPH/Capstone/data/Mortality/"
readNHIS <- function(fromdir = NULL, mortyrs = 1998:2003){
        sasprog <- "../H-SES/sasread/nhisreadin.sas"
        sas.import <- readLines(sasprog)
        sas.import.tf <- tempfile()
        writeLines(sas.import, con=sas.import.tf)
        dimensions <- parse.SAScii(sas.import.tf)
        dimensions <- dimensions[complete.cases(dimensions),]
        colos <- fwf_widths(dimensions[,2], dimensions[,1])
        neededyrs <- paste0(mortyrs, collapse="|")
        mortfiles <- file.path(fromdir, grep(pattern=neededyrs, dir(fromdir), value=TRUE))
        mortdat <- list()
        for (i in 1:length(mortfiles)){
        mortdat[[i]] <- read_fwf(mortfiles[i], colos)
        }
        return(mortdat)
}
mymorts <- readNHIS(mortloc)

for (j in seq(length(mymorts))){
  mymorts[[j]]$PUBLICID <- sapply(mymorts[j], FUN = function(datas) { gsub("\r\n", "", datas$PUBLICID, fixed=TRUE)})
  mymorts[[j]]$YEAR <- sapply(mymorts[j], FUN = function(dff) {substr(dff$PUBLICID, 1,4)})
  #mymorts[[j]]$PUBLICID <- sapply(mymorts[j], FUN = function(datas) { gsub("^[0-9]{4}", "", datas$PUBLICID, perl=TRUE)})
}
options(scipen=999)

mortdata <- do.call(rbind, mymorts)
mortdata <- as.data.frame(mortdata, stringsAsFactors=FALSE)
mortdata <- subset(mortdata, mortdata$ELIGSTAT == 1)
mortdata$ELIGSTAT <- factor(mortdata$ELIGSTAT, levels=c(1), labels=c("Eligible"))
# mortdata$MORTSTAT <- factor(mortdata$MORTSTAT, levels=c(0,1), labels=c("Assumed alive", "Assumed deceased"))
mortdata$PUBLICID <- as.numeric(mortdata$PUBLICID)
mortdata$YEAR <- as.numeric(mortdata$YEAR)
mortdata$yrsalive <- with(mortdata, DODYEAR - YEAR)


mortdata <- subset(mortdata, select=c("PUBLICID", "MORTSTAT", "DODYEAR", "SA_WGT_NEW", "YEAR", "yrsalive"))



# mortdat2 <- lapply(mortdat, FUN= function(dataset) { dataset <- subset(dataset, dataset$ELIGSTAT == 1)})
# mortdat3 <- lapply(seq(length(mortdat2)), FUN= function(dataset){ cbind(mortdat2[[dataset]], YEAR = yrs[[dataset]]) })
mydirs <- file.path(todir, grep("[0-9]{4}", dir(todir), value=TRUE))

for (j in seq(mydirs)){
        exefiles <- paste(mydirs[j], grep("\\.exe", dir(mydirs[j]), value=TRUE), sep="/")
        sasfiles <- paste(mydirs[j], grep("\\.sas", dir(mydirs[j]), value=TRUE), sep="/")
        myresult <- lapply(seq(exefiles), function(y) {readNHISfiles(sasfile = sasfiles[y], datafile = exefiles[y])} )
}


readNHISfiles <- function(sasfile, datafile){
        datafile.tf <- tempfile()
        writeLines(datafile, con=datafile.tf)
        
        sas.import <- readLines(sasfile)
        sas_start <- grep("INPUT ALL VARIABLES", sas.import)+1        
        sas.import.tf <- tempfile()
        writeLines(sas.import, con=sas.import.tf)
        output <- read.SAScii(datafile.tf, sas.import.tf, zipped=TRUE, beginline = sas_start)
        
        #dimensions <- parse.SAScii(sas.import.tf, beginline = sas_start)
        #dimensions <- dimensions[complete.cases(dimensions),]
        #colos <- fwf_widths(dimensions[,2]+1, dimensions[,1])
        
        #output <- read_fwf(datafile, colos)
        return(output)
}
exe.tf <- tempfile()
writeLines(exes[[1]], con=exe.tf)

sas.import <- readLines(esses[[1]])
sas_start <- grep("INPUT ALL VARIABLES", sas.import)+1
sas.import.tf <- tempfile()
writeLines(sas.import, con=sas.import.tf)
output <- read.SAScii(exes[[1]], sas.import.tf, beginline= sas_start, lrecl=35)


return(output)

mydata <- readNHIS(todir)

library(data.table)
mydata2 <- rbindlist(mydata)

# apply manual formats






# Applying Formats --------------------------------------------------------

formatR <- function(data){
        a <- grep("VALUE", readLines(sasprog), value=TRUE)
        a <- gsub(" ", "", sapply(strsplit(a, "VALUE"), "[", 2))
        b <- grep("[\\.]$", readLines(sasprog), value=TRUE)
        cols <- gsub(" ", "", sapply(strsplit(b, "\t"), "[", 2))
        lastfmt <- sapply(strsplit(b, "\t"), FUN= function(x){length(x)}) 
        fmts <- c()
        for (i in 1:length(lastfmt)){
                fmts <- rbind(fmts, sapply(strsplit(b[i], "\t"), "[", lastfmt[i]))
        }
        fmts <- gsub("\\.", "", fmts)
        fmts <- as.character(fmts)
        sasfmt <- cbind(cols, fmts)
        
        
        filecon <- file("sasprog", open="rt")
        chunksize <- 4 
        nchunks <- nrow(sasfmt) 
        for (i in 1:nchunks){
                chunk<-readLines(inputfile, n=grep("PROC FORMAT", readLines(sasprog))[1])
                # process this block
        }
        
        
        for (block in 1:nblocks) { 
                x <- readLines(ff, n=121) 
                # process this block 
        } 
        
        
        while(readLines(progsas)!=""){
                readLines(progsas)
        }
        
        readLines(sasprog, begin)
}
