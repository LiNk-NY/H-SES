# merging datasets NHIS
library(pipeR)
library(dplyr)

tomatch <- paste("person", "house", "family", "samadult", sep="|")
yrs <- as.character(2003:1998)
lapply(yrs, dir) %>>% lapply(FUN= function(file) {grep("\\.rda", file, value=TRUE)}) %>>%
  lapply(FUN = function(files) {grep(tomatch, files, value=TRUE)}) -> datalist
names(datalist) <- yrs

filenames <- file.path(sort(rep(yrs, 5), decreasing=TRUE), unlist(datalist))

for (j in filenames){
  load(j)
}


# Persons Load ------------------------------------------------------------
colnames(NHIS.00.personsx.df)[match("wrklyr", names(NHIS.00.personsx.df))] <- "wrklyr1"
colnames(NHIS.99.personsx.df)[match("wrklyr", names(NHIS.99.personsx.df))] <- "wrklyr1"
colnames(NHIS.98.personsx.df)[match("wrklyr", names(NHIS.98.personsx.df))] <- "wrklyr1"
colnames(NHIS.98.personsx.df)[match("race", names(NHIS.98.personsx.df))] <- "racerp_i"
colnames(NHIS.99.personsx.df)[match("racer_p", names(NHIS.99.personsx.df))] <- "racerp_i"
colnames(NHIS.03.personsx.df)[match("racerpi2", names(NHIS.03.personsx.df))] <- "racerp_i"

pers <- lapply(grep("person", ls(), value=TRUE), get)
for (j in seq(length(pers))){
        pers[[j]]$ID <- sapply(pers[j], FUN = function(datas){ paste0(datas$srvy_yr, datas$hhx, datas$fmx, datas$px)})
}

names(pers) <- as.character(c(pers[[1]]$srvy_yr[1], pers[[2]]$srvy_yr[1], pers[[3]]$srvy_yr[1], pers[[4]]$srvy_yr[1], pers[[5]]$srvy_yr[1], pers[[6]]$srvy_yr[1]))

filt <- c("ID", "wrklyr1", "educ_r1", "private", "notcov", "racerp_i", "srvy_yr")

pers2 <- lapply(pers, FUN = function(y){ subset(y, select = filt) })

# check lapply "bug" with named list after creating new var

personsx <- do.call(rbind, pers2)

xtabs(~ private + notcov, personsx)

personsx$insstat <- ifelse(personsx$private<=2 & personsx$notcov ==2, 3, 
                           ifelse(personsx$private ==3 & personsx$notcov==2, 2, 
                                  ifelse(personsx$private == 3 & personsx$notcov==1, 1, NA)))
personsx$education <- with(personsx, ifelse(educ_r1 <=2 , 1, 
                                            ifelse(educ_r1 == 3 | educ_r1 == 4, 2, 
                                                   ifelse(educ_r1 %in% c(5,6,7), 3, 
                                                          ifelse(educ_r1 %in% c(8,9), 4, NA)))))
personsx$worklyr <- ifelse(personsx$wrklyr1>6, NA, personsx$wrklyr1)
personsx$worklyr <- (3-personsx$worklyr) #reverse code

personsx <- subset(personsx, select=c("ID", "insstat", "education", "racerp_i", "worklyr"))


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
finaldata$sex <- relevel(finaldata$sex, ref = "Female")
finaldata <- merge(finaldata, personsx, by.x = "ID", by.y="ID")

library(psych)

myfit <- principal(finaldata[,grep(gsub("ID|","", targets, fixed = T), names(finaldata), value=TRUE)], nfactors=2, rotate="varimax", scores=TRUE)
plot(myfit$values, type="b", ylab="Eigen values", xlab="Components", main="Scree plot", lwd=2, col="darkblue"); abline(h=1, lty=2, col="darkgray", lwd=2)
incs <- cbind(myfit$scores[,1], finaldata$age_p)
colnames(incs) <- c("income", "age")

polyset <- finaldata[, grep("usual|ahca|long|stat|educ", names(finaldata), val=T)]
poly1 <- polychoric(polyset)
correls1 <- poly1$rho

myfit2 <- principal(correls1, nfactors=7, rotate="varimax", scores=TRUE)
plot(myfit2$values, type="b", ylab="Eigen values", xlab="Components", main="Scree plot", lwd=2, col="darkblue"); abline(h=1, lty=2, col="darkgray", lwd=2)
myfit2 <- principal(correls1, nfactors=3, rotate="varimax", scores=TRUE)
polyscores <- predict(myfit2, polyset)
colnames(polyscores) <- c("unafford", "medusual", "educdentalins")

# write.csv(myfit2$loadings[1:8,1:3], file="pcaloads.csv")

finaldata <- cbind(finaldata, polyscores, incs)

rm(list=grep("NHIS|ii", ls(), value=TRUE))

library(survey)
options("survey.lonely.psu"="adjust")

dsgnobj <- svydesign(id=~psu, strata = ~stratum, weights=~sawgtnew_c, data = finaldata, nest = TRUE )
# add gender after
svymean(~age_p, dsgnobj)
svymean(~sex, dsgnobj)
svymean(~factor(MORTSTAT), dsgnobj)

s <- svykm(Surv(yrstoevent, MORTSTAT==1)~1, design=dsgnobj)
# png(filename = "KMsurv.png", width = 720, height = 480)

plot(s, lwd=2, main="Kaplan-Meier Survival Curve", xlab="Time (years)")
mtext(text = "All-cause Mortality", side = 3, line = 0.5)
abline(a = .5, b=0, lty=3)
graphics.off()


sort(which(!complete.cases(finaldata[, c("yrstoevent", "MORTSTAT", "unafford", "medusual", "educdentalins", "income", "age", "sex")])))

modelset <- finaldata[, c("psu", "stratum", "sawgtnew_c", "yrstoevent", "MORTSTAT", "unafford", "medusual", "educdentalins", "income", "age", "sex")]
modelset <- modelset[complete.cases(modelset),]

dsgnobj2 <- svydesign(id=~psu, strata = ~stratum, weights=~sawgtnew_c, data = modelset, nest = TRUE )

model <- svycoxph(Surv(yrstoevent, MORTSTAT==1)~unafford+medusual+educdentalins+income+age+sex, design=dsgnobj2)
riskscore <- predict(model)
library(Hmisc)
terts <- cut2(riskscore, g=3)

bas <- cbind(summary(model)$coefficients, summary(model)$conf.int)
bas <- round(bas[,c(2,1,3,5,8,9)],3)

# write.csv(bas, file="coxcoeff.csv")

png(filename = "KMsurv.png", width = 720, height = 540 )
s1 <- svykm(Surv(yrstoevent, MORTSTAT==1)~ strata(terts), design=dsgnobj2)
plot(s1, lwd=2, main="Kaplan-Meier Survival Tertiles Curve", xlab = "Time (years)", lty=6)
mtext(text="All-cause Mortality", side=3, line=0.5)
legend(1,.5, c("Tertile 1", "Tertile 2", "Tertile 3"), lty=6)
text(x=1, y=.55, labels = "Risk Score", pos = 4)

graphics.off()

devtools::install_github("christophergandrud/simPH")
# works on srvyfit objects