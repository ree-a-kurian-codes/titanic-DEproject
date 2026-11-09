
# Titanic Survival Prediction Project
# R Implementation

cat("========================================\n")
cat("Titanic Survival Prediction Project - R\n")
cat("========================================\n")

# Question 23: Load the training dataset

cat("\n=== Question 23: Load Training Dataset ===\n")

# The Docker container will mount the data folder here
data_path <- "/app/src/data/train.csv"

# Load the Titanic training dataset
train_data <- read.csv(data_path)

cat("\nTraining dataset loaded successfully!\n")

# Display the dataset dimensions
cat("\nDataset shape (rows, columns):\n")
print(dim(train_data))

# Display the first five passengers
cat("\nFirst five rows:\n")
print(head(train_data, 5))

# Display the column names
cat("\nDataset columns:\n")
print(names(train_data))

cat("\nQuestion 23 completed successfully!\n")


# Question 24 - Explore and prepare the data

cat("\n=== Explore and Prepare Training Data ===\n")

# Select the features used for prediction
features <- c("Pclass", "Sex", "Age", "SibSp", "Parch", "Fare")

model_data <- train_data[, c("Survived", features)]

# Explore the data
cat("\nSummary of selected columns:\n")
print(summary(model_data))

cat("\nMissing values before cleaning:\n")
print(colSums(is.na(model_data)))

# Replace missing ages with the median age
median_age <- median(model_data$Age, na.rm = TRUE)

model_data$Age[is.na(model_data$Age)] <- median_age

cat("\nMissing ages filled with median age:", median_age, "\n")

# Replace missing fares if any exist
median_fare <- median(model_data$Fare, na.rm = TRUE)

model_data$Fare[is.na(model_data$Fare)] <- median_fare

# Convert Sex from text into numbers
# male = 0, female = 1
model_data$Sex <- ifelse(model_data$Sex == "female", 1, 0)

cat("\nMissing values after cleaning:\n")
print(colSums(is.na(model_data)))

cat("\nFirst five rows after preprocessing:\n")
print(head(model_data, 5))

cat("\nData exploration and preprocessing completed!\n")


# Question 24 - Build Logistic Regression Model

cat("\n=== Build Logistic Regression Model ===\n")

# Train the logistic regression model
titanic_model <- glm(
  Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
  data = model_data,
  family = binomial
)

cat("\nLogistic regression model trained successfully!\n")

# Display information about the trained model
cat("\nModel coefficients:\n")
print(coef(titanic_model))

# Predict survival probabilities on the training data
train_probabilities <- predict(
  titanic_model,
  newdata = model_data,
  type = "response"
)

# Convert probabilities into predictions:
# 0 = did not survive, 1 = survived
train_predictions <- ifelse(train_probabilities >= 0.5, 1, 0)

cat("\nFirst 10 survival predictions:\n")
print(head(train_predictions, 10))

cat("\nLogistic regression modeling completed!\n")


# Question 24 - Measure Training Accuracy

cat("\n=== Training Model Accuracy ===\n")

# Get the actual survival outcomes
actual_survival <- model_data$Survived

# Compare the predictions with the actual outcomes
correct_predictions <- sum(train_predictions == actual_survival)

# Count the total passengers
total_passengers <- length(actual_survival)

# Calculate accuracy
training_accuracy <- mean(train_predictions == actual_survival)

# Display the results
cat("\nTotal passengers:", total_passengers, "\n")
cat("Correct predictions:", correct_predictions, "\n")
cat("Incorrect predictions:",
    total_passengers - correct_predictions, "\n")

cat(
  "\nTraining Accuracy:",
  round(training_accuracy * 100, 2),
  "%\n"
)

cat("\nTraining accuracy evaluation completed!\n")


# Question 24 - Predict on the Test Dataset

cat("\n=== Predict Survival on Test Dataset ===\n")

# Load test.csv
test_path <- "/app/src/data/test.csv"
test_data <- read.csv(test_path)

cat("\nTest dataset loaded successfully!\n")
cat("Test dataset dimensions:\n")
print(dim(test_data))

# Select the same six features used during training
test_features <- test_data[, features]

cat("\nMissing values before cleaning:\n")
print(colSums(is.na(test_features)))

# Fill missing values using the TRAINING medians
test_features$Age[is.na(test_features$Age)] <- median_age
test_features$Fare[is.na(test_features$Fare)] <- median_fare

# Convert Sex into numbers
test_features$Sex <- ifelse(
  test_features$Sex == "female", 1, 0
)

cat("\nMissing values after cleaning:\n")
print(colSums(is.na(test_features)))

