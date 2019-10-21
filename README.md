# Prediction-of-Hospital-Readmission


## Executive summary

Background:
Nowadays hospitals are struggling to meet demand of a growing quantity of people seeking medical treatment. Unplanned hospital admissions (HUA) are a problem for hospitals internationally as they are costly and disruptive to elective health care, and increase waiting lists. Readmission, which is the estimate of the rate of unplanned return to hospital in the 30 days after discharge, is one of the 7 main criterions that measure the overall ratings of the hospitals’ quality.  A high readmission lowers the rating of a hospital, because it means that the patients are not cured well at the first time for a large proportion of diseases that neither chronic nor deadly rapidly. Furthermore, Centers for Medicare & Medicaid Services established the “Hospital Readmissions Reduction Program” which aims to improve quality of care for patients and reduce healthcare spending by applying payment penalties to hospitals that have more than expected readmission rates for certain conditions. Therefore, make more patients readmission not only won’t bring higher income to hospital, but will cause negative impact on both reputation of hospitals and the economy because of fewer charges on the same services compared with those from the first time treatment.

To conclude, decreasing the return rate is a goal for most hospitals, to achieve which a good way is to predict precisely about which group of people are most likely to return in 30 days, and take targeted measures against this group people to reduce the readmission. 

If hospitals can successfully predict whether a patient will return to the hospital in 30 days, hospitals can pay more attention to this group of patients either by extending the duration of their treatment of this time to cure more thorough or by conducting more frequent phone follow-up to give corresponding advice on convalescing at home. This operation can reduce the readmission and improve the service quality of hospitals. Additionally, acknowledgement of patients returning will assist in allocation of resources in hospitals, such as schedules of doctors and nurses, procurement of medicine, availability of medical equipment and apportionment of rooms.

In our case, accurately predicting the people who will return in 30 days means making the true positive rate of our prediction (which means predict the maximum proportion of all the patients who actually return to the hospital in 30 days) as high as possible, but do not penalty our prediction accuracy (which means predict patients who will both return and not return in 30 days as far as possible) too much because it is also meaningless to predict almost patients to return patients. 

## Method and result:
We explored a file containing the information about more than 38,000 reception records from 5 hospitals, including basic information of patients, reception time, acuity of illness at the arrival, diagnosis result and details, charge, financial method for medical treatment, and whether return the hospital in 30 days. We pre-processed data by removing error records and missing values by deleting some columns and rows, by setting numeric variables to bins, and by aggregating some categories with just a few observations to one category.  

![Image of DataInsight](https://github.com/shenzijian/Prediction-of-Hospital-Readmission/blob/master/data%20insights.png)

After cleaning data, we split the original training dataset, 70% to fit models, and 30% to choose the parameters of each type of model. We run 6 models in total, including logistic, boosting, random forest, LDA, lasso and KNN. To achieve our goal, we evaluate these models by enhancing the true positive rate of our prediction as far as possible under the condition of not a very bad accuracy performance of prediction. 

After determining the best parameters of each model, we evaluated these models by predicting test dataset. In the end, lasso model performed best, because it has the highest positive rate without penalizing accuracy too much.

**_example of Random Forest model parameter selection_**  

ntree | mtry | accuracy | TPR
----- | ---- | -------- | ---
100	| 3	| 0.6787664	| 0.5531365
100	| 4	| 0.6342795	| 0.6501845
100	| 5	| 0.6175400	| 0.6782288
100	| 6	| 0.6129003	| 0.6822878
500	| 3	| 0.6772198	| 0.5630996
500	| 4	| 0.6316412	| 0.6531365
500	| 5	| 0.6140830	| 0.6856089
500	| 6	| 0.6036208	| 0.6922509
1000 | 3 | 0.6782205	| 0.5675277
1000	| 4	| 0.6324600	| 0.6542435
1000	| 5	| 0.6114447	| 0.6800738
1000	| 6	| 0.6045306	| 0.6955720
1500	| 3	| 0.6764920	| 0.5715867
1500	| 4	| 0.6337336	| 0.6549815
1500	| 5	| 0.6107169	| 0.6878229
1500	| 6	| 0.6038028	| 0.6937269



![Image of Random Forest spider plot](https://github.com/shenzijian/Prediction-of-Hospital-Readmission/blob/master/random%20forest%20spider%20plot.png)  

**_Comparing models  and conclusion_**

![Image of model comparsion](https://github.com/shenzijian/Prediction-of-Hospital-Readmission/blob/master/model%20camparison.png)
 
