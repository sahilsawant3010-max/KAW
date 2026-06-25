# ============================================================================
# HOLIDAY SETTINGS UI MODULE
# ============================================================================

#' Create holiday settings UI
create_holiday_settings_ui <- function(holidays) {
  fluidPage(
    fluidRow(
      column(
        12,
        h2("Holiday Settings"),
        p("Manage holidays and non-working days"),
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
            h4("Add Holiday")
          ),
          div(
            class = "panel-body",
            
            div(
              class = "form-group",
              label("Holiday Date"),
              dateInput(
                "holiday_date",
                NULL,
                format = "yyyy-mm-dd"
              )
            ),
            
            div(
              class = "form-group",
              label("Holiday Name"),
              textInput(
                "holiday_name",
                NULL,
                placeholder = "e.g., Independence Day"
              )
            ),
            
            actionButton(
              "add_holiday",
              "➕ Add Holiday",
              class = "btn btn-success"
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
            h4("Current Holidays")
          ),
          div(
            class = "panel-body",
            if (length(holidays) > 0) {
              div(
                lapply(seq_along(holidays), function(i) {
                  div(
                    style = "padding: 8px; border-bottom: 1px solid #ecf0f1;",
                    strong(format(holidays[i], "%d-%b-%Y")),
                    actionButton(
                      paste0("delete_holiday_", i),
                      "🗑️",
                      class = "btn btn-xs btn-danger",
                      style = "float: right;"
                    )
                  )
                })
              )
            } else {
              p("No holidays configured yet.")
            }
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
          h5("ℹ️ Holiday Configuration"),
          HTML(
            "<strong>Weekly Off:</strong> Monday (Fixed)<br>
             <strong>Custom Holidays:</strong> Add specific dates for festivals, company holidays, etc.<br>
             <strong>Impact:</strong> Machines will not operate on holidays. Orders will be extended accordingly."
          )
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
            "save_holidays",
            "💾 Save Holiday Settings",
            class = "btn btn-success btn-lg"
          )
        )
      )
    )
  )
}
