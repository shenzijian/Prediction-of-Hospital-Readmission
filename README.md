# Prediction-of-Hospital-Readmission
Healthcare project

Executive summary

Background:
Nowadays hospitals are struggling to meet demand of a growing quantity of people seeking medical treatment. Unplanned hospital admissions (HUA) are a problem for hospitals internationally as they are costly and disruptive to elective health care, and increase waiting lists. Readmission, which is the estimate of the rate of unplanned return to hospital in the 30 days after discharge, is one of the 7 main criterions that measure the overall ratings of the hospitals’ quality.  A high readmission lowers the rating of a hospital, because it means that the patients are not cured well at the first time for a large proportion of diseases that neither chronic nor deadly rapidly. Furthermore, Centers for Medicare & Medicaid Services established the “Hospital Readmissions Reduction Program” which aims to improve quality of care for patients and reduce healthcare spending by applying payment penalties to hospitals that have more than expected readmission rates for certain conditions. Therefore, make more patients readmission not only won’t bring higher income to hospital, but will cause negative impact on both reputation of hospitals and the economy because of fewer charges on the same services compared with those from the first time treatment.

To conclude, decreasing the return rate is a goal for most hospitals, to achieve which a good way is to predict precisely about which group of people are most likely to return in 30 days, and take targeted measures against this group people to reduce the readmission. 

If hospitals can successfully predict whether a patient will return to the hospital in 30 days, hospitals can pay more attention to this group of patients either by extending the duration of their treatment of this time to cure more thorough or by conducting more frequent phone follow-up to give corresponding advice on convalescing at home. This operation can reduce the readmission and improve the service quality of hospitals. Additionally, acknowledgement of patients returning will assist in allocation of resources in hospitals, such as schedules of doctors and nurses, procurement of medicine, availability of medical equipment and apportionment of rooms.

In our case, accurately predicting the people who will return in 30 days means making the true positive rate of our prediction (which means predict the maximum proportion of all the patients who actually return to the hospital in 30 days) as high as possible, but do not penalty our prediction accuracy (which means predict patients who will both return and not return in 30 days as far as possible) too much because it is also meaningless to predict almost patients to return patients. 

Method and result:
We explored a file containing the information about more than 38,000 reception records from 5 hospitals, including basic information of patients, reception time, acuity of illness at the arrival, diagnosis result and details, charge, financial method for medical treatment, and whether return the hospital in 30 days. We pre-processed data by removing error records and missing values by deleting some columns and rows, by setting numeric variables to bins, and by aggregating some categories with just a few observations to one category.  

After cleaning data, we split the original training dataset, 70% to fit models, and 30% to choose the parameters of each type of model. We run 6 models in total, including logistic, boosting, random forest, LDA, lasso and KNN. To achieve our goal, we evaluate these models by enhancing the true positive rate of our prediction as far as possible under the condition of not a very bad accuracy performance of prediction. 

After determining the best parameters of each model, we evaluated these models by predicting test dataset. In the end, lasso model performed best, because it has the highest positive rate without penalizing accuracy too much.

In a nutshell, we will strongly suggest hospitals to use our lasso model to predict whether a patient will return the hospital in 30 days, because we can predict nearly 70% of the actual return patients. Then hospitals can make preparation in advance to reduce the unplanned admission and readmission. 
 
Data insights

The “Hospital_Train.csv” dataset contains 27 columns and 38221 rows describing information of hospitals, patients, medical records and return result. Around 9.7% of the data is missing. ADMIT_RESULT, RISK and SEVERITY have more than 80% missing value rates. Data like RACE and ETHNICITY and ED_RESULT have less than 1% missing value. 4 columns are numeric variables, which are INDEX, AGE, DIAG_DETAILS and CHARGES. The rest are all categorical variables.
 
Two types of columns were supposed to be deleted, one is those with high missing value rate, the other one is those with obvious error records or have no influence on the model prediction. Based on these two criterions, INDEX, RISK, SEVERITY, WEEKDAY_DEP, HOUR_DEP, and MONTH_DEP columns were deleted from the dataset. We saved the ADMIT_RESULT, the reason of which we will demonstrate later. Furthermore, two kinds of observations should be set to missing values. One are the rows with problematic records which appear to be error data, the other one is that there are missing values such as “Unknown” in the rows, and the rows contain values that just occur in the corresponding column for one time because we consider it is very unlikely that there is just one observation in one column in a such big dataset. 

Some columns are set to bins, and some columns are releveled. AGE is assigned to 7 bins according to human physiological growth, and HOUR_ARR is set to 4 bins according to custom working time arrangement in hospitals. We created the bins based on our domain knowledge, which can be risky and may affect the prediction performance. However, we consider this action reasonable because firstly people of similar age have similar health condition so that have similar return rate, secondly a factor variable with a few categories can cost less computation than a numeric variable, thirdly after we have test the prediction performance later in the modeling stage we found out that there is no too much difference to use the two variables as categorical or numeric. What’s more, some low frequency (less than 50 observations) levels which are  RACE, FINANCIAL_CLASS, ED_RESULT and DC_RESULT  are aggregated to a new “other” category, because some categories have so few observations that are not very powerful to make prediction and could also make out data very noisy. This action may result in bad inference to these observations based on our model, but since our goal is to make prediction, we could try this method. (See more analysis on Appendix 1)

