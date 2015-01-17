library(lmtest)
library(ggplot2)

data(mtcars)
mtcars$am = factor(mtcars$am)
mtcars$cyl = factor(mtcars$cyl)
mtcars$vs = factor(mtcars$vs)
mtcars$gear = factor(mtcars$gear)
mtcars$carb = factor(mtcars$carb)
levels(mtcars$am) = c('Automatic','Manual')

make.fit = function(response,intercept,mpg,cyl,disp,hp,drat,wt,qsec,vs,am,gear,carb) {
  if(!intercept) { regressors = c('0')} else { regressors = c('1') }
  if(mpg) { regressors = c(regressors,'mpg') }
  if(cyl) { regressors = c(regressors,'cyl') }
  if(disp) { regressors = c(regressors,'disp') }
  if(hp) { regressors = c(regressors,'hp') }
  if(drat) { regressors = c(regressors,'drat') }
  if(wt) { regressors = c(regressors,'wt') }
  if(qsec) { regressors = c(regressors,'qsec') }
  if(vs) { regressors = c(regressors,'vs') }
  if(am) { regressors = c(regressors,'am') }
  if(gear) { regressors = c(regressors,'gear') }
  if(carb) { regressors = c(regressors,'carb') }
  formula = reformulate(termlabels = regressors, response = response)
  lm(formula, data=mtcars)  
}

calc.rmse = function(fit) {
  sqrt(deviance(fit)/df.residual(fit))  
}

plot.fitted = function(response, fit) {
  ggplot(data=data.frame(actual=mtcars[,response],fitted=fit$fitted),aes(x=actual,y=fitted))+geom_point()+geom_abline(intercept=0,slope=1,aes(col='red'))  
}

test.result = function(test) {
  reject = ' '
  if (test$p.value > .05) { reject = ' CANNOT '}
  paste0('We',reject,'REJECT the null hypothesis at 5%.')
  
}

shinyServer(
  function(input, output) {
      fit = reactive({make.fit(input$response,input$intercept,input$mpg,input$cyl,input$disp,input$hp,input$drat,input$wt,input$qsec,input$vs,input$am,input$gear,input$carb)})
      shapiro = reactive({shapiro.test(resid(fit()))})
      breusch = reactive({bptest(fit(),studentize=TRUE)})
      durbin = reactive({dwtest(fit())})
      
      output$fitSummary = renderPrint({summary(fit())})
      output$signif = renderPrint({names(coef(fit()))[coef(summary(fit()))[,4]<.05]})
      output$fitRMSE = renderPrint({calc.rmse(fit())})
      output$fittedPlot = renderPlot({plot.fitted(input$response,fit())})
      output$shapiro = renderPrint({shapiro()})
      output$shapiro.p = renderPrint({test.result(shapiro())})
      output$breusch = renderPrint({breusch()})
      output$breusch.p = renderPrint({test.result(breusch())})
      output$durbin = renderPrint({durbin()})
      output$durbin.p = renderPrint({test.result(durbin())})
      output$residPlot = renderPlot({par(mfrow=c(2,2))
                                   plot(fit())})
  }
)