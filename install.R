# R Package Installation and Setup Script
# Run this first to install all required packages

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of required packages
required_packages <- c(
  "colorspace",
  "ggplot2", 
  "dplyr",
  "rmarkdown",
  "knitr"
)

# Function to install packages if they don't exist
install_if_missing <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat("Installing package:", pkg, "\n")
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    } else {
      cat("Package", pkg, "is already installed and loaded.\n")
    }
  }
}

# Install and load all required packages
cat("Checking and installing required packages...\n")
install_if_missing(required_packages)

cat("\nAll packages installed successfully!\n")
cat("You can now run your R Markdown document.\n")