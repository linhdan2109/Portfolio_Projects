# Objective
- Build a Regression model to determine the effects of the number of cigs smoked by the mother per day during pregnancy, family income and the gender of the baby on infant health. I take the birth weight to represent the health of the infant. I also take some other factors that affect birth weight and likely to be correlated with smoking into account. Consider the following model: 
    - bwght = β0 + β1 faminc + β2 male + β3 cigs + β4 cigtax + β5 cigprice + u
    
-  The data of is project is from Wooldridge libary: Use the data set BWGHT in libary (Wooldridge) to estimate the model.

# Introduce Variables
- Dependent Variable
    - bwght: birth weight, ounces
    
- Independent Variables
  - faminc: family income, $1000s
  - male: =1 if male child - Dummy Variable
  - cigs:  cigs smoked per day while preg
  - cigtax: cig. tax in home state
  - cigprice:  cig. price in home state

# Skills Acquired
1. Basic knowledge of Economometrics
2. Build a Multiple Linear Regression Model
3. Hypothesis Testing:  Residual Normality Test, Heteroskedasticity Test, T-test, F-test to remove insignificant variables and unnecessary variables 
4. R language
