# these are the task i shall be performing. 
# 
# 1. Merges the training and the test sets to create one data set.
# 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 
# 3. Uses descriptive activity names to name the activities in the data set
# 
# 4. Appropriately labels the data set with descriptive variable names. 
# 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load Packages and get the Data

if(!require("tidyverse")){
  install.packages("tidyverse")
  library(tidyverse)
}
if(!require("tidyr")){
  install.packages("tidyr")
  library(tidyr)
}

if(!require("lubridate")){
  install.packages("lubridate")                                       #helps in date formats
  library(lubridate)
}

if(!require("dplyr")){
  install.packages("dplyr")
  library(dplyr)
}

if(!require("data.table")){
  install.packages("data.table")
  library(data.table)
}
if(!require("reshape2")){
  install.packages("reshape2")
  library(reshape2)
}

path<-"./"
# reading the data from d datasets

# deafault sep set to auto by default as such space is selected as a delimiter to separating entry into columns from columns

activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))     

features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))

# get indices for rows containing either of these string format mean() or std()
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
# use indices obtained from the featuresWanted to extract the desired entry
measurements <- features[featuresWanted, featureNames]
# Replace () with an empty string
measurements <- gsub('[()]', '', measurements)



# reading the training dataset
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
#replacing the default column names of train dataset with data extracted from measurement
setnames(train, colnames(train), measurements)

# reading y training label datasets
train_Activities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# reading the training dataset
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]

#replacing the default column names of train dataset with data extracted from measurement
setnames(test, colnames(test), measurements)

# reading y testng label datasets
test_Activities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))
test <- cbind(testSubjects, test_Activities, test)

#combining test and train dataset
combined_data <- rbind(train, test) # merging the train and test dataset
