# ============================================================================
# MONTHLY SUMMARY UI MODULE
# ============================================================================

#' Create monthly summary UI
create_monthly_summary_ui <- function(orders, machines) {
  fluidPage(
    fluidRow(
      column(
        12,
        h2("Monthly Summary"),
        p("Production metrics and machine utilization analysis"),
        hr()
      )
    ),
    
    fluidRow(
      column(
        12,
        div(
          class = "form-group",
          label("Select Month"),
          dateInput(
            "summary_month",
            NULL,
            format = "yyyy-mm-dd"
          )
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Overall Production Metrics")
      )
    ),
    
    fluidRow(
      column(
        3,
        div(
          class = "panel panel-primary",
          div(
            class = "panel-heading",
            "Total Plates Processed"
          ),
          div(
            class = "panel-body",
            h2(
              textOutput("summary_total_plates"),
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
            "Total Production Hours"
          ),
          div(
            class = "panel-body",
            h2(
              textOutput("summary_production_hours"),
              style = "color: #27ae60; text-align: center;"
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
            "Downtime Hours"
          ),
          div(
            class = "panel-body",
            h2(
              textOutput("summary_downtime_hours"),
              style = "color: #f39c12; text-align: center;"
            )
          )
        )
      ),
      column(
        3,
        div(
          class = "panel panel-danger",
          div(
            class = "panel-heading",
            "Breakdown Hours"
          ),
          div(
            class = "panel-body",
            h2(
              textOutput("summary_breakdown_hours"),
              style = "color: #e74c3c; text-align: center;"
            )
          )
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Machine-wise Summary")
      )
    ),
    
    fluidRow(
      column(
        12,
        DT::dataTableOutput("summary_machine_table")
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Plate Type Analysis")
      )
    ),
    
    fluidRow(
      column(
        6,
        plotly::plotlyOutput("summary_plate_type_chart")
      ),
      column(
        6,
        plotly::plotlyOutput("summary_plate_size_chart")
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Machine Utilization")
      )
    ),
    
    fluidRow(
      column(
        12,
        plotly::plotlyOutput("summary_utilization_chart")
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Export Monthly Report")
      )
    ),
    
    fluidRow(
      column(
        12,
        actionButton(
          "export_monthly_csv",
          "💿 Export as CSV",
          class = "btn btn-success"
        ),
        actionButton(
          "export_monthly_pdf",
          "📋 Export as PDF",
          class = "btn btn-danger"
        )
      )
    )
  )
}
