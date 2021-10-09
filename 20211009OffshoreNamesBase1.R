library(dplyr)
library(tidyverse)
library(formatR)
library(RCurl)
library(babynames)


# Get Names of Offshore Account Holder ------------------------------------
panama <- read_csv("panama_papers.nodes.officer.csv") #Thesa are from ICIJ website.
panama<-select(panama, name)
off <- read_csv("offshore_leaks.nodes.officer.csv")
off<-select(off, name)
bahamas<- read_csv("bahamas_leaks.nodes.officer.csv")
bahamas<-select(bahamas, name)
paradise <- read_csv("paradise_papers.nodes.officer.csv")
paradise<-select(paradise, name)
# Get Common Names of Babies ----------------------------------------------

babynameyear<-read.csv(urlfile<-("https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv")) #This is for BabyNames by year
nameyear<-read.csv("https://raw.githubusercontent.com/organisciak/names/master/data/us-names-by-year.csv") #These are all names by year
spanishlastname1<-read.csv("https://raw.githubusercontent.com/marcboquet/spanish-names/master/apellidos-20.csv") #this is spanish Compiled from the file "Names with a frequency greater than or equal to 20 and their average ages"
spanishlastnames2<-read.csv("https://raw.githubusercontent.com/marcboquet/spanish-names/master/apellidos.csv") #Last Names
spanishfirstmale1<-read.csv("https://raw.githubusercontent.com/marcboquet/spanish-names/master/hombres.csv")
spanishfirstfemale1<-read.csv("https://raw.githubusercontent.com/marcboquet/spanish-names/master/mujeres.csv")# Maybe girls
hadleybabynames<-read.csv("https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv")

# Breaking down names -----------------------------------------------------

panama<-panama %>%
  separate(name,c("First","Second","Third","Fourth","Fifth","Sixth","Seventh"), " ")
off<-off %>%
  separate(name,c("First","Second","Third","Fourth","Fifth","Sixth","Seventh"), " ")
bahamas<-bahamas %>%
  separate(name,c("First","Second","Third","Fourth","Fifth","Sixth","Seventh"), " ")
paradise<-paradise %>%
  separate(name,c("First","Second","Third","Fourth","Fifth","Sixth","Seventh"), " ")

# Merging the file --------------------------------------------------------

offnames<-rbind(panama,off)
offnames<-rbind(offnames,bahamas)
offnames<-rbind(offnames,paradise)
offnames<-as.data.frame(offnames)
offnames$First<-tolower(offnames$First) #So that searching is not a problem later. 
offnames$Second<-tolower(offnames$Second)
offnames$Third<-tolower(offnames$Third)
offnames$Fourth<-tolower(offnames$Fourth)
offnames$Fifth<-tolower(offnames$Fifth)
offnames$Sixth<-tolower(offnames$Sixth)
offnames$Seventh<-tolower(offnames$Seventh)

# Match with Name Lists ---------------------------------------------------

## Use grepl to find if it matches. We can get from baby year name: the year in which this name was common
# We can get% of people who had this name. We can see whether this was the most common name: for a Yes/No Match.
# tempname<-offnames[j,k]
# file1 <-filter(offnames,First==tempname)
# merge(file1,babynameyear,by.x="First",by.y="name",all.x=TRUE,all.y=FALSE)
# Append the merged file somewhere
# if(grep(tempname,babynameyear$name)
pb = txtProgressBar(min = 0, max = length(offnames$First)*2000, initial = 0, style = 3)#This is for the ProgressBar but not working for some reason
pb = txtProgressBar(min = 0, max = length(offnames$First), initial = 0)
result1<-data.frame()

for (k in 1:ncol(offnames)){
    for (i in 1:length(offnames$First)){
        tempname<-offnames[i,k]
        grepname<-paste("^",tempname,"$", sep="")
        file1 <-filter(babynameyear,name==tempname)
        length(grep(tempname,babynameyear$name))
        result1[i,1]<-tempname
        result1[i,2]<-length(grep(grepname,babynameyear$name))
       # result1[i,3]<-file1$year #This has been hashed because in the first installment we only want to see how many part of the common names.
        number<-number+1
        #print(number)
        setTxtProgressBar(pb,i*5)
}
}
close(pb)
result1<-unique(result1)





