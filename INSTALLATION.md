# ============================================================================
# INSTALLATION AND SETUP GUIDE
# ============================================================================

## System Requirements

### Hardware
- CPU: 2+ cores recommended
- RAM: 4GB minimum, 8GB recommended
- Disk Space: 500MB

### Software
- R: Version 4.0 or higher
- RStudio: Version 2022.12.0 or higher (recommended)
- Windows/Mac/Linux operating system

## Installation Steps

### Step 1: Clone Repository

```bash
cd your_desired_directory
git clone https://github.com/sahilsawant3010-max/KAW.git
cd KAW
git checkout queue-scheduler-app
```

### Step 2: Install R Packages

**Option A: Automatic Installation (Recommended)**

```r
# In R console
source("requirements.R")
install_requirements()
```

**Option B: Manual Installation**

```r
# In R console
install.packages(c(
  "shiny",
  "shinyBS",
  "shinyalert",
  "tidyverse",
  "lubridate",
  "DT",
  "plotly",
  "shinythemes",
  "digest"
))
```

### Step 3: Verify Installation

```r
# In R console
source("requirements.R")
check_requirements()
```

You should see:
```
✓ shiny: OK
✓ shinyBS: OK
✓ shinyalert: OK
✓ tidyverse: OK
✓ lubridate: OK
✓ DT: OK
✓ plotly: OK
✓ shinythemes: OK
✓ digest: OK

✓ All requirements met!
```

### Step 4: Run the Application

**Method 1: Using startup script (Recommended)**

```r
# In R console
source("start_app.R")
```

**Method 2: Direct execution**

```r
# In R console
shiny::runApp("app.R")
```

**Method 3: RStudio**

1. Open `app.R` in RStudio
2. Click "Run App" button
3. Select "Run in Window" or "Run in Viewer"

### Step 5: Access Application

1. Application opens automatically in default browser
2. URL: `http://127.0.0.1:3838` (or shown in console)
3. Default login password: `admin123`

## Configuration

### Change Default Password

Edit `app.R` line ~90:

```r
# BEFORE
admin_password = "admin123"

# AFTER
admin_password = "your_secure_password"
```

### Update Machine Costs

Edit `R/data_config.R` in machine_details sections:

```r
machine_details <- list(
  planning = data.frame(
    id = c("PL-01", "PL-02", "BTMM", "CNC-BDM-01"),
    name = c("PL-01", "PL-02", "BTMM", "CNC BDM-01"),
    cost_per_hour = c(300, 300, 450, 780),  # Update costs here
    stringsAsFactors = FALSE
  ),
  # ...
)
```

### Customize Processing Times

Edit `R/data_config.R`:

```r
planning_time_config <- list(
  "Trash without RIB" = list(
    "24*48" = c(7.75, 7.75, 5.80, 4.75),  # Update times
    # ...
  )
)
```

## Troubleshooting

### Issue: Packages won't install

**Solution:**
1. Update R to latest version
2. Update RStudio
3. Try individual package installation:
   ```r
   install.packages("package_name", dependencies = TRUE)
   ```
4. Check for errors in console

### Issue: Application won't start

**Solution:**
1. Check requirements: `source("requirements.R"); check_requirements()`
2. Clear R environment: `rm(list=ls())`
3. Restart R session
4. Check for typos in file paths

### Issue: Application runs but interface is broken

**Solution:**
1. Clear browser cache
2. Try different browser
3. Check browser console for JavaScript errors
4. Ensure JavaScript is enabled

### Issue: Data not persisting

**Solution:**
Current version stores data in memory only. To add database persistence:

1. Install database packages:
   ```r
   install.packages(c("RSQLite", "DBI"))
   ```

2. Modify `app.R` to use database connections

## Production Deployment

### Shiny Server Deployment

1. Install Shiny Server:
   ```bash
   # On Linux server
   sudo apt-get install gdebi-core
   wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.x.x-amd64.deb
   sudo gdebi shiny-server-1.5.x.x-amd64.deb
   ```

2. Copy application to Shiny directory:
   ```bash
   sudo cp -r KAW /srv/shiny-server/
   ```

3. Configure `shiny-server.conf`

4. Restart Shiny Server:
   ```bash
   sudo systemctl restart shiny-server
   ```

### Docker Deployment

1. Create `Dockerfile`:
   ```dockerfile
   FROM rocker/shiny:latest
   RUN apt-get update && apt-get install -y git
   RUN git clone https://github.com/sahilsawant3010-max/KAW.git /srv/shiny-server/kaw
   WORKDIR /srv/shiny-server/kaw
   RUN Rscript requirements.R
   EXPOSE 3838
   ```

2. Build and run:
   ```bash
   docker build -t kaw-scheduler .
   docker run -p 3838:3838 kaw-scheduler
   ```

## Database Setup (Optional)

To enable data persistence:

1. Install SQLite support:
   ```r
   install.packages(c("RSQLite", "DBI"))
   ```

2. Create database schema (see database documentation)

3. Modify application to use database connections

## Performance Optimization

1. **Reduce data load**: Implement pagination for large datasets
2. **Cache computations**: Use Shiny reactive caching
3. **Optimize database queries**: Add indexes
4. **Compress images**: Reduce asset sizes
5. **Use server-side processing**: For heavy calculations

## Backup and Recovery

### Backup Data

```r
# Add to app.R
observeEvent(input$backup_data, {
  backup_dir <- format(Sys.time(), "backup_%Y%m%d_%H%M%S")
  dir.create(backup_dir)
  
  # Save all reactive data
  saveRDS(shared_state$orders, file.path(backup_dir, "orders.rds"))
  saveRDS(shared_state$machines, file.path(backup_dir, "machines.rds"))
  saveRDS(shared_state$breakdowns, file.path(backup_dir, "breakdowns.rds"))
})
```

### Restore Data

```r
# Add to app.R
observeEvent(input$restore_data, {
  shared_state$orders <- readRDS("backup_[datetime]/orders.rds")
  shared_state$machines <- readRDS("backup_[datetime]/machines.rds")
  shared_state$breakdowns <- readRDS("backup_[datetime]/breakdowns.rds")
})
```

## Support

- **Documentation**: See README.md
- **Issues**: GitHub Issues section
- **Email**: sahilsawant3010@gmail.com

## License

Proprietary - KAW Manufacturing

---

**Last Updated**: June 25, 2026
