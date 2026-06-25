# API and Integration Guide

## Overview

This document describes the technical architecture and how to extend the KAW Queue Scheduler.

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│           Shiny Application (UI Layer)              │
│  (Login, Dashboard, Order Entry, etc.)              │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│         Reactive State Management                   │
│  (shared_state reactiveValues)                      │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│      Scheduling Engine (Business Logic)             │
│  - scheduler_engine.R                               │
│  - Load balancing                                   │
│  - Rescheduling logic                               │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│      Data Layer                                     │
│  - data_config.R (Processing times)                │
│  - Machine configurations                           │
│  - Holiday/shift settings                           │
└─────────────────────────────────────────────────────┘
```

## Core Functions

### Scheduling Engine (R/scheduler_engine.R)

#### schedule_order(order, shared_state)
**Purpose**: Schedule a new order through both Planning and Grooving operations

```r
schedule_order <- function(order, shared_state) {
  # 1. Schedule Planning operation
  # 2. Schedule Grooving operation (after Planning completes)
  # 3. Update order with completion dates
}
```

**Parameters**:
- `order`: Data frame with order details
- `shared_state`: Reactive values object containing system state

**Returns**: Updates shared_state$orders with completion dates

#### schedule_operation(order, operation, machines, time_config, shared_state)
**Purpose**: Schedule a single operation (Planning or Grooving)

```r
schedule_operation <- function(order, operation, machines, time_config, 
                               shared_state, earliest_start = NULL) {
  # 1. Get processing times
  # 2. Calculate hours per machine
  # 3. Allocate based on scheduling mode
  # 4. Calculate completion times
}
```

#### allocate_to_machines(order, machines, total_hours_per_machine, mode, shared_state)
**Purpose**: Allocate work based on scheduling mode

```r
allocate_to_machines <- function(order, machines, total_hours_per_machine, 
                                 mode, shared_state) {
  if (mode == "Fast") {
    # Allocate equally to all machines
  } else if (mode == "Minimum Cost") {
    # Allocate inversely to machine cost
  } else {
    # Moderate: balanced allocation
  }
}
```

### Data Configuration (R/data_config.R)

#### Processing Times
```r
planning_time_config <- list(
  "Plate Type" = list(
    "Plate Size" = c(time_m1, time_m2, time_m3, time_m4)
  )
)

grooving_time_config <- list(
  "Plate Type" = list(
    "Plate Size" = c(time_m1, time_m2, time_m3)
  )
)
```

**Format**:
- Index 1-4 for Planning machines (PL-01, PL-02, BTMM, CNC-BDM-01)
- Index 1-3 for Grooving machines (CNC-BDM-02, CNC-BDM-03, GCM)

#### Machine Details
```r
machine_details <- list(
  planning = data.frame(
    id = c("PL-01", ...),
    name = c("PL-01", ...),
    cost_per_hour = c(300, ...)
  ),
  grooving = data.frame(...)
)
```

## Reactive Data Flow

### Shared State Object
```r
shared_state <- reactiveValues(
  user_authenticated = FALSE,
  current_user = NULL,
  machines = list(planning = ..., grooving = ...),
  orders = data.frame(),
  machine_schedules = list(),
  breakdowns = data.frame(),
  operator_absences = data.frame(),
  holidays = as.Date(c()),
  shift_settings = list(),
  scheduling_mode = "Moderate"
)
```

### Data Updates
```
User Input → Reactive Expression → Validation → 
Business Logic → Update shared_state → UI Renders
```

## Adding New Features

### 1. Add New Plate Type

**Step 1**: Update R/data_config.R
```r
planning_time_config <- list(
  "New Plate Type" = list(
    "24*48" = c(7.0, 7.0, 5.0, 4.0),
    "30*60" = c(9.0, 9.0, 7.0, 6.0),
    # ... more sizes
  ),
  # ... existing types
)

plate_types <- c(
  "Trash without RIB",
  "Trash with RIB",
  "Scraper MS",
  "Scraper CS",
  "Scraper CI",
  "New Plate Type"  # Add here
)
```

**Step 2**: Update R/ui_order_entry.R
```r
select(
  "order_plate_type",
  NULL,
  choices = c(
    "",
    "Trash without RIB",
    "Trash with RIB",
    "Scraper MS",
    "Scraper CS",
    "Scraper CI",
    "New Plate Type"  # Add here
  )
)
```

### 2. Add New Machine

**Step 1**: Update R/data_config.R
```r
machine_details <- list(
  planning = data.frame(
    id = c("PL-01", "PL-02", "BTMM", "CNC-BDM-01", "NEW-MACHINE"),
    name = c("PL-01", "PL-02", "BTMM", "CNC BDM-01", "New Machine"),
    cost_per_hour = c(300, 300, 450, 780, 550),
    stringsAsFactors = FALSE
  )
)

planning_time_config <- list(
  "Trash without RIB" = list(
    "24*48" = c(7.75, 7.75, 5.80, 4.75, 6.0),  # Add 5th value
    # ...
  )
)
```

**Step 2**: Update UI files to include new machine in dropdowns

### 3. Add Custom Scheduling Mode

**Step 1**: Add to R/scheduler_engine.R
```r
allocate_to_machines <- function(order, machines, total_hours_per_machine, 
                                 mode, shared_state) {
  if (mode == "Fast") {
    allocations <- rep(mean(total_hours_per_machine), length(machines))
  } else if (mode == "Minimum Cost") {
    # Existing logic
  } else if (mode == "Custom") {
    # Your custom logic here
    allocations <- your_allocation_function(machines, total_hours_per_machine)
  } else {
    # Moderate mode
  }
  return(allocations)
}
```

**Step 2**: Update UI to include new mode
```r
selectInput(
  "scheduling_mode",
  NULL,
  choices = c("Fast", "Moderate", "Minimum Cost", "Custom")
)
```

### 4. Add Database Persistence

**Step 1**: Install database packages
```r
install.packages(c("RSQLite", "DBI"))
```

**Step 2**: Create database connection in app.R
```r
library(DBI)
db <- dbConnect(RSQLite::SQLite(), "database.db")

