##########################
#
# Linear Regression
# 
##########################

# load MASS, corrplot and ggplot2
library(MASS)
library(ggplot2)
install.packages('corrplot')
library(corrplot)

# examine the docs for the Boston dataset 
?Boston

# examine the structure of the dataset
str(Boston)

# compute the correlation matrix
boston_cor <- cor(Boston)
View(boston_cor)

# one option for plotting correlations: 
# using colors to represent the extent of correlation
corrplot(boston_cor, type = "upper", diag = FALSE)


# another option, with both colors and exact correlation scores
corrplot.mixed(boston_cor)


# create scatterplots for the dependent variable (medv) and 
# candidate independent variables (lstat, rm, ptratio)
ggplot(Boston, aes(x = medv, y = lstat)) + geom_point()
ggplot(Boston, aes(x = medv, y = rm)) + geom_point()


#############################################
# Split the data into training and test sets
#############################################

# install and load caret package
install.packages('caret')
library(caret)

summary(Boston$medv)

# assure the replicability of the results by setting the seed 
# generate indices of the observations to be selected for the training set
set.seed(3)
train_indices <- createDataPartition(Boston$medv, p = 0.8, list = FALSE)

# select observations at the positions defined by the train.indices vector
boston_train <- Boston[train_indices, ]
# select observations at the positions that are NOT in the train.indices vector
boston_test <- Boston[-train_indices, ]

summary(boston_train$medv)
summary(boston_test$medv)

###################################
## Create a linear regression model
###################################

# build an lm model with a train dataset using the formula: medv ~ lstat + rm + ptratio
lm1 <- lm(medv ~ lstat + rm + ptratio, data = boston_train)

# print the model summary
summary(lm1)

# print the coefficients
coef(lm1)

# compute 95% confidence interval for the coefficients
confint(lm1)


##########################
## Diagnostic Plots
##########################

# split the plotting area into 4 cells
par(mfrow=c(2,2))

# print the diagnostic plots
plot(lm1)

# reset the plotting area
par(mfrow=c(1,1))



###########################################
## Make predictions and evaluate the model
###########################################

# calculate the predictions with the fitted model over the test data
lm1_pred <- predict(lm1, newdata = boston_test)

# print out a few predictions
head(lm1_pred)

# calculate the predictions with the fitted model over the test data, 
# including the confidence interval
lm1_pred <- predict(lm1, newdata = boston_test, interval = 'conf')
head(lm1_pred)

# combine the test set with the predictions
boston_test$medv_pred <- lm1_pred[,1]

# plot actual (medv) vs. predicted values
ggplot(boston_test) +
  geom_density(aes(x=medv, color='actual')) +
  geom_density(aes(x=medv_pred, color='predicted')) +
  theme_minimal()


# calculate RSS (Residual Sum of Squares)
RSS_lm1 <- sum((boston_test$medv - boston_test$medv_pred)^2)

# calculate TSS (Total Sum of Squares)
TSS <- sum((boston_test$medv - mean(boston_train$medv))^2)

# calculate R-squared on the test data
# R2 = (TSS-RSS)/TSS = 1 - RSS/TSS
R2_lm1 <- 1 - RSS_lm1/TSS
R2_lm1

# calculate RMSE
# RMSE = sqrt(RSS/n)
RMSE_lm1 <- sqrt(RSS_lm1/nrow(boston_test))
RMSE_lm1

# compare medv mean to the RMSE
RMSE_lm1/mean(boston_test$medv)

##############################################################
## Create a more complex model and examine multicollinearity
##############################################################

# build a new model using all of the variables
lm2 <- lm(medv ~ ., data = boston_train)

# print the model summary
summary(lm2)

# check for multicollinearity using the vif function (from the 'car' package)
install.packages('car')
library(car)
?vif

# calculate vif
vif(lm2)

# calculate square root of the VIF
sort(sqrt(vif(lm2)))

# build a new model using all of the variables except those with the 
# highest VIF value
lm3 <- lm(medv ~ . - (tax + nox), data = boston_train)

sort(sqrt(vif(lm3)))

# print the model summary
summary(lm3)

# calculate the predictions over the test data
lm3_pred <- predict(lm3, newdata = boston_test)

# combine the test set with the predictions
boston_test$medv_pred_lm3 <- lm3_pred
colnames(boston_test)[15] <- "medv_pred_lm1"

# plot actual (medv) vs. predicted values
ggplot(boston_test) +
  geom_density(aes(x=medv, color='actual')) +
  geom_density(aes(x=medv_pred_lm1, color='lm1_predicted')) +
  geom_density(aes(x=medv_pred_lm3, color='lm3_predicted')) +
  theme_minimal()

# calculate RSS
RSS_lm3 <- sum((boston_test$medv - boston_test$medv_pred_lm3)^2)

# calculate R-squared on the test data
R2_lm3 <- 1 - RSS_lm3/TSS
R2_lm3
R2_lm1

# calculate RMSE
RMSE_lm3 <- sqrt(RSS_lm3/nrow(boston_test))
RMSE_lm3
RMSE_lm1
