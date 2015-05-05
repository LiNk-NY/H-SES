# merging datasets NHIS
library(pipeR)
library(dplyr)

# setwd("/media/mr148/MR_USB30//Capstone/datanew/")
setwd("~/Capstone FW SPH/Capstone/datanew/")
tomatch <- paste("person", "house", "family", "samadult", sep="|")
yrs <- as.character(2003:1998)
lapply(yrs, dir) %>>% lapply(FUN= function(file) {grep("\\.rda", file, value=TRUE)}) %>>%
  lapply(FUN = function(files) {grep(tomatch, files, value=TRUE)}) -> datalist
names(datalist) <- yrs

filenames <- file.path(sort(rep(yrs, 5), decreasing=TRUE), unlist(datalist))

for (j in filenames){
  load(j)
}

# Income Load -------------------------------------------------------------
incomes <- list()
for(l in seq(length(yrs))){
        load(paste0("./", as.numeric(yrs)[l], "/incimps.rda"))
        incomes[[l]] <- lapply(grep("ii", ls(), value=TRUE), get)
}

incomeyrs <- list()
for (k in seq(length(incomes))){
incomeyrs[[k]] <- do.call(cbind, incomes[[k]])
}

for (k in seq(length(incomeyrs))){
        incomeyrs[[k]]$ID <- sapply(incomeyrs[k], FUN = function(datas){paste0(datas$srvy_yr, datas$hhx, datas$fmx, datas$fpx)})
}

varnames <- lapply(incomeyrs, names)[[1]]
rnames <- c("faminci2", "tcincm_f", "povrati2", "ernyr_i2", "tcearn_f")
for(i in rnames){
        mypos <- grep(i, varnames)
        varnames[mypos] <- paste0(varnames[mypos], seq(length(mypos)))
}


for (j in seq(length(incomeyrs))){
names(incomeyrs[[j]]) <- varnames
}
incomes <- do.call(rbind, incomeyrs)
targets <- paste("ID", "faminci2", "tcincm_f", "povrati2", "ernyr_i2", "tcearn_f", sep="|")

incomes <- incomes[,grep(targets, names(incomes), value=TRUE)]
sapply(incomes, function(x) sum(is.na(x)))

incomes <- incomes[, grep(paste("ID", "faminci2", "povrati2", sep="|"), names(incomes), value=TRUE)]
rm(incomeyrs)

# Adult Sample ------------------------------------------------------------
colnames(NHIS.00.samadult.df)[match("adnlongr", names(NHIS.00.samadult.df))] <- "adnlong2"
colnames(NHIS.99.samadult.df)[match("adnlongr", names(NHIS.99.samadult.df))] <- "adnlong2"
colnames(NHIS.98.samadult.df)[match("adenlong", names(NHIS.98.samadult.df))] <- "adnlong2"
colnames(NHIS.98.samadult.df)[match("amdlong", names(NHIS.98.samadult.df))]  <- "amdlongr"

adultsamp <- lapply(grep("samadult", ls(), value=TRUE), get)
for (j in seq(length(adultsamp))){
        adultsamp[[j]]$ID <- sapply(adultsamp[j], FUN = function(datas){ paste0(datas$srvy_yr, datas$hhx, datas$fmx, datas$px)})
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
rm(adultsamp)

goodvars <- c("ID", "psu", "stratum", "wtfa_sa", "sex", "age_p", "ausualpl", "ahcafyr1", "ahcafyr2", "ahcafyr3", "adnlong2", "amdlongr", "srvy_yr")
svydata <- subset(svydata, select=goodvars)
svydata$sex <- factor(svydata$sex, levels=c(1,2), labels=c("Male", "Female"))
svydata$ausualpl[which(svydata$ausualpl==9)] <- 0
svydata$ausualpl[which(svydata$ausualpl>6)] <- NA
svydata$ausualpl <- 3-svydata$ausualpl+1
svydata$ahcafyr1[which(svydata$ahcafyr1>3)] <- NA
svydata$ahcafyr2[which(svydata$ahcafyr2>3)] <- NA
svydata$ahcafyr3[which(svydata$ahcafyr3>3)] <- NA
svydata$adnlong2[which(svydata$adnlong2 %in% c(7,8))] <- NA
svydata$adnlong2[which(svydata$adnlong2==9)] <- 6
svydata$amdlongr[which(svydata$amdlongr %in% c(7,8))] <- NA
svydata$amdlongr[which(svydata$amdlongr==9)] <- 6


# The Merge ---------------------------------------------------------------

finaldata <- merge(svydata, mortdata, by.x="ID", by.y="PUBLICID")
finaldata <- merge(finaldata, incomes, by.x="ID", by.y="ID")
library(psych)

myfit <- principal(finaldata[,grep(gsub("ID","age_p", targets, fixed = T), names(finaldata), value=TRUE)], nfactors=10, rotate="varimax", scores=TRUE)
plot(myfit$values, type="b", ylab="Eigen values", xlab="Components", main="Scree plot", lwd=2, col="darkblue"); abline(h=1, lty=2, col="darkgray", lwd=2)
myfit <- principal(finaldata[,grep(gsub("ID|","", targets, fixed = T), names(finaldata), value=TRUE)], nfactors=2, rotate="varimax", scores=TRUE)
incs <- myfit$scores[,c(1,2)]
colnames(incs) <- c("income", "age")

polyset <- cbind(sex=as.numeric(finaldata[,5]), finaldata[, 7:12])
poly1 <- polychoric(polyset)
correls1 <- poly1$rho

myfit2 <- principal(correls1, nfactors=7, rotate="varimax", scores=TRUE)
plot(myfit2$values, type="b", ylab="Eigen values", xlab="Components", main="Scree plot", lwd=2, col="darkblue"); abline(h=1, lty=2, col="darkgray", lwd=2)
myfit2 <- principal(correls1, nfactors=3, rotate="varimax", scores=TRUE)
polyscores <- predict(myfit2, polyset)
colnames(polyscores) <- c("unafford", "medsexusual", "dental")

# write.csv(myfit2$loadings[1:7,1:3], file="pcaloads.csv")

finaldata <- cbind(finaldata, polyscores, incs)

rm(list=grep("NHIS|ii", ls(), value=TRUE))

library(survey)
options("survey.lonely.psu"="adjust")

svymean(~age_p, dsgnobj)
svymean(~sex, dsgnobj)

dsgnobj <- svydesign(id=~psu, strata = ~stratum, weights=~sawgtnew_c, data = finaldata, nest = TRUE )

s <- svykm(Surv(yrstoevent, MORTSTAT>0)~1, design=dsgnobj)
plot(s, lwd=2, main="Survival Estimate", xlab="Time (years)")
abline(a = .5, b=0, lty=3)

model <- svycoxph(Surv(yrstoevent, MORTSTAT>0)~unafford+medsexusual+dental+income+age, design=dsgnobj)

bas <- cbind(summary(model)$coefficients, summary(model)$conf.int)
bas <- bas[,c(2,1,3,5,8,9)]

# write.csv(bas, file="coxcoeff.csv")
