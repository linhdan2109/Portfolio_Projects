#B3 xac dinh dang ham hoi quy
#bwght = b0 + b1faminc + b2cigs + b3male + b4cigtax + b5cigprice+ u # nolint

#B4: tien hanh hoi quy
library(wooldridge)
kqua <- lm(bwght ~ faminc + male + cigs + cigtax + cigprice, data = bwght)
summary(kqua)

#B5 kiem dinh sai dang ham (kiem dinh RESET)
library(lmtest)
resettest(lm(bwght ~ faminc + male + cigs + cigtax + cigprice, data = bwght))

#B6 kiem dinh pp chuan cua u (neu mau lon ta co the suy ra mau tiem can chuan)
library(normtest)
u <- resid(kqua)
jb.norm.test(u)
shapiro.test(u)

#B7 kiem dinh phuong sai thay doi
library(lmtest)
bptest(kqua)
#white test
bptest(kqua, ~ fitted(kqua) + I(fitted(kqua)^2))

#B8.1 kiem dinh cac bien co y nghia thong ke hay khong (kiem dinh t)
summary(kqua)

#B8.2 kiem dinh dong thoi
# kiem dinh F
library(car)
h0 <- c("cigtax=0", "cigprice=0")
linearHypothesis(kqua, h0)

# kiem dinh Lagrange
# 1. mo hinh rang buoc
kqua_restr <- lm(bwght ~ faminc + cigs + male, data = bwght)
# 2. tim phan du cua mo hinh rang buoc
u_restr <- resid(kqua_restr)
# 3. hoi quy tat ca cac bien theo phan du cua mo hinh rang buoc
lagrange <- lm(u_restr ~ faminc + cigs + male + cigtax + cigprice, data = bwght)
# 4. tinh LM = r^2 * n
lm <- summary(lagrange)$r.squared * nobs(lagrange)
# tính p-value. Bac bo H0 neu p-value < a
1 - pchisq(lm, 2)

#9 mo hinh hoi quy dung
kqua_dung <- lm(bwght ~ faminc + male + cigs, data = bwght)
summary(kqua_dung)