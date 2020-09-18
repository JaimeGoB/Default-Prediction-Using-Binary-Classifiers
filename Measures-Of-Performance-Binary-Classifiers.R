library(pROC)
library(MASS)
library(dplyr)
library(ISLR)
#DT
library(rpart)
library(rpart.plot)
#KNN
library(kknn)
library(class)


german_credit = read.csv("~/Documents/UTD/stat-learning-stat4360/Mini-Project-2/Discriminant-Analysis/Data/germancredit.csv")

#checking for missing data
sum(is.na(german_credit))
sum(is.null(german_credit))

#Changing ShellType from chr to factor
german_credit$Default <- factor(german_credit$Default)
str(german_credit)
# Seperating response and predictors
train_Y<- german_credit[['Default']]
train_X <- german_credit[,-1]

##############
# Linear Discriminant Analysis
##############
#Fitting the lda model
lda_fit <- lda(Default ~ ., data = german_credit)
lda_pred <- predict(lda_fit, train_X)

#Calculating the confusion matrix
confusion_matrix_lda <- table(lda_pred$class, train_Y)
confusion_matrix_lda 

#Setting up True positive, false postive ...
#Correct
TruePostive <- confusion_matrix_lda[1,1]
#InCorrect
FalseNegative <- confusion_matrix_lda[1,2]
#InCorrect
FalsePositive <- confusion_matrix_lda[2,1]
#Correct
TrueNegative <- confusion_matrix_lda[2,2]

#Measures of performance
sensitivity_lda <- TruePostive / (TruePostive + FalsePositive)
specificity_lda <- TrueNegative / (TrueNegative + FalseNegative)
missclassification_rate_lda <- ((FalsePositive + FalseNegative) 
                              / (TruePostive + TrueNegative + FalsePositive + FalseNegative))
missclassification_rate_lda
#ROC curve
roc_curve_lda <- roc(train_Y, lda_pred$posterior[,"1"], levels = c("0", "1"))
plot(roc_curve_lda, col = 'blue', main = "ROC Curve")
legend("bottomright",
       legend=c("ROC Curve - LDA"),
       col=c("blue"),
       lty=c(1))

##############
# Quadratic Discriminant Analysis
##############
qda_fit <- qda(Default ~ ., data = german_credit)
qda_pred <- predict(qda_fit, train_X)

#Calculating the confusion matrix
confusion_matrix_qda <- table(qda_pred$class, train_Y)
confusion_matrix_qda 

#Setting up True positive, false postive ...
#Correct
TruePostive <- confusion_matrix_qda[1,1]
#InCorrect
FalseNegative <- confusion_matrix_qda[1,2]
#InCorrect
FalsePositive <- confusion_matrix_qda[2,1]
#Correct
TrueNegative <- confusion_matrix_qda[2,2]

#Measures of performance
sensitivity_qda <- TruePostive / (TruePostive + FalsePositive)
specificity_qda <- TrueNegative / (TrueNegative + FalseNegative)
missclassification_rate_qda <- ((FalsePositive + FalseNegative) 
                              / (TruePostive + TrueNegative + FalsePositive + FalseNegative) )
missclassification_rate_qda
#ROC curve
roc_curve_qda <- roc(train_Y, qda_pred$posterior[,"1"], levels = c("0", "1"))
plot(roc_curve_qda, col = 'red', main = "ROC Curve")
legend("bottomright",
       legend=c("ROC Curve - QDA"),
       col=c("red"),
       lty=c(1))


##############
# Logistic Regression
#https://stackoverflow.com/questions/18449013/r-logistic-regression-area-under-curve
##############

#creating a different dataset for logistic regression
#we will add an extra column for pobability of default
german_credit_lgm = german_credit

#Fitting lg model and its prediction
logistic_regression_fit <- glm(Default ~ ., family = binomial,data = german_credit)
logistic_regression_pred <- predict(logistic_regression_fit, type = 'response')


#adding probability of default column
german_credit_lgm$probabilty_default = logistic_regression_pred

#Plotting a histogram of probs of default
summary(german_credit_lgm$probabilty_default)
hist(german_credit_lgm$probabilty_default,main = " Histogram ",xlab = "Probability of Default", col = 'light blue')
abline(v=mean(german_credit_lgm$probabilty_default),col="red")
legend("topright",
       legend=c("Mean"),
       col= "red",
       lty=c(1))


#setting up confusion matrix for logistic regression model
confusion_matrix_lgm <- table(logistic_regression_pred > 0.5, train_Y)
confusion_matrix_lgm


#Setting up True positive, false postive ...
#Correct
TruePostive <- confusion_matrix_lgm[1,1]
#InCorrect
FalseNegative <- confusion_matrix_lgm[1,2]
#InCorrect
FalsePositive <- confusion_matrix_lgm[2,1]
#Correct
TrueNegative <- confusion_matrix_lgm[2,2]

