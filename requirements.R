# R Package Requirements
# Install all required packages before running the application

# Required packages for KAW Queue Scheduler
required_packages <- list(
  list(
    package = "shiny",
    version = ">= 1.7.0",
    description = "Web application framework"
  ),
  list(
    package = "shinyBS",
    version = ">= 0.61",
    description = "Bootstrap components for Shiny"
  ),
  list(
    package = "shinyalert",
    version = ">= 3.0.0",
    description = "JavaScript alerts and alerts"
  ),
  list(
    package = "tidyverse",
    version = ">= 2.0.0",
    description = "Data manipulation and visualization"
  ),
  list(
    package = "lubridate",
    version = ">= 1.9.0",
    description = "Date and time handling"
  ),
  list(
    package = "DT",
    version = ">= 0.27",
    description = "Data table visualization"
  ),
  list(
    package = "plotly",
    version = ">= 4.10.0",
    description = "Interactive charts and visualizations"
  ),
  list(
    package = "shinythemes",
    version = ">= 1.2.0",
    description = "Shiny UI themes"
  ),
  list(
    package = "digest",
    version = ">= 0.6.31",
    description = "Password hashing and security"
  )
)

# Installation function
install_requirements <- function() {
  cat("Installing required packages...\n\n")
  
  for (pkg in required_packages) {
    cat(sprintf("Installing %s (>= %s)... ", pkg$package, pkg$version))
    
    if (!require(pkg$package, character.only = TRUE)) {
      install.packages(pkg$package)
      if (require(pkg$package, character.only = TRUE)) {
        cat("✓ SUCCESS\n")
      } else {
        cat("✗ FAILED\n")
      }
    } else {
      cat("✓ ALREADY INSTALLED\n")
    }
  }
  
  cat("\n✓ All packages installed successfully!\n")
}

# Check requirements
check_requirements <- function() {
  cat("Checking package requirements...\n\n")
  
  missing_packages <- c()
  
  for (pkg in required_packages) {
    if (!require(pkg$package, character.only = TRUE)) {
      missing_packages <- c(missing_packages, pkg$package)
      cat(sprintf("✗ %s: NOT INSTALLED\n", pkg$package))
    } else {
      cat(sprintf("✓ %s: OK\n", pkg$package))
    }
  }
  
  if (length(missing_packages) > 0) {
    cat(sprintf("\n✗ Missing packages: %s\n", paste(missing_packages, collapse=", ")))
    cat("Run: source('requirements.R'); install_requirements()\n")
    return(FALSE)
  } else {
    cat("\n✓ All requirements met!\n")
    return(TRUE)
  }
}

# Quick install
if (interactive() && !exists("skip_auto_install")) {
  if (!check_requirements()) {
    response <- readline("Install missing packages? (y/n): ")
    if (tolower(response) == "y") {
      install_requirements()
    }
  }
}
