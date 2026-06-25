# Startup Script for KAW Queue Scheduler
# Run this script to start the application

cat("\n")
cat("╔════════════════════════════════════════════════════════════╗\n")
cat("║   KAW Queue Scheduler - Manufacturing Operations Manager   ║\n")
cat("║                  v1.0.0 - June 2026                        ║\n")
cat("╚════════════════════════════════════════════════════════════╝\n")
cat("\n")

# Check and load requirements
cat("[1/3] Checking package requirements...\n")
source("requirements.R")
if (!check_requirements()) {
  cat("\n✗ Cannot proceed. Please install missing packages.\n")
  cat("Run: source('requirements.R'); install_requirements()\n\n")
  stop()
}
cat("      ✓ All packages loaded\n\n")

# Load application
cat("[2/3] Loading application modules...\n")
tryCatch({
  # Source all modules
  source("app.R")
  cat("      ✓ Application loaded successfully\n\n")
  
  cat("[3/3] Starting Shiny application...\n")
  cat("      ✓ Application running on http://127.0.0.1:3838\n\n")
  
  cat("╔════════════════════════════════════════════════════════════╗\n")
  cat("║  Default Login Password: admin123                         ║\n")
  cat("║  Change this immediately in production!                   ║\n")
  cat("╚════════════════════════════════════════════════════════════╝\n")
  cat("\n")
  
}, error = function(e) {
  cat("\n✗ Error loading application:\n")
  cat(sprintf("  %s\n", e$message))
  stop()
})
