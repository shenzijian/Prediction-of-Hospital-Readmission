library(readr)
library(dplyr)
#define NA string

setwd("~/Desktop/UMD/课程/第二学期/758T/Project Files")


##read valuable row and turn problematic values to NA
na_strings <- c("Unknown", "Declined to Answer","","#N/A","5 Purple","#VALUE!",'Expired','Deceased','Hospice/Medical Facility','Hospice/Home')

hos <- read_csv("Hospitals_Train.csv", na=na_strings)

### real data 
real_test <- read_csv("Hospitals_Test_Y_data.csv")


test_X = read_csv('Hospitals_Test_X.csv', na=na_strings)
test_whole = read.csv('Hospitals_Test_X.csv')

hos <- hos[1:38221,]

hos$ACUITY_ARR[is.na(hos$ACUITY_ARR)] <- 'new_category'
hos$CHARGES[is.na(hos$CHARGES)] <- 0
hos$CONSULT_IN_ED[is.na(hos$CONSULT_IN_ED)] <- 0    ####because distribution of CHARGE's NA's RETURN similar to CHARGE == 0
hos$ADMIT_RESULT[is.na(hos$ADMIT_RESULT)] <- 'new_category'
hos$RACE[is.na(hos$RACE)] <- 'new_category'
hos$ETHNICITY[is.na(hos$ETHNICITY)] <- 'new_category'
# hos$RISK[is.na(hos$RISK)] <- 'new_category'
# hos$SEVERITY[is.na(hos$SEVERITY)] <- 'new_category'


test_X$ACUITY_ARR[is.na(test_X$ACUITY_ARR)] <- 'new_category'
test_X$CHARGES[is.na(test_X$CHARGES)] <- 0
test_X$CONSULT_IN_ED[is.na(test_X$CONSULT_IN_ED)] <- 0
test_X$ADMIT_RESULT[is.na(test_X$ADMIT_RESULT)] <- 'new_category'
test_X$RACE[is.na(test_X$RACE)] <- 'new_category'
test_X$ETHNICITY[is.na(test_X$ETHNICITY)] <- 'new_category'
# test_X$RISK[is.na(test_X$RISK)] <- 'new_category'
# test_X$SEVERITY[is.na(test_X$SEVERITY)] <- 'new_category'


## check distribution of "3-" and "new_cate"

urge <- hos %>% 
  filter(ACUITY_ARR == '3-Urgent')

table(urge$RETURN)

newC <- hos %>% 
  filter(ACUITY_ARR == 'new_category')

table(newC$RETURN)

#create bin
hos$AGE = cut(hos$AGE, c(-Inf, 24,34,44,59,74,89, Inf), labels=1:7)
hos$HOUR_ARR = cut(hos$HOUR_ARR, c(-Inf,6,12,18,Inf), labels = 1:4)






test_X$AGE = cut(test_X$AGE, c(-Inf, 24, 34, 44, 59, 74, 89, Inf), labels = 1:7)
test_X$HOUR_ARR = cut(test_X$HOUR_ARR, c(-Inf, 6, 12, 18, Inf), labels = 1:4)




#delete unneccessary column
clean1 = subset(hos, select=-c(INDEX,WEEKDAY_DEP,HOUR_DEP,MONTH_DEP,RISK,SEVERITY))

#omit NA value after subset
hos=na.omit(clean1)
dim(hos)

clean2 = subset(test_X, select = -c(WEEKDAY_DEP,HOUR_DEP,MONTH_DEP,RISK,SEVERITY))
test_X = na.omit(clean2)



#test_X$RETURN = ifelse(test_X$RETURN == 'Yes', 1, 0)
dim(test_X)
dim(test_whole)

##assign omit data label as RETURN = 'No'



#create index list which row contain NA
NA_list <- setdiff(test_whole$INDEX, test_X$INDEX)

#create new column RETURN and assign row with NA_STRING to NO.
namevector <- c("RETURN")
test_whole[,namevector] <- NA

test_whole$RETURN[test_whole$INDEX %in% NA_list] <- 'No'

test_whole$RETURN <- ifelse(test_whole$INDEX %in% NA_list, 'No',test_whole$RETURN)

No_R = test_whole %>%
  filter(RETURN == 'No') %>%
  dplyr::select(INDEX,RETURN)




#change some small number levels into 'Other'
a = hos[ hos$RACE %in%  names(table(hos$RACE))[table(hos$RACE) <50] , ]
unique(a$RACE)
hos$RACE[which(hos$RACE %in% unique(a$RACE))]<- 'Other'
table(hos$RACE)

