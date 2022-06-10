
library("readxl")
library("stringr")
library("dplyr")

rankall <- function(outcome, num = "best") {
  
  #outcome <-"heart attack"
  #num <-"worst"
  ## Read outcome data
  data<- read.csv("data/assignment3/outcome-of-care-measures.csv", colClasses = "character")
  # Replace with NA
  data[data=="Not Available"] <- NA
  
  ## Check that state and outcome are valid
  possible_outcome <- c("heart attack", "heart failure", "pneumonia")
  possible_state <-unique(data$State)
  
  if (!(outcome %in% possible_outcome)){
    stop("Invalid outcome")
  }
  
  #rank category
  num <- as.character(num)
  if(num =="best"){
    rank_cat <- 1L
  }else if(num =="worst"){
    rank_cat <- 0L
  }else{
    rank_cat<- as.integer(num)
  }
  
  outcome <-str_to_title(outcome) %>% #Capitalize outcome String
    #Replace space with '.' 
    str_replace_all(" ",".")
  
  
  outcome_col_name <- paste("Hospital.30.Day.Death..Mortality..Rates.from.",outcome,sep = "")
  
  #Convert outcome column into numeric
  data[[outcome_col_name]] <- as.numeric(data[[outcome_col_name]])
  
  #create empty data frame
  summary_data <- data.frame(matrix(nrow = 0,ncol = 2))
  colnames(summary_data) <-c("hospital","state")
  ## For each state, find the hospital of the given rank
  for(state in unique(data$State)){
    
    #Run through each state and return results
    compiled <- data %>%
      filter(State == state) %>%
      select(Hospital.Name,State,all_of(outcome_col_name))
    
    #Sort data frame by mortality rate and hospital name
    hosp_data <- compiled %>% 
      arrange(compiled[,3],compiled[,1]) 
    
    #Remove hospitals with no data
    hosp_data <- hosp_data %>%
      filter(!is.na(hosp_data[,3]))
    
    
    if(rank_cat == 0){
      returned_data <- hosp_data[as.integer(nrow(hosp_data)),1:2]
    }else if(rank_cat > nrow(hosp_data)){
      returned_data <- data.frame("Hospital.Name" = NA,"State" = state)
    }else{
      returned_data <-  hosp_data[rank_cat,1:2]
    }
    
    #Convert empty to NA before returning result
    summary_data<-summary_data%>%
      rbind(returned_data %>%
              rename(
                hospital = Hospital.Name,
                state    = State
              )
            )
  }
  
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  summary_data %>%
    arrange(state)
}

print(tail(rankall("heart failure"), 10))
