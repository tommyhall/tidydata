#run_analysis.R readme

This script loads accelerometer data from a Samsung Galaxy S smartphone and creates a new, tidy data set with mean values for each subject, activity, and measure.


###Running the code

To generate the tidy data set, you first need to load the script using the command:
 ```
 source("run_analysis.R")
 ```

You can then call the **run_analysis()** function like so:
 ```
 tidy_data <- run_analysis()
 ```


###Additional functions

The run_analysis() function makes use of the following functions, also found in run_analysis.R
* **get_var_names:** creates descriptive variable names for the tidy data set.
* **merge_data:** reads in the 'train' and 'test' sets of Samsung Galaxy S accelerometer data, drops all measures that are not mean() or std(), and merges into one data frame
* **create_tidy_df:** creates a new tidy data set from the merged data frame, with means of the variables for each subject and activity