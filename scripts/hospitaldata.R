
library("readxl")

## 1. Plot the 30-day mortality rates for heart attack

## Read outcome data
outcome <- read.csv("data/assignment3/outcome-of-care-measures.csv", colClasses = "character")
head(outcome)
names(outcome)
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])
