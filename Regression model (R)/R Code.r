# Store results under "bwght_res" and display full table:
library(wooldridge)
bwght_res <- lm(bwght ~ faminc + male + cigs + cigtax + cigprice, data = bwght)
summary(bwght_res)

# Regression specification error test (RESET test)
library(lmtest)
resettest(bwght_res)

# Residual Normality Test (Jarque.Bera test and Shapiro.Wilk test)
library(normtest)
u <- resid(bwght_res)
jb.norm.test(u)
shapiro.test(u)

# Heteroskedasticity test (BP test and White test)
library(lmtest)
bptest(bwght_res)
bptest(bwght_res, ~ fitted(bwght_res) + I(fitted(bwght_res)^2))

# Tests for statistical significance (T-test)
summary(bwght_res)

# Joint hypotheses test (F-test)
library(car)
h0 <- c("cigtax=0", "cigprice=0")
linearHypothesis(bwght_res, h0)

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

# True model
final_bwght_res <- lm(bwght ~ faminc + male + cigs, data = bwght)
summary(final_bwght_res)
