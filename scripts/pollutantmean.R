
library("readxl")

test <-read.csv("data/specdata/300.csv")

dir <- "data/specdata/"

pollutantmean <-function(directory,pollutant,id =1:332){
  
  tot_mon    <-length(id) #Number of monitors
  all_vect <- c()
  
  final_mean <- 0.0
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
    
    #Get pollutant mean
    #final_mean<- mean(file[[pollutant]],na.rm= TRUE)
    all_vect<-c(all_vect,file[[pollutant]])
  }
  
  mean(all_vect,na.rm= TRUE)
}

pollutantmean(directory = dir,pollutant = "nitrate")



