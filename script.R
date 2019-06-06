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
p1 <- ggplot(data = Boston, mapping = aes(x = lstat, y = medv)) +
geom_point(shape = 1)
p1

#  plot *rm* against the response variable
p2 <- ggplot(data = Boston, mapping = aes(x = rm, y = medv)) +
geom_point(shape = 1)
p2

##########################
# Simple Linear Regression
##########################

# build an lm model with a formula: medv ~ lstat 
lm1 <- lm(medv ~ lstat, data = Boston)

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

##########################
## Making predictions
##########################

# create a test data frame containing only lstat variable and three observations: 5, 10, 15
df.test <- data.frame(lstat=c(5, 10, 15))

# calculate the predictions with the fitted model over the test data
predict(lm1, newdata = df.test)

# calculate the predictions with the fitted model over the test data, including the confidence interval
predict(lm1, newdata = df.test, interval = "confidence")

# calculate the predictions with the fitted model over the test data, including the prediction interval
predict(lm1, newdata = df.test, interval = "predict")

# plot the data points and the regression line
ggplot(data = Boston, mapping = aes(x = lstat, y = medv)) +
  geom_point(shape = 1) +
  geom_smooth(method = "lm")

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
n <- nrow(Boston)
p <- 1
cutoff <- 2*(p+1)/n
length(which(lm1.leverage > cutoff))

###############################
## Multiple Linear Regression
###############################

# generate the scatterplots for variables medv, lstat, rm, ptratio
pairs(~medv + lstat + rm + ptratio, data = Boston)

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

# print the summary of both train and test sets
summary(train.boston$medv)
summary(test.boston$medv)

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
ggplot() + 
  geom_density(data = test.boston.lm2, mapping = aes(x=medv, color = 'real')) +
  geom_density(data = test.boston.lm2, mapping = aes(x=pred, color = 'predicted')) +
  scale_colour_discrete(name ="medv distribution")

# calculate RSS
lm2.test.RSS <- sum((lm2.predict - test.boston$medv)^2)

# calculate TSS
lm.test.TSS <- sum((mean(test.boston$medv) - test.boston$medv)^2)

# calculate R-squared on the test data
lm2.test.R2 <- 1 - lm2.test.RSS/lm.test.TSS
lm2.test.R2

# calculate RMSE
lm2.test.RMSE <- sqrt(lm2.test.RSS/nrow(test.boston))
lm2.test.RMSE

# compare medv mean to the RMSE
mean(test.boston$medv)
lm2.test.RMSE/mean(test.boston$medv)

# build an lm model with the training set using all of the variables
lm3 <- lm(medv ~ ., data = train.boston) # note the use of '.' to mean all variables

# print the model summary
summary(lm3)

# calculate the predictions with the lm3 model over the test data
lm3.predict <- predict(lm3, newdata = test.boston)

# print out a few predictions
head(lm3.predict)

# combine the test set with the predictions
test.boston.lm3 <- cbind(test.boston, pred = lm3.predict) 

# plot actual (medv) vs. predicted values
ggplot() + 
  geom_density(data = test.boston.lm3, mapping = aes(x=medv, color = 'real')) +
  geom_density(data = test.boston.lm3, mapping = aes(x=pred, color = 'predicted')) +
  scale_colour_discrete(name ="medv distribution")

# calculate RSS
lm3.test.RSS <- sum((lm3.predict - test.boston$medv)^2)

# calculate R-squared on the test data
lm3.test.R2 <- 1 - lm3.test.RSS/lm.test.TSS
lm3.test.R2

# calculate RMSE
lm3.test.RMSE <- sqrt(lm3.test.RSS/nrow(test.boston))
lm3.test.RMSE

# load the 'car' package
library(car)

# calculate vif
vif(lm3)

# calculate square root of the VIF
sqrt(vif(lm3))