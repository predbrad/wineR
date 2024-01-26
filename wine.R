# Load the MASS library for statistical functions, including 'polr'
library(MASS)

# Reading and preparing the data
# Read CSV file into a data frame
data <- read.csv("df.csv", header = TRUE, sep = ",", dec = ".")

# Removing specific columns and ensuring the data is in a data frame format
data <- as.data.frame(data[-c(1,2,3,16,17)])

# Inspecting the last few rows of the dataset
tail(data)

# Inspecting the first few rows of the dataset
head(data)

# Displaying the structure of the dataset
str(data)

# Check for missing values in the dataset
# Stop execution if missing values are found
if(anyNA(data)) {
    stop("Missing values found in the dataset.")
}

# Convert 'z' column to a factor, assuming it's a categorical variable
data$z <- as.factor(data$z)
class(data$z)

# Setting up cross-validation
# Set a seed for reproducibility
set.seed(12345)

# Define the number of folds for cross-validation
k <- 2

# Generate a random sequence of fold numbers for each row in the dataset
folds <- sample(1:k, nrow(data), replace = TRUE)

# Initialize a vector to store accuracy for each fold
cv_accuracy <- numeric(k)

# Cross-validation loop
for (i in 1:k) {
    # Splitting data into training and validation sets
    train <- data[folds != i, ]
    valid <- data[folds == i, ]

    # Convert the response variable 'quality3' to a factor in both training and validation sets
    # Required for the 'polr' function
    train$quality3 <- as.factor(train$quality3)
    valid$quality3 <- as.factor(valid$quality3)

    # Ensure factor levels are consistent in training and validation sets
    valid$z <- factor(valid$z, levels = levels(train$z))

    # Fit the proportional odds logistic regression model to the training data
    # 'polr' function documentation: https://www.rdocumentation.org/packages/MASS/versions/7.3-47/topics/polr
    model <- polr(quality3 ~ ., data = train, Hess = TRUE)

    # Generate predictions for the validation set
    predictions <- predict(model, newdata = valid, type = "class")

    # Calculate accuracy for this fold and store it in the cv_accuracy vector
    cv_accuracy[i] <- mean(predictions == valid$quality3)
}

# Calculating and displaying the results
# Calculate the mean and standard deviation of the cross-validation accuracy
mean_cv_accuracy <- round(mean(cv_accuracy), 5)
sd_cv_accuracy <- round(sd(cv_accuracy), 5)

# Display the mean and standard deviation of cross-validation accuracy
cat("Mean CV Accuracy:", mean_cv_accuracy, "\n")
cat("SD CV Accuracy: ", sd_cv_accuracy, "\n")