b = hos[ hos$FINANCIAL_CLASS %in%  names(table(hos$FINANCIAL_CLASS))[table(hos$FINANCIAL_CLASS) <50] , ]
unique(b$FINANCIAL_CLASS)
hos$FINANCIAL_CLASS[which(hos$FINANCIAL_CLASS %in% unique(b$FINANCIAL_CLASS))]<- 'Other'
table(hos$FINANCIAL_CLASS)

c = hos[ hos$ED_RESULT %in%  names(table(hos$ED_RESULT))[table(hos$ED_RESULT) <50] , ]
unique(c$ED_RESULT)
hos$ED_RESULT[which(hos$ED_RESULT %in% unique(c$ED_RESULT))]<- 'Other'
table(hos$ED_RESULT)

d = hos[ hos$DC_RESULT %in%  names(table(hos$DC_RESULT))[table(hos$DC_RESULT) <100] , ]
unique(d$DC_RESULT)
hos$DC_RESULT[which(hos$DC_RESULT %in% unique(d$DC_RESULT))]<- 'Other'
table(hos$DC_RESULT)

a1 = test_X[ test_X$RACE %in%  names(table(test_X$RACE))[table(test_X$RACE) <50] , ]
unique(a1$RACE)
test_X$RACE[which(test_X$RACE %in% unique(a1$RACE))]<- 'Other'
table(test_X$RACE)

b1 = test_X[ test_X$FINANCIAL_CLASS %in%  names(table(test_X$FINANCIAL_CLASS))[table(test_X$FINANCIAL_CLASS) <50] , ]
unique(b1$FINANCIAL_CLASS)
test_X$FINANCIAL_CLASS[which(test_X$FINANCIAL_CLASS %in% unique(b1$FINANCIAL_CLASS))]<- 'Other'
table(test_X$FINANCIAL_CLASS)

c1 = test_X[ test_X$ED_RESULT %in%  names(table(test_X$ED_RESULT))[table(test_X$ED_RESULT) <50] , ]
unique(c1$ED_RESULT)
test_X$ED_RESULT[which(test_X$ED_RESULT %in% unique(c1$ED_RESULT))]<- 'Other'
table(test_X$ED_RESULT)

d1 = test_X[ test_X$DC_RESULT %in%  names(table(test_X$DC_RESULT))[table(test_X$DC_RESULT) <100] , ]
unique(d1$DC_RESULT)
test_X$DC_RESULT[which(test_X$DC_RESULT %in% unique(d1$DC_RESULT))]<- 'Other'
table(test_X$DC_RESULT)
#turn some variables to factor variable
hos$WEEKDAY_ARR = as.factor(hos$WEEKDAY_ARR)
hos$AGE = as.factor(hos$AGE)
hos$HOUR_ARR = as.factor(hos$HOUR_ARR)
hos$MONTH_ARR = as.factor(hos$MONTH_ARR)
hos$CONSULT_CHARGE = as.factor(hos$CONSULT_CHARGE)
hos$CONSULT_ORDER = as.factor(hos$CONSULT_ORDER)
hos$CONSULT_IN_ED = as.factor(hos$CONSULT_IN_ED)
hos$SAME_DAY = as.factor(hos$SAME_DAY)
hos$RETURN =as.factor(hos$RETURN)
hos$HOSPITAL = as.factor(hos$HOSPITAL)
hos$GENDER = as.factor(hos$GENDER)
hos$FINANCIAL_CLASS = as.factor(hos$FINANCIAL_CLASS)
hos$RACE = as.factor(hos$RACE)
hos$ETHNICITY = as.factor(hos$ETHNICITY)
hos$ED_RESULT = as.factor(hos$ED_RESULT)
hos$ACUITY_ARR = as.factor(hos$ACUITY_ARR)
hos$DC_RESULT = as.factor(hos$DC_RESULT)
hos$DIAGNOSIS = as.factor(hos$DIAGNOSIS)
hos$ADMIT_RESULT = as.factor(hos$ADMIT_RESULT)

test_X$WEEKDAY_ARR = as.factor(test_X$WEEKDAY_ARR)
test_X$AGE = as.factor(test_X$AGE)
test_X$HOUR_ARR = as.factor(test_X$HOUR_ARR)
test_X$MONTH_ARR = as.factor(test_X$MONTH_ARR)
test_X$CONSULT_CHARGE = as.factor(test_X$CONSULT_CHARGE)
test_X$CONSULT_ORDER = as.factor(test_X$CONSULT_ORDER)
test_X$CONSULT_IN_ED = as.factor(test_X$CONSULT_IN_ED)
test_X$SAME_DAY = as.factor(test_X$SAME_DAY)
test_X$HOSPITAL = as.factor(test_X$HOSPITAL)
test_X$GENDER = as.factor(test_X$GENDER)
test_X$FINANCIAL_CLASS = as.factor(test_X$FINANCIAL_CLASS)
test_X$RACE = as.factor(test_X$RACE)
test_X$ETHNICITY = as.factor(test_X$ETHNICITY)
test_X$ED_RESULT = as.factor(test_X$ED_RESULT)
test_X$ACUITY_ARR = as.factor(test_X$ACUITY_ARR)
test_X$DC_RESULT = as.factor(test_X$DC_RESULT)
test_X$DIAGNOSIS = as.factor(test_X$DIAGNOSIS)
test_X$ADMIT_RESULT = as.factor(test_X$ADMIT_RESULT)
# # # phase 2 , logistic regression # # #

