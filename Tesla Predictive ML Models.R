#OBJECTIVES
#Explore and visualize stock trends  
#Predict next_day_close using Linear Regression  
#Predict price movement (up/down) using Logistic Regression  
#KNN or Random Forest to compare results  
-------------------------------------------------------------------------------------
#Install and Download necessary libraries

library(tidyverse)
library(lubridate)
library(caret)
library(class)
library(e1071)
library(randomForest)
library(zoo)

#load our datasets
data<-read.csv("C:/Users/gyasi/OneDrive/Desktop/DATA ANALYTICS/R/tsla_2014_2023.csv")

#to further understand our data, we perform EDA
summary(data)
str(data)

#convert date
data$date <- as.Date(data$date, format = "%Y-%m-%d")

#re-run to verify that date has been correctly formatted
summary(data)
str(data)

data$return<- data$next_day_close-data$close
data$price_up <-ifelse(data$return>0,1,0)
data$volatility<-zoo::rollapply(data$return,7,sd,fill=NA)

if (length(unique(data$price_up)) > 1) {
  train_lorm <- createDataPartition(data$price_up, p = 0.8, list = FALSE)
  train2 <- data[train_lorm, ]
  test2 <- data[-train_lorm, ]
} else {
  stop("Error: Not enough unique values in price_up for training/testing split.")
}


#VISUALIZATION TRENDS
#line chart (Date vs closing)  
ggplot(data, aes(x = date, y = close)) +
  geom_line(color = "blue") +
  labs(title = "Tesla Stock Closing Price Over Time",
       x = "Date", 
       y = "Closing Price") +
  theme_minimal()

#Histogram (Daily returns)
#create a new column to calculate daily returns
data$daily_return <- c(NA, diff(log(data$close)))
data <- data[is.finite(data$daily_return), ]

ggplot(data, aes(x = daily_return)) +
  geom_histogram(binwidth = 0.01, fill = "dodgerblue", color = "black") +
  labs(title = "Distribution of Daily Returns",
       x = "Daily Returns",
       y = "Frequency") +
  theme_minimal()

#Scatter plot (RSI vs Closing price)
ggplot(data, aes(x = rsi_14, y = close)) +
  geom_point(color = "orangered", alpha = 0.6) +
  labs(title = "RSI vs Closing Price",
       x = "RSI (14-day)",
       y = "Closing Price") +
  theme_minimal()

--------------------------------------------------------------------------------
#BUILD LINEAR REGRESSION MODEL
#GOAL: PREDICT Next day close

features<- c("close","volume","rsi_14","macd","sma_50")
formula<- as.formula(paste("next_day_close ~ ", paste(features,collapse = " + ")))
set.seed(42)

train_lrm <-createDataPartition(data$next_day_close,p=0.8,list = FALSE)
train <-data[  train_lrm, ]
test <-data[- train_lrm]

#Build model, Name of model = lm_model
lm_model <-lm(formula, data = train)

summary(lm_model)


------

#Evaluate model
predicted <- predict(lm_model, newdata = test)

# Ensure test set has all required columns
print(colnames(test))

# If columns are missing, re-create the split
set.seed(42)
train_lrm <- createDataPartition(data$next_day_close, p = 0.8, list = FALSE)
train <- data[train_lrm, ]
test <- data[-train_lrm, ]

# Rebuild model (optional)
lm_model <- lm(formula, data = train)

# Predict and calculate RMSE
predicted <- predict(lm_model, newdata = test)  # Now works if test has all columns
actual <- test$next_day_close
rmse <- sqrt(mean((predicted - actual)^2))
print(paste("RMSE:", rmse))
--------------------------------------------------------------------------------

#BUILD LOGISTIC REGRESSION MODEL
#GOAL: Predict Price up(0 or 1)
data$price_up <- ifelse(data$next_day_close > data$close, 1, 0)

set.seed(42)
train_lorm <- createDataPartition(data$price_up, p = 0.8, list = FALSE)
train2 <- data[train_lorm, ]
test2 <- data[-train_lorm, ]

