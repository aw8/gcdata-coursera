### "Getting and Cleaning Data" course project
### Albert Wang

#assuming current working directory is the folder containing the data

#load libraries
library(dplyr)
library(reshape2)
#ensure "plyr" package is not loaded as the rename function will conflict.

#read in the data
Xtest <- read.table("test/X_test.txt")
Xtrain <- read.table("train/X_train.txt")
Ytest <- read.table("test/y_test.txt")
Ytrain <- read.table("train/y_train.txt")
subjecttest <- read.table("test/subject_test.txt")
subjecttrain <- read.table("train/subject_train.txt")

##Step 1: merge training and test sets
testdata <- cbind(subjecttest, Ytest, Xtest)
traindata <- cbind(subjecttrain, Ytrain, Xtrain)
alldata <- rbind(testdata, traindata)

##Step 4: appropriately label the data set with descriptive variable names
## NOTE: variable names used here are the feature names in features.txt. Further description will be provided in Codebook.
#read in feature names
featurenames <- read.table("features.txt")
featurenames <- select(featurenames, V2)
featurenames <- rename (featurenames, names = V2)
featurenames <- rbind(data.frame(names=c("subjectnumber", "activitynumber")), featurenames)

#add the names to the data
names(alldata) <- featurenames$names

##Step 2: extract only measurements on mean and standard deviation for each measurement
#first, make sure all the column names are unique (there are duplicate names in features.txt that will be removed later anyway)
names(alldata) <- make.unique(names(alldata), sep="_")
#now that column names are unique create subset (otherwise the select command produced an error)
selecteddata <- select(alldata, grep("mean|std|subjectnumber|activitynumber",colnames(alldata)))

##Step 3: descriptive activity names to name the activities in the data set
#read in activity names
activitydata <- read.table("activity_labels.txt")
activitydata <- rename(activitydata, activitynumber = V1, activityname = V2)
nameddata <- merge(activitydata, selecteddata, by="activitynumber")
#remove unnecessary activity number column
nameddata <- select(nameddata, -activitynumber)

##Step 4 continued: make variable names a bit more understandable
namelist <- names(nameddata)
namelist <- sub("BodyBody", "Body", namelist)
namelist <- sub("^t", "TimeDomainOf", namelist)
namelist <- sub("^f", "FreqDomainOf", namelist)
namelist <- sub("Mag", "Magnitude", namelist)
namelist <- sub("mean", "Mean", namelist)
namelist <- sub("std", "StandardDeviation", namelist)
namelist <- gsub("-", "", namelist)
namelist <- sub("\\(\\)", "", namelist)
namelist <- sub("X$", "-XDim", namelist)
namelist <- sub("Y$", "-YDim", namelist)
namelist <- sub("Z$", "-ZDim", namelist)
namelist[1] = "activityName"
namelist[2] = "subjectNumber"
names(nameddata) = namelist

##Step 5: second, independent tidy data set with the average of each variable for each activity and each subject
#melt data
nameddata_melted <- melt(nameddata, id=c("activityName", "subjectNumber"))
#recast while also finding averages
tidydata <- dcast(nameddata_melted, activityName + subjectNumber ~ variable, mean)
#change variable names to show that they're all averages
namelist <- names(tidydata)
namelist <- lapply(namelist, function(x) paste("avgOf", x, sep=""))
namelist[1] = "activityName"
namelist[2] = "subjectNumber"
names(tidydata) = namelist

#write out the tidy data set
write.table(tidydata, file = "tidydata.txt", row.name=FALSE)
