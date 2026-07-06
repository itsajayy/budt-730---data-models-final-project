set.seed(123)

library(dplyr)

sample_df <- sample_n(car_prices_clean_main, 20000) 

#modelA

modelA <- lm(sellingprice ~ year + make +	model +	trim 
             + body +	transmission + state + condition 
             + odometer + color + interior, data=sample_df)

summary(modelA)

alias(modelA)

anova(modelA)

par(mfrow = c(2, 2))


# 1. scatter plot of fitted vs. sellingprice

plot(modelA$fitted.values, sample_df$sellingprice,
     main = "Fitted vs Observed selling price")
abline(0, 1, col = "red")

# 2. residual plot (residuals vs. fitted values)

plot(modelA$fitted.values, resid(modelA),
     main = "Residuals vs Fitted Values")
abline(h=0,col = "red", lwd = 2)

#3. Q-Q plot of residuals

qqnorm(resid(modelA))
qqline(resid(modelA), col = "red", lwd = 2)

#4. histogram of residuals

hist(resid(modelA))

#calculating vif 

install.packages("car")

library(car)

vif_values <- vif(modelA)
print(vif_values)

# creating correlation matrix
dtcorr <- sample_df[, c("year","make","model","trim","body","transmission","state","condition","odometer","color","interior")]
corr <- cor(dtcorr)

print(corr)

install.packages("corrplot")

library(corrplot)
corrplot(corr)



#ModelB

set.seed(123)

library(dplyr)

sample_df2 <- sample_n(car_sales_without_outliers, 20000) 

modelB <- lm(sellingprice ~ factor(year) + make +	model +	trim 
             + body +	transmission + state + condition 
             + odometer + color + interior, data=sample_df2)

summary(modelB)

alias(modelB)

anova(modelB)

par(mfrow = c(2, 2))


# 1. scatter plot of fitted vs. sellingprice

plot(modelB$fitted.values, sample_df2$sellingprice,
     main = "Fitted vs Observed selling price")
abline(0, 1, col = "red")

# 2. residual plot (residuals vs. fitted values)

plot(modelB$fitted.values, resid(modelB),
     main = "Residuals vs Fitted Values")
abline(h=0,col = "red", lwd = 2)

#3. Q-Q plot of residuals

qqnorm(resid(modelB))
qqline(resid(modelB), col = "red", lwd = 2)

#4. histogram of residuals

hist(resid(modelB))

#calculating vif 

install.packages("car")

library(car)

vif_values <- vif(modelB)
print(vif_values)

# creating correlation matrix
dtcorr <- sample_df[, c("year","make","model","trim","body","transmission","state","condition","odometer","color","interior")]
corr <- cor(dtcorr)

print(corr)

install.packages("corrplot")

library(corrplot)
corrplot(corr)



#modelB1

anova(modelB1)


set.seed(123)

library(dplyr)

sample_df3 <- sample_n(car_stats_quartile, 25000) 



summary(modelB1)


sample_df3$model_trim <- paste(sample_df3$model,sample_df3$trim, sep = '_')

count_distinct <- sample_df3 %>%
  distinct(model_trim) %>%
  nrow()

top_combinations <- names(sort(table(sample_df3$model_trim), decreasing = TRUE))[1:50]

sample_df3$model_trim <- ifelse(
  sample_df3$model_trim %in% top_combinations,
  sample_df3$model_trim,
  "Other"
)

sample_df3 <- sample_df3 %>% select(-model, -trim) 

modelB1 <- lm(log(sellingprice) ~ year + model_trim 
              + body +	transmission + state + condition 
              + log(odometer) + interior, data=sample_df3)

summary(modelB1)

anova(modelB1)

library(car)

vif_values <- vif(modelB1)
print(vif_values)

#model b2 <- without body

modelB2 <- lm(log(sellingprice) ~ year + model_trim +	transmission + state + condition 
              + log(odometer) + interior, data=sample_df3)

summary(modelB2)

anova(modelB2)

library(car)

vif_values <- vif(modelB2)
print(vif_values)


par(mfrow = c(2, 2))

# 1. scatter plot of fitted vs. sellingprice

plot(modelB2$fitted.values, sample_df3$sellingprice,
     main = "Fitted vs Observed selling price")
abline(0, 1, col = "red")

# 2. residual plot (residuals vs. fitted values)

plot(modelB2$fitted.values, resid(modelB2),
     main = "Residuals vs Fitted Values")
abline(h=0,col = "red", lwd = 2)

#3. Q-Q plot of residuals

qqnorm(resid(modelB2))
qqline(resid(modelB2), col = "red", lwd = 2)

#4. histogram of residuals

hist(resid(modelB2))