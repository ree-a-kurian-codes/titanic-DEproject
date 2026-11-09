# Titanic Survival Prediction

## Project Overview

This repository analyzes passenger data from the Titanic disaster and predicts whether passengers survived using logistic regression models implemented in Python and R.

Both models run in Docker containers this means the users do not need to install Python, R, or their packages separately.

The project demonstrates:
- Loading and exploring the Titanic dataset
- Cleaning missing values and preparing features
- Training logistic regression models
- Measuring training and held-out validation accuracy
- Predicting survival for the Kaggle test dataset
- Running the complete workflow through the terminal using Docker

## 1. Prerequisites

Before starting, install:

1. **Git** — https://git-scm.com/downloads
2. **Docker Desktop** — https://www.docker.com/products/docker-desktop/
3. A Kaggle account — https://www.kaggle.com/

Make sure Docker Desktop is open and running before building the containers. You do **not** need to install Python or R locally.

## 2. Clone the Repository

Open Terminal and run:

git clone git clone https://github.com/ree-a-kurian-codes/titanic-DEproject.git
cd titanic-DEproject

**Important:** 
Please replace `YOUR-USERNAME` with the GitHub username of the repository owner. All Docker commands below must be run from the repository's root folder (`titanic-DEproject`).

## 3. Download the Titanic Dataset

The dataset is intentionally **not included in this repository** (as required by the assignment).

To get the dataset:
1. Open the Kaggle Titanic competition: https://www.kaggle.com/competitions/titanic/data
2. Sign in to Kaggle.
3. Join or accept the competition rules if Kaggle asks you to.
4. Download the data.
5. Unzip the downloaded file if necessary.
6. Find these two files:
   - `train.csv`
   - `test.csv`
7. Place both files inside the project's `src/data/` folder.


**Do not rename the CSV files.** Both scripts run by expecting these exact filenames.

### Verify the dataset files

From the repository root, run:
```bash
ls src/data
```

You should see `train.csv` and `test.csv`. (The Kaggle training dataset includes the `Survived` column. The Kaggle test dataset does not include survival labels.)

## 4. Run the Python Model Using Docker

### Step 1: Build the Python Docker image

From the repository root, run:
```bash
docker build -f src/python/Dockerfile -t titanic-python .
```

This command builds a Docker image using the Python Dockerfile and installs the required Python packages from `requirements.txt`.

The Python environment uses:
- Python 3.15
- NumPy 2.5.4
- pandas 3.1.1
- scikit-learn 1.9.1

The first build may take several minutes. So wait patiently as it is finsihing up.

### Step 2: Create an output folder

We will call this folder predictions.
```bash
mkdir -p predictions
```

### Step 3: Run the Python Docker container

```bash
docker run --rm \
  -v "$(pwd)/src/data:/app/src/data:ro" \
  -v "$(pwd)/predictions:/app/predictions" \
  titanic-python
```

The first volume makes the locally downloaded dataset available inside the container as read-only data. The second volume allows predictions to be saved on your computer.

### Step 4: Review the terminal output

The Python script displays:
- Dataset information and missing values
- Data cleaning and feature preparation
- Logistic regression training
- Training accuracy
- Predictions for the Kaggle test passengers
- Held-out validation accuracy

Expected model results:

Training accuracy | 79.57%
Held-out validation accuracy | 80.45% 
Kaggle test passengers predicted | 418 

The output file is:
predictions/titanic_predictions.csv

## 5. Run the R Model Using Docker

### Step 1: Build the R Docker image

From the repository root, run:
```bash
docker build -f src/r/Dockerfile -t titanic-r .
```

The R Dockerfile uses R 4.4.3.

The model uses built-in R functionality, including `read.csv()`, `glm()`, and `predict()`. No additional R packages are required.

### Step 2: Create an output folder

If you already created this folder for Python, you can skip this step.
```bash
mkdir -p predictions
```

