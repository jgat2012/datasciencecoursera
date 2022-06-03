

library("readxl")
library("dplyr")

test <-read.csv("data/specdata/300.csv")

dir <- "data/specdata/"

complete <- function(directory, id=1:332){
  
  tot_mon    <-length(id) #Number of monitors
  
  columns <-c("id","nobs")
  data <-data.frame(matrix(nrow = 0, ncol = length(columns)))
  colnames(data)<-columns
  
  
  for (i in id){#Loop through monitors id to know which file to open
    file_name<-""
    
    if(i<10){
      file_name<-as.character(paste("00",i,".csv",sep=""))
    }else if(i<100){
      file_name<-as.character(paste("0",i,".csv",sep=""))
    }else{
      file_name<-as.character(paste(i,".csv",sep=""))
    }
    
    #Get file name
    file <-read.csv(paste(dir,file_name,sep=""))
    
    #Get total number of complete cases
    tot_complete <-file %>%
      summarize(
       id   = i,
       nobs = sum((!is.na(nitrate) & !is.na(sulfate) & !is.na(Date)),na.rm = TRUE) 
      )
    
    data<-data %>%rbind(
      tot_complete
    )
  }
  
  data
  
}

RNGversion("3.5.1")  
set.seed(42)
cc <- complete(dir, 332:1)
use <- sample(332, 10)
print(cc[use, "nobs"])

  