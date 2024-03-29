##########################
# Linear Regression
##########################

# load MASS, corrplot and ggplot2
library(MASS)
#install.packages('corrplot')
library(corrplot)
library(ggplot2)

# examine the structure of the Boston dataset
str(Boston)

# bring out the docs for the dataset 
?Boston

# compute the correlation matrix
corr.matrix <- cor(Boston)

# one option for plotting correlations: using colors to represent the extent of correlation
corrplot(corr.matrix, method = "number", type = "upper", diag = FALSE, number.cex=0.75, tl.cex = 0.85)

# another option, with both colors and exact correlation scores
corrplot.mixed(corr.matrix, tl.cex=0.75, number.cex=0.75)

#  plot *lstat* against the response variable
ggplot(data = Boston, mapping = aes(x = lstat, y = medv)) +
  geom_point(shape = 1) +
  theme_classic()

#  plot *rm* against the response variable
ggplot(data = Boston, mapping = aes(x = rm, y = medv)) +
  geom_point(shape = 1) +
  theme_classic()


#############################################
# Split the data into training and test sets
#############################################

# install.packages('caret')
library(caret)

# assure the replicability of the results by setting the seed 
set.seed(123)

# generate indices of the observations to be selected for the training set
train.indices <- createDataPartition(Boston$medv, p = 0.80, list = FALSE)
# select observations at the positions defined by the train.indices vector
train.boston <- Boston[train.indices,]
# select observations at the positions that are NOT in the train.indices vector
test.boston <- Boston[-train.indices,]


##########################
# Simple Linear Regression
##########################

# build an lm model with a formula: medv ~ lstat 
lm1 <- lm(medv ~ lstat, data = train.boston)

# print the model summary
summary(lm1)

# print all attributes stored in the fitted model 
names(lm1)

# print the coefficients
lm1$coefficients

# print the coefficients with the coef() f.
coef(lm1)

# compute the RSS
lm1_rss <- sum(lm1$residuals^2)
lm1_rss

# compute 95% confidence interval
confint(lm1, level = 0.95)

# plot the data points and the regression line
ggplot(data = train.boston, mapping = aes(x = lstat, y = medv)) +
  geom_point(shape = 1) +
  geom_smooth(method = "lm") +
  theme_classic()

##########################
## Making predictions
##########################

# calculate the predictions with the fitted model over the test data
medv_pred <- predict(lm1, newdata = test.boston)
head(medv_pred, 10)

# calculate the predictions with the fitted model over the test data, including the confidence interval
medv_pred <- predict(lm1, newdata = test.boston, interval = "confidence")
head(medv_pred, 10)

# calculate the predictions with the fitted model over the test data, including the prediction interval
medv_pred <- predict(lm1, newdata = test.boston, interval = "predict")
head(medv_pred, 10)


##########################
## Diagnostic Plots
##########################

# split the plotting area into 4 cells
par(mfrow=c(2,2))

# print the diagnostic plots
plot(lm1)

# reset the plotting area
par(mfrow=c(1,1)) 

# compute the leverage statistic
lm1.leverage <- hatvalues(lm1)
plot(lm1.leverage)

# calculate the number of high leverage points 
n <- nrow(train.boston)
p <- 1
cutoff <- 2*(p+1)/n
length(which(lm1.leverage > cutoff))

###############################
## Multiple Linear Regression
###############################

# generate the scatterplots for variables medv, lstat, rm, ptratio
pairs(~medv + lstat + rm + ptratio, data = train.boston)

# build an lm model with a train dataset using the formula: medv ~ lstat + rm + ptratio
lm2 <- lm(medv ~ lstat + rm + ptratio, data = train.boston)

# print the model summary
summary(lm2)

# calculate the predictions with the lm2 model over the test data
lm2.predict <- predict(lm2, newdata = test.boston)

# print out a few predictions
head(lm2.predict)

# combine the test set with the predictions
test.boston.lm2 <- cbind(test.boston, pred = lm2.predict) 

# plot actual (medv) vs. predicted values
ggplot(data = test.boston.lm2) + 
  geom_density(mapping = aes(x=medv, color = 'real')) +
  geom_density(mapping = aes(x=pred, color = 'predicted')) +
  scale_colour_discrete(name ="medv distribution") +
  theme_classic()

# calculate RSS
lm2.test.RSS <- sum((lm2.predict - test.boston$medv)^2)

# calculate TSS
lm.test.TSS <- sum((mean(train.boston$medv) - test.boston$medv)^2)

# calculate R-squared on the test data
lm2.test.R2 <- 1 - lm2.test.RSS/lm.test.TSS
lm2.test.R2

# calculate RMSE
lm2.test.RMSE <- sqrt(lm2.test.RSS/nrow(test.boston))
lm2.test.RMSE

# compare medv mean to the RMSE
mean(test.boston$medv)
lm2.test.RMSE/mean(test.boston$medv)

# build an lm model with the training set using all of the variables except chas
lm3 <- lm(medv ~ . - chas, data = train.boston) 
# note the use of '.' to mean all variables and the use of '-' to exclude the chas variable

# print the model summary
summary(lm3)

# check for multicolinearity using the vif function (from the 'car' package)
library(car)

# calculate vif
vif(lm3)

# calculate square root of the VIF
sort(sqrt(vif(lm3)))

# build an lm model with the training set using all of the variables except chas and tax
# (multicolinearity was detected for 'tax') 
lm4 <- lm(medv ~ . - (chas + tax), data = train.boston) 

# check the VIF scores again
sort(sqrt(vif(lm4)))

# next, we will exclude *nox* and build a new model (lm5):
lm5 <- lm(medv ~ . - (chas + tax + nox), data = train.boston) 

sort(sqrt(vif(lm5)))
# The *dis* variable is the edge case

summary(lm5)

# The summary of lm5 indicated that *dis* should be excluded
lm6 <- lm(medv ~ . - (chas + tax + nox + dis), data = train.boston) 

summary(lm6)


# calculate the predictions with the new model over the test data
lm6.predict <- predict(lm6, newdata = test.boston)

# print out a few predictions
head(lm6.predict)

# combine the test set with the predictions
test.boston.lm6 <- cbind(test.boston, pred = lm6.predict) 

# plot actual (medv) vs. predicted values
ggplot(data = test.boston.lm6) + 
  geom_density(mapping = aes(x=medv, color = 'real')) +
  geom_density(mapping = aes(x=pred, color = 'predicted')) +
  scale_colour_discrete(name ="medv distribution") +
  theme_classic()

# calculate RSS
lm6.test.RSS <- sum((lm6.predict - test.boston$medv)^2)

# calculate R-squared on the test data
lm6.test.R2 <- 1 - lm6.test.RSS/lm.test.TSS
lm6.test.R2

# calculate RMSE
lm6.test.RMSE <- sqrt(lm6.test.RSS/nrow(test.boston))
lm6.test.RMSE