### Step 3: Run the R Docker container

```bash
docker run --rm \
  -v "$(pwd)/src/data:/app/src/data:ro" \
  -v "$(pwd)/predictions:/app/predictions" \
  titanic-r
```

### Step 4: Review the terminal output

The R script displays:
- Training and test dataset information
- Missing-value handling
- Feature preparation
- Logistic regression training
- Training accuracy
- Predictions for the Kaggle test passengers
- Held-out validation accuracy

Expected model results:

Training accuracy | 79.46% 
Held-out validation accuracy | 74.86% 
Kaggle test passengers predicted | 418

The output file is:
predictions/titanic_r_predictions.csv

## 6. Features Used by the Models

Both models use the following passenger characteristics:

| Feature | Description |
| `Pclass` | Passenger ticket class |
| `Sex` | Passenger sex |
| `Age` | Passenger age |
| `SibSp` | Number of siblings/spouses aboard |
| `Parch` | Number of parents/children aboard |
| `Fare` | Ticket fare |

Missing numeric values are filled using median values, and sex is converted into a numeric feature.

Both models use logistic regression to estimate passenger survival.

## 7. Understanding Model Accuracy

**Training accuracy** measures how often the model correctly predicts survival for the labeled training data used to fit the model.

**Held-out validation accuracy** evaluates predictions on a portion of the labeled training dataset reserved for testing.

The Kaggle `test.csv` file does **not** contain the actual `Survived` values. Therefore, its accuracy cannot be calculated directly from that file.

Instead, both scripts:
1. Evaluate model accuracy using labeled training data.
2. Generate survival predictions for all 418 Kaggle test passengers.

The Python and R implementations use their own validation procedures, so their validation scores should not be treated as a controlled, identical-split comparison.

## 8. Find the Prediction Files

After running both containers, your local `predictions/` folder should contain:

```text
predictions/
├── titanic_predictions.csv
└── titanic_r_predictions.csv
```

Each file contains survival predictions for the Kaggle test passengers.

You can inspect the files in VS Code or open them using spreadsheet software.

## 9. Troubleshooting

### Docker is not running

If Docker reports that it cannot connect to the Docker daemon, open Docker Desktop and wait until it finishes starting. Then rerun the command.

### Dataset file not found

Make sure `train.csv` and `test.csv` are inside: src/data/

Do not put them inside `src/python/` or `src/r/`.

### Docker build fails

Check that you are running the build command from the repository root and that Docker Desktop is running.

### Prediction files are not visible

Make sure you created the `predictions` folder and included the output volume mount in the `docker run` command.

### Running on Windows

The commands in this README use a Bash-compatible terminal (macOS, Linux, or Git Bash on Windows). The `$(pwd)` syntax may need to be adjusted when using PowerShell or Command Prompt.

## 10. Repository and Data Policy

The repository contains the code, Dockerfiles, package requirements, and documentation necessary to reproduce the project.

The following are intentionally excluded from Git:
- Titanic CSV datasets
- Generated prediction files
- Local Python virtual environments
- Operating-system-specific temporary files

Users must download the Kaggle dataset themselves.

## 11. Quick Start

After installing Git and Docker Desktop, clone the repository and download `train.csv` and `test.csv` into `src/data/`.

Then run these commands from the repository root:

**Python:**

```bash
docker build -f src/python/Dockerfile -t titanic-python .
mkdir -p predictions
docker run --rm -v "$(pwd)/src/data:/app/src/data:ro" -v "$(pwd)/predictions:/app/predictions" titanic-python
```

**R:**

```bash
docker build -f src/r/Dockerfile -t titanic-r .
mkdir -p predictions
docker run --rm -v "$(pwd)/src/data:/app/src/data:ro" -v "$(pwd)/predictions:/app/predictions" titanic-r
```

Both models print their processing steps and results in the terminal and save their Kaggle test predictions locally.