# Create tables
dbExecute(db, "
  CREATE TABLE IF NOT EXISTS orders (
    order_id TEXT PRIMARY KEY,
    plate_type TEXT,
    plate_size TEXT,
    quantity INTEGER,
    operation TEXT,
    scheduling_mode TEXT,
    status TEXT,
    created_date DATE,
    created_time TIME,
    expected_completion_date DATE,
    expected_completion_time TIME
  )
")
```

**Step 3**: Update save/load functions
```r
# Save order
observeEvent(input$submit_order, {
  # ... existing code ...
  dbWriteTable(db, "orders", new_order, append = TRUE)
})

# Load orders
shared_state$orders <- dbReadTable(db, "orders")
```

## API Endpoints (Future)

When adding REST API support:

```r
# POST /api/orders
# Create new order
POST /api/orders
Body: {
  "plate_type": "Trash without RIB",
  "plate_size": "24*48",
  "quantity": 10,
  "operation": "Planning",
  "scheduling_mode": "Moderate"
}
Response: {
  "order_id": "ORD-20260625123456",
  "status": "scheduled",
  "expected_completion": "2026-06-27T17:00:00Z"
}

# GET /api/orders/{order_id}
# Get order details
GET /api/orders/ORD-20260625123456
Response: {
  "order_id": "ORD-20260625123456",
  "plate_type": "Trash without RIB",
  ...
}

# GET /api/machines
# Get all machines and their status
GET /api/machines
Response: [
  {
    "machine_id": "PL-01",
    "name": "PL-01",
    "status": "active",
    "current_load": 0.75,
    "free_date": "2026-06-27"
  },
  ...
]

# GET /api/timeline
# Get Gantt chart data
GET /api/timeline
Response: [
  {
    "machine": "PL-01",
    "order_id": "ORD-20260625123456",
    "start_date": "2026-06-25T07:30:00Z",
    "end_date": "2026-06-27T17:00:00Z"
  },
  ...
]
```

## Performance Optimization

### Current Bottlenecks
1. Large dataset rendering in DataTables
2. Gantt chart rendering
3. Rescheduling calculations

### Solutions
1. **Implement pagination**
   ```r
   DT::datatable(
     data,
     options = list(
       pageLength = 25,
       server = TRUE,  # Server-side processing
       searching = TRUE
     )
   )
   ```

2. **Cache expensive computations**
   ```r
   machine_loads <- reactive({
     # Heavy computation
   }) %>% 
     debounce(1000)  # Debounce rapid updates
   ```

3. **Lazy load visualizations**
   ```r
   output$gantt_chart <- renderPlotly({
     req(input$show_gantt)  # Only render when needed
     create_gantt_chart(...)
   })
   ```

## Testing

### Unit Tests
```r
# tests/test_scheduler.R
library(testthat)

test_that("allocation_fast_mode_works", {
  result <- allocate_to_machines(
    order = test_order,
    machines = test_machines,
    total_hours_per_machine = c(10, 10, 10, 10),
    mode = "Fast",
    shared_state = test_state
  )
  expect_equal(length(result), 4)
  expect_true(all(result > 0))
})
```

### Integration Tests
```r
test_that("end_to_end_order_scheduling", {
  # Create order
  # Schedule order
  # Verify Planning scheduled
  # Verify Grooving scheduled
  # Check completion dates
})
```

## Debugging

### Enable Debug Mode
```r
# In app.R
options(shiny.error = browser)  # Open debugger on error
options(shiny.trace = TRUE)      # Print reactive updates
```

### Logger Function
```r
log_event <- function(event, details) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  message(sprintf("[%s] %s: %s", timestamp, event, details))
}

# Usage
log_event("ORDER_CREATED", paste("Order", new_order$order_id))
```

## Version Control

### Branch Strategy
- `main`: Production-ready code
- `queue-scheduler-app`: Development branch
- `feature/*`: Feature branches

### Commit Messages
```
[FEATURE] Add new plate type support
[BUGFIX] Fix machine load calculation
[DOCS] Update API documentation
[REFACTOR] Reorganize scheduling logic
```

## Documentation Standards

### Function Documentation
```r
#' Schedule a new order
#'
#' @description
#' Creates a new order and schedules it through Planning and Grooving operations
#' with automatic load balancing based on selected scheduling mode.
#'
#' @param order Data frame containing order details
#' @param shared_state Reactive values object with application state
#'
#' @return Updates shared_state$orders with new scheduled order
#'
#' @examples
#' \dontrun{
#'   new_order <- data.frame(
#'     order_id = "ORD-001",
#'     plate_type = "Trash without RIB",
#'     plate_size = "24*48",
#'     quantity = 10,
#'     operation = "Planning",
#'     scheduling_mode = "Moderate"
#'   )
#'   schedule_order(new_order, shared_state)
#' }
schedule_order <- function(order, shared_state) {
  # Implementation
}
```

---

**Last Updated**: June 25, 2026
