#OBJECTIVES
#Explore and visualize stock trends  
#Predict next_day_close using Linear Regression  
#Predict price movement (up/down) using Logistic Regression  
#BONUS: Use KNN or Random Forest to compare results  
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
#KNN 
#Normalize numeric columns (min-max)
  
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
