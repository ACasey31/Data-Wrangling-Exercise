
#Load all 8 files from original dataset
 subject_test <- read.table("~/GitHub/Data-Wrangling-Ex.3/subject_test.txt", quote="\"", comment.char="")
   View(subject_test)
 subject_train <- read.table("~/GitHub/Data-Wrangling-Ex.3/subject_train.txt", quote="\"", comment.char="")
   View(subject_train)
 y_test <- read.table("~/GitHub/Data-Wrangling-Ex.3/y_test.txt", quote="\"", comment.char="")
   View(y_test)
 y_train <- read.table("~/GitHub/Data-Wrangling-Ex.3/y_train.txt", quote="\"", comment.char="")
   View(y_train)
 X_test <- read.table("~/GitHub/Data-Wrangling-Ex.3/X_test.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
View(X_test)
 X_train <- read.table("~/GitHub/Data-Wrangling-Ex.3/X_train.txt", quote="\"", comment.char="")
   View(X_train)
 activity_labels <- read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
   View(activity_labels)
 features <- read.table("~/Downloads/UCI HAR Dataset/features.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
   View(features)
   
# 1. Merge all train and test data into one dataset.
#Begin with data sets that have matching number of variables.
   
#Subject_test and subject_train both have 1 variable.
load(dplyr)
Subject<-bind_rows(subject_test,subject_train)

#Do the same with y_test and y_train since they also have 1 variable each.
Y<-bind_rows(y_test, y_train)

#x_test and X-train each have 561 variables. 
X<-rbind(X_test, X_train)

#features has the same number of variables as X datasets.
#Rename columns with data from features respectively.
f<-features$V2
names(X)<-f

#Combine all into one data frame called new_df.
new_df<-data.frame(c(X, Y, Subject))
#Rename columns in new dataset for clarity.
names(new_df[562:563])
names(new_df)[562]<-"y_data"
names(new_df)[563]<-"subject_data"

# 2. Extract columns containing mean and standard deviation for each measurement. 
library(dplyr)
mean_df<-select(new_df, contains("mean", ignore.case = TRUE))
std_df<-select (new_df, contains("std", ignore.case = TRUE))
measurements<-data.frame(c(mean_df, std_df))

# 3. Create variables called ActivityLabel and ActivityName that label all observations with the corresponding activity labels and names respectively

#Add Y to averages_df as ActivityLabel variable.
measurements$ActivityLabel<-Y
names(measurements[87])

#Apply the activity names in activity_labels to their respective code in Y.
library(plyr)
Yfactor<-as.factor(Y$V1)

#Create variable ActivityName with the lut applied to Y.
measurements$ActivityName<-revalue(Yfactor, c("1"="WALKING", 
                                                               "2"="WALKING_UPSTAIRS", 
                                                               "3"="WALKING_DOWNSTAIRS",
                                                               "4"="SITTING", 
                                                               "5"="STANDING",
                                                               "6"="LAYING"))
names(measurements[88])

# 4. From the data set in step 3, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
measurements$Subject<-Subject
measurements$Subject<-as.vector(measurements$Subject$V1, mode="any")
measurements$ActivityLabel<-as.vector(measurements$ActivityLabel$V1, mode="any")

Mean_df<-group_by(measurements, Subject, ActivityLabel)
Mean_df<-summarise_each(Mean_df, funs(mean))

Mean_df$ActivityLabel<-as.character(Mean_df$ActivityLabel)
Mean_df$ActivityName<-revalue(Mean_df$ActivityLabel, c("1"="WALKING", 
                                                       "2"="WALKING_UPSTAIRS", 
                                                       "3"="WALKING_DOWNSTAIRS",
                                                       "4"="SITTING", 
                                                       "5"="STANDING",
                                                       "6"="LAYING")) 




