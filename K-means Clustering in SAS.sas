proc import datafile='\\apporto.com\dfs\UNCC\Users\u381_uncc\Desktop\data\power_usage.xlsx' 
DBMS=xlsx out=power replace; 
ods pdf file="\\apporto.com\dfs\UNCC\Users\u381_uncc\Desktop\data\Assignment_7_Clustering_in_SAS_Marcie_Matejka.pdf";
proc print data=power; run;
proc univariate data=power normal plot;
var Global_active_power Global_reactive_power Global_intensity;
run;
*1. Perform K-means clustering on power-usage data with k=6 between 
*global_active_power, global_reactive_power, and global_intensity variables;
*cluster run with outliers, max=6; 
proc fastclus data=power maxclusters=6 out=clust  MAXITER=20;
var Global_active_power Global_reactive_power Global_intensity;
run;
*2. How many iterations are performed? What are the initial and final centroids for Cluster 2?;
*5 interations performed;
*Cluster 2 initial seeds are:
*Global_active_power = 4.96800000, 
*Global_reactive_power = 0.00000000,
*Global_intensity = 20.80000000;
*Cluster 2 final centroids are:
*Global_active_power = 4.61846341, 
*Global_reactive_power = 0.10346341,
*Global_intensity = 19.62439024;

*3. Report “Cubic Clustering Criterion” of this clustering? CCC=1.268
*Does this value suggest a good quality Clustering? 
*Values between 0 and 2 indicate potential clusters, but they should be taken with caution;
*If not, suggest what can be done to improve the quality of clustering with proper reasoning. 
*We can improve the quality of clustering by removing outliers. Outliers are observations that fall 
*below Q1 - 1.5(IQR) or above Q3 + 1.5(IQR). 
*Here, IQR = Q3 - Q1;
*Global_active_power: Q1=1.804, Q3=3.308, IQR =1.504, 1.804 - 1.5(1.504)= -.452, 3.308 + 1.5(1.504)=5.564;
*Global_reactive_power: Q1=0.051, Q3 =0.176, IQR =0.125, 0.051 - 1.5(0.125)= -0.1365, 0.176 + 1.5(0.125)=0.3635;
*Global_intensity: Q1=7.8, Q3=14.0, IQR =6.2, 7.8 - 1.5(6.2)= -1.5, 14 + 1.5(6.2)=23.3;
data mod_power; set power;
if Global_active_power > 5.564 then delete;
if Global_active_power < -.452 then delete;
if Global_reactive_power > 0.3635 then delete;
if Global_reactive_power < -0.1365 then delete;
if Global_intensity > 23.3 then delete; 
if Global_intensity < -1.5 then delete; 
run;
*NOTE: There were 1440 observations read from the data set WORK.POWER.
*NOTE: The data set WORK.MOD_POWER has 1357 observations and 8 variables.;
proc print data=mod_power; run;
*4. Perform K-means clustering with K=6 (after steps suggested in c) and comment on the quality of clustering.
*cluster run without outliers, max=6; 
proc fastclus data=mod_power maxclusters=6 out=clust  MAXITER=20;
var Global_active_power Global_reactive_power Global_intensity;
run;
*The CCC after outliers were removed=23.803. This suggest much higher clustering quality than the CCC
*before outliers were removed which was 1.268.

*5. What are the similarity and dissimilarity measures in SAS output for Cluster 4? (Hint: Look into 
*Cluster Summary table)
*For cluster 4, RMS Std Deviation (similarity) = 0.6293. Cluster 4 has a higher than average of all 
*clusters similarity measure. 
*Maximum Distance from Seed to Observation=2.3578, Distance Between Cluster Centroids=3.1966 
*For cluster 4, the difference between max distance from seed to obs and the distance between cluster
*centriods (dissimilarity)is 0.8388. This lower than the average dissimilarity of all clusters (1.1976)
*but it is still significant and not the lowest cluster in terms of dissimilarity.;
ods pdf close;
