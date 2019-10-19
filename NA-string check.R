setwd("~/Desktop/UMD/课程/第二学期/758T/Project Files")

######check NA string distribution##########
hos_whole <- read_csv("Hospitals_Train.csv")

hos_whole <- hos_whole[1:38221,]

##read valuable row and turn problematic values to NA
na_strings <- c("Unknown", "Declined to Answer","","#N/A","5 Purple","#VALUE!",'Expired','Deceased','Hospice/ Medical Facility','Hospice/Home')

hos <- read_csv("Hospitals_Train.csv", na=na_strings)
hos <- hos[1:38221,]

hos$ACUITY_ARR[is.na(hos$ACUITY_ARR)] <- 'new_category'
hos$CHARGES[is.na(hos$CHARGES)] <- 0
hos$CONSULT_IN_ED[is.na(hos$CONSULT_IN_ED)] <- 0    ####because distribution of CHARGE's NA's RETURN similar to CHARGE == 0

test_X$ACUITY_ARR[is.na(test_X$ACUITY_ARR)] <- 'new_category'
test_X$CHARGES[is.na(test_X$CHARGES)] <- 0
test_X$CONSULT_IN_ED[is.na(test_X$CONSULT_IN_ED)] <- 0


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
clean1 = subset(hos, select=-c(WEEKDAY_DEP,HOUR_DEP,MONTH_DEP,ADMIT_RESULT,RISK,SEVERITY))

#omit NA value after subset
hos=na.omit(clean1)
dim(hos)





NA_list <- setdiff(hos_whole$INDEX, hos$INDEX)
####check how distribution in NA-string

NA_df <- hos_whole$RETURN[hos_whole$INDEX %in% NA_list]

table(NA_df)


############

NV <- hos_whole %>%
  filter(CHARGES == "#VALUE!")

table(NV$RETURN)

Ngender <- hos_whole %>%
  filter(is.na(GENDER))

## ethnicity##
Unknow <- hos_whole %>%
  filter(ETHNICITY == 'Unknown')

table(Unknow$RETURN)
## 0.09311741



### race declined to answer###

decline <- hos_whole %>%
  filter(RACE == 'Declined to Answer')

table(decline$RETURN)
# 3 No#####
###############################
