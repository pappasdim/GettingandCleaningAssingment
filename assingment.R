if(!file.exists("data")) { dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileUrl, destfile="./data/UCI_HAR.zip")
dateDownloaded <- date()

X_train_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/train/X_train.txt")
X_train <- read.table(X_train_txt)

Y_train_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/train/y_train.txt")
Y_train <- read.table(Y_train_txt)

subject_train_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/train/subject_train.txt")
subject_train <- read.table(subject_train_txt)

X_test_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/test/X_test.txt")
X_test <- read.table(X_test_txt)

Y_test_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/test/y_test.txt")
Y_test <- read.table(Y_test_txt)

subject_test_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/test/subject_test.txt")
subject_test <- read.table(subject_test_txt)

features_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/features.txt")
features <- read.table(features_txt)

activity_labels_txt <- unz("./data/UCI_HAR.zip", "UCI HAR Dataset/activity_labels.txt")
activity_labels <- read.table(activity_labels_txt )

Train <- cbind(X_train, Y_train, subject_train)
Test <- cbind(X_test, Y_test, subject_test)
data_set <- rbind(Train, Test)

library(plyr)
colnames(data_set) <- features[ ,2]
colnames(data_set)[562] <- "activity"
colnames(data_set)[563] <- "subject"

#colKeep <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 345:350, 424:430, 503:504, 516:517, 529:530, 542:543)


colKeep1 <- grep("mean", names(data_set) )
colKeep2 <- grep("std", names(data_set) )
colKeep <- c(colKeep1, colKeep2, 562, 563)
data_set2 <- data_set[,colKeep]

data_set2$activity[data_set2$activity == 1] <- "WALKING"
data_set2$activity[data_set2$activity == 2] <- "WALKING_UPSTAIRS"
data_set2$activity[data_set2$activity == 3] <- "WALKING_DOWNSTAIRS"
data_set2$activity[data_set2$activity == 4] <- "SITTING"
data_set2$activity[data_set2$activity == 5] <- "STANDING"
data_set2$activity[data_set2$activity == 6] <- "LAYING"

group_sub_act <- group_by(data_set2, subject, activity)
tidy_data <- summarize_each(group_sub_act, funs(mean))

write.table(tidy_data, "./tidy_data.txt", row.name=FALSE)
data <- read.table(file_path, header = TRUE) 
View(data)