#set seed
set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]

model_full <- glm(RETURN~.,data=hos_train,family="binomial")
model_stepwise = step(model_full, direction = 'both')
stepwise_pred = predict(model_stepwise, newdata = hos_valid, type = 'response')
stepwise_class = ifelse(stepwise_pred > 0.5, 'Yes','No')

sum(ifelse(stepwise_class==hos_valid$RETURN,1,0))/nrow(hos_valid)


###[1] 0.7780725


###baseline##
sum(ifelse(hos_valid$RETURN=='No',1,0))/nrow(hos_valid)


##################### logistic in testing###################


set.seed(1313)

####create a test_X without index#### 
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)



#####run model
model_full <- glm(RETURN~.,data=hos,family="binomial")
model_stepwise = step(model_full, direction = 'both')
stepwise_pred = predict(model_stepwise, newdata = test_X1, type = 'response')
stepwise_class = ifelse(stepwise_pred > 0.5, 'Yes','No')


# create RETURN column for test_X and attach log_class to it
namevector <- c("RETURN")
test_X[,namevector] <- stepwise_class

step_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
step_R = as.data.frame(step_R)

total = rbind(No_R, step_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN



#### check RETURN
table(test_whole$RETURN)

####accuracy in testing

result = table(real_test$RETURN,test_whole$RETURN)
result
# ACC
(result[1,1] + result[2,2]) / sum(result)

# TPR
result[2,2]/ (result[2,1]+result[2,2])







### output a format 
output <- test_whole %>% 
  dplyr::select(1,27)





#output the csv
write.csv(output, file = "stepwise.csv",row.names=FALSE)

##########################################分隔符QDA -DAY2########################################################################################
library(MASS)

set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]

qda_model = qda(ifelse(RETURN=="Yes",1,0)~., data = hos_train)
summary(qda_model)
qda_predict = predict(qda_model, newdata = hos_valid)
qda_preds = qda_predict$posterior[,2]
qda_class = ifelse(qda_preds > 0.5, "Yes", "No")

sum(ifelse(qda_class==hos_valid$RETURN,1,0))/nrow(hos_valid)

#create a test_X without INDEX
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

### run qda model
qda_model = qda(ifelse(RETURN=="Yes",1,0)~., data = hos)
summary(qda_model)
qda_predict = predict(qda_model, newdata = test_X1)
qda_preds = qda_predict$posterior[,2]
qda_class = ifelse(qda_preds > 0.5, "Yes", "No")

### attach return column to test_X dataset
namevector <- c("RETURN")
test_X[,namevector] <- qda_class
library(dplyr)
qda_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
qda_R = as.data.frame(qda_R)

total = rbind(No_R, qda_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN



#output the csv
write.csv(test_whole, file = "submission_TEAM_3(QDA).csv",row.names=FALSE)


###################分隔符qda有问题，Yes太多################

##########################################分隔符LDA ########################################################################################
library(MASS)

############ LDA in train######

set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]

lda_model = lda(ifelse(RETURN=="Yes",1,0)~., data = hos_train)
summary(lda_model)
lda_predict = predict(lda_model, newdata = hos_valid)
lda_preds = lda_predict$posterior[,2]
lda_class = ifelse(lda_preds > 0.5, "Yes", "No")
result = table(lda_class, hos_valid$RETURN)
result


lda_acc = sum(ifelse(lda_class==hos_valid$RETURN,1,0))/nrow(hos_valid)
lda_TPR = result[2,2] / (result[2,1] + result[2,2])

sum(ifelse(hos_valid$RETURN=='No',1,0))/nrow(hos_valid)

#baseline[1] 0.7585323
#[1] 0.7759505

###########spider plot###########

cutoffs = c(0.20, 0.23, 0.25, 0.27, 0.30, 0.33, 0.35, 0.40, 0.45, 0.5)
full_acc = rep(0, 10)
full_TPR = rep(0, 10)

for (i in 1:10){
  lda_class = ifelse(lda_preds > cutoffs[i], 'Yes', 'No')
  confuse_test = table(hos_valid$RETURN, lda_class)
  lda_acc[i] = (confuse_test[1,1] + confuse_test[2,2]) / sum(confuse_test)
  lda_TPR[i] = confuse_test[2,2] / (confuse_test[2,1] + confuse_test[2,2])
}
data.frame(cutoffs, lda_acc, lda_TPR)

