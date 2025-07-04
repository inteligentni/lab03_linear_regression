##########################
# Linear Regression
##########################

# load MASS, corrplot and ggplot2

#install.packages('corrplot')

# examine the structure of the Boston dataset

# bring out the docs for the dataset 

# compute the correlation matrix

# one option for plotting correlations: using colors to represent the extent of correlation

# another option, with both colors and exact correlation scores

#  plot *lstat* against the response variable


#  plot *rm* against the response variable


#############################################
# Split the data into training and test sets
#############################################

# install.packages('caret')

# assure the replicability of the results by setting the seed 

# generate indices of the observations to be selected for the training set

# select observations at the positions defined by the train.indices vector

# select observations at the positions that are NOT in the train.indices vector


##########################
# Simple Linear Regression
##########################

# build an lm model with a formula: medv ~ lstat 

# print the model summary

# print all attributes stored in the fitted model 

# print the coefficients

# print the coefficients with the coef() f.

# compute the RSS

# compute 95% confidence interval

# plot the data points and the regression line


##########################
## Making predictions
##########################

# calculate the predictions with the fitted model over the test data

# calculate the predictions with the fitted model over the test data, including the confidence interval

# calculate the predictions with the fitted model over the test data, including the prediction interval


##########################
## Diagnostic Plots
##########################

# split the plotting area into 4 cells

# print the diagnostic plots

# reset the plotting area

# compute the leverage statistic


# calculate the number of high leverage points 


###############################
## Multiple Linear Regression
###############################

# generate the scatterplots for variables medv, lstat, rm, ptratio

# build an lm model with a train dataset using the formula: medv ~ lstat + rm + ptratio

# print the model summary

# calculate the predictions with the lm2 model over the test data

# print out a few predictions

# combine the test set with the predictions

# plot actual (medv) vs. predicted values


# calculate RSS

# calculate TSS

# calculate R-squared on the test data


# calculate RMSE


# compare medv mean to the RMSE


# build an lm model with the training set using all of the variables except chas

# note the use of '.' to mean all variables and the use of '-' to exclude the chas variable

# print the model summary

# check for multicolinearity using the vif function (from the 'car' package)

# calculate vif

# calculate square root of the VIF

# build an lm model with the training set using all of the variables except chas and tax
# (multicolinearity was detected for 'tax') 

# check the VIF scores again

# next, we will exclude *nox* and build a new model (lm5):

# The *dis* variable is the edge case


# The summary of lm5 indicated that *dis* should be excluded



# calculate the predictions with the new model over the test data

# print out a few predictions

# combine the test set with the predictions

# plot actual (medv) vs. predicted values

# calculate RSS

# calculate R-squared on the test data


# calculate RMSE


