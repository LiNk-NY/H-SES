# merging datasets NHIS
library(pipeR)
library(dplyr)
#setwd("/media/mr148/MR_USB30//Capstone/datanew/")
setwd("~/Capstone FW SPH/Capstone/datanew/")
tomatch <- paste("person", "house", "family", "samadult", "access", "incimp", sep="|")
yrs <- as.character(2003:1998)
lapply(yrs, dir) %>>% lapply(FUN= function(file) {grep("\\.rda", file, value=TRUE)}) %>>%
  lapply(FUN = function(files) {grep(tomatch, files, value=TRUE)}) -> datalist
names(datalist) <- yrs

filenames <- file.path(sort(rep(yrs, 5), decreasing=TRUE), unlist(datalist))

for (j in filenames){
  load(j)
}


data03 <- lapply(grep("NHIS.03", ls(), value=TRUE), get)
names(data03) <- grep("NHIS.03", ls(), value=TRUE)
# dataprep <- lapply(data98, FUN= function(cc) { cc$newid <- paste(cc$hhx, cc$px)})
# combine ID check mortality file for ID

housefam <- data03[c("NHIS.03.househld.df", "NHIS.03.familyxx.df")]
housefam <- Reduce(function(...) merge(..., by="hhx", all=TRUE), housefam)

persadult <- data03[c("NHIS.03.personsx.df", "NHIS.03.samadult.df")]
for (j in seq(length(persadult))){
persadult[[j]]$newid <- sapply(persadult[j], FUN = function(cc){ paste0(cc$hhx, cc$px) })
}
persadult <- Reduce(function(...) merge(..., by="newid", all=TRUE), persadult)

merged <- Reduce(function(...) merge(..., by="hhx", all=TRUE), data98)




# Adult Sample ------------------------------------------------------------

adultsamp <- lapply(grep("samadult", ls(), value=TRUE), get)
for (j in seq(length(adultsamp))){
        adultsamp[[j]]$ID <- sapply(adultsamp[j], FUN = function(datas){ paste0(datas$srvy_yr, datas$hhx, datas$px)})
}

namedlist <- lapply(adultsamp, names)

common <- NULL
a <- 2
for (i in 1:4){
       
if(is.null(common)){
        common <- intersect(namedlist[[1]], namedlist[[2]])
}
a <- a + 1
common <- intersect(common, namedlist[[a]])
}
common <- sort(common)

for(b in seq(length(adultsamp))){
adultsamp[[b]] <- adultsamp[[b]][,names(adultsamp[[b]]) %in% common]
}

lapply(adultsamp, names) %>>% lapply(FUN=sort)

svydata <- do.call(rbind, adultsamp)
#svydata[na.omit(match(mortdata$PUBLICID, svydata$ID)),]

finaldata <- merge(svydata, mortdata, by.x="ID", by.y="PUBLICID")

cbind(svydata, mortdata[, ""])