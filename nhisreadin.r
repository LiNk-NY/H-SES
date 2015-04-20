# Loading mortality data from file
library(SAScii)
library(readr)
setwd("~/Capstone FW SPH/Capstone/data/")
todir <- getwd()
fromdir <- todir

begin <- 1986
finish <- 2004
yrs <- seq(begin, finish, 1)

readNHIS <- function(fromdir = NULL){
        sasprog <- "../H-SES/sasread/nhisreadin.sas"
        sas.import <- readLines(sasprog)
        sas.import.tf <- tempfile()
        writeLines(sas.import, con=sas.import.tf)
        dimensions <- parse.SAScii(sas.import.tf)
        dimensions <- dimensions[complete.cases(dimensions),]
        colos <- fwf_widths(dimensions[,2], dimensions[,1])
        
        mortfiles <- file.path(fromdir, grep("public\\.dat$", dir(), value=TRUE))
        mortdat <- list()
        for (i in 1:length(mortfiles)){
        mortdat[[i]] <- read_fwf(mortfiles[i], colos)
        }
        mortdat2 <- lapply(mortdat, FUN= function(dataset) { dataset <- subset(dataset, dataset$ELIGSTAT == 1)})
        mortdat3 <- lapply(seq(length(mortdat2)), FUN= function(dataset){ cbind(mortdat2[[dataset]], YEAR = yrs[[dataset]]) })
        return(mortdat3)
}

readNHISfiles <- function(sasfile, datafile){
        
        sas.import <- readLines(sasfile)
        sas_start <- grep("INPUT ALL VARIABLES", sas.import)+1
        sas.import.tf <- tempfile()
        writeLines(sas.import, con=sas.import.tf)
        dimensions <- parse.SAScii(sas.import.tf, beginline = sas_start)
        dimensions <- dimensions[complete.cases(dimensions),]
        colos <- fwf_widths(dimensions[,2], dimensions[,1])
        
        output <- read_fwf(datafile, colos)
        return(output)
}

sas.import <- readLines(sasfiles[1])
sas_start <- grep("INPUT ALL VARIABLES", sas.import)+1
sas.import.tf <- tempfile()
writeLines(sas.import, con=sas.import.tf)
dimensions <- parse.SAScii(sas.import.tf, beginline = sas_start)
dimensions <- dimensions[complete.cases(dimensions),]
colos <- fwf_widths(dimensions[,2], dimensions[,1])
read.SAScii(exefiles[1], sas.import.tf, zipped=TRUE)
#output <- read_fwf(datafile, colos)
return(output)

mydata <- readNHIS(todir)

library(data.table)
mydata2 <- rbindlist(mydata)

# apply manual formats

sasprog <- "../H-SES/sasread/nhisreadin.sas"
readLines(sasprog)

mydata2$ELIGSTAT <- factor(mydata2$ELIGSTAT, levels=c(1,2,3), labels=c("Eligible", "Under18", "Ineligible"))
mydata2$MORTSTAT <- factor(mydata2$MORTSTAT, levels=c(0,1), labels=c("Assumed alive", "Assumed deceased"))
options(scipen=999)
setkey(mydata2, PUBLICID)




mydirs <- file.path(todir, grep("[0-9]{4}", dir(todir), value=TRUE))

for (j in seq(mydirs)){
        exefiles <- paste(mydirs[j], grep("\\.exe", dir(mydirs[j]), value=TRUE), sep="/")
        sasfiles <- paste(mydirs[j], grep("\\.sas", dir(mydirs[j]), value=TRUE), sep="/")
        myresult <- lapply(seq(exefiles), function(y) {readNHISfiles(sasfile = sasfiles[y], datafile = exefiles[y])} )
}




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
