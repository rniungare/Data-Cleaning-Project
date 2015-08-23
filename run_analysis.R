#Get the path of data directory
path_rf <- file.path("./data" , "UCI HAR Dataset")

# Read data from the data files into variables
dtActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dtActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dtSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dtSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dtFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dtFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#Merging of training and test data

dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
dtActivity<- rbind(dtActivityTrain, dtActivityTest)
dtFeatures<- rbind(dtFeaturesTrain, dtFeaturesTest)

names(dtSubject)<-c("subject")
names(dtActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dtFeatures)<- dataFeaturesNames$V2

dtCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dtFeatures, dtCombine)

#Extracts only the measurements on the mean and standard deviation for each measurement.

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#Appropriately labels the data set with descriptive names.

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)









