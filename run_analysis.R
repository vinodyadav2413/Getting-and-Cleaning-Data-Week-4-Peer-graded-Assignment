#load the dplyr package
library(dplyr)
#Read variable names
features<-read.table("./UCI HAR dataset/features.txt", col.names = c("n","functions"))

#Read activity labels
activity_labels<-read.table("./UCI HAR dataset/activity_labels.txt",col.names = c("code", "activity"))

#Read training data
X_train<-read.table("./UCI HAR dataset/train/X_train.txt",col.names = features$functions)
Y_train<-read.table("./UCI HAR dataset/train/Y_train.txt",col.names = "code")
subject_train<-read.table("./UCI HAR dataset/train/subject_train.txt",col.names = "subject")

#Read testing data
X_test<-read.table("./UCI HAR dataset/test/X_test.txt",col.names = features$functions)
Y_test<-read.table("./UCI HAR dataset/test/Y_test.txt",col.names = "code")
subject_test<-read.table("./UCI HAR dataset/test/subject_test.txt",col.names = "subject")

# Step 1: Merging training and testing datasets
X<-rbind(X_train,X_test)
Y<-rbind(Y_train,Y_test)
subject<-rbind(subject_train,subject_test)
merged_data<-cbind(subject,X,Y)

#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
Tidydata <- merged_data %>% select(subject, code, contains("mean"), contains("std"))

#Step 3: Uses descriptive activity names to name the activities in the data set.
Tidydata$code <- activity_labels[TidyData$code, 2]

#Step 4: Appropriately labels the data set with descriptive variable names.
names(Tidydata)[2] = "activity"
names(Tidydata)<-gsub("Acc", "Accelerometer", names(Tidydata))
names(Tidydata)<-gsub("Gyro", "Gyroscope", names(Tidydata))
names(Tidydata)<-gsub("BodyBody", "Body", names(Tidydata))
names(Tidydata)<-gsub("Mag", "Magnitude", names(Tidydata))
names(Tidydata)<-gsub("^t", "Time", names(Tidydata))
names(Tidydata)<-gsub("^f", "Frequency", names(Tidydata))
names(Tidydata)<-gsub("tBody", "TimeBody", names(Tidydata))
names(Tidydata)<-gsub("-mean()", "Mean", names(Tidydata), ignore.case = TRUE)
names(Tidydata)<-gsub("-std()", "STD", names(Tidydata), ignore.case = TRUE)
names(Tidydata)<-gsub("-freq()", "Frequency", names(Tidydata), ignore.case = TRUE)
names(Tidydata)<-gsub("angle", "Angle", names(Tidydata))
names(Tidydata)<-gsub("gravity", "Gravity", names(Tidydata))

#Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
FinalData <- Tidydata %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(FinalData, "TidyData.txt", row.name=FALSE)



