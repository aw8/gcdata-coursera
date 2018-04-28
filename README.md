---
title: "README"
author: "Albert Wang"
date: "27/04/2018"
---

# README: Getting and Cleaning Data Project

Albert Wang (adwwang@me.com)

## Introduction
This assignment involves collecting and processing data from the following project: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Script: run_analysis.R
This script, if run while the current working directory contains the data from the Human Activity Recognition using Smart Phones project, will do the following:
1. import the libraries "dplyr" and "reshape2" (ensure both are already installed for all commands to work correctly)
2. Read in the testing and training data sets, and combine them
3. Sets descriptive variable names for the table columns (using the feature names provided, but modified for increased readability)
4. Extracts measurements on mean and standard deviation for each measurement
5. Replaces the activity numbers with the names provided
6. Creates a second tidy data set containing only the average of each variable for each activity and each subject.
7. Outputs the data set as the file: "tidydata.txt"

Note that the data set produced is of a "wide" format, and is tidy according to the following rules:
* Each variable measured in 1 column
* Each observation of that variable in a different row

## HOWTO
1. Ensure "run_analysis.R" is in the correct folder which contains: "activity_labels.txt", "features_info.txt", "features.txt", "README.txt", and the "test" and "train" folders. Ensure the working directory is set to this same folder.
2. open "run_analysis.R" and run all of the commands contained within.
3. the tidy data set will be output in the current working directory as "tidydata.txt" and will also be available as the R data frame "tidydata".
4. In order to read the tidy data set back into R from "tidydata.txt" run the following code:

`
data <- read.table("tidydata.txt", header = TRUE);
View(data)
`