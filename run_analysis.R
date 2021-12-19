setwd("C:/Users/UCI HAR Dataset")
library(dplyr)

#1. Merges the training and the test sets to create one data set.
#trainset
feature_names <- read.table("./features.txt")

train <- read.table("./train/X_train.txt")
names(train)[1:561] <- feature_names[1:561,2]

# Uses descriptive activity names to name the activities in the data set
train_label <- read.table("./train/y_train.txt")
activity_label <- read.table("./activity_labels.txt")
train_label <- left_join(train_label, activity_label, by = "V1")
colnames(train_label) <- c("train_label", "activity_label")

train_subject <- read.table("./train/subject_train.txt")
colnames(train_subject) <- "subject_label"

train <- cbind(train, train_label,train_subject)
train <- subset(train, select = -c(train_label))

#testset
test <- read.table("./test/X_test.txt")
names(test)[1:561] <- feature_names[1:561,2]

# Uses descriptive activity names to name the activities in the data set
test_label <- read.table("./test/y_test.txt")
test_label <- left_join(test_label, activity_label, by = "V1")
colnames(test_label) <- c("test_label", "activity_label")

test_subject <- read.table("./test/subject_test.txt")
colnames(test_subject) <- "subject_label"

test <- cbind(test, test_label,test_subject)
test <- subset(test, select = -c(test_label))

#Merge train and test
merged_data <- rbind(train,test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
temp <- merged_data %>%
  select(subject_label,activity_label) 
merged_data <- merged_data[ , grep("mean|std" , names(merged_data))]
merged_data <- merged_data[, -grep("meanFreq", names(merged_data))]

merged_data <- cbind(temp, merged_data)
  
# Appropriately labels the data set with descriptive variable names. 
colnames(merged_data) <- c("subject", "activity", "mean_time_body_acceleration_X", "mean_time_body_acceleration_Y",
                           "mean_time_body_acceleration_Z", "std_time_body_acceleration_X", "std_time_body_acceleration_Y",
                           "std_time_body_acceleration_Z", "mean_time_gravity_acceleration_X", "mean_time_gravity_acceleration_Y",
                           "mean_time_gravity_acceleration_Z", "std_time_gravity_acceleration_X", "std_time_gravity_acceleration_Y",
                           "std_time_gravity_acceleration_Z","mean_time_body_linear_acceleration_jerk_X", "mean_time_body_linear_acceleration_jerk_Y",
                           "mean_time_body_linear_acceleration_jerk_Z", "std_time_body_linear_acceleration_jerk_X", "std_time_body_linear_acceleration_jerk_Y",
                           "std_time_body_linear_acceleration_jerk_Z", "mean_time_angular_velocity_X", "mean_time_angular_velocity_Y",
                           "mean_time_angular_velocity_Z", "std_time_angular_velocity_X", "std_time_angular_velocity_Y", "std_time_angular_velocity_Z",
                           "mean_time_angular_velocity_jerk_X", "mean_time_angular_velocity_jerk_Y", "mean_time_angular_velocity_jerk_Z",
                           "std_time_angular_velocity_jerk_X", "std_time_angular_velocity_jerk_Y", "std_time_angular_velocity_jerk_Z",
                           "mean_time_euclidean_body_acceleration", "std_time_euclidean_body_acceleration", "mean_time_euclidean_gravity_acceleration",
                           "std_time_euclidean_gravity_acceleration", "mean_time_euclidean_body_linear_acceleration_jerk", "std_time_euclidean_body_linear_acceleration_jerk",
                           "mean_time_euclidean_angular_velocity", "std_time_euclidean_angular_velocity", "mean_time_euclidean_angular_velocity_jerk",
                           "std_time_euclidean_angular_velocity_jerk", "mean_FFT_body_acceleration_X", "mean_FFT_body_acceleration_Y",
                           "mean_FFT_body_acceleration_Z", "std_FFT_body_acceleration_X", "std_FFT_body_acceleration_Y",
                           "std_FFT_body_acceleration_Z", "mean_FFT_body_linear_acceleration_jerk_X", "mean_FFT_body_linear_acceleration_jerk_Y",
                           "mean_FFT_body_linear_acceleration_jerk_Z", "std_FFT_body_linear_acceleration_jerk_X", "std_FFT_body_linear_acceleration_jerk_Y",
                           "std_FFT_body_linear_acceleration_jerk_Z", "mean_FFT_angular_velocity_X", "mean_FFT_angular_velocity_Y",
                           "mean_FFT_angular_velocity_Z", "std_FFT_angular_velocity_X", "std_FFT_angular_velocity_Y", "std_FFT_angular_velocity_Z",
                           "mean_FFT_euclidean_body_acceleration", "std_FFT_euclidean_body_acceleration", 
                           "meanFFT__euclidean_body_linear_acceleration_jerk", "std_FFT_euclidean_body_linear_acceleration_jerk",
                           "mean_FFT_euclidean_angular_velocity", "std_FFT_euclidean_angular_velocity", 
                           "mean_FFT_euclidean_angular_velocity_jerk", "std_FFT_euclidean_angular_velocity_jerk"
                           )

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
second_dataset <- merged_data %>%
                  group_by(subject, activity)%>%
                  summarise_all(mean)
second_dataset <- as.data.frame(second_dataset)
write.table(second_dataset, file = "tidy_data.txt", row.names = FALSE) 
