# KAW Queue Scheduler Application
## Manufacturing Operations Queue Management System

### Overview

The KAW Queue Scheduler is a comprehensive R Shiny application designed for managing manufacturing operations with multi-order queue scheduling and dynamic machine allocation. The system is built for industrial plate manufacturing operations with two main processes:

1. **Planning Operation** - 4 machines (PL-01, PL-02, BTMM, CNC-BDM-01)
2. **Grooving Operation** - 3 machines (CNC-BDM-02, CNC-BDM-03, GCM)

### Key Features

#### 1. **Intelligent Scheduling Engine**
- **Three Scheduling Modes**:
  - **Fast Mode**: Minimize order completion time
  - **Moderate Mode**: Balance cost and completion time (Recommended)
  - **Minimum Cost Mode**: Minimize total machining cost
- **Automatic Order Processing**: Orders flow through Planning → Grooving operations sequentially
- **Load Balancing**: Intelligent distribution of work across machines
- **Real-time Rescheduling**: Automatic adjustment when machines break down or operators are absent

#### 2. **Machine Management**
- **7 Machines** with individual configurations:
  - Machine name and cost per hour (₹/hour)
  - Shift type (8-hour or 12-hour)
  - Active shifts configuration
  - Real-time load monitoring
  - Breakdown tracking

#### 3. **Shift Management**
- **8-Hour Shift Configuration**:
  - Shift 1: 07:30 AM - 04:30 PM
  - Shift 2: 04:30 PM - 11:30 PM
  - Shift 3: 11:30 PM - 07:30 AM
- **12-Hour Shift Configuration**:
  - Shift 1: 07:30 AM - 07:30 PM
  - Shift 2: 07:30 PM - 07:30 AM
- **Break Time**: 30-minute lunch break (automatically deducted)
- **Weekly Off**: Monday (fixed)
- **Holiday Management**: Configurable holidays

#### 4. **Plate Processing**
- **5 Plate Types**:
  1. Trash Without RIB
  2. Trash With RIB
  3. Scraper MS
  4. Scraper CS
  5. Scraper CI

- **9 Plate Sizes**: 24x48, 30x60, 30x66, 36x72, 36x78, 40x80, 42x84, 45x90, 50x100
- **Machine-specific Processing Times**: Varies by plate type, size, and machine

#### 5. **Breakdown Management**
- Record machine breakdowns with start and end dates
- Automatic rescheduling of pending jobs
- "Machine Active Again" button for early repairs
- Automatic return to scheduling after breakdown end date
- Breakdown impact limited to specified duration

#### 6. **Operator Absence Management**
- Record operator absences by:
  - Machine name
  - Specific date
  - Affected shift number
- Automatic rescheduling of affected shift orders
- Limited impact to specified shift and date

#### 7. **Production Tracking**
- **Active Production List**: Real-time view of current orders
- **Complete Production History**: Archive of completed and cancelled orders
- **Order Cancellation**: Cancel any order with automatic rescheduling
- **Expected Completion Times**: Calculated for each order

#### 8. **Machine Schedule Visualization**
- Machine-wise schedule view showing:
  - Number of plates assigned
  - Plate types
  - Start date and time
  - End date and time
  - Machine free date and time
  - Utilization percentage

#### 9. **Analytics & Reporting**
- **Monthly Summary**:
  - Total plates processed
  - Plate type-wise quantity
  - Machine utilization percentage
  - Production hours
  - Downtime hours
  - Breakdown hours

- **Live Timeline Tracking**: Gantt chart visualization of all machines
- **Export Capabilities**: CSV and PDF exports

#### 10. **Security**
- Password-protected login page
- Administrator authentication
- Secure session management

### User Interface

The application provides 12 distinct pages:

1. **Login Page**: Secure authentication
2. **Dashboard**: Quick overview and statistics
3. **New Order**: Order entry and scheduling
4. **Active Production**: Real-time production monitoring
5. **Production History**: Completed orders archive
6. **Machine Schedule**: Detailed machine schedules
7. **Timeline Tracking**: Gantt chart visualization
8. **Monthly Summary**: Production analytics
9. **Machine Settings**: Configure machine parameters
10. **Shift Settings**: Configure shift timings
11. **Holiday Settings**: Manage holidays
12. **Breakdown Management**: Record machine breakdowns
13. **Operator Absence**: Record operator absences

### Machine Costs (₹/Hour)

**Planning Machines**:
- PL-01: ₹300/hr
- PL-02: ₹300/hr
- BTMM: ₹450/hr
- CNC BDM-01: ₹780/hr

**Grooving Machines**:
- CNC BDM-02: ₹780/hr
- CNC BDM-03: ₹780/hr
- GCM: ₹450/hr

### System Architecture

```
app.R (Main Application)
├── R/
│   ├── utils.R (Utility Functions)
│   ├── data_config.R (Processing Times & Configurations)
│   ├── scheduler_engine.R (Scheduling Logic)
│   ├── ui_login.R (Login Interface)
│   ├── ui_dashboard.R (Main Dashboard)
│   ├── ui_order_entry.R (Order Entry Form)
│   ├── ui_machine_settings.R (Machine Configuration)
│   ├── ui_shift_settings.R (Shift Configuration)
│   ├── ui_holiday_settings.R (Holiday Management)
│   ├── ui_breakdown_management.R (Breakdown Tracking)
│   ├── ui_operator_absence.R (Absence Management)
│   ├── ui_active_production.R (Active Orders View)
│   ├── ui_production_history.R (Order History)
│   ├── ui_machine_schedule.R (Machine Schedules)
│   ├── ui_monthly_summary.R (Analytics)
│   └── ui_timeline_tracking.R (Gantt Charts)
```

