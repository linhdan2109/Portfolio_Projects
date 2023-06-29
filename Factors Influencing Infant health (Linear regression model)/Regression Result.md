# Regression Result
## 1. The original model:  
bwght = β0 + β1 faminc + β2 male + β3 cigs + β4 cigtax + β5 cigprice + u
- R code:

 ```R
 library(wooldridge)
bwght_res <- lm(bwght ~ faminc + male + cigs + cigtax + cigprice, data = bwght)
summary(bwght_res)
```
 
- The OLS regression is:

```
bwght = 114.8178 + 0.0963faminc + 3.0365male – 0.4666cigs + 0.1439cigtax – 0.0179cigprice
        (11.8974)   (0.0295)       (1.0769)    (0.0914)       (0.1442)	       (0.1102)      
		n = 1388,  R2 = 0.03788

Equation (1)
 ```
 
## 2. Regression specification error test (RESET)


Let bwght^ denote the OLS fitted values from estimating (1). 


Use the following equation, Equation (2), to test whether (1) has missed important nonlinearities:


```
bwght = 114.8178 + 0.0963faminc + 3.0365male – 0.4666cigs + 0.1439cigtax 
	– 0.0179cigprice + d1.(bwght^)^2 + d2.(bwght^)^3 + error    
	
Equation (2)
```
- Hypothesis:
	- H0: d1 = 0, d2 = 0 ( Equation (1) is correctly specified )
	- H1: H0 is not true 
- R code:
``` R
library(lmtest)
resettest(bwght_res)
```
- Result:


The RESET statistic in Equation (2) have p-value = 0.3759 > α=0.05  


Thus, we do not reject H0 at the 5% significance level


We can conclude that the model (1) was not rejected by RESET (at the 5% level)


## 3. Residual Normality Test (Jarque.Bera test and Shapiro.Wilk test)
- Hypothesis:
     - H0: residual is normally distributed
     - H1: residual is not normally distributed
- R code:
```R
library(normtest)
u <- resid(bwght_res)
jb.norm.test(u)
shapiro.test(u)
```
- Result: 
    
    
    Jarque-Bera test for normality: p-value < 2.2e-16
    
    
    Shapiro-Wilk normality test: p-value = 1.37e-15  


Thus, we reject H0 at the 5% significance level. So, residual is not normally distributed


But because our dataset has a large sample size (1388 observations). 


=> the OLS estimators are normally distributed regardless of the population distribution of u (from Central limit theorem)


=> the T-test and the F-test are still valid


## 4.  Heteroskedasticity Test (Breusch-Pagan Test and White Test)
- Hypothesis:
     - H0: Homoskedasticity 
     - H1: Heteroskedasticity

```R
library(lmtest)
bptest(bwght_res)
bptest(bwght_res, ~ fitted(bwght_res) + I(fitted(bwght_res)^2))
```
- Result: 
    
    
    Breusch-Pagan test : p-value = 0.9762 > α=0.05
    
    
    White test: p-value = 0.6603 > α=0.05


Therefore, we fail to reject the null hypothesis of homoskedasticity (at the 5% level)


## 5. T-Test
- Hypothesis:
     - H0: βj = 0 (j = 1,2,3,4,5)
     - H1: βj != 0 (j = 1,2,3,4,5)
```R
summary(bwght_res)
```
- Result:


Under this alternative, xj has a ceteris paribus effect on y without specifying whether the effect is positive or negative.
Result (at the 5% level):
  
  - faminc: 
  
  
  p-value = 0,00113 < α=0.05 
  
  => reject H0
  
  
  => faminc has a ceteris paribus effect on bwght
	
  - male: 
 
 
 p-value = 0,00448 < α=0.05 
 
 => reject H0
  
 
 => male has a ceteris paribus effect on bwght
	
  - cigs: 
  
  
  p-value = 3.72e^(-7)< α=0.05 
  
  =>  reject H0
  
  
  => cigs has a ceteris paribus effect on bwght
	
  - Biến cigtax: 
  
  
  p-value = 0,31827 > α=0.05 
  
  => Can't not reject H0
  
  
  => cigtax does not have a ceteris paribus effect on bwght
	
  - cigprice: 
  
  
  p-value = 0,87097 > α=0.05 
  
  
  => reject Ho 
  
  
  => cigprice does not have a ceteris paribus effect on bwght


## 6. F-Test - LM Test


As the test results above, we see that cigtax and cigprice has no partial effect on bwght.


Now, we want to test whether a group of (cigtax and cigprice) has no effect on bwght by F-test and LM test
- Hypothesis:
     - H0: β4 = β5 = 0 
     - H1: H0 is not true
- F test
```R
# Joint hypotheses test (F-test)
library(car)
h0 <- c("cigtax=0", "cigprice=0")
linearHypothesis(bwght_res, h0)
```
- LM test:
```R
# Lagrange multiplier statistic
# 1. Regress y on the restricted set of independent variables
bwght_restr <- lm(bwght ~ faminc + cigs + male, data = bwght)
# 2. Save the residuals of the restricted model
u_restr <- resid(bwght_restr)
# 3. Regress u_restr on all of the independent variables
lagrange <- lm(u_restr ~ faminc + cigs + male + cigtax + cigprice, data = bwght)
# 4. LM = R(u)^2 * n
lm <- summary(lagrange)$r.squared * nobs(lagrange)
# Find p-value
1 - pchisq(lm, 2)
```
- Result: 
    
    
    F-test : p-value = 0.1999 > α=0.05
    
    
    LM test: p-value = 0.1989 > α=0.05


Therefore, we fail to reject the null hypothesis (at the 5% level)


=> the group of variables are jointly insignificant


=> dropping them from the model.
    
    
## 7. The right model is:
```
bwght = β0  + β1 faminc + β2 male + β3 cigs + u     

```
- R code:
```R
final_bwght_res <- lm(bwght ~ faminc + male + cigs, data = bwght)
summary(final_bwght_res)
```
- The OLS regression is
```
bwght = 115.2277  + 0.0969faminc + 3.114male – 0.4611cigs 
        (1.2079)      (0.0292)	   (1.0764)	(0.0913)	    
	n = 1388,  R2 = 0.03564  
```
