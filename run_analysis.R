#Rename the variables in X_test and X_train with the data from features
#First,create factor with new variable names in features
features<-features$V2
#Rename the variables in X_test and X_train with features.
names(X_test)<-features
names(X_train)<-features

#Merge data sets that have matching number of variables.
#Subject_test and subject_train both have 1 variable.
Bind_rows(subject_test,subject_train)

#Do the same with y_test and y_train since they also have 1 variable each.
Bind_rows(y_test, y_train)

#x_test and X-train each have 561 variables. Merge these together as well.
Bind_rows(x_test, X_train)

#We need to change the data in y_train and y_test to it's appropriate activity from the data in activity_labels
#First, create a look up table with data from activity-labels
lut<-c("1"="WALKING", 
       "2"="WALKING_UPSTAIRS", 
       "3"="WALKING_DOWNSTAIRS",
       "4"="SITTING", 
       "5"="STANDING",
       "6"="LAYING")
#Then isolate the variable we want to change from y_test and y_train.
test_V1<-y_test$V1
train_V1<-y_train$V1
#Apply the look up table to these new objects
test_V1<-lut[test_V1]
train_V1<-lut[train_V1]
#The number of observations in test_V1 and train_V1 matches the number of observations in X_test and X_train.Let's add these as new variables to X-test andX_train. 
#Create a new column called ActivityLabel containing y_test and add to X_test
X-test$ActivityLabel<-y_test$V1

#Do the same with the data for y_train into X-train
X-train$ActivityLabel<-y_train$V1

#Add subject_train into a column of X_train
X_train$Subject<-subject_train$V1

#Add subject_test data into a new column of X_test
X_test$Subject<-subject_test$V1

#Merge X_test with X_train. 
library(dplyr)
Whole_df<-bind_rows(X-test,X_train)

#Extract the variables containing mean, standard deviation for each measurement. 
library(dplyr)
select(Whole_df, contains("mean"), 
                 contains("Mean"), 
                 contains("std"))
#Create new variable Activity_Name that shows the corresponding activity name based on data found in activity_labels
#First, create a look up table with data from activity_labels
lut<-c("1"="WALKING", 
       "2"="WALKING_UPSTAIRS", 
       "3"="WALKING_DOWNSTAIRS",
       "4"="SITTING", 
       "5"="STANDING",
       "6"="LAYING")
#Now apply this function to ActivityLabel in a new column. 
library(dplyr)

