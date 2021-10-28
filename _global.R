# Global

### Load packages
library(dplyr)
library(tidytext)
library(data.table)
library(quanteda)
library(quanteda.textplots)
library(stringr)


# Data
qd<-readRDS("corpora/corpus_worldreg_004.RDS")
td<-tidy(qd)
def<-readRDS("dict/worldreg003_def.RDS")
dic<-readRDS("dict/worldreg003_dict.RDS")

# param
media <- "fr_FRA_lmonde"
date_min <- as.Date("2019-01-01")
date_max <- as.Date("2019-12-31")
mylang  <- substr(media,1,2)
myreg   <- "Q15"


# Sample
samp<-td %>% filter(source == "fr_FRA_lmonde", 
                    date >= date_min,
                    date <=date_max)
samp$text<-as.character(samp$text)

# Dict
dico <- dic %>% filter (id == myreg, lang==mylang)
OUI <- as.character(dico$label)
NON <- as.character(c("Afrique du Sud", "Afrique de l’Ouest", "Afrique australe", "Afrique du nord",
                      "Afrique de l’Est", "Afrique du Nord","Afrique subsaharienne", "Le Monde Afrique",
                      "Coupe d'Afrique", "corne de l'Afrique", "Corne de l'Afrique"))
NON

# Check problem

samp$OUI <- as.character(lapply(str_extract_all(samp$text,paste(OUI, collapse = '|')), paste,collapse=" & "))
samp$NON <- as.character(lapply(str_extract_all(samp$text,paste(NON, collapse = '|')), paste,collapse=" & "))
samp$OK <- (samp$OUI !="")  & (samp$NON=="")
samp$PBM <- (samp$OUI !="")  & (samp$NON!="")


check<-samp %>% filter((samp$OUI !="")  | (samp$NON!=""))

