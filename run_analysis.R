# these are the task i shall be performing but not in the order stated. 

# 1. Merges the training and the test sets to create one data set.
# 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 
# 3. Uses descriptive activity names to name the activities in the data set
# 
# 4. Appropriately labels the data set with descriptive variable names. 
# 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable

#    for each activity and each subject.
# Load Packages if required

if(!require("tidyverse")){
  install.packages("tidyverse")
  library(tidyverse)
}
if(!require("tidyr")){
  install.packages("tidyr")
  library(tidyr)
}


if(!require("dplyr")){
  install.packages("dplyr")
  library(dplyr)
}

if(!require("data.table")){
  install.packages("data.table")
  library(data.table)
}


#TASK 3. Uses descriptive activity names to name the activities in the data set
current_directory<-"./"
# reading the data from d datasets

# deafault sep set to auto by default as such space is selected as a delimiter to separating entry into columns from columns

activity_labels <- fread(file.path(current_directory, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))     

features <- fread(file.path(current_directory, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))

# get indices for rows containing either of these string format mean() or std()
# TASK 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
# use indices obtained from the featuresWanted to extract the desired entry
measurements <- features[featuresWanted, featureNames]
# Replace () with an empty string
measurements <- gsub('[()]', '', measurements)


#TASK 4.Appropriately labels the data set with descriptive variable names. 
# reading the training dataset
train <- fread(file.path(current_directory, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
#replacing the default column names of train dataset with data extracted from measurement
setnames(train, colnames(train), measurements)

# reading y training label datasets
train_Activities <- fread(file.path(current_directory, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
train_Subjects <- fread(file.path(current_directory, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
train <- cbind(train_Subjects, train_Activities, train)

# reading the training dataset
test <- fread(file.path(current_directory, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]

#replacing the default column names of train dataset with data extracted from measurement
setnames(test, colnames(test), measurements)

# reading y testng label datasets
test_Activities <- fread(file.path(current_directory, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
test_Subjects <- fread(file.path(current_directory, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))
test <- cbind(test_Subjects, test_Activities, test)

# TASK 1. Merges the training and the test sets to create one data set.
#combining rows of test and train into a single dataset
combined_data <- rbind(train, test) # merging the train and test dataset


#TASK 5. From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.

factor_1<-factor(combined_data$SubjectNum)
factor_2<-factor(combined_data$Activity)
factor_combinations<-list(factor_1,factor_2)
average_per_activity_per_person<-lapply(split(combined_data, factor_combinations),function(x) {
                                              colMeans(x[,3:ncol(x)],
                                                       na.rm = TRUE)})
# converting the list data type of the variable average_per_activity_per_person to a dataframe
# and the swap row and column fields with the t() function                                            

average_per_activity_per_person <-data.frame(t(data.frame(average_per_activity_per_person)))

# colMeans(combined_data[,3:ncol(combined_data)],na.rm=TRUE)

combined_data[["Activity"]] <- factor(combined_data[, Activity]
                                 , levels = activity_labels[["classLabels"]]
                                 , labels = activity_labels[["activityName"]])

combined_data[["SubjectNum"]] <- as.factor(combined_data[, SubjectNum])
combined_data <- reshape2::melt(data = combined_data, id = c("SubjectNum", "Activity"))
combined_data <- reshape2::dcast(data = combined_data, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = combined_data, file = "tidyData.txt", quote = FALSE)

