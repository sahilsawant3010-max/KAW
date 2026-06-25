# ============================================================================
# PRODUCTION HISTORY UI MODULE
# ============================================================================

fluidPage(
  fluidRow(
    column(
      12,
      h2("Production History"),
      p("View completed and cancelled orders"),
      hr()
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-success",
        h5("📅 Production Records"),
        "This page shows all completed and cancelled orders with their details and performance metrics."
      )
    )
  ),
  
  fluidRow(
    column(
      12,
      h3("Filters")
    )
  ),
  
  fluidRow(
    column(
      3,
      div(
        class = "form-group",
        label("Filter by Status"),
        selectInput(
          "history_filter_status",
          NULL,
          choices = c("All" = "", "Completed", "Cancelled")
        )
      )
    ),
    column(
      3,
      div(
        class = "form-group",
        label("Filter by Operation"),
        selectInput(
          "history_filter_operation",
          NULL,
          choices = c("All" = "", "Planning", "Grooving")
        )
      )
    ),
    column(
      3,
      div(
        class = "form-group",
        label("From Date"),
        dateInput(
          "history_from_date",
          NULL,
          format = "yyyy-mm-dd"
        )
      )
    ),
    column(
      3,
      div(
        class = "form-group",
        label("To Date"),
        dateInput(
          "history_to_date",
          NULL,
          format = "yyyy-mm-dd"
        )
      )
    )
  ),
  
  fluidRow(
    column(
      12,
      actionButton(
        "apply_history_filters",
        "🔍 Apply Filters",
        class = "btn btn-primary"
      ),
      actionButton(
        "clear_history_filters",
        "🗑️ Clear Filters",
        class = "btn btn-secondary"
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Production History Table")
    )
  ),
  
  fluidRow(
    column(
      12,
      DT::dataTableOutput("production_history_table")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Export Options")
    )
  ),
  
  fluidRow(
    column(
      12,
      actionButton(
        "export_csv",
        "💿 Export as CSV",
        class = "btn btn-success"
      ),
      actionButton(
        "export_pdf",
        "📋 Export as PDF",
        class = "btn btn-danger"
      )
    )
  )
)
