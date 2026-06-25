# ============================================================================
# OPERATOR ABSENCE UI MODULE
# ============================================================================

fluidPage(
  fluidRow(
    column(
      12,
      h2("Operator Absence Management"),
      p("Record operator absence for specific shifts"),
      hr()
    )
  ),
  
  fluidRow(
    column(
      6,
      div(
        class = "panel panel-primary",
        div(
          class = "panel-heading",
          h4("Record Operator Absence")
        ),
        div(
          class = "panel-body",
          
          div(
            class = "form-group",
            label("Machine Name"),
            selectInput(
              "absence_machine",
              NULL,
              choices = c("", "PL-01", "PL-02", "BTMM", "CNC-BDM-01", "CNC-BDM-02", "CNC-BDM-03", "GCM")
            )
          ),
          
          div(
            class = "form-group",
            label("Absence Date"),
            dateInput(
              "absence_date",
              NULL,
              format = "yyyy-mm-dd"
            )
          ),
          
          div(
            class = "form-group",
            label("Affected Shift"),
            selectInput(
              "absence_shift",
              NULL,
              choices = c("", "Shift 1", "Shift 2", "Shift 3")
            )
          ),
          
          div(
            class = "form-group",
            label("Reason (Optional)"),
            textInput(
              "absence_reason",
              NULL,
              placeholder = "e.g., Medical leave"
            )
          ),
          
          actionButton(
            "add_operator_absence",
            "✋ Record Absence",
            class = "btn btn-warning btn-lg"
          )
        )
      )
    ),
    
    column(
      6,
      div(
        class = "panel panel-info",
        div(
          class = "panel-heading",
          h4("Recent Absence Records")
        ),
        div(
          class = "panel-body",
          DT::dataTableOutput("recent_absences_table")
        )
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("ℹ️ Operator Absence Management"),
        HTML(
          "<strong>Recording Absence:</strong> Enter the date and shift when operator is absent<br>
           <strong>Automatic Rescheduling:</strong> Orders for affected shift are automatically rescheduled to other machines<br>
           <strong>Machine Impact:</strong> Only specified shift and date are affected<br>
           <strong>Production Impact:</strong> Workload is redistributed to maintain production schedule"
        )
      )
    )
  )
)
