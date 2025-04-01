library(shiny)
library(ggplot2)
library(forecast)
library(tseries)
library(zoo)
library(randomForest)  

# Load and preprocess data
data <- read.csv("C:/Users/gyasi/OneDrive/Desktop/DATA ANALYTICS/R/tsla_2014_2023.csv")
data$date <- as.Date(data$date, format = "%Y-%m-%d")
data$log_close <- log(data$close)
data$log_close <- na.locf(data$log_close, na.rm = FALSE)

# Create next_day_close column for prediction
data$next_day_close <- c(data$close[-1], NA)

# Remove rows with NA values
data <- na.omit(data)

# Verify required columns exist
required_cols <- c("close", "volume", "rsi_14", "next_day_close")
if(!all(required_cols %in% colnames(data))) {
  stop("Missing required columns in dataset")
}

# Split data into training and test sets (80% train, 20% test)
set.seed(123)
train_indices <- sample(1:nrow(data), size = floor(0.8 * nrow(data)))
train <- data[train_indices, ]
test <- data[-train_indices, ]

# Time series data for ARIMA models
ts_data <- ts(data$close, start = c(2014, 1), frequency = 252)
ts_data_log <- ts(data$log_close, start = c(2014, 1), frequency = 252)

# Build ARIMA models
original_arima <- auto.arima(ts_data)
improved_arima <- auto.arima(ts_data_log)

forecast_original <- forecast(original_arima, h = 90)
forecast_improved <- forecast(improved_arima, h = 90)

# Shiny UI
ui <- fluidPage(
  titlePanel("Tesla Stock Analysis"),
  
  tabsetPanel(
    tabPanel("Visualizations", 
             plotOutput("linePlot"),
             plotOutput("histPlot"),
             plotOutput("scatterPlot")
    ),
    tabPanel("Models", 
             verbatimTextOutput("lmSummary"),
             verbatimTextOutput("logisticSummary"),
             verbatimTextOutput("rfSummary")
    ),
    tabPanel("ARIMA Forecasting", 
             fluidRow(
               column(6, plotOutput("originalArimaPlot")),
               column(6, plotOutput("improvedArimaPlot"))
             ),
             fluidRow(
               column(6, plotOutput("originalResiduals")),
               column(6, plotOutput("improvedResiduals"))
             )
    )
  )
)

# Server Function
server <- function(input, output) {
  
  # Create binary target for classification models
  train$up_down <- as.factor(ifelse(c(NA, diff(train$close)) > 0, 1, 0))
  test$up_down <- as.factor(ifelse(c(NA, diff(test$close)) > 0, 1, 0))
  
  # Remove first row with NA (from diff operation)
  train_cls <- train[-1, ]
  test_cls <- test[-1, ]
  
  # Linear Regression Model
  lm_model <- lm(next_day_close ~ close + volume + rsi_14, data = train)
  lm_pred <- predict(lm_model, newdata = test)
  lm_rmse <- sqrt(mean((lm_pred - test$next_day_close)^2, na.rm = TRUE))
  
  # Logistic Regression
  logistic_model <- tryCatch({
    glm(up_down ~ volume + rsi_14, 
        data = train_cls, 
        family = binomial())
  }, error = function(e) {
    return(NULL)
  })
  
  if(!is.null(logistic_model)) {
    logistic_probs <- predict(logistic_model, newdata = test_cls, type = "response")
    logistic_preds <- ifelse(logistic_probs > 0.5, 1, 0)
    logistic_cm <- table(Predicted = logistic_preds, Actual = test_cls$up_down)
    logistic_accuracy <- sum(diag(logistic_cm))/sum(logistic_cm)
  }
  
  # Random Forest
  rf_model <- tryCatch({
    randomForest(up_down ~ volume + rsi_14, 
                 data = train_cls,
                 importance = TRUE)
  }, error = function(e) {
    return(NULL)
  })
  
  if(!is.null(rf_model)) {
    rf_preds <- predict(rf_model, newdata = test_cls)
    rf_cm <- table(Predicted = rf_preds, Actual = test_cls$up_down)
    rf_accuracy <- sum(diag(rf_cm))/sum(rf_cm)
  }
  
  # Plot outputs
  output$linePlot <- renderPlot({
    ggplot(data, aes(x = date, y = close)) +
      geom_line(color = "blue") +
      labs(title = "Tesla Stock Closing Price Over Time", x = "Date", y = "Closing Price") +
      theme_minimal()
  })
  
  output$histPlot <- renderPlot({
    returns <- c(NA, diff(log(data$close)))
    ggplot(data.frame(returns = returns), aes(x = returns)) +
      geom_histogram(binwidth = 0.01, fill = "dodgerblue", color = "black") +
      labs(title = "Distribution of Daily Returns", x = "Daily Returns", y = "Frequency") +
      theme_minimal()
  })
  
  output$scatterPlot <- renderPlot({
    ggplot(data, aes(x = rsi_14, y = close)) +
      geom_point(color = "orangered", alpha = 0.6) +
      labs(title = "RSI vs Closing Price", x = "RSI (14-day)", y = "Closing Price") +
      theme_minimal()
  })
  
  output$originalArimaPlot <- renderPlot({
    plot(forecast_original, main = "Original Tesla Stock 90-Day Forecast", col = "blue")
  })
  
  output$improvedArimaPlot <- renderPlot({
    plot(forecast_improved, main = "Improved Tesla Stock 90-Day Forecast", col = "blue")
  })
  
  output$originalResiduals <- renderPlot({
    checkresiduals(original_arima)
  })
  
  output$improvedResiduals <- renderPlot({
    checkresiduals(improved_arima)
  })
  
  # Model outputs
  output$lmSummary <- renderPrint({
    cat("=== Linear Regression Model ===\n")
    print(summary(lm_model))
    cat("\n=== Model Evaluation (Test Set) ===\n")
    cat(paste("RMSE:", round(lm_rmse, 4), "\n"))
    cat(paste("Number of test samples:", nrow(test), "\n"))
  })
  
  output$logisticSummary <- renderPrint({
    if(is.null(logistic_model)) {
      cat("Could not build logistic regression model - check for missing values or insufficient data\n")
    } else {
      cat("=== Logistic Regression Model ===\n")
      print(summary(logistic_model))
      cat("\n=== Model Evaluation (Test Set) ===\n")
      cat("Confusion Matrix:\n")
      print(logistic_cm)
      cat(paste("\nAccuracy:", round(logistic_accuracy, 4), "\n"))
      cat(paste("Number of test samples:", nrow(test_cls), "\n"))
    }
  })
  
  output$rfSummary <- renderPrint({
    if(is.null(rf_model)) {
      cat("Could not build random forest model - check for missing values or insufficient data\n")
    } else {
      cat("=== Random Forest Model ===\n")
      print(rf_model)
      cat("\n=== Model Evaluation (Test Set) ===\n")
      cat("Confusion Matrix:\n")
      print(rf_cm)
      cat(paste("\nAccuracy:", round(rf_accuracy, 4), "\n"))
      cat("\nVariable Importance:\n")
      print(importance(rf_model))
      cat(paste("\nNumber of test samples:", nrow(test_cls), "\n"))
    }
  })
}

# Run App
shinyApp(ui = ui, server = server)