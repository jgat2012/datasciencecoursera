
library("readxl")
library("dplyr")

test <-read.csv("data/specdata/300.csv")

dir <- "data/specdata/"

num_files <- as.numeric(length(list.files(dir)))

corr <- function(directory,threshold = 0){
  
  tot_mon    <-length(id) #Number of monitors
  
  columns <-c("id","nobs")
  cor_vec <-numeric()
  
  
  for (i in 1:num_files){#Loop through monitors id to know which file to open
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
        nobs = sum((!is.na(nitrate) & !is.na(sulfate) & !is.na(Date) & !is.na(ID)),na.rm = TRUE)
      )

    #Check if # complete cases is > threshold
    if(tot_complete$nobs>threshold){
      cur_file <- file%>%
        filter(!is.na(nitrate) & !is.na(sulfate) & !is.na(Date) & !is.na(ID))
      cor_vec<-c(cor_vec,cor(x=cur_file$nitrate,y=cur_file$sulfate))
    }
  }
  
  cor_vec
  
}


cr <- corr("specdata", 2000)                
n <- length(cr)                
cr <- corr("specdata", 1000)                
cr <- sort(cr)
print(c(n, round(cr, 4)))
