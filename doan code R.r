# B3: Xác định dạng hàm hồi quy
# bwght = b0 + b1faminc + b2cigs + b3male + b4cigtax + b5cigprice+ u # nolint

# B4: tiến hành hồi quy
library(wooldridge)
kqua <- lm(bwght ~ faminc + male + cigs + cigtax + cigprice, data = bwght)
summary(kqua)

# B5 kiểm định sai dạng hàm (kiểm định RESET)
library(lmtest)
resettest(lm(bwght ~ faminc + male + cigs + cigtax + cigprice, data = bwght))

# B6 Kiểm định phân phối chuẩn của u (Kiểm định giả thuyết MLR. 6)
# cách 1
library(normtest)
u <- resid(kqua)
# cách 2
jb.norm.test(u)
shapiro.test(u)

# B7 Kiểm định phương sai thay đổi (Kiểm định giả thuyết MLR. 5)
# bp test
library(lmtest)
bptest(kqua)
#white test
bptest(kqua, ~ fitted(kqua) + I(fitted(kqua)^2))

# B8a kiểm định ý nghĩa riêng lẻ các biến (kiểm định t)
summary(kqua)

# B8b kiểm định đồng thời
# kiểm định F
library(car)
h0 <- c("cigtax=0", "cigprice=0")
linearHypothesis(kqua, h0)

# kiểm định nhân tử Lagrange
# 1. Hồi quy y theo mô hình đã gán ràng buộc
kqua_restr <- lm(bwght ~ faminc + cigs + male, data = bwght)
# 2. Tìm phần dư u~ của mô hình đã gán ràng buộc
u_restr <- resid(kqua_restr)
# 3. Hồi quy u~ theo tất cả các biến độc lập. Từ đó tìm được Ru~^2
lagrange <- lm(u_restr ~ faminc + cigs + male + cigtax + cigprice, data = bwght)
# 4. tính LM = Ru~^2 * n
lm <- summary(lagrange)$r.squared * nobs(lagrange)
# Tính p-value
1 - pchisq(lm, 2)

# B9 mô hình hồi quy đúng
kqua_dung <- lm(bwght ~ faminc + male + cigs, data = bwght)
summary(kqua_dung)
