
library("readxl")
library("stringr")
library("dplyr")

rankhospital <- function(state, outcome, num = "best") {
  
  #state   <-"MD"
  #outcome <-"heart attack"
  #num <-"worst"
  ## Read outcome data
  data<- read.csv("data/assignment3/outcome-of-care-measures.csv", colClasses = "character")
  # Replace with NA
  data[data=="Not Available"] <- NA
  
  ## Check that state and outcome are valid
  possible_outcome <- c("heart attack", "heart failure", "pneumonia")
  possible_state <-unique(data$State)
  
  if(!(state %in% possible_state)){
    stop("Invalid state")
  }
  
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
  
  compiled <- data %>%
    filter(State == state) %>%
    select(Hospital.Name,all_of(outcome_col_name))
  
  #Sort data frame by mortality rate and hospital name
  hosp_data <- compiled %>% 
    arrange(compiled[,2],compiled[,1]) 
  
  #Remove hospitals with no data
  hosp_data <- hosp_data %>%
    filter(!is.na(hosp_data[,2]))
  
  
    if(rank_cat == 0){
      returned_data <- hosp_data[as.integer(nrow(hosp_data)),1]
    }else if(rank_cat > nrow(hosp_data)){
      returned_data <- NA
    }else{
      returned_data <-  hosp_data[rank_cat,1]
    }
  
  ## Return hospital name in that state with the given rank
  
  #Convert empty to NA before returning result
  returned_data[returned_data[""]] <-NA
  returned_data
}

print(rankhospital("MN", "heart attack", 5000))