#Measures of performance
sensitivity_lgm <- TruePostive / (TruePostive + FalsePositive)
specificity_lgm <- TrueNegative / (TrueNegative + FalseNegative)
missclassification_rate_lgm <- ((FalsePositive + FalseNegative) 
                              / (TruePostive + TrueNegative + FalsePositive + FalseNegative) )
missclassification_rate_lgm

#ROC curve
roc_curve_lgm <- roc(Default ~ logistic_regression_pred, data = german_credit)
plot(roc_curve_lgm, col = 'green', main = "ROC Curve")
legend("bottomright",
       legend=c("ROC Curve - LR"),
       col=c("green"),
       lty=c(1))

##############
# Decision Tree
##############
#Fitting lg model and its prediction
decision_tree_fit <- rpart(Default ~ ., 
                           data = german_credit,
                           method = "class")
decision_tree_pred <- predict(decision_tree_fit, type = "class")

#visual of decission tree
rpart.plot(decision_tree_fit, main="Decision Tree German Credit")

#Setting up confusio matrix
confusion_matrix_dt <- table(decision_tree_pred , train_Y)
confusion_matrix_dt

#Setting up True positive, false postive ...
#Correct
TruePostive <- confusion_matrix_dt[1,1]
#InCorrect
FalseNegative <- confusion_matrix_dt[1,2]
#InCorrect
FalsePositive <- confusion_matrix_dt[2,1]
#Correct
TrueNegative <- confusion_matrix_dt[2,2]

#Measures of performance
sensitivity_dt <- TruePostive / (TruePostive + FalsePositive)
specificity_dt <- TrueNegative / (TrueNegative + FalseNegative)
missclassification_rate_dt <- ((FalsePositive + FalseNegative) 
                             / (TruePostive + TrueNegative + FalsePositive + FalseNegative) )
missclassification_rate_dt





#ROC curve
#https://www.youtube.com/watch?v=B0ZuGCibYRw
#time 9:41
decision_tree_pred_prob <- predict(decision_tree_fit, type = "prob")
roc_curve_dt <- roc(train_Y, decision_tree_pred_prob[,1])
plot(roc_curve_dt, col = 'pink', main = "ROC Curve")
legend("bottomright",
       legend=c("ROC Curve - DT"),
       col=c("pink"),
       lty=c(1))

##############
# KNN
##############
knn_fit <- train.kknn(Default ~ ., 
                      german_credit, 
                      ks = 3,
                      kernel = "rectangular", 
                      scale = TRUE)
# knn_pred <- as.numeric(predict(knn_fit, german_credit))
knn_pred <- predict(knn_fit, german_credit)

#Setting up confusio matrix
confusion_matrix_knn <- table(knn_pred, train_Y)
confusion_matrix_knn

#Setting up True positive, false postive ...
#Correct
TruePostive <- confusion_matrix_knn[1,1]
#InCorrect
FalseNegative <- confusion_matrix_knn[1,2]
#InCorrect
FalsePositive <- confusion_matrix_knn[2,1]
#Correct
TrueNegative <- confusion_matrix_knn[2,2]

#Measures of performance
sensitivity_knn <- TruePostive / (TruePostive + FalsePositive)
specificity_knn <- TrueNegative / (TrueNegative + FalseNegative)
missclassification_rate_knn <- ((FalsePositive + FalseNegative) 
                              / (TruePostive + TrueNegative + FalsePositive + FalseNegative) )
missclassification_rate_knn

#ROC curve
knn_pred_prob <- predict(knn_fit, german_credit, type = "prob")
roc_curve_knn <- roc(train_Y, knn_pred_prob[,1])
plot(roc_curve_knn, col = 'black', main = "ROC Curve")
legend("bottomright",
       legend=c("ROC Curve - KNN"),
       col=c("black"),
       lty=c(1))

#Comparing all classifiers
plot(roc_curve_lda, col = 'blue', main = "ROC Curve Binary Classifcations")
lines(roc_curve_qda, col = 'red')
lines(roc_curve_lgm, col = 'green')
lines(roc_curve_dt, col = 'pink')
lines(roc_curve_knn, col = 'black')
legend("bottomright",
       legend=c("Linear Discriminant Analysis", "Quadratic Discriminant Analysis", "Logistic Regression","Decision Tree", "KNN"),
       col=c("blue", "red", "green", "pink", "black"),
       lty=c(1))



##############
# #combing all missclassifcation values
##############
all_missclassification_rates <- cbind(missclassification_rate_lda,
                                      missclassification_rate_qda,
                                      missclassification_rate_lgm,
                                      missclassification_rate_dt,
                                      missclassification_rate_knn)

colnames(all_missclassification_rates) <- c("LDA", "QDA", "LG", "DT", "KNN")
rownames(all_missclassification_rates) <- c("missclassification Rate")

all_missclassification_rates