plot(cutoffs, step_TPR, type = 'l', col = 'green', xlab = 'Cutoff', ylab = 'Value', main = 'Spider Plot')
lines(cutoffs, step_acc, col = 'blue')
legend(0.4, 0.55, legend = c('TPR', 'Accuracy'), fill = c('green', 'blue'))
#create a test_X without INDEX
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

### run qda model
lda_model = lda(ifelse(RETURN=="Yes",1,0)~., data = hos)
summary(lda_model)
lda_predict = predict(lda_model, newdata = test_X1)
lda_preds = lda_predict$posterior[,2]
lda_class = ifelse(lda_preds > 0.5, "Yes", "No")

### attach return column to test_X dataset
namevector <- c("RETURN")
test_X[,namevector] <- lda_class
library(dplyr)
lda_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
lda_R = as.data.frame(lda_R)

total = rbind(No_R, lda_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN


output <- test_whole %>%
  dplyr::select(1,27)



####accuracy in testing

result = table(real_test$RETURN,test_whole$RETURN)
result
# ACC
(result[1,1] + result[2,2]) / sum(result)

# TPR
result[2,2]/ (result[2,1]+result[2,2])



#output the csv
write.csv(output, file = "submission_TEAM_3(LDA).csv",row.names=FALSE)



##############boosting#################

#set seed
set.seed(1313)
# check how many row
num_obs = nrow(hos)

train_obs <- sample(num_obs,0.7*num_obs)
hos_rest <- hos[train_obs,]
hos_test <- hos[-train_obs,]

library(gbm)

## The one downside to gbm in R: it requires numeric variables
## So, let's turn our factor into a 0 and 1 numeric variable and tell it to use a binomial ("bernoulli") distribution
##    with numeric variables from our data set
boost.hos=gbm(as.numeric(RETURN)-1~.,data=hos_rest,distribution="bernoulli",n.trees=1000)
summary(boost.hos)

boosting_probs=predict(boost.hos,newdata=hos_test,n.trees=1000,type="response")

boosting_class=ifelse(boosting_probs>0.5,'Yes','No')
sum(ifelse(boosting_class==hos_test$RETURN,1,0))/nrow(hos_test)

# [1] 0.7780725


########################### in TESTING ############################
#create a test_X without INDEX
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

set.seed(1313)

library(gbm)

## The one downside to gbm in R: it requires numeric variables
## So, let's turn our factor into a 0 and 1 numeric variable and tell it to use a binomial ("bernoulli") distribution
##    with numeric variables from our data set
boost.hos=gbm(as.numeric(RETURN)-1~.,data=hos,distribution="bernoulli",n.trees=1000)
summary(boost.hos)

boosting_probs=predict(boost.hos,newdata=test_X1,n.trees=1000,type="response")

boosting_class=ifelse(boosting_probs>0.26,'Yes','No')
table(boosting_class)




### attach return column to test_X dataset
namevector <- c("RETURN")
test_X[,namevector] <- boosting_class
library(dplyr)
boosting_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
boosting_R = as.data.frame(boosting_R)

total = rbind(No_R, boosting_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN

output <- test_whole %>%
  dplyr::select(1,27)

#####testing accuracy TPR in boosting#####

result = table(real_test$RETURN,test_whole$RETURN)
result

###ACC
(result[1,1] + result[2,2]) / sum(result)
###TPR
result[2,2]/sum(confuse_test[2,])








#output the csv
write.csv(output, file = "submission_TEAM_3(Boosting).csv",row.names=FALSE)















##############################LASSO#################
library(glmnet)

#set seed
set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]


hos_X <- model.matrix( ~ .-1, hos[,c(1:20)])
hos_train_X <- model.matrix( ~ .-1, hos_train[,c(1:20)])
hos_valid_X <- model.matrix( ~ .-1, hos_valid[,c(1:20)])

glmnet_lasso=glmnet(hos_train_X,hos_train$RETURN,family="binomial",alpha=1)
glmnet_lasso.cv=cv.glmnet(hos_train_X,hos_train$RETURN,family="binomial",alpha=1)
plot(glmnet_lasso.cv)
best.lambda.new=glmnet_lasso.cv$lambda.min
best.lambda.new

lasso_probs = predict(glmnet_lasso,s=best.lambda.new,newx=hos_valid_X,type="response")
lasso_class = ifelse(lasso_probs>0.50,'Yes','No')

sum(ifelse(lasso_class==hos_valid$RETURN,1,0))/nrow(hos_valid)
# [1] 0.778603

cutoffs = c(0.20, 0.23, 0.25, 0.27, 0.30, 0.33, 0.35, 0.40, 0.45, 0.5)
lasso_acc = rep(0, 10)
lasso_TPR = rep(0, 10)

for (i in 1:10){
  lasso_class = ifelse(lasso_probs > cutoffs[i], 'Yes', 'No')
  confuse_test = table(hos_valid$RETURN, lasso_class)
  lasso_acc[i] = (confuse_test[1,1] + confuse_test[2,2]) / sum(confuse_test)
  lasso_TPR[i] = confuse_test[2,2] / (confuse_test[2,1] + confuse_test[2,2])
}
data.frame(cutoffs, lasso_acc, lasso_TPR)

plot(cutoffs, lasso_TPR, type = 'l', col = 'green', xlab = 'Cutoff', ylab = 'Value', main = 'Lasso Spider Plot')
lines(cutoffs, lasso_acc, col = 'blue')
legend(0.4, 0.55, legend = c('TPR', 'Accuracy'), fill = c('green', 'blue'))



##################LASSO in testing##################

set.seed(1313)

####create a test_X without index#### 
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

######格式一致######
test_X1 <- rbind(hos[1, ] , test_X1)
test_X1 <- test_X1[-1,]

#####run model
hos_X <- model.matrix( ~ .-1, hos[,c(1:20)])
hos_test_X1 <- model.matrix( ~ .-1, test_X1[,c(1:20)])


glmnet_lasso=glmnet(hos_X,hos$RETURN,family="binomial",alpha=1)
glmnet_lasso.cv=cv.glmnet(hos_X,hos$RETURN,family="binomial",alpha=1)
plot(glmnet_lasso.cv)
best.lambda.new=glmnet_lasso.cv$lambda.min
best.lambda.new

lasso_probs = predict(glmnet_lasso,s=best.lambda.new,newx=hos_test_X1,type="response")
lasso_class = ifelse(lasso_probs>0.5,'Yes','No')
sum(ifelse(lasso_class==test_X1$RETURN,1,0))/nrow(hos_test)



# create RETURN column for test_X and attach log_class to it
namevector <- c("RETURN")
test_X[,namevector] <- lasso_class

lasso_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
lasso_R = as.data.frame(lasso_R)

total = rbind(No_R, lasso_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN



#### check RETURN
table(test_whole$RETURN)


####ACC TPR
result = table(real_test$RETURN,test_whole$RETURN)
result

###ACC
(result[1,1] + result[2,2]) / sum(result)
###TPR
result[2,2]/sum(confuse_test[2,])






### output a format 
output <- test_whole %>% 
  dplyr::select(1,27)




#output the csv
write.csv(output, file = "lasso.csv",row.names=FALSE)


##################ridge##############
library(glmnet)

#set seed
set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]


hos_X <- model.matrix( ~ .-1, hos[,c(1:20)])
hos_train_X <- model.matrix( ~ .-1, hos_train[,c(1:20)])
hos_valid_X <- model.matrix( ~ .-1, hos_valid[,c(1:20)])


glmnet_ridge=glmnet(hos_train_X,hos_train$RETURN,family="binomial",alpha=0)
glmnet_ridge.cv=cv.glmnet(hos_train_X,hos_train$RETURN,family="binomial",alpha=0)
plot(glmnet_ridge.cv)
best.lambda.new1=glmnet_ridge.cv$lambda.min
best.lambda.new1

ridge_probs = predict(glmnet_ridge,s=best.lambda.new1,newx=hos_valid_X,type="response")
ridge_class = ifelse(ridge_probs>0.5,'Yes','No')
sum(ifelse(ridge_class==hos_valid$RETURN,1,0))/nrow(hos_valid)
sum(ifelse(hos_valid$RETURN=='No',1,0))/nrow(hos_valid)
#[[1] 0.7784262




##################ridge in testing##################

set.seed(1313)

####create a test_X without index#### 
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

######格式一致######
test_X1 <- rbind(hos[1, ] , test_X1)
test_X1 <- test_X1[-1,]

#####run model
hos_X <- model.matrix( ~ .-1, hos[,c(1:20)])
hos_test_X1 <- model.matrix( ~ .-1, test_X1[,c(1:20)])


glmnet_ridge=glmnet(hos_X,hos$RETURN,family="binomial",alpha=0)
glmnet_ridge.cv=cv.glmnet(hos_X,hos$RETURN,family="binomial",alpha=0)
plot(glmnet_ridge.cv)
best.lambda.new=glmnet_ridge.cv$lambda.min
best.lambda.new

ridge_probs = predict(glmnet_ridge,s=best.lambda.new,newx=hos_test_X1,type="response")
ridge_class = ifelse(ridge_probs>0.5,'Yes','No')




# create RETURN column for test_X and attach log_class to it
namevector <- c("RETURN")
test_X[,namevector] <- ridge_class

ridge_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
ridge_R = as.data.frame(ridge_R)

total = rbind(No_R, ridge_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN



#### check RETURN
table(test_whole$RETURN)

### output a format 
output <- test_whole %>% 
  dplyr::select(1,27)





#output the csv
write.csv(output, file = "ridge.csv",row.names=FALSE)

##############bagging##################

# Bagging
library(randomForest)
bg.trees=randomForest(RETURN~.,data=hos_train, mtry = 20, importance=TRUE)
bg.trees

bg_preds=predict(bg.trees,newdata=hos_valid,type="prob")
bg_probs=bg_preds[,2]
bg_class=ifelse(bg_probs>0.5,"Yes",'No')

table(hos_valid$RETURN,bg_class)

sum(ifelse(bg_class==hos_valid$RETURN,1,0))/nrow(hos_valid)
# [1] 0.7677277

#####

bg.trees=randomForest(RETURN~.,data=hos,importance=TRUE)
bg.trees

##create test_X1 no INDEX

clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)




###predict with model rf.trees
#create RETURN column
namevector <- c("RETURN")
test_X1[,namevector] <- NA

##trick  https://stackoverflow.com/questions/24829674/r-random-forest-error-type-of-predictors-in-new-data-do-not-match
test_X1 <- rbind(hos[1, ] , test_X1)
test_X1 <- test_X1[-1,]



bg_preds=predict(bg.trees,newdata=test_X1,type="prob")
bg_probs=bg_preds[,2]
bg_class=ifelse(bg_probs>0.5,"Yes","No")

namevector <- c("RETURN")
test_X[,namevector] <- rf_class

bg_R = test_X %>%
  select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
bg_R = as.data.frame(bg_R)

total = rbind(No_R, bg_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN

#output format


output <- test_whole %>%
  dplyr::select(1,27)
#output the csv
write.csv(output, file = "bagging.csv",row.names=FALSE)


################# Random Forest #################
library(randomForest)
#set seed
set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]

library(randomForest)
rf.trees=randomForest(RETURN~.,data=hos_train,importance=TRUE)
rf.trees

rf_preds=predict(rf.trees,newdata=hos_valid,type="prob")
rf_probs=rf_preds[,2]
rf_class=ifelse(rf_probs>0.52,"Yes",'No')

table(hos_valid$RETURN,rf_class)

sum(ifelse(rf_class==hos_valid$RETURN,1,0))/nrow(hos_valid)

###[1] 0.7786914
######testing##

rf.trees=randomForest(RETURN~.,data=hos,ntree=1000, mtry=6,importance=TRUE)
rf.trees

##create test_X1 no INDEX

clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)




