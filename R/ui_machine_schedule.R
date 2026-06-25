# ============================================================================
# MACHINE SCHEDULE UI MODULE
# ============================================================================

#' Create machine schedule UI
create_machine_schedule_ui <- function(machines, orders) {
  fluidPage(
    fluidRow(
      column(
        12,
        h2("Machine Schedule"),
        p("View detailed schedule and load for each machine"),
        hr()
      )
    ),
    
    fluidRow(
      column(
        12,
        div(
          class = "form-group",
          label("Select Machine"),
          selectInput(
            "schedule_machine_select",
            NULL,
            choices = c(
              "All",
              "PL-01", "PL-02", "BTMM", "CNC-BDM-01",
              "CNC-BDM-02", "CNC-BDM-03", "GCM"
            )
          )
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        h3("Machine Details")
      )
    ),
    
    fluidRow(
      column(
        3,
        div(
          class = "panel panel-primary",
          div(
            class = "panel-heading",
            "Machine Name"
          ),
          div(
            class = "panel-body",
            h4(textOutput("schedule_machine_name"))
          )
        )
      ),
      column(
        3,
        div(
          class = "panel panel-info",
          div(
            class = "panel-heading",
            "Plates Assigned"
          ),
          div(
            class = "panel-body",
            h4(textOutput("schedule_plates_count"))
          )
        )
      ),
      column(
        3,
        div(
          class = "panel panel-warning",
          div(
            class = "panel-heading",
            "Machine Free Date"
          ),
          div(
            class = "panel-body",
            h4(textOutput("schedule_free_date"))
          )
        )
      ),
      column(
        3,
        div(
          class = "panel panel-success",
          div(
            class = "panel-heading",
            "Machine Utilization"
          ),
          div(
            class = "panel-body",
            h4(textOutput("schedule_utilization"))
          )
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Scheduled Orders")
      )
    ),
    
    fluidRow(
      column(
        12,
        DT::dataTableOutput("schedule_orders_table")
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Plate Type Distribution")
      )
    ),
    
    fluidRow(
      column(
        12,
        plotly::plotlyOutput("schedule_plate_distribution")
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Schedule Timeline")
      )
    ),
    
    fluidRow(
      column(
        12,
        div(
          class = "alert alert-info",
          h5("📊 Timeline View"),
          "Shows when each order starts and completes on the selected machine"
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        plotly::plotlyOutput("schedule_timeline")
      )
    )
  )
}