#Build the model
formula <- price_up ~ close + rsi_14 + macd + volume
logistic_model <- glm(formula, data = train2, family = "binomial")

summary(logistic_model)

# Predict on the test set
predictions2 <- predict(logistic_model, newdata = test, type = "response")
predicted_class <- ifelse(predictions2 > 0.5, 1, 0)

-------
  
# Evaluate with Confusion Matrix
confusion <- table(Predicted = predicted_class, Actual = test$price_up)
print(confusion)

# Calculate Accuracy
accuracy <- sum(diag(confusion)) / sum(confusion)
print(paste("Logistic Regression Model Accuracy:", round(accuracy, 4)))

------------------------------------------------------------------------------

#Random Forest
#Normalize numeric columns (min-max)
  
# Normalize the numeric features using min-max scaling
numeric_features <- c("close", "rsi_14", "macd", "volume")
pre_process <- preProcess(data[, numeric_features], method = "range")
data_normalized <- predict(pre_process, data[, numeric_features])

# Add normalized features back to the original data
data[, numeric_features] <- data_normalized

# Create the formula for Random Forest model
formula2 <- price_up ~ close + rsi_14 + macd + volume

# Split the data into training and testing sets (80% train, 20% test)
set.seed(42)
train_rfm <- createDataPartition(data$price_up, p = 0.8, list = FALSE)
train3 <- data[train_rfm, ]
test3 <- data[-train_rfm, ]

# Train the Random Forest model
rf_model <- randomForest(formula2, data = train3, importance = TRUE)

# View model summary
print(rf_model)

# Predict on the test dataset
predictions3 <- predict(rf_model, newdata = test)

# Convert predictions to binary outcome (0 or 1)
predicted_class <- ifelse(predictions3 > 0.5, 1, 0)

-----------------------
  
# Confusion matrix
confusion2 <- table(Predicted = predicted_class, Actual = test$price_up)
print(confusion2)

# Calculate accuracy
accuracy2 <- sum(diag(confusion2)) / sum(confusion2)
print(paste("Random Forest Model Accuracy:", round(accuracy2, 4)))

-----------------
  
#Time series forecasting (ARIMA)
#install and import "forecast" library

library(forecast)
library(tseries)

ts_data <- ts(data$close, start = c(2014, 1), frequency = 252)
plot(ts_data, main = "Tesla Stock Closing Price Over Time", col = "blue", ylab = "Closing Price", xlab = "Year")

adf.test(ts_data)


#P value > 0.05 therefore data is none stationary, so let's consider applying first-order differencing

diff_data <- diff(ts_data)
plot(diff_data, main = "Differenced Tesla Closing Prices", col = "red", ylab = "Differenced Price")

adf.test(diff_data) 

arima_model <- auto.arima(ts_data)
summary(arima_model)

forecast_values <- forecast(arima_model, h = 90)
plot(forecast_values, main = "Tesla Stock Price 90 Day Forecast", col = "blue")


#Evaluating Accuracy
checkresiduals(arima_model)

-----------------------------------------
#Improving the Arima Model
#need to stabilize the fluctuations
data$log_close <- log(data$close)
ts_data_log <- ts(data$log_close, start = c(2014, 1), frequency = 252)

library(tseries)
adf.test(ts_data_log)

sum(is.na(data$log_close))  # Count missing values
sum(is.infinite(data$log_close))  # Count infinite values


data <- data[!is.na(data$log_close) & !is.infinite(data$log_close), ]

library(zoo)
data$log_close <- na.locf(data$log_close, na.rm = FALSE)

ts_data_log <- ts(data$log_close, start = c(2014, 1), frequency = 252)
adf.test(ts_data_log)


ts_data_diff <- diff(ts_data_log, differences = 1)
adf.test(ts_data_diff)

plot(ts_data_diff, main = "Differenced Time Series", col = "blue")


library(forecast)
best_arima <- auto.arima(ts_data_log)
summary(best_arima)


#Now lets plot the new model: 
forecast_values <- forecast(best_arima, h = 90)
plot(forecast_values, main = "Improved Tesla Stock 90 Day Forecast", col = "blue")


checkresiduals(best_arima)

