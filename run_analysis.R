
### This function returns a tidy data set from the merged 'train' 
### and 'test' sets of Samsung accelerometer data from the Galaxy
### S smartphone
run_analysis <- function() {
    
    library(plyr)
    library(reshape2)
    
    # Read in the feature names, subset so we have only the names
    feat <- read.table("./data/features.txt")
    feat_labels <- feat[,2]
    
    # Get only the relevant mean() and std() measures
    means <- grep("mean()", feat_labels, fixed=TRUE)
    stds <- grep("std()", feat_labels, fixed=TRUE)
    means_stds <- c(means, stds)
    sort(means_stds)
    
    # Get the variable names for the data set
    var_names <- get_var_names(feat_labels, means_stds)
    
    # Get a data frame containing the merged 'train' and 'test' data
    merged_data <- merge_data(var_names, means_stds)
    
    # Create a new, tidy data set from the merged one
    tidy_data <- create_tidy_df(merged_data, var_names)
    tidy_data
}


### Merges the 'train' and 'test' data sets, returns a data frame
merge_data <- function(var_names, means_stds) {
    
    ### Get the 'train' data
    
    # Read in the participant IDs
    train_ids <- read.table("./data/train/subject_train.txt")
    
    # Get the activity numbers and labels
    train_activity_nums <- read.table("./data/train/y_train.txt")
    activity_labels <- read.table("./data/activity_labels.txt")
    
    # Convert the long list of activity numbers into a list of labels
    # (so that we can read it in english)
    mact <- merge(train_activity_nums, activity_labels, by.x="V1", by.y="V1", all=TRUE)
    train_act_names <- as.character(mact[,2])
    
    # Combine the IDs and activity labels into a data frame,
    # then give the variables meaningful names
    train_df <- cbind(train_ids, I(train_act_names))
    names(train_df) <- c("id","activity")
    
    # Get the 'train' results data
    train_data <- read.table("./data/train/x_train.txt")
    
    # Subset only the relevant variables and name them
    train_data <- subset(train_data, select=means_stds)
    names(train_data) <- var_names
    
    # Add this data onto our existing data frame
    train_df <- cbind(train_df, train_data)
    
    
    ### Get the 'test' data
    
    # Read in the participant IDs and activity numbers
    test_ids <- read.table("./data/test/subject_test.txt")
    test_activity_nums <- read.table("./data/test/y_test.txt")
    
    # Convert the long list of activity numbers into a list of labels
    # (so that we can read it in english)
    mact <- merge(test_activity_nums, activity_labels, by.x="V1", by.y="V1", all=TRUE)
    test_act_names <- as.character(mact[,2])
    
    # Combine the IDs and activity labels into a data frame
    test_df <- cbind(test_ids, I(test_act_names))
    names(test_df) <- c("id","activity")
    
    # Read the 'test' results data, subset the columns we want, 
    # name it, and add to our existing test_df
    test_data <- read.table("./data/test/x_test.txt")
    test_data <- subset(test_data, select=means_stds)
    names(test_data) <- var_names
    test_df <- cbind(test_df, test_data)
        
    # Add the test data frame to the train data frame
    df <- rbind(train_df, test_df)
    df
}


### Creates descriptive variable names
get_var_names <- function(feat_labels, means_stds) {
    
    # Rename the variables
    var_names <- feat_labels[means_stds]
    var_names <- sapply(var_names, tolower)
    var_names <- gsub("-","",var_names)
    var_names <- gsub("\\()","", var_names)
    var_names <- unname(var_names)
    var_names
}


### Creates a narrow, tidy data set of the means of all mean() and std()
### variables in the original data set
create_tidy_df <- function(data, var_names) {
    m <- melt(data, id=c("id","activity"))
    tidy <- ddply(m, c("id", "activity", "variable"), summarise, mean=mean(value))
    tidy
}