# Step 1
# Define a variable with the folder main path that contains the raw data
path       <-"./data/UCI HAR Dataset/"
pathTest   <-"./data/UCI HAR Dataset/test/"
pathTrain  <-"./data/UCI HAR Dataset/train/"

# Step 2
# Get and create a Table with the activity_labels.txt file
activity_lables <- read.table(paste(path,"activity_labels.txt",sep = ""), 
                              sep=" ",
                              col.names=c("id_activity", "name_activity"))

# Step 3
# Get and create a Table with the features.txt file
features_lables <- read.table(paste(path,"features.txt",sep = ""), 
                              sep=" ",
                              col.names=c("id_feature", "name_feature"))

# Step 4
# Get and create a Table with both Test and Train "subject_test.txt" and "subject_train.txt" files
Test_Subjects  <- (read.table(paste(pathTest,"subject_test.txt",sep = ""),col.names=c("id_subject")))
Train_Subjects <- (read.table(paste(pathTrain,"subject_train.txt",sep = ""),col.names=c("id_subject")))

# Step 5
# Get and create a Table with both Test and Train "y_test.txt" and "y_train.txt" files
Test_ytest   <- (read.table(paste(pathTest,"y_test.txt",sep = ""),col.names=c("id_activity")))
Train_ytrain <- (read.table(paste(pathTrain,"y_train.txt",sep = ""),col.names=c("id_activity")))

# Step 6
# Get and create a Table with both Test and Train "X_test.txt" and "X_train.txt" files
Test_Xtest   <- (read.table(paste(pathTest,"X_test.txt",sep = "")))
Train_Xtrain <- (read.table(paste(pathTrain,"X_train.txt",sep = "")))


# Step 7
# Create a Features frame, only with the mean and std columns name
meancols <- grep("mean",features_lables$name_feature)
stdcols  <- grep("std",features_lables$name_feature)
mean_std_cols <- append(meancols,stdcols)

ColumnNames <- merge(as.data.frame(mean_std_cols),features_lables,by.x = "mean_std_cols",by.y = "id_feature")

Test_Features  <- Test_Xtest[,as.vector(mean_std_cols)]
names(Test_Features) <- make.names(ColumnNames[[2]])
Train_Features <- Train_Xtrain[,as.vector(mean_std_cols)]
names(Train_Features) <- make.names(ColumnNames[[2]])

# Step 8
# Create data frame with the columns required for both Test and Train
Test_DF <- Test_Subjects
Test_DF <- cbind(Test_DF,Test_ytest)
Test_DF <- cbind(Test_DF,Test_Features)

Train_DF <- Train_Subjects
Train_DF <- cbind(Train_DF,Train_ytrain)
Train_DF <- cbind(Train_DF,Train_Features)

# Step 9
# Create only one Data Frame from both Test_DF and Train_DF
DataFrame <- rbind(Test_DF,Train_DF)

# Step 10
# Merge the DataFrame with the file that contains the activities lables
DataFrame <- merge(DataFrame,activity_lables,by.x = "id_activity",by.y = "id_activity")


######################################################################

# Independent tidy data set with the average of each variable for each activity and each subject

library(dplyr)
DataFrameTidy  <- group_by(DataFrame,name_activity,id_subject)
DataFrameTidyS <- summarize_each(DataFrameTidy,funs(mean), 3:81)

#####################################################################

#Save both Finals Data Frames into a csv file

write.table(DataFrame, file ="./DataFrame.txt",row.name=FALSE )
write.table(DataFrameTidyS, file ="././DataFrameTidySummarized..txt",row.name=FALSE )