With the further exploration of the relation between return results and the predictors, we found that 3263 observations with ACUITY_ARR missing, of which there are 1421 “RETURN=YES”, nearly half of the missing observations, which is important to our prediction faced with a such unbalanced dataset with so many “RETURN=NO”. Therefore, we define the missing values in ACUITY_ARR as a new category called “new_category” as it may give additional predictive power to our model. Similarly, the reason why we keep the ADMIT_RESULT variable is that the observations with missing ADMIT_RESULT record have a higher rate of “RETURN=YES” than the existing categories. Therefore, we also create a new variable named “new_category” for these missing values. (See more analysis on Appendix 2)

Having taken all the pre-processing measures above, finally we got a clean dataset with 21 columns and 36640 rows. 

Model insights

After data cleaning, next step was to try building models and then evaluate them. We randomly further partitioned the whole training dataset into a small training dataset and a validation dataset. We set 70% of the original training dataset as training dataset used to train the model and 30% of the original training dataset as validation dataset used to decide the best parameter combinations for each model. Finally, we will use the testing dataset to help us compare several models to decide the best model.
According to the purpose we mentioned above, when we evaluated models, the criterion is that we hope to get a relatively high true positive rate but the accuracy should not be too low. Since the validation and testing baseline accuracy are both about 75.5%, we decided to make sure that the accuracy of our result should be at least 60%.

1. Logistic model
Logistic regression is a supervised classification method widely used in classification prediction problems. To start with, we need to decide which variables to use. First of all, we used the full 21 potential independent variables to build first model based on training dataset. Then we used the validation dataset to test this model using 10 cutoffs, which are 0.2, 0.23, 0.25, 0.27, 0.3, 0.33, 0.35, 0.4, 0.45 and 0.5. For each cutoff, we calculated its corresponding accuracy and true positive rate.

As to the cutoff, the common rules of which is 0.5, but because we focus on the TPR of our prediction we need to lower the cutoff in order to get a higher TPR under the condition of ensuring the accuracy to some degree. This action takes a cost of decreasing the accuracy of our prediction. However, we consider this action is meaningful and necessary, because the dataset has too many “RETURN=NO” outcome, so the baseline accuracy (which is predicting all the new observations as “NO”) is already very high, so the model is more likely to predict a “NO” value compared a “YES” value with the cutoff of 0.5, but the cost of mis-predicting an actual “YES” to “NO” is much higher than that of mis-predicting an actual “NO” to “YES”, because we hope to identify any potential return patient as firmly as possible to prepare in advance, so missing anyone of them will be costly. Therefore, we decided to choose the appropriate cutoff from the 10 values above for all the models we run.
      

Next, we used the backward stepwise and forward stepwise method to select variables from the 21 potential independent variables and saw whether these methods bring better prediction performance. The results of the backward stepwise and forward stepwise are totally the same. They both selected 15 variables, which are ED_RESULT, FINANCIAL_CLASS, GENDER, ETHNICITY, AGE, HOUR_ARR, MONTH_ARR, RACE, DC_RESULT, ACUITY_ARR, ADMIT_RESULT, CHARGES, WEEKDAY_ARR, SAME_DAY and CONSULT_CHARGE. The AIC decreased from 26950 in the full model to 26940.96 in the model after stepwise. Then we also used 10 cutoffs to test this model by validation dataset. When we compared the two models, we could notice that their results are really similar but the model with full 21 independent variables are relatively better, because for most cutoffs in the data frame, the full model’s accuracy and true positive rate are higher than that of the stepwise model. Thus, we choose to use full 21 independent variables to build logistic model.

Next, we drew a spider plot to decide which cutoff to use. Finally, we combined the training and validation data set to get the final logistic model using full 21 independent variables and cutoff 0.26 and used that logistic model to predict the test dataset.

2. Boosting model
Boosting is a supervised method that reweights wrong predicted observations to improve the overall accuracy of the whole model. Thus, it is expected to perform well for unbalanced dataset, especially for our dataset with too many “RETURN=YES”. We need to decide the number of trees in the model and the cutoffs. Firstly, we tried 5 tree numbers which are 500, 800, 1000, 1200, and 1500. After that we found that the TPR increased from 500 to 1000, but decreased from 1000 to 1500. What’s more, the TPRs are highest between 800 to 1200, so we zoomed in this range by choosing new 4 values of tree numbers which are 900, 950, 1000 and 1050. Trying all the combination of “n.tree” and cutoff can be costly. Therefore, we decided to set the cutoff as 0.3 first to test which is the best “n.tree”. Then we would test the 10 cutoffs on the model with the best tree numbers and choose the best cutoff with the highest TPR without penalizing accuracy too much. 
                                  

