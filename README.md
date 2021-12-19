# Samsung_data
This README file describes how to derive the tidy_data.txt file from the run_analysis.R script.

From lines 6 to 21, we are working on the trainset data:

We first replace the column names in the X_train.txt dataset with the names provided in the features.txt dataset.
Next, we replace the y_train.txt activity codes with the actual activity names using the activity_labels.txt dataset.
We also read in the subject labels in subject_train.txt dataset.
We then use cbind() to merge the X_train.txt, y_train.txt and subject_train.txt datasets together and remove the column named train_label.

We repeat the above steps for the testset data (lines 24 to 36).

In line 39, we use rbind() to merge the trainset and testset data (merged_data).

Next, we extract from merged_data the subject and activity columns (i.e. subject_label and activity_label) and also extract the columns containing mean or standard deviation measurements.

We then rename the columns in merged_data with descriptive variable names. Details on each variable can be found in the code book.

Lastly, we use group_by() and summarise_all() from dplyr to calculate the average of each variable for each subject and activity, resulting in the tidy_data.txt generated.