### Installation & Setup

#### Prerequisites
```r
# Required R packages
required_packages <- c(
  "shiny",
  "shinyBS",
  "shinyalert",
  "tidyverse",
  "lubridate",
  "DT",
  "plotly",
  "shinythemes",
  "digest"
)
```

#### Installation

1. **Clone the Repository**
```bash
git clone https://github.com/sahilsawant3010-max/KAW.git
cd KAW
git checkout queue-scheduler-app
```

2. **Install Required Packages**
```r
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  shiny, shinyBS, shinyalert, tidyverse, lubridate,
  DT, plotly, shinythemes, digest
)
```

3. **Run the Application**
```r
shiny::runApp("app.R")
```

### Usage Guide

#### 1. **Login**
- Default password: `admin123`
- Change this in production!

#### 2. **Create a New Order**
1. Navigate to "New Order" tab
2. Select plate type, size, and quantity
3. Choose scheduling mode (Moderate recommended)
4. Click "Submit Order"
5. Order automatically scheduled for Planning → Grooving

#### 3. **Monitor Production**
1. Go to "Active Production" to see current orders
2. Use "Machine Schedule" to view machine-specific loads
3. Check "Timeline Tracking" for Gantt chart view

#### 4. **Handle Machine Issues**
- **Breakdown**: Go to Settings → Breakdown Management
- **Operator Absence**: Go to Settings → Operator Absence
- System automatically reschedules affected orders

#### 5. **View Analytics**
- Monthly Summary: Production metrics and machine utilization
- Production History: Completed/cancelled orders
- Export reports as CSV or PDF

### Order Allocation Rules

1. **Every new order is distributed among all active machines**
2. **No machine is overloaded** - balanced distribution
3. **Machine loading is balanced** - prevents idle time
4. **All machines finish nearly together** - synchronized completion
5. **Load balancing prevents excessive idle time** - redistributes work as machines complete tasks

### Scheduling Modes Explained

#### Fast Mode
- ✓ Complete orders as early as possible
- ✓ Use all active machines
- ✓ Minimize completion time
- ✗ May increase costs

#### Moderate Mode (Recommended)
- ✓ Balance cost and completion time
- ✓ Use all active machines
- ✓ Most machines finish on same day
- ✓ Good cost efficiency

#### Minimum Cost Mode
- ✓ Minimize total machining cost
- ✓ Use all active machines
- ✓ Machines finish nearly same day
- ✗ May increase completion time slightly

### Dynamic Rescheduling Triggers

Automatic rescheduling occurs when:
1. Machine breaks down
2. Operator is absent
3. Shift is disabled
4. Machine becomes active again after breakdown
5. Order is cancelled

### Key Processing Times (Example)

**Planning Operation - Trash without RIB (24x48 size)**
- PL-01: 7.75 hours per plate
- PL-02: 7.75 hours per plate
- BTMM: 5.80 hours per plate
- CNC-BDM-01: 4.75 hours per plate

**Grooving Operation - Trash without RIB (24x48 size)**
- CNC-BDM-02: 2.875 hours per plate
- CNC-BDM-03: 2.875 hours per plate
- GCM: 6.125 hours per plate

### Best Practices

1. **Use Moderate Mode** for most scenarios - balances cost and speed
2. **Monitor Machine Load** regularly through Machine Schedule
3. **Configure Holidays** at beginning of month
4. **Record Breakdowns Immediately** for accurate rescheduling
5. **Export Reports** for compliance and analysis
6. **Review Monthly Summary** for optimization opportunities

### Troubleshooting

#### Orders not scheduling?
- Check if machines are configured correctly in Machine Settings
- Verify shift settings are active
- Ensure plate type and size are in the database

#### Machine showing as overloaded?
- Check for breakdowns or absences
- Try "Moderate" or "Minimum Cost" scheduling mode
- Cancel lower-priority orders if needed

#### Timeline not updating?
- Click "Refresh Timeline" button
- Check browser console for errors
- Ensure browser JavaScript is enabled

### Database Schema

#### Orders Table
- order_id
- plate_type
- plate_size
- quantity
- operation
- scheduling_mode
- status (Active/Completed/Cancelled)
- created_date, created_time
- expected_completion_date, expected_completion_time
- actual_completion_date, actual_completion_time

#### Breakdowns Table
- machine_id
- start_date
- end_date
- status
- description

#### Operator Absences Table
- machine_id
- date
- shift
- reason

### Future Enhancements

- [ ] Multi-user support with role-based access
- [ ] Database persistence (SQLite/PostgreSQL)
- [ ] Mobile app interface
- [ ] Integration with ERP systems
- [ ] Predictive maintenance
- [ ] Cost optimization algorithms
- [ ] Email/SMS notifications
- [ ] Advanced reporting with custom filters
- [ ] Machine performance analytics
- [ ] Order priority system

### Support & Contact

For issues or feature requests, please contact:
- Email: sahilsawant3010@gmail.com
- GitHub Issues: [KAW Repository Issues](https://github.com/sahilsawant3010-max/KAW/issues)

### License

This project is proprietary software for KAW manufacturing operations.

### Version

v1.0.0 - Initial Release (June 2026)

---

**Last Updated**: June 25, 2026
