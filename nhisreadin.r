# Loading mortality data from file
library(SAScii)
setwd("~/Capstone FW SPH/Capstone/data/")
todir <- getwd()
fromdir <- todir

begin <- 1986
finish <- 2004
yrs <- seq(begin, finish, 1)

readNHIS <- function(fromdir = todir){
        sasprog <- "../H-SES/sasread/nhisreadin.sas"
        mortfiles <- file.path(fromdir, grep("public\\.dat$", dir(), value=TRUE))
        mortdat <- list()
        for (i in 1:length(mortfiles)){
        mortdat[[i]] <- read.SAScii(mortfiles[i], sasprog, beginline=1)
        }
        mortdat2 <- lapply(mortdat, FUN= function(dataset) { dataset <- subset(dataset, dataset$ELIGSTAT == 1)})
        mortdat3 <- lapply(seq(length(mortdat2)), FUN= function(dataset){ cbind(mortdat2[[dataset]], YEAR = yrs[[dataset]]) })
}

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