# Predict survival probabilities
test_probabilities <- predict(
  titanic_model,
  newdata = test_features,
  type = "response"
)

# Convert probabilities into 0 or 1
test_predictions <- ifelse(test_probabilities >= 0.5, 1, 0)

cat("\nFirst 10 test predictions:\n")
print(head(test_predictions, 10))

# Create a results table
results <- data.frame(
  PassengerId = test_data$PassengerId,
  Survived = test_predictions
)

# Save predictions outside the source code folder
output_dir <- "/app/predictions"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

output_path <- file.path(output_dir, "titanic_r_predictions.csv")
write.csv(results, output_path, row.names = FALSE)

cat("\nPredictions saved to:", output_path, "\n")
cat("Total test passengers predicted:", nrow(results), "\n")

cat("\nTest dataset prediction completed!\n")


# Question 24 - Evaluate Model on Held-Out Data

cat("\n=== Held-Out Model Evaluation ===\n")

# Set a seed so the random split is reproducible
set.seed(42)

# Split the original labeled data into 80% training
# and 20% validation
total_rows <- nrow(train_data)
training_indices <- sample(
  seq_len(total_rows),
  size = floor(0.8 * total_rows)
)

evaluation_train <- train_data[training_indices, ]
evaluation_test <- train_data[-training_indices, ]

cat("\nEvaluation training passengers:",
    nrow(evaluation_train), "\n")
cat("Held-out validation passengers:",
    nrow(evaluation_test), "\n")

# Prepare the training portion
eval_train_features <- evaluation_train[, c("Survived", features)]

# Calculate medians from evaluation training data only
eval_median_age <- median(eval_train_features$Age, na.rm = TRUE)
eval_median_fare <- median(eval_train_features$Fare, na.rm = TRUE)

eval_train_features$Age[is.na(eval_train_features$Age)] <- eval_median_age
eval_train_features$Fare[is.na(eval_train_features$Fare)] <- eval_median_fare
eval_train_features$Sex <- ifelse(
  eval_train_features$Sex == "female", 1, 0
)

# Prepare the held-out validation portion
eval_test_features <- evaluation_test[, c("Survived", features)]

# Use the training medians, not validation medians
eval_test_features$Age[is.na(eval_test_features$Age)] <- eval_median_age
eval_test_features$Fare[is.na(eval_test_features$Fare)] <- eval_median_fare
eval_test_features$Sex <- ifelse(
  eval_test_features$Sex == "female", 1, 0
)

cat("\nMissing values in evaluation training data:\n")
print(colSums(is.na(eval_train_features)))

cat("\nMissing values in held-out validation data:\n")
print(colSums(is.na(eval_test_features)))

# Train a separate model using only the 80% training portion
evaluation_model <- glm(
  Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
  data = eval_train_features,
  family = binomial
)

cat("\nEvaluation model trained successfully!\n")

# Predict survival on the unseen 20% validation portion
validation_probabilities <- predict(
  evaluation_model,
  newdata = eval_test_features,
  type = "response"
)

validation_predictions <- ifelse(
  validation_probabilities >= 0.5, 1, 0
)

# Compare predictions with the actual outcomes
validation_actual <- eval_test_features$Survived

validation_correct <- sum(
  validation_predictions == validation_actual
)

validation_total <- length(validation_actual)

validation_accuracy <- mean(
  validation_predictions == validation_actual
)

cat("\nHeld-out validation results:\n")
cat("Total passengers:", validation_total, "\n")
cat("Correct predictions:", validation_correct, "\n")
cat("Incorrect predictions:",
    validation_total - validation_correct, "\n")

cat(
  "Held-Out Accuracy:",
  round(validation_accuracy * 100, 2),
  "%\n"
)

cat("\nHeld-out model evaluation completed!\n")


# Question 24 - Final Summary

cat("\n========================================\n")
cat("TITANIC R MODEL - FINAL SUMMARY\n")
cat("========================================\n")

cat("\nTraining dataset passengers:", nrow(train_data), "\n")

cat(
  "Training accuracy:",
  round(training_accuracy * 100, 2),
  "%\n"
)

cat("\nKaggle test passengers predicted:", nrow(test_data), "\n")
cat("Prediction file:", output_path, "\n")

cat(
  "\nHeld-out validation accuracy:",
  round(validation_accuracy * 100, 2),
  "%\n"
)

cat(
  "\nNote: Kaggle test.csv has no Survived labels,\n",
  "so its actual accuracy cannot be calculated locally.\n",
  sep = ""
)

cat("\nR Titanic analysis completed successfully!\n")




