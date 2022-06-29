# Getting and Cleaning Data Project

This project is the final project for the course module Getting and Cleaning data from John Hopskins university
A course that is part of the Data Science Specialization

0. We first started by loading packages and raw datasets
Loagind raw datasets in their own objects is an important step in order to keep integrity of the raw data when
later on doing data manipulation

## 1. Merge train and test datasets. 
After loading and including column names/variable names, we bound test rows to train rows datasets in order to merge them 
into one dataset

## 2. Extract only measurements for mean and standard deviation
This section is about subsetting the dataset from the previous step in order to only include column that are needed.
We used the *matches* function in order to filter columns that are needed

## 3. Use descriptive activity names
We first started by binding activities for both the train and test datasets using the *rdind* function. 
Then we added that vector as a column to the merged dataset from the previous step using *cbind* function.
Using *case_when* control structure, we used corresponding descriptive activities names in order to update the activities ids

## 4. Appropriately label datasets with descriptive variable names
Here we just used the janitor package in order clean the names in a "R" acceptable format. 
We limit ourselves to that so as not to have very long names as we saw that these names were descriptive enough

## 5. Creating an indenpent tidy data set with average  of each variable for each activity
- We first filtered the columns to only the mean and activities columns
- Using pivoting, we melted the data 
- We then wroted the final tidy dataset into a csv file in order to make it exploitable for later analysis
- We finally created a codebook for ease of interpretation of the data
