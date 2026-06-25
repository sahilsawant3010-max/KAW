# ============================================================================
# SHIFT SETTINGS UI MODULE
# ============================================================================

#' Create shift settings UI
create_shift_settings_ui <- function(machines) {
  fluidPage(
    fluidRow(
      column(
        12,
        h2("Shift Settings"),
        p("Configure shift timings for each machine"),
        hr()
      )
    ),
    
    fluidRow(
      column(
        12,
        div(
          class = "alert alert-info",
          h5("Predefined Shift Timings"),
          HTML(
            "<strong>8-Hour Shifts:</strong><br>
             - Shift 1: 07:30 AM - 04:30 PM<br>
             - Shift 2: 04:30 PM - 11:30 PM<br>
             - Shift 3: 11:30 PM - 07:30 AM<br><br>
             <strong>12-Hour Shifts:</strong><br>
             - Shift 1: 07:30 AM - 07:30 PM<br>
             - Shift 2: 07:30 PM - 07:30 AM"
          )
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        h3("Shift Configuration per Machine")
      )
    ),
    
    fluidRow(
      column(
        6,
        div(
          class = "panel panel-primary",
          div(
            class = "panel-heading",
            h4("Planning Machines")
          ),
          div(
            class = "panel-body",
            lapply(seq_along(machines$planning), function(i) {
              machine <- machines$planning[[i]]
              div(
                style = "margin-bottom: 20px; padding: 10px; border: 1px solid #bdc3c7; border-radius: 4px;",
                h5(machine$name),
                checkboxGroupInput(
                  paste0("shift_active_", machine$id),
                  "Active Shifts",
                  choices = c("Shift 1" = "1", "Shift 2" = "2", "Shift 3" = "3"),
                  selected = "1",
                  inline = FALSE
                )
              )
            })
          )
        )
      ),
      
      column(
        6,
        div(
          class = "panel panel-info",
          div(
            class = "panel-heading",
            h4("Grooving Machines")
          ),
          div(
            class = "panel-body",
            lapply(seq_along(machines$grooving), function(i) {
              machine <- machines$grooving[[i]]
              div(
                style = "margin-bottom: 20px; padding: 10px; border: 1px solid #bdc3c7; border-radius: 4px;",
                h5(machine$name),
                checkboxGroupInput(
                  paste0("shift_active_", machine$id),
                  "Active Shifts",
                  choices = c("Shift 1" = "1", "Shift 2" = "2", "Shift 3" = "3"),
                  selected = "1",
                  inline = FALSE
                )
              )
            })
          )
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Break Time"),
        div(
          class = "alert alert-warning",
          "Lunch Break Duration: 30 minutes (Fixed)",
          br(),
          "Break is automatically deducted from available working hours."
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        h3("Working Days"),
        div(
          class = "alert alert-warning",
          "Weekly Off: Monday (Fixed)",
          br(),
          "Additional holidays can be configured in Holiday Settings."
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        div(
          style = "margin: 20px 0;",
          actionButton(
            "save_shift_settings",
            "💾 Save Shift Settings",
            class = "btn btn-success btn-lg"
          )
        )
      )
    )
  )
}
