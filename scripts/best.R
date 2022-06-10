

library("readxl")
library("stringr")
library("dplyr")

best <- function(state, outcome) {
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
  
  ## Return hospital name in that state with lowest 30-day death
  outcome <-str_to_title(outcome) %>% #Capitalize outcome String
    #Replace space with '.' 
    str_replace_all(" ",".")
  
  
  outcome_col_name <- paste("Hospital.30.Day.Death..Mortality..Rates.from.",outcome,sep = "")
  
  
  #Convert outcome column into numeric
  data[[outcome_col_name]] <- as.numeric(data[[outcome_col_name]])
  
  compiled <- data %>%
    filter(State == state) %>%
    select(Hospital.Name,all_of(outcome_col_name))  
  
  hosp_best <- compiled %>%
    filter(compiled[,2] == min(compiled[,2],na.rm = TRUE)) %>%
    select(Hospital.Name) %>%
    #Order by Hospital Name and get first name in case of Tie
    arrange(Hospital.Name) %>%
    head(1)
  
  print(hosp_best)
  
  ## rate
}

best("NY", "heart attack")