###predict with model rf.trees
#create RETURN column
namevector <- c("RETURN")
test_X1[,namevector] <- NA

##trick  https://stackoverflow.com/questions/24829674/r-random-forest-error-type-of-predictors-in-new-data-do-not-match
test_X1 <- rbind(hos[1, ] , test_X1)
test_X1 <- test_X1[-1,]



rf_preds=predict(rf.trees,newdata=test_X1,type="prob")
rf_probs=rf_preds[,2]
rf_class=ifelse(rf_probs>0.5,"Yes","No")
# create RETURN column for test_X and attach rf_class to it
namevector <- c("RETURN")
test_X[,namevector] <- rf_class

RF_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
RF_R = as.data.frame(RF_R)

total = rbind(No_R, RF_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN

#output format


output <- test_whole %>%
  dplyr::select(1,27)


####accuracy and TPR in testing#


result = table(real_test$RETURN,test_whole$RETURN)
result

# ACC
(result[1,1] + result[2,2]) / sum(result)

# TPR
result[2,2]/ (result[2,1]+result[2,2])

#output the csv
write.csv(output, file = "RF.csv",row.names=FALSE)
######################## KNN ####################
set.seed(1313)
# check how many row
num_obs = nrow(hos)

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]

library(class)

hos_X <- model.matrix( ~ .-1, hos[,c(1:20)])
hos_train_X <- model.matrix( ~ .-1, hos_train[,c(1:20)])
hos_valid_X <- model.matrix( ~ .-1, hos_valid[,c(1:20)])

