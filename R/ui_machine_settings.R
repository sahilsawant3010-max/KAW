# ============================================================================
# MACHINE SETTINGS UI MODULE
# ============================================================================

#' Create machine settings UI
create_machine_settings_ui <- function(machines) {
  fluidPage(
    fluidRow(
      column(
        12,
        h2("Machine Settings"),
        p("Configure machine parameters and hourly costs"),
        hr()
      )
    ),
    
    # Planning Machines
    fluidRow(
      column(
        12,
        h3("Planning Machines")
      )
    ),
    
    lapply(seq_along(machines$planning), function(i) {
      machine <- machines$planning[[i]]
      fluidRow(
        column(
          12,
          div(
            class = "machine-card active",
            fluidRow(
              column(
                3,
                h4(machine$name),
                tags$small(paste("ID:", machine$id))
              ),
              column(
                3,
                div(
                  tags$label("Hourly Cost (₹/hr)"),
                  numericInput(
                    paste0("machine_cost_", machine$id),
                    NULL,
                    value = machine$cost_per_hour,
                    min = 0,
                    step = 10
                  )
                )
              ),
              column(
                3,
                div(
                  tags$label("Shift Type"),
                  selectInput(
                    paste0("machine_shift_", machine$id),
                    NULL,
                    choices = c("8-hour", "12-hour"),
                    selected = machine$shift_type
                  )
                )
              ),
              column(
                3,
                div(
                  tags$label("Active Shifts"),
                  selectInput(
                    paste0("machine_shifts_", machine$id),
                    NULL,
                    choices = 1:3,
                    selected = machine$active_shifts
                  )
                )
              )
            )
          )
        )
      )
    }),
    
    hr(),
    
    # Grooving Machines
    fluidRow(
      column(
        12,
        h3("Grooving Machines")
      )
    ),
    
    lapply(seq_along(machines$grooving), function(i) {
      machine <- machines$grooving[[i]]
      fluidRow(
        column(
          12,
          div(
            class = "machine-card active",
            fluidRow(
              column(
                3,
                h4(machine$name),
                tags$small(paste("ID:", machine$id))
              ),
              column(
                3,
                div(
                  tags$label("Hourly Cost (₹/hr)"),
                  numericInput(
                    paste0("machine_cost_", machine$id),
                    NULL,
                    value = machine$cost_per_hour,
                    min = 0,
                    step = 10
                  )
                )
              ),
              column(
                3,
                div(
                  tags$label("Shift Type"),
                  selectInput(
                    paste0("machine_shift_", machine$id),
                    NULL,
                    choices = c("8-hour", "12-hour"),
                    selected = machine$shift_type
                  )
                )
              ),
              column(
                3,
                div(
                  tags$label("Active Shifts"),
                  selectInput(
                    paste0("machine_shifts_", machine$id),
                    NULL,
                    choices = 1:3,
                    selected = machine$active_shifts
                  )
                )
              )
            )
          )
        )
      )
    }),
    
    hr(),
    
    fluidRow(
      column(
        12,
        div(
          style = "margin: 20px 0;",
          actionButton(
            "save_machine_settings",
            "💾 Save Settings",
            class = "btn btn-success btn-lg"
          )
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        div(
          class = "alert alert-info",
          h5("ℹ️ Machine Configuration"),
          HTML(
            "<strong>Hourly Cost:</strong> Machine operating cost per hour<br>
             <strong>Shift Type:</strong> 8-hour or 12-hour shifts<br>
             <strong>Active Shifts:</strong> Number of shifts machine operates (1-3)"
          )
        )
      )
    )
  )
}
