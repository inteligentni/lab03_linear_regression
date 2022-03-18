##########################
#
# Linear Regression
# 
##########################

# load MASS, corrplot and ggplot2


# examine the docs for the Boston dataset 



# examine the structure of the dataset



# compute the correlation matrix


# one option for plotting correlations: 
# using colors to represent the extent of correlation



# another option, with both colors and exact correlation scores



# create scatterplots for the dependent variable (medv) and 
# candidate independent variables (lstat, rm, ptratio)



#############################################
# Split the data into training and test sets
#############################################

# install and load caret package


# assure the replicability of the results by setting the seed 


# generate indices of the observations to be selected for the training set


# select observations at the positions defined by the train.indices vector


# select observations at the positions that are NOT in the train.indices vector


###################################
## Create a linear regression model
###################################

# build an lm model with a train dataset using the formula: medv ~ lstat + rm + ptratio


# print the model summary


# print the coefficients


# compute 95% confidence interval for the coefficients



##########################
## Diagnostic Plots
##########################

# split the plotting area into 4 cells


# print the diagnostic plots


# reset the plotting area



###########################################
## Make predictions and evaluate the model
###########################################

# calculate the predictions with the fitted model over the test data


# print out a few predictions


# calculate the predictions with the fitted model over the test data, 
# including the confidence interval


# combine the test set with the predictions


# plot actual (medv) vs. predicted values



# calculate RSS


# calculate TSS


# calculate R-squared on the test data


# calculate RMSE


# compare medv mean to the RMSE


##############################################################
## Create a more complex model and examine multicollinearity
##############################################################

# build an lm model with the training set using all of the variables except chas


# print the model summary


# check for multicolinearity using the vif function (from the 'car' package)


# calculate square root of the VIF


# build an lm model with the training set using all of the variables except chas and tax
# (multicolinearity was detected for 'tax') 


# check the VIF scores again


# next, we will exclude *nox* and build a new model (lm5):


# The summary of lm5 indicated that *dis* should be excluded


# calculate the predictions with the new model over the test data


# combine the test set with the predictions


# plot actual (medv) vs. predicted values


# calculate RSS


# calculate R-squared on the test data


# calculate RMSE

