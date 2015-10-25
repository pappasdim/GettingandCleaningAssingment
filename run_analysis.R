library(plyr)
require(dplyr)
library(reshape2)


## Read the training data and label the dataframe's columns
X_train_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/train/X_train.txt")
X_train <- read.table(X_train_txt)
## Read the activity id's of the training data and label the dataframe's columns
Y_train_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/train/y_train.txt")
Y_train <- read.table(Y_train_txt)
## Read the ids of the test subjects and label the the dataframe's columns
subject_train_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/train/subject_train.txt")
subject_train <- read.table(subject_train_txt)
## Read the test data and label the dataframe's columns
X_test_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/test/X_test.txt")
X_test <- read.table(X_test_txt)
## Read the activity id's of the test data and label the the dataframe's columns
Y_test_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/test/y_test.txt")
Y_test <- read.table(Y_test_txt)
## Read the ids of the test subjects and label the the dataframe's columns
subject_test_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/test/subject_test.txt")
subject_test <- read.table(subject_test_txt)
# Read the features table.
features_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/features.txt")
features <- read.table(features_txt)
# Read the activities list.
activity_labels_txt <- unz("./UCI_HAR.zip", "UCI HAR Dataset/activity_labels.txt")
activity_labels <- read.table(activity_labels_txt )


# Merges the training and the test sets to create one data set.
Train <- cbind(X_train, Y_train, subject_train)
Test <- cbind(X_test, Y_test, subject_test)
data_set <- rbind(Train, Test)

#Appropriately labels the data set with descriptive activity names.
colnames(data_set) <- features[ ,2]
colnames(data_set)[562] <- "activity"
colnames(data_set)[563] <- "subject"

#Extracts only the measurements on the mean and standard deviation for each measurement.
colKeep1 <- grep("mean", names(data_set) )
colKeep2 <- grep("std", names(data_set) )
colKeep <- c(colKeep1, colKeep2, 562, 563)
data_set2 <- data_set[,colKeep]

#Uses descriptive activity names to name the acts in the data set.
data_set2$activity[data_set2$activity == 1] <- "WALKING"
data_set2$activity[data_set2$activity == 2] <- "WALKING_UPSTAIRS"
data_set2$activity[data_set2$activity == 3] <- "WALKING_DOWNSTAIRS"
data_set2$activity[data_set2$activity == 4] <- "SITTING"
data_set2$activity[data_set2$activity == 5] <- "STANDING"
data_set2$activity[data_set2$activity == 6] <- "LAYING"

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
group_sub_act <- group_by(data_set2, subject, activity)
tidy_data <- summarize_each(group_sub_act, funs(mean))
# Reshape the data.
tidy_data_melt <- melt(tidy_data,c("activity","subject"))

write.table(tidy_data, "./tidy_data.txt", row.name=FALSE)
write.table(tidy_data_melt, "./tidy_data_melt.txt", row.name=FALSE)

data <- read.table(file_path, header = TRUE) 
View(data)