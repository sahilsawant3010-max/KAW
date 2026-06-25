# ============================================================================
# MACHINE MEAN PROCESSING TIME MANAGEMENT UI MODULE
# ============================================================================

fluidPage(
  fluidRow(
    column(
      12,
      h2("Machine Mean Processing Time"),
      p("View and edit average processing times for each machine by plate type and size"),
      hr()
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-warning",
        h5("🔐 Administrator Access Required"),
        "To edit machine processing times, please enter your administrator password below."
      )
    )
  ),
  
  # ====================================================================
  # PASSWORD PROTECTION
  # ====================================================================
  fluidRow(
    column(
      6,
      div(
        class = "panel panel-danger",
        div(
          class = "panel-heading",
          h4("Administrator Authentication")
        ),
        div(
          class = "panel-body",
          div(
            class = "form-group",
            label("Administrator Password"),
            passwordInput(
              "mean_time_admin_password",
              NULL,
              placeholder = "Enter password to unlock editing"
            )
          ),
          div(
            class = "form-group",
            actionButton(
              "verify_mean_time_password",
              "🔓 Unlock Editor",
              class = "btn btn-danger btn-lg"
            )
          ),
          uiOutput("mean_time_lock_status")
        )
      )
    )
  ),
  
  hr(),
  
  # ====================================================================
  # PLANNING OPERATIONS TIMES
  # ====================================================================
  fluidRow(
    column(
      12,
      h3("Planning Operation - Machine Mean Processing Times (Hours)")
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("ℹ️ Planning Machines"),
        HTML(
          "<strong>PL-01</strong>: ₹300/hr<br>
           <strong>PL-02</strong>: ₹300/hr<br>
           <strong>BTMM</strong>: ₹450/hr<br>
           <strong>CNC BDM-01</strong>: ₹780/hr"
        )
      )
    )
  ),
  
  fluidRow(
    column(
      12,
      DT::dataTableOutput("planning_mean_times_table")
    )
  ),
  
  hr(),
  
  # ====================================================================
  # EDIT PLANNING TIMES SECTION
  # ====================================================================
  fluidRow(
    column(
      12,
      conditionalPanel(
        condition = "output.mean_time_editor_unlocked",
        div(
          class = "panel panel-success",
          div(
            class = "panel-heading",
            h4("✏️ Edit Planning Operation Times")
          ),
          div(
            class = "panel-body",
            fluidRow(
              column(
                3,
                div(
                  class = "form-group",
                  label("Plate Type"),
                  selectInput(
                    "edit_planning_plate_type",
                    NULL,
                    choices = c(
                      "",
                      "Trash without RIB",
                      "Trash with RIB",
                      "Scraper MS",
                      "Scraper CS",
                      "Scraper CI"
                    )
                  )
                )
              ),
              column(
                3,
                div(
                  class = "form-group",
                  label("Plate Size"),
                  selectInput(
                    "edit_planning_plate_size",
                    NULL,
                    choices = c(
                      "",
                      "24*48", "30*60", "30*66", "36*72", "36*78",
                      "40*80", "42*84", "45*90", "50*100"
                    )
                  )
                )
              )
            ),
            fluidRow(
              column(
                3,
                div(
                  class = "form-group",
                  label("PL-01 Time (hours)"),
                  numericInput(
                    "edit_planning_pl01",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              ),
              column(
                3,
                div(
                  class = "form-group",
                  label("PL-02 Time (hours)"),
                  numericInput(
                    "edit_planning_pl02",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              ),
              column(
                3,
                div(
                  class = "form-group",
                  label("BTMM Time (hours)"),
                  numericInput(
                    "edit_planning_btmm",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              ),
              column(
                3,
                div(
                  class = "form-group",
                  label("CNC BDM-01 Time (hours)"),
                  numericInput(
                    "edit_planning_cnc_bdm_01",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              )
            ),
            div(
              style = "margin-top: 15px;",
              actionButton(
                "save_planning_time",
                "💾 Save Planning Time",
                class = "btn btn-success btn-lg"
              ),
              actionButton(
                "reset_planning_time",
                "🔄 Reset Form",
                class = "btn btn-secondary btn-lg"
              )
            )
          )
        )
      )
    )
  ),
  
  hr(),
  
  # ====================================================================
  # GROOVING OPERATIONS TIMES
  # ====================================================================
  fluidRow(
    column(
      12,
      h3("Grooving Operation - Machine Mean Processing Times (Hours)")
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("ℹ️ Grooving Machines"),
        HTML(
          "<strong>CNC BDM-02</strong>: ₹780/hr<br>
           <strong>CNC BDM-03</strong>: ₹780/hr<br>
           <strong>GCM</strong>: ₹450/hr"
        )
      )
    )
  ),
  
  fluidRow(
    column(
      12,
      DT::dataTableOutput("grooving_mean_times_table")
    )
  ),
  
  hr(),
  
  # ====================================================================
  # EDIT GROOVING TIMES SECTION
  # ====================================================================
  fluidRow(
    column(
      12,
      conditionalPanel(
        condition = "output.mean_time_editor_unlocked",
        div(
          class = "panel panel-success",
          div(
            class = "panel-heading",
            h4("✏️ Edit Grooving Operation Times")
          ),
          div(
            class = "panel-body",
            fluidRow(
              column(
                3,
                div(
                  class = "form-group",
                  label("Plate Type"),
                  selectInput(
                    "edit_grooving_plate_type",
                    NULL,
                    choices = c(
                      "",
                      "Trash without RIB",
                      "Trash with RIB",
                      "Scraper MS",
                      "Scraper CS",
                      "Scraper CI"
                    )
                  )
                )
              ),
              column(
                3,
                div(
                  class = "form-group",
                  label("Plate Size"),
                  selectInput(
                    "edit_grooving_plate_size",
                    NULL,
                    choices = c(
                      "",
                      "24*48", "30*60", "30*66", "36*72", "36*78",
                      "40*80", "42*84", "45*90", "50*100"
                    )
                  )
                )
              )
            ),
            fluidRow(
              column(
                4,
                div(
                  class = "form-group",
                  label("CNC BDM-02 Time (hours)"),
                  numericInput(
                    "edit_grooving_cnc_bdm_02",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              ),
              column(
                4,
                div(
                  class = "form-group",
                  label("CNC BDM-03 Time (hours)"),
                  numericInput(
                    "edit_grooving_cnc_bdm_03",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              ),
              column(
                4,
                div(
                  class = "form-group",
                  label("GCM Time (hours)"),
                  numericInput(
                    "edit_grooving_gcm",
                    NULL,
                    value = 0,
                    min = 0,
                    step = 0.25
                  )
                )
              )
            ),
            div(
              style = "margin-top: 15px;",
              actionButton(
                "save_grooving_time",
                "💾 Save Grooving Time",
                class = "btn btn-success btn-lg"
              ),
              actionButton(
                "reset_grooving_time",
                "🔄 Reset Form",
                class = "btn btn-secondary btn-lg"
              )
            )
          )
        )
      )
    )
  ),
  
  hr(),
  
  # ====================================================================
  # HISTORY AND AUDIT LOG
  # ====================================================================
  fluidRow(
    column(
      12,
      h3("📋 Edit History & Audit Log")
    )
  ),
  
  fluidRow(
    column(
      12,
      DT::dataTableOutput("mean_time_audit_log")
    )
  ),
  
  hr(),
  
  # ====================================================================
  # INFORMATION BOX
  # ====================================================================
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("ℹ️ Machine Mean Processing Time Information"),
        HTML(
          "<strong>Mean Processing Time:</strong> Average time (in hours) required for each machine to process one plate<br><br>
           <strong>Calculation:</strong> Total time ÷ Number of plates<br><br>
           <strong>Impact on Scheduling:</strong> These times are used to calculate expected order completion dates and machine utilization<br><br>
           <strong>Edit Restrictions:</strong> Only administrators can modify these values. All changes are logged for audit purposes.<br><br>
           <strong>Precision:</strong> Values can be entered in increments of 0.25 hours (15 minutes)
          "
        )
      )
    )
  )
)
