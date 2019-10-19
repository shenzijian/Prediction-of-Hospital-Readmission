setwd("~/Desktop/UMD/课程/第二学期/758T/Project Files")
library(readr)
library(ggplot2)
library(dplyr)

#define NA string
na_strings <- c("Unknown", "Declined to Answer","","Not specified Other or Unknown","#N/A","5 Purple","#VALUE!")
##read valuable row and turn problematic values to NA
hos <- read_csv("Hospitals_Train.csv",n_max = 38221,na=na_strings) 
attach(hos)
colnames(hos)

#create bin
cut(AGE, c(-Inf, 24,34,44,59,74,89, Inf), labels=1:7)
cut(HOUR_ARR, c(-Inf,6,12,18,Inf), labels = 1:4)
hos$AGE = cut(AGE, c(-Inf, 24,34,44,59,74,89, Inf), labels=1:7)
# hos$HOUR_ARR = cut(HOUR_ARR, c(-Inf,6,12,18,Inf), labels = 1:4)

# turn empty cell in CUNSULT_IN_ED to 0
hos$CONSULT_IN_ED[is.na(hos$CONSULT_IN_ED)] <- 0

#check correlation between consult variable

# CONSULT_IN_ED = as.numeric(CONSULT_IN_ED)
# CONSULT_CHARGE = as.numeric(CONSULT_CHARGE)
# CONSULT_ORDER = as.numeric(CONSULT_ORDER)

cor(cbind(CONSULT_CHARGE, CONSULT_IN_ED, CONSULT_ORDER))


#delete unneccessary column

clean = subset(hos, select=-c(INDEX,WEEKDAY_DEP,HOUR_DEP,MONTH_DEP))

#omit NA value after subset
hos=na.omit(clean)
dim(hos)

#turn some variables to factor variable




hos$WEEKDAY_ARR = as.factor(hos$WEEKDAY_ARR)
hos$AGE = as.factor(hos$AGE)
hos$HOUR_ARR = as.factor(hos$HOUR_ARR)
hos$MONTH_ARR = as.factor(hos$MONTH_ARR)
hos$CONSULT_CHARGE = as.factor(hos$CONSULT_CHARGE)
hos$CONSULT_IN_ED = as.factor(hos$CONSULT_IN_ED)
hos$CONSULT_ORDER = as.factor(hos$CONSULT_ORDER)

hos$CONSULT_CHARGE = as.factor(hos$CONSULT_CHARGE)
hos$CHARGES = as.numeric(hos$CHARGES)


# check distribution of variable


ggplot(hos, aes(x="", y=, fill=RETURN))+geom_bar(width = 1) + coord_polar("y")






# a = hos[ hos$RACE %in%  names(table(hos$RACE))[table(hos$RACE) <50] , ]
# unique(a$RACE)
# hos$RACE[which(hos$RACE %in% unique(a$RACE))]<- 'Other'
# table(hos$RACE)





#Result Distribution

#ED_RESULT

ggplot(hos,aes(ED_RESULT,fill = RETURN,label=RETURN))+
  geom_histogram(position = "identity",alpha = 0.6,binwidth = 1000, stat = 'count')


#dc result distribution
ggplot(hos,aes(DC_RESULT)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(DC_RESULT,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
table(DC_RESULT)

ggplot(hos,aes(DC_RESULT,fill = RETURN,label=RETURN))+
  geom_histogram(position = "identity",alpha = 0.6,binwidth = 1000, stat = 'count')



#risk
ggplot(hos,aes(RISK)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(RISK,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
table(RISK)


#severity
ggplot(hos,aes(SEVERITY)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(SEVERITY,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
table(SEVERITY)



#hospital result distribution
ggplot(hos,aes(HOSPITAL)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(HOSPITAL,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
table(HOSPITAL)

#hour arrive
ggplot(hos,aes(HOUR_ARR)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(HOUR_ARR,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
table(HOUR_ARR)

####admit result
ggplot(hos,aes(ADMIT_RESULT)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(ADMIT_RESULT,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
table(HOSPITAL)

#age distribution
ggplot(hos,aes(AGE)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(AGE,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")

# consult 三兄弟
ggplot(hos,aes(CONSULT_ORDER, fill = RETURN, label = RETURN))+geom_bar(position = "fill") +labs(y = "Portion")
ggplot(hos,aes(CONSULT_CHARGE, fill = RETURN, label = RETURN))+geom_bar(position = "fill") +labs(y = "Portion")
ggplot(hos,aes(CONSULT_IN_ED, fill = RETURN, label = RETURN))+geom_bar(position = "fill") +labs(y = "Portion")

#financial class
ggplot(hos,aes(FINANCIAL_CLASS)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")
ggplot(hos,aes(FINANCIAL_CLASS,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")

ggplot(hos,aes(FINANCIAL_CLASS,fill = RETURN,label=RETURN))+
  geom_histogram(position = "identity",alpha = 0.6,binwidth = 1000, stat = 'count')



#CONSULT_CHARGE and CHARGE
hos %>%
  group_by(ETHNICITY) %>%

ggplot(hos,aes(ETHNICITY,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
#race 

ggplot(hos,aes(RACE,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")
#race distribution
ggplot(hos,aes(RACE,fill = RETURN,label=RETURN))+
  geom_histogram(position = "identity",alpha = 0.6,binwidth = 1000, stat = 'count')


  
r = table(RACE)
r = as.data.frame(r) 
r$RACE[r$Freq<10]

hos %>%
  select(RACE, RETURN) %>%
  filter(RACE == "Hispanic" | RACE == "Two or More Races")
  
# DIAG_DETAILS boxplot
  
ggplot(hos,aes(DC_RESULT,fill = RETURN,label=RETURN)) + geom_histogram(position = "fill",stat="count",alpha = 0.6) + labs(y = "Return")


d = table(DC_RESULT)
d = as.data.frame(d) 
d$DC_RESULT[d$Freq<100]


#diag_detail
#hour
ggplot(hos,aes(HOUR_ARR)) + geom_histogram(stat="count",alpha = 0.6) + labs(y = "Count")

#filter small data in ED_RESULT and assign value 'Other' to them


edre = hos[ hos$ED_RESULT %in%  names(table(hos$ED_RESULT))[table(hos$ED_RESULT) <50] , ]
unique(edre$ED_RESULT)
hos$ED_RESULT[which(hos$ED_RESULT %in% unique(edre$ED_RESULT))]<- 'Other'




# # # phase 2 , logistic regression # # #

#set seed
set.seed(1313)
# check how many row
num_obs = nrow(hos)

## Let's make 70% of those training observations
## First, we sample 70% of the observations (the rows) in the training data

train_obs <- sample(num_obs,0.7*num_obs)

## Then we assign the random sample to a new data set, Beer_train

hos_train <- hos[train_obs,]

## That maeans the remaining rows should go to another new data set, Beer_test

hos_valid <- hos[-train_obs,]




### phase 2 ## re-category base on business logic ####
hos %>% 
  filter(str_detect(DC_RESULT, "Hospice"))



