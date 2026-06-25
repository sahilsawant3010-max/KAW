# ============================================================================
# BREAKDOWN MANAGEMENT UI MODULE
# ============================================================================

fluidPage(
  fluidRow(
    column(
      12,
      h2("Machine Breakdown Management"),
      p("Record machine breakdowns and track repair status"),
      hr()
    )
  ),
  
  fluidRow(
    column(
      6,
      div(
        class = "panel panel-danger",
        div(
          class = "panel-heading",
          h4("Record Machine Breakdown")
        ),
        div(
          class = "panel-body",
          
          div(
            class = "form-group",
            label("Machine Name"),
            selectInput(
              "breakdown_machine",
              NULL,
              choices = c("", "PL-01", "PL-02", "BTMM", "CNC-BDM-01", "CNC-BDM-02", "CNC-BDM-03", "GCM")
            )
          ),
          
          div(
            class = "form-group",
            label("Breakdown Start Date"),
            dateInput(
              "breakdown_start_date",
              NULL,
              format = "yyyy-mm-dd"
            )
          ),
          
          div(
            class = "form-group",
            label("Expected Repair Completion Date"),
            dateInput(
              "breakdown_end_date",
              NULL,
              format = "yyyy-mm-dd"
            )
          ),
          
          div(
            class = "form-group",
            label("Breakdown Description"),
            textAreaInput(
              "breakdown_description",
              NULL,
              rows = 3,
              placeholder = "e.g., Motor bearing failure"
            )
          ),
          
          actionButton(
            "add_breakdown",
            "⚠️ Record Breakdown",
            class = "btn btn-danger btn-lg"
          )
        )
      )
    ),
    
    column(
      6,
      div(
        class = "panel panel-warning",
        div(
          class = "panel-heading",
          h4("Active Breakdowns")
        ),
        div(
          class = "panel-body",
          uiOutput("active_breakdowns_list")
        )
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Breakdown History"),
      DT::dataTableOutput("breakdown_history_table")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("ℹ️ Breakdown Management"),
        HTML(
          "<strong>Recording Breakdown:</strong> Enter the date when breakdown occurs<br>
           <strong>Repair Completion:</strong> Expected date when machine will be operational<br>
           <strong>Automatic Rescheduling:</strong> When breakdown ends, pending orders are automatically rescheduled<br>
           <strong>Machine Active Again:</strong> Use this button if repair finishes earlier than expected"
        )
      )
    )
  )
)
