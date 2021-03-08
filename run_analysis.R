#working environment
library(data.table)
library(reshape2)

#get and read files
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile =  "projectdata.zip")
unzip("projectdata.zip")

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
trainingset <- read.table("./UCI HAR Dataset/train/X_train.txt")
traininglabels <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testset<- read.table("./UCI HAR Dataset/test/X_test.txt")
testlabels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#filtering and cleaning
featuresneeded <- grep("std|mean\\(\\)", features[, 2])
featuresnames <- features[featuresneeded, 2]
featuresnames <- gsub('[()]', '', featuresnames)
trainingset <- trainingset[ ,featuresneeded]
testset <- testset[ ,featuresneeded]

#merge
set <- rbind(trainingset, testset)
labels <- rbind(traininglabels, testlabels)
subject <- rbind(trainsubject, testsubjects)
colnames(set) <- c(featuresnames)
dataset <- cbind(subject, labels, set)

#rename data set
colnames(dataset) <- c("subject", "activity",featuresnames)
dataset$activity <- factor(dataset$activity, levels = activitylabels[,1],
                           labels = activitylabels[,2])

#melt and rearrange the data set
dataset <- melt(dataset, id = c("subject", "activity"))
dataset <- dcast(dataset, subject + activity ~ variable, mean)

#generate tidy data set
write.table(dataset, "tidy_data_set.txt", row.names = FALSE, quote = FALSE)