We drew a spider plot and found that the corresponding cutoff of intersection is 0.26. Therefore, the best boosting model we built has 1000 trees and 0.26 cutoff. We used this model to predict test dataset later.

3. Random Forest model
Random forest is an ensemble method aimed at making better prediction, which can get rid of overfitting to some extent compared with a single tree, and can reduce the structure similarity and consequent high correlation in predictions compared with bagging. The parameters we needed to decide are the number of trees, the number of variables used in every split, and the cutoff. The “ntree” by default in R code is 500, so we chose a smaller one 100, and two larger ones 1000 and 1500 to compare. The “mtry” by default in R code is the squared root of the number of all the predictors, which is 21 in our case, so we chose the nearest 4 values from the squared root of 21, which is 3, 4, 5, and 6. We chose the cutoff from the same 10 values. However, trying all the combination of all the “ntree”, “mtry” and cutoff is a very heavy burden on computation and time. Therefore, we decided to fix the cutoff as 0.25 at first, because the best cutoff of both the logistic and boosting model is about 0.25, then we tried the combination of “ntree” and “mtry”. Later we would choose the model with the highest TPR without penalizing accuracy too much, then test the 10 cutoffs on this model to choose the best cutoff. We know this action may miss some combination so that may miss the best model. However, trying all the combination not only costs too much computation but also cannot ensure to build a best model because the parameters we have tried are limited, in other words, we cannot try any combination of the three parameters actually. Therefore, our measure is to pursue the best model under this condition as far as possible. 

ntree	mtry	accuracy	TPR
100	3	0.6787664	0.5531365
100	4	0.6342795	0.6501845
100	5	0.6175400	0.6782288
100	6	0.6129003	0.6822878
500	3	0.6772198	0.5630996
500	4	0.6316412	0.6531365
500	5	0.6140830	0.6856089
500	6	0.6036208	0.6922509
1000	3	0.6782205	0.5675277
1000	4	0.6324600	0.6542435
1000	5	0.6114447	0.6800738
1000	6	0.6045306	0.6955720
1500	3	0.6764920	0.5715867
1500	4	0.6337336	0.6549815
1500	5	0.6107169	0.6878229
1500	6	0.6038028	0.6937269

From the table above, we can see that the model with 1000 trees and 6 variables used in every split has the highest TPR and a not too bad accuracy. 
 
Then we made a spider plot to decide the cutoff based on this model. (see Appendix 4) The corresponding cutoff of the intersection is 0.27. Therefore, the best random forest model we decided is with 1000 trees, 6 “mtry” and 0.27 cutoff, we used which to predict the test data later by combining the training and validation datasets. 

4. LDA QDA models
Discriminant analysis is also a method which we can fit the data instead of describing a specific model, especially when we have a large volume of data. For LDA, our model will fit the data with same distribution for both target variable classes, but for QDA, our model will fit the model with 2 different distributions for prediction.

After fitting the training data with QDA, we did prediction on validation data. However, QDA performed badly on the validation data with accuracy just around 50% no matter how we adjust the cutoff.
 
Then we tried fitting the training data with LDA and created a spider plot with the 10 cutoffs. (see Appendix 4) The corresponding cutoff of the intersection is 0.25. We used this model to predict test dataset later.

5. Lasso model
Lasso, the least absolute shrinkage and selection operator, performs both variable selection and regularization in order to enhance the prediction accuracy. The parameter lambda in a lasso model is created by cross-validation method and R can choose the best lambda automatically, which is 0.00105634 in our case. Therefore, the only one parameter we need to decide is cutoff. We drew a spider plot with the 10 cutoffs. (see Appendix 4) The corresponding cutoff of the intersection is 0.26. Later we would use this lasso model to predict test dataset.
 

6. Comparing models  and conclusion
After predicting test dataset used the 5 models we decided above, we got a table of the performance of each model, and compared it between the same model with 0.5 cutoff.

 

From the table above, we can see that lasso model has the highest TPR, the accuracy of which is also good which is 66%. Therefore, lasso model is the best model to achieve our business goal. 



 
Appendix 1
The variables we releveled is RACE, FINANCIAL_CLASS, ED_RESULT, DC_RESULT. We took this action because there are too many categories with very few observations.
 
 
 
 
Appendix 2

The proportion of each category of “ADMIT_RESULT” corresponding to “RETURN=YES”, including original categories and categories after we created a “new_category”.

 

 
 
Appendix 3


kNN model

kNN is a data driven model which we do not have to consider the distribution of data. It is possible to run the categorical variables in the cleaned dataset with “model.martrix( )” function in R. There could be issue with AGE and CHARGES columns since they are both continuous numeric values which may dominate the distance matrix. So these two columns were scaled down to 0 to 1.
Our kNN model take in all the processed data as input. The accuracy is around 78% which does not fluctuate a lot. The accuracy performance on kNN is comparative normal compare to other models. However, the cutoff can’t be adjusted as we want. With the adjustment of different k parameters, TPR is less than 20%. Our goal is to predict a high accuracy of those who come back to the hospital within 30 days with a comparative high accuracy. So kNN does not meet our goal which is not used in our final models.


