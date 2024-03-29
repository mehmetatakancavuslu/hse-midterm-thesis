# Model 1 using the weekly data to overcome hardware limitations
library(dplyr)
library(tidyverse) # Modern data science library
library(completejourney) # Retailer data
library(plm)       # Panel data analysis library
library(car)       # Companion to applied regression
library(gplots)    # Various programing tools for plotting data
library(tseries)   # For timeseries analysis
library(lmtest)
library(AER)
library(ggplot2)
library(GGally)
library(VGAM)

#Read CSVs
weekly_household_spendings <- read.csv("weekly_household_spendings.csv")
weekly_household_campaigns <-  read.csv("weekly_household_campaigns.csv")

#Merge to final dataset & removed unused DFs
m1 <- merge(weekly_household_campaigns,weekly_household_spendings)
rm("weekly_household_spendings","weekly_household_campaigns")

#Change all variables to factors except amount spent for  OLS & Tobit
m1$week <- as.factor(m1$week)
m1$household_id <- as.factor(m1$household_id)
str(m1)

#tobit with VGAM Package
m_tobit <- vglm(daily_amount_spent~household_id+week+coupons_per_day, tobit(Lower = 0), data = m1)
summary(m_tobit)

# Check if week is critical
plotLowess(coupons_per_day~week, data=m1, col.lowess="red", lty.lowess=2)
lw <- lowess(coupons_per_day~week, data=m1)

# OLS model
m_ols <-lm(daily_amount_spent~coupons_per_day, data = m1)
summary(m_ols)
yhat <- m_ols$fitted
ggplot(m1, aes(x = coupons_per_day, y = daily_amount_spent))+
  geom_point(position = "jitter") +
  geom_smooth(method=lm)

