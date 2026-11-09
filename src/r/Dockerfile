
# Use an official R environment
FROM rocker/r-ver:4.4.3

# Set the working directory
WORKDIR /app

# Copy the package installation script
COPY src/r/install_packages.R /app/install_packages.R

# Run the package installation script
RUN Rscript /app/install_packages.R

# Copy the main R script
COPY src/r/titanic_model.R /app/src/r/titanic_model.R

# Run the Titanic R script
CMD ["Rscript", "/app/src/r/titanic_model.R"]
