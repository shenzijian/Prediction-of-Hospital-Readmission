library(readr)
library(dplyr)
#define NA string
na_strings <- c("Unknown", "Declined to Answer","","#N/A","5 Purple","#VALUE!",'Expired','Deceased','Hospice/ Medical Facility','Hospice/Home')
setwd("~/Desktop/UMD/课程/第二学期/758T/Project Files")

##read valuable row and turn problematic values to NA
hos <- read_csv("Hospitals_Train.csv", na=na_strings)


hos$CONSULT_IN_ED[is.na(hos$CONSULT_IN_ED)] <- 0

hos = hos[1:38221,]

clean = subset(hos, select=-c(INDEX,WEEKDAY_DEP,HOUR_DEP,MONTH_DEP,ADMIT_RESULT,RISK,SEVERITY))


##### check RETURN of rows with NONE value 
miss <- clean[!complete.cases(clean),]
#### 4635
table(miss$RETURN)

#No  Yes 
#1351   89 



No  Yes 
2778 1498


#define NA string

setwd("~/Desktop/UMD/课程/第二学期/758T/Project Files")

##read valuable row and turn problematic values to NA
hos <- read_csv("Hospitals_Train.csv")


hos$CONSULT_IN_ED[is.na(hos$CONSULT_IN_ED)] <- 0


hos = hos[1:38221,]

clean1 = subset(hos, select=-c(WEEKDAY_DEP,HOUR_DEP,MONTH_DEP,ADMIT_RESULT,RISK,SEVERITY))

miss <- clean1[!complete.cases(clean),]
#### 4635
table(miss$RETURN)

AC_NA <- miss %>%
  filter(is.na(ACUITY_ARR))
nrow(AC_NA)
##[1] 3263
#No  Yes 
#1836 1421

 

ED_NA <- miss %>%
  filter(is.na(ED_RESULT))
nrow(ED_NA)

table(ED_NA$RETURN)
# No Yes 
##68  12

CHARGE_NA <- miss %>%
  filter(is.na(CHARGES))

table(CHARGE_NA$RETURN)

No Yes 
50  44 

###### whole data CHARGE = 0

CHARGE_0 <- hos %>%
  filter(CHARGES == 0)

#N/A   No  Yes 
#1 1074 1198


write.csv(miss, file = "missing.csv",row.names=FALSE)


No  Yes 
2116 1432 