hos_train_X <- as.data.frame(hos_train_X)
hos_valid_X <- as.data.frame(hos_valid_X)


train.return=hos_train$RETURN
valid.return=hos_valid$RETURN

knn.pred=knn(hos_train_X,hos_valid_X,train.return,k=131)


sum(ifelse(knn.pred==valid.return,1,0))/nrow(hos_valid)

sum(ifelse(valid.return=='No',1,0))/nrow(hos_valid)

##########knn in testing########


### create same matrix type of testing data as training data
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

### type consistency
test_X1 = rbind(hos[1,-21],test_X1)
test_X1 = test_X1[-1,]

hos_X <- model.matrix( ~ .-1, hos[,c(1:20)])
hos_test_X <- model.matrix( ~ .-1, test_X1[,c(1:20)])

hos_X <- as.data.frame(hos_X)
hos_test_X <- as.data.frame(hos_test_X)

hos.return=hos$RETURN

knn.pred=knn(hos_X,hos_test_X,hos.return,k=131)

namevector <- c("RETURN")
test_X[,namevector] <- xgb_class

knn_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
knn_R = as.data.frame(knn_R)

total = rbind(No_R, knn_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN



#### check RETURN
table(test_whole$RETURN)

### output a format 
output <- test_whole %>% 
  dplyr::select(1,27)


table(output$RETURN)


#output the csv
write.csv(output, file = "knn.csv",row.names=FALSE)




# ###############XGBoost##################

set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations

train_obs <- sample(num_obs,0.7*num_obs)
hos_train <- hos[train_obs,]
hos_valid <- hos[-train_obs,]


library(xgboost)
label = hos_train$RETURN
label = ifelse(label == 'Yes', 1, 0)
hos_X = model.matrix(~.-1, hos[, c(1:20)])
hos_train_X = model.matrix(~.-1, hos_train[, c(1:20)])
hos_valid_X = model.matrix(~.-1, hos_valid[, c(1:20)])

### create same matrix type of testing data as training data
clean3 = subset(test_X, select = -c(INDEX))
test_X1 = na.omit(clean3)

### type consistency
test_X1 = rbind(hos[1,-21],test_X1)
test_X1 = test_X1[-1,]


hos_test_X1 = model.matrix(~.-1, test_X1[, c(1:20)])
label_w = ifelse(hos$RETURN == 'Yes', 1, 0)

### accuracy in training and validation in whole training dataset



bst = xgboost(data = hos_train_X, label = label, max.depth = 5, eta = 0.1, nround = 300, nthread = 4, objective = 'binary:logistic')
xgb_prb = predict(bst, newdata = hos_valid_X)
xgb_class = ifelse(xgb_prb > 0.5, 'Yes', 'No')
result = table(xgb_class, hos_valid$RETURN)
result
(result[1,1] + result[2,2]) / sum(result)
result[2,2]/(result[2,1]+result[2,2])
#[1] 0.7821397

xgb_TPR = result[2,2] / (result[2,1] + result[2,2])
xgb_TNR = result[1,1] / (result[1,1] + result[1,2])


################spider plot ###########
cutoffs = c(0.20, 0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29, 0.30, 0.35, 0.40, 0.45, 0.5, 0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58)
xgb_acc = rep(0, 22)
xgb_TPR = rep(0, 22)


for (i in 1:23){
  xgb_class = ifelse(xgb_prb > cutoffs[i], 1, 0)
  confuse_test = table(hos_valid$RETURN, xgb_class)
  xgb_acc[i] = (confuse_test[1,1] + confuse_test[2,2]) / sum(confuse_test)
  xgb_TPR[i] = confuse_test[2,2] / (confuse_test[2,1] + confuse_test[2,2])
}
data.frame(cutoffs, xgb_acc, xgb_TPR)


# ROC curve
xgb_FPR = 1 - xgb_TNR
plot(xgb_FPR, xgb_TPR, type = 'l', xlab = 'False Positive Rate', ylab = 'True Positive Rate', main = 'ROC Curve', xlim = c(0, 1), ylim = c(0, 1))
lines(x = c(0, 1), y = c(0, 1))

# Spider Plot
plot(cutoffs, xgb_TPR, type = 'l', col = 'green', xlab = 'Cutoff', ylab = 'Value', main = 'Spider Plot')
lines(cutoffs, xgb_TNR, col = 'red')
lines(cutoffs, xgb_acc, col = 'blue')
legend(0.2, 0.4, legend = c('TPR', 'TNR', 'Accuracy'), fill = c('green', 'red', 'blue'),cex = 0.5)



## xgboost in testing data

bst_whole = xgboost(data = hos_X, label = label_w, max.depth = 5, eta = 0.1, nround = 300, nthread = 4, objective = 'binary:logistic')
xgb_prb = predict(bst_whole, newdata = hos_test_X1)
xgb_class = ifelse(xgb_prb > 0.52, 'Yes', 'No')



namevector <- c("RETURN")
test_X[,namevector] <- xgb_class

xgb_R = test_X %>%
  dplyr::select(INDEX,RETURN)

# merge two dataframe and sort by index
No_R = as.data.frame(No_R)
xgb_R = as.data.frame(xgb_R)

total = rbind(No_R, xgb_R)
newdata <- total[order(total$INDEX),] 

## reset RETURN column to whole dataset
test_whole$RETURN <- NULL
namevector <- c("RETURN")
test_whole[,namevector] <- newdata$RETURN



#### check RETURN
table(test_whole$RETURN)

### output a format 
output <- test_whole %>% 
  dplyr::select(1,27)


table(output$RETURN)


#output the csv
write.csv(output, file = "xgboost.csv",row.names=FALSE)



################### tree #####################
library(tree)
hos.tree=tree(RETURN~., data = hos_train)
summary(hos.tree)
plot(hos.tree)
text(hos.tree, pretty = 1)


tree_preds <- predict(hos.tree, newdata = hos_valid)
tree_probs = tree_preds[, 2]
tree_probs
tree_class = ifelse(tree_probs>0.33, 1, 0)
confuse_valid = table(hos_valid$RETURN, tree_class, dnn = c('Actual', 'Predicted'))

(confuse_valid[1,1]+confuse_valid[2,2])/sum(confuse_valid) #ACC
confuse_valid[2,2]/(confuse_valid[2,1]+confuse_valid[2,2]) #TPR
confuse_valid[1,1]/(confuse_valid[1,1]+confuse_valid[1,2]) # TNR

cutoffs = c(0.1, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 0.99)
log_acc = rep(0, 18)
log_TPR = rep(0, 18)
log_TNR = rep(0, 18)
tree_preds = predict(hos.tree, newdata = hos_valid)
tree_probs = tree_preds[, 2]

for (i in 1:18){
  tree_class = ifelse(tree_probs > cutoffs[i], 1, 0)
  confuse_valid = table(hos_valid$RETURN, tree_class)
  log_acc[i] = (confuse_valid[1,1] + confuse_valid[2,2]) / sum(confuse_valid)
  log_TPR[i] = confuse_valid[2,2] / (confuse_valid[2,1] + confuse_valid[2,2])
  log_TNR[i] = confuse_valid[1,1] / (confuse_valid[1,1] + confuse_valid[1,2])
}
data.frame(cutoffs, log_acc, log_TPR, log_TNR)


model_stepwise = step(model_full, direction = 'both')
summary(model_stepwise)


stepwise_pred = predict(model_stepwise, newdata = hos_valid, type = 'response')
stepwise_class = ifelse(stepwise_pred > 0.5, 1, 0)
table_stepwise = table(hos_valid$RETURN, stepwise_class)
table_stepwise
(table_stepwise[1,1] + table_stepwise[2,2]) / sum(table_stepwise)
table_stepwise[2,2] / (table_stepwise[2,1] + table_stepwise[2,2])
table_stepwise[1,1] / (table_stepwise[1,1] + table_stepwise[1,2])

model_try = glm(RETURN~GENDER + AGE + RACE + FINANCIAL_CLASS + WEEKDAY_ARR + HOUR_ARR + MONTH_ARR + ED_RESULT + ACUITY_ARR + CONSULT_ORDER + DIAGNOSIS + CHARGES,data=hos_train,family="binomial")
summary(model_try)
try_pred = predict(model_try, newdata = hos_valid, type = 'response')
try_class = ifelse(try_pred > 0.5, 1, 0)
table_try = table(hos_valid$RETURN, try_class)
table_try
(table_try[1,1] + table_try[2,2]) / sum(table_try)
table_try[2,2] / (table_try[2,1] + table_try[2,2])
table_try[1,1] / (table_try[1,1] + table_try[1,2])


cutoffs = c(0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99)
log_acc = rep(0, 13)
log_TPR = rep(0, 13)
log_TNR = rep(0, 13)
log_preds = predict(model_full, newdata = hos_valid, type = 'response')
for (i in 1:13){
  log_class = ifelse(log_preds > cutoffs[i], 1, 0)
  confuse_test = table(hos_valid$RETURN, log_class)
  log_acc[i] = (confuse_test[1,1] + confuse_test[2,2]) / sum(confuse_test)
  log_TPR[i] = confuse_test[2,2] / (confuse_test[2,1] + confuse_test[2,2])
  log_TNR[i] = confuse_test[1,1] / (confuse_test[1,1] + confuse_test[1,2])
  }
data.frame(cutoffs, log_acc, log_TPR, log_TNR)


# ROC curve
log_FPR = 1 - log_TNR
plot(log_FPR, log_TPR, type = 'l', xlab = 'False Positive Rate', ylab = 'True Positive Rate', main = 'ROC Curve', xlim = c(0, 1), ylim = c(0, 1))
lines(x = c(0, 1), y = c(0, 1))

# Spider Plot
plot(cutoffs, log_TPR, type = 'l', col = 'green', xlab = 'Cutoff', ylab = 'Value', main = 'Spider Plot')
lines(cutoffs, log_TNR, col = 'red')
lines(cutoffs, log_acc, col = 'blue')
legend(0.5, 0.55, legend = c('TPR', 'TNR', 'Accuracy'), fill = c('green', 'red', 'blue'))
