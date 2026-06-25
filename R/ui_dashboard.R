# ============================================================================
# MAIN DASHBOARD UI MODULE
# ============================================================================

#' Create main dashboard UI
create_main_ui <- function() {
  navbarPage(
    title = "KAW Queue Scheduler",
    theme = shinytheme("flatly"),
    
    # ====================================================================
    # DASHBOARD TAB
    # ====================================================================
    tabPanel(
      "📊 Dashboard",
      
      fluidRow(
        column(
          12,
          h1("Dashboard"),
          textOutput("dashboard_title"),
          hr()
        )
      ),
      
      fluidRow(
        column(
          3,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h4("Active Orders")
            ),
            div(
              class = "panel-body",
              h2(
                textOutput("active_orders_count"),
                style = "color: #3498db; text-align: center;"
              )
            )
          )
        ),
        column(
          3,
          div(
            class = "panel panel-success",
            div(
              class = "panel-heading",
              h4("Completed Orders")
            ),
            div(
              class = "panel-body",
              h2(
                textOutput("completed_orders_count"),
                style = "color: #27ae60; text-align: center;"
              )
            )
          )
        ),
        column(
          3,
          div(
            class = "panel panel-info",
            div(
              class = "panel-heading",
              h4("Scheduling Mode")
            ),
            div(
              class = "panel-body",
              selectInput(
                "scheduling_mode",
                NULL,
                choices = c("Fast", "Moderate", "Minimum Cost"),
                selected = "Moderate"
              )
            )
          )
        ),
        column(
          3,
          div(
            class = "panel panel-warning",
            div(
              class = "panel-heading",
              h4("System Status")
            ),
            div(
              class = "panel-body",
              h2(
                "🟢 Active",
                style = "color: #27ae60; text-align: center; font-size: 16px;"
              )
            )
          )
        )
      ),
      
      hr(),
      
      fluidRow(
        column(
          12,
          h3("Quick Actions"),
          div(
            style = "margin: 20px 0;",
            actionButton("quick_new_order", "➕ New Order", class = "btn btn-primary btn-lg"),
            actionButton("quick_view_production", "👀 View Production", class = "btn btn-info btn-lg"),
            actionButton("quick_timeline", "📈 Timeline", class = "btn btn-success btn-lg"),
            actionButton("quick_settings", "⚙️ Settings", class = "btn btn-warning btn-lg")
          )
        )
      )
    ),
    
    # ====================================================================
    # ORDER ENTRY TAB
    # ====================================================================
    tabPanel(
      "📝 New Order",
      source("R/ui_order_entry.R", local = TRUE)$value
    ),
    
    # ====================================================================
    # ACTIVE PRODUCTION TAB
    # ====================================================================
    tabPanel(
      "🔧 Active Production",
      source("R/ui_active_production.R", local = TRUE)$value
    ),
    
    # ====================================================================
    # PRODUCTION HISTORY TAB
    # ====================================================================
    tabPanel(
      "📋 Production History",
      source("R/ui_production_history.R", local = TRUE)$value
    ),
    
    # ====================================================================
    # MACHINE SCHEDULE TAB
    # ====================================================================
    tabPanel(
      "🏢 Machine Schedule",
      source("R/ui_machine_schedule.R", local = TRUE)$value
    ),
    
    # ====================================================================
    # TIMELINE TRACKING TAB
    # ====================================================================
    tabPanel(
      "📊 Timeline Tracking",
      source("R/ui_timeline_tracking.R", local = TRUE)$value
    ),
    
    # ====================================================================
    # MONTHLY SUMMARY TAB
    # ====================================================================
    tabPanel(
      "📈 Monthly Summary",
      source("R/ui_monthly_summary.R", local = TRUE)$value
    ),
    
    # ====================================================================
    # SETTINGS MENU
    # ====================================================================
    navbarMenu(
      "⚙️ Settings",
      
      tabPanel(
        "Machine Settings",
        source("R/ui_machine_settings.R", local = TRUE)$value
      ),
      
      tabPanel(
        "Shift Settings",
        source("R/ui_shift_settings.R", local = TRUE)$value
      ),
      
      tabPanel(
        "Holiday Settings",
        source("R/ui_holiday_settings.R", local = TRUE)$value
      ),
      
      tabPanel(
        "Breakdown Management",
        source("R/ui_breakdown_management.R", local = TRUE)$value
      ),
      
      tabPanel(
        "Operator Absence",
        source("R/ui_operator_absence.R", local = TRUE)$value
      )
    ),
    
    # ====================================================================
    # LOGOUT BUTTON
    # ====================================================================
    tabPanel(
      actionButton("logout_btn", "🚪 Logout", class = "btn btn-danger")
    )
  )
}
