# Getting-and-cleaning-data
==================================================================
##How to get to the tinyData.txt:

Download data from the link below and unzip it into working directory of R Studio.
Execute the R script.
About the source data
The source data are from the Human Activity Recognition Using Smartphones Data Set. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

About R script
File with R code "run_analysis.R" performs the 5 following steps (in accordance assigned task of course work):

Reading in the files and merging the training and the test sets to create one data set.
line 14 - 34 # Load Packages if required

line 43 - 45 #  Reading activity labels

line 45-46  Reading feature names tables

line 51-56  cleaning and modify data obtained from feature names

line 59 - 62 Reading the training dataset and cleaning the column names

line 65 -66  reading y training label datasets

line 67 -68  reading y subjectnames datasets

line 69 column combine training label,subject name and train data

line 78 - 82 reading  testng ,label datasets

line 86 merged test and train dataset into a single data

line 92 - 93 creating factor variable

line 95 -99 evaluated averages for each person per activity

line 100 -106 converted vaiable average_per_activity_per_person to a dataframe and store the result in a          average_per_activity_per_person.txt file 




About variables:
x_train, y_train, x_test, y_test, subject_train and subject_test contain the data from the downloaded files.
x_data, y_data and subject_data merge the previous datasets to further analysis.
features contains the correct names for the x_data dataset, which are applied to the column names stored in
