# ExploratoryRegression
Course Project - Developing Data Products 

This is a simple application to allow an exploratory regression of MTCARS data by selecting a continuous variable as response and as many regressors as you'd like (just be careful not to choose the response variable as a regressor).
When you click the 'Submit' button, the application will show your model's estimated coefficients and highlight which ones are statistically significant at 5%. You also get the root mean squared error (RMSE) of your model (the lower the better).
Then you can see a scatterplot of actual and fitted data where the red line indicates a perfect estimate.
There are also some residual analysis to check if the linear model assumptions hold, that is, the residuals are normally distributed, homoskedastic and without serial correlation. So, you want the null hypothesis for all three tests to NOT be rejected.