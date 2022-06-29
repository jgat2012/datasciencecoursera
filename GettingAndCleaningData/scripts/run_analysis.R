

## 0. Load packages and datasets

library("tidyr")
library("dplyr") #Used for data manipulation
library("janitor") # Clean column names
library("dataMaid") #Used to create a data codebook

#Load datasets
features <- read.table("./data/UciHarDataset/features.txt",sep = "",header = F)
activities_lbl <- read.table("./data/UciHarDataset/activity_labels.txt",sep = "",header = F)

train_ft_raw <- read.table("./data/UciHarDataset/train/X_train.txt",sep = "",header = F)
train_lbl_raw <- read.table("./data/UciHarDataset/train/y_train.txt",sep = "",header = F)
train_subj <- read.table("./data/UciHarDataset/train/subject_train.txt",sep = "",header = F)

test_ft_raw  <- read.table("./data/UciHarDataset/test/X_test.txt",sep = "",header = F)
test_lbl_raw <- read.table("./data/UciHarDataset/test/y_test.txt",sep = "",header = F)
test_subj  <- read.table("./data/UciHarDataset/test/subject_test.txt",sep = "",header = F)

#Get the vector from the features data that will be assigned as column names
mycolnames <- unlist(c(features[2]))

#Assign as column names
colnames(train_ft_raw) <- mycolnames
colnames(test_ft_raw)  <- mycolnames

## 1. Merge train and test data sets to make one data set
final_data <- rbind(train_ft_raw,test_ft_raw)

## 2. Extract only the measurements for the mean and standard deviation
mean_std <- final_data %>%
  select(matches("mean|std"))

## 3. Uses descriptive activity names to name the activities in the data set

 # Append activity labels for both train and tests data sets
activities_lbl_data <- rbind(train_lbl_raw,test_lbl_raw)
colnames(activities_lbl_data) <- "activity"

 # Append the activity label as a column to the mean_std table
mean_std_data <- mean_std %>%
  cbind(activities_lbl_data)

mean_std_data <- mean_std_data %>%
  mutate(
    activity = case_when(
      activity == activities_lbl[1,1] ~ activities_lbl[1,2],
      activity == activities_lbl[2,1] ~ activities_lbl[2,2],
      activity == activities_lbl[3,1] ~ activities_lbl[3,2],
      activity == activities_lbl[4,1] ~ activities_lbl[4,2],
      activity == activities_lbl[5,1] ~ activities_lbl[5,2],
      activity == activities_lbl[6,1] ~ activities_lbl[6,2],
      TRUE ~ ""
    )
  )



## 4. Appropriately labels the data set with descriptive variable names.
mean_std_data <- mean_std_data %>% janitor::clean_names()


## 5. Creating independent tidy data set with average  of each variable for each
# activity

  # Getting mean data
mean_data <- mean_std_data %>%
  select(matches("mean|activity"))

new_data <- mean_data %>%
  
  #Convert to long data format to get each variable
  pivot_longer(cols = colnames(select(mean_data,-("activity"))),names_to = "means") %>%
  
  #Get mean for each activity and variable
  group_by(activity,means)%>%
  
  summarise(
    average = mean(value)
  ) %>%
  
  #Convert back to wider format after summarizing data
  pivot_wider(names_from = means,values_from = average)


## Write data set to csv
write.csv(new_data,"./data/tidy_data.csv",row.names = FALSE)

## Create Codebook
makeCodebook(new_data)
