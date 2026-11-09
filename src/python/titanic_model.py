
# Titanic Survival Prediction Project

import pandas as pd
import numpy as np
from pathlib import Path
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split

def main():
    print("=== Titanic Survival Prediction Project ===")

    # Find train.csv relative to this Python script
    data_path = Path(__file__).resolve().parent.parent / "data" / "train.csv"

    # Load the training dataset
    train_data = pd.read_csv(data_path)

    print("\nTraining dataset loaded successfully!")

    # Display the size of the dataset
    print("\nDataset shape (rows, columns):")
    print(train_data.shape)

    # Display the first five passengers
    print("\nFirst five rows:")
    print(train_data.head())

    # Display the column names
    print("\nDataset columns:")
    print(train_data.columns.tolist())


    # Question 14: Explore and prepare the dataset

    print("\n=== Question 14: Data Exploration ===")

    # Check for missing values
    print("\nMissing values in each column:")
    print(train_data.isnull().sum())

    # Examine survival counts
    print("\nSurvival counts:")
    print(train_data["Survived"].value_counts())

    # Select useful features
    features = ["Pclass", "Sex", "Age", "SibSp", "Parch", "Fare"]
    X = train_data[features].copy()

    print("\nSelected features:")
    print(features)

    print("\nFeature explanations:")
    print("Pclass: Passenger ticket class")
    print("Sex: Passenger sex")
    print("Age: Passenger age")
    print("SibSp: Number of siblings/spouses aboard")
    print("Parch: Number of parents/children aboard")
    print("Fare: Passenger ticket fare")


    
    # Fill missing numerical values with the median
    age_median = X["Age"].median()
    fare_median = X["Fare"].median()

    print("\n=== Data Cleaning Changes ===")
    print(f"Replacing missing Age values with median: {age_median:.2f}")
    print(f"Replacing missing Fare values with median: {fare_median:.2f}")

    X["Age"] = X["Age"].fillna(age_median)
    X["Fare"] = X["Fare"].fillna(fare_median)

    # Convert passenger sex to numerical values
    print("\nConverting Sex column into numerical values:")
    print("male = 0")
    print("female = 1")

    X["Sex"] = X["Sex"].map({"male": 0, "female": 1})


    

    print("\nMissing values after preprocessing:")
    print(X.isnull().sum())

    print("\nFirst five rows after preprocessing:")
    print(X.head())


    # Question 15: Build a logistic regression model

    print("\n=== Question 15: Logistic Regression Model ===")

    # Select the target variable (the correct survival answers)
    y = train_data["Survived"]

    print("\nTarget variable:")
    print("Survived (0 = Did not survive, 1 = Survived)")

    # Create the logistic regression model
    model = LogisticRegression(max_iter=1000)

    # Train the model using passenger features and survival outcomes
    model.fit(X, y)

    print("\nLogistic regression model trained successfully!")

    # Generate predictions for the training dataset
    train_predictions = model.predict(X)

    print("\nFirst 10 survival predictions:")
    print(train_predictions[:10])


    # Question 16: Measure training accuracy

    print("\n=== Question 16: Training Accuracy ===")

    # Compare predictions with actual survival outcomes
    train_accuracy = accuracy_score(y, train_predictions)

    # Display accuracy as a percentage
    print(f"\nTraining accuracy: {train_accuracy * 100:.2f}%")

    # Count the number of correct predictions
    correct_predictions = (y == train_predictions).sum()

    print(f"Correct predictions: {correct_predictions}")
    print(f"Total passengers: {len(y)}")


    # Question 17: Load test.csv and predict survival

    print("\n=== Question 17: Test Dataset Predictions ===")

    # Locate and load the test dataset
    test_path = Path(__file__).resolve().parent.parent / "data" / "test.csv"
    test_data = pd.read_csv(test_path)

    print("\nTest dataset loaded successfully!")
    print(f"Test dataset shape: {test_data.shape}")

    # Select the same features used for training
    X_test = test_data[features].copy()

    # Fill missing numerical values using training medians
    X_test["Age"] = X_test["Age"].fillna(train_data["Age"].median())
    X_test["Fare"] = X_test["Fare"].fillna(train_data["Fare"].median())

    # Convert passenger sex into numbers
    X_test["Sex"] = X_test["Sex"].map({"male": 0, "female": 1})

    print("\nMissing values after test preprocessing:")
    print(X_test.isnull().sum())

    # Predict survival using the trained model
    test_predictions = model.predict(X_test)

    print("\nFirst 10 test survival predictions:")
    print(test_predictions[:10])

    # Save predictions to a CSV file
    predictions_folder = Path(__file__).resolve().parent.parent.parent / "predictions"
    predictions_folder.mkdir(exist_ok=True)

    submission = pd.DataFrame({
        "PassengerId": test_data["PassengerId"],
        "Survived": test_predictions
    })

    output_path = predictions_folder / "titanic_predictions.csv"
    submission.to_csv(output_path, index=False)

    print(f"\nPredictions saved to: {output_path}")
    print(f"Total test predictions: {len(test_predictions)}")

    # Question 17: Load test.csv and predict survival

    print("\n=== Question 17: Test Dataset Predictions ===")

    # Locate and load the test dataset
    test_path = Path(__file__).resolve().parent.parent / "data" / "test.csv"
    test_data = pd.read_csv(test_path)

    print("\nTest dataset loaded successfully!")
    print(f"Test dataset shape: {test_data.shape}")

    # Select the same features used for training
    X_test = test_data[features].copy()

    # Fill missing numerical values using training medians
    X_test["Age"] = X_test["Age"].fillna(train_data["Age"].median())
    X_test["Fare"] = X_test["Fare"].fillna(train_data["Fare"].median())

    # Convert passenger sex into numbers
    X_test["Sex"] = X_test["Sex"].map({"male": 0, "female": 1})

    print("\nMissing values after test preprocessing:")
    print(X_test.isnull().sum())

    # Predict survival using the trained model
    test_predictions = model.predict(X_test)

    print("\nFirst 10 test survival predictions:")
    print(test_predictions[:10])

    # Save predictions to a CSV file
    predictions_folder = Path(__file__).resolve().parent.parent.parent / "predictions"
    predictions_folder.mkdir(exist_ok=True)

    submission = pd.DataFrame({
        "PassengerId": test_data["PassengerId"],
        "Survived": test_predictions
    })

    output_path = predictions_folder / "titanic_predictions.csv"
    submission.to_csv(output_path, index=False)

    print(f"\nPredictions saved to: {output_path}")
    print(f"Total test predictions: {len(test_predictions)}")


    # Question 18: Evaluate accuracy on held-out data

    print("\n=== Question 18: Test Accuracy ===")

    # Split the labeled data into training and testing portions
    X_train, X_holdout, y_train, y_holdout = train_test_split(
        X,
        y,
        test_size=0.20,
        random_state=42,
        stratify=y
    )

    print(f"\nTraining passengers: {len(X_train)}")
    print(f"Held-out test passengers: {len(X_holdout)}")

    # Create a separate model for evaluation
    evaluation_model = LogisticRegression(max_iter=1000)

    # Train only on the training portion
    evaluation_model.fit(X_train, y_train)

    # Predict on passengers not used to train this model
    holdout_predictions = evaluation_model.predict(X_holdout)

    # Calculate accuracy
    holdout_accuracy = accuracy_score(
        y_holdout,
        holdout_predictions
    )

    print(f"\nHeld-out test accuracy: {holdout_accuracy * 100:.2f}%")

    correct_holdout = (y_holdout == holdout_predictions).sum()

    print(f"Correct held-out predictions: {correct_holdout}")
    print(f"Total held-out passengers: {len(y_holdout)}")

    print("\nNote: Kaggle test.csv has no Survived column.")
    print("Accuracy is measured on a held-out portion of train.csv.")


    # Question 19: Final terminal summary

    print("\n" + "=" * 50)
    print("TITANIC SURVIVAL PREDICTION - FINAL SUMMARY")
    print("=" * 50)

    print(f"Training dataset passengers: {len(train_data)}")
    print(f"Kaggle test dataset passengers: {len(test_data)}")
    print(f"Features used: {', '.join(features)}")
    print("Model: Logistic Regression")

    print(f"\nTraining accuracy: {train_accuracy * 100:.2f}%")
    print(f"Held-out test accuracy: {holdout_accuracy * 100:.2f}%")

    print(f"\nKaggle test predictions generated: {len(test_predictions)}")
    print(f"Predictions file: {output_path}")

    print("\nModel execution completed successfully!")
    print("=" * 50)







if __name__ == "__main__":
    main()
