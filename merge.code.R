library(readr)
library(dplyr)
#define NA string

setwd("~/Desktop/UMD/课程/第二学期/758T/Project Files/final")




M <- read_csv("merge.csv")

head(M)
M$a=ifelse(M$a=='Yes',1,0)
M$b=ifelse(M$b=='Yes',1,0)
M$c=ifelse(M$c=='Yes',1,0)

M <- M %>%
  mutate(sumall = rowSums(.[2:4]))

M <- M %>%
  mutate(ensemble = ifelse(sumall>=2,1,0))


output <- M %>%
  dplyr::select(1,6)

output$ensemble <- ifelse(output$ensemble == 1,'Yes','No')

table(output$ensemble)
#output the csv
write.csv(output, file = "ensemble.csv",row.names=FALSE)
 