# ============================================================================
# ACTIVE PRODUCTION UI MODULE
# ============================================================================

fluidPage(
  fluidRow(
    column(
      12,
      h2("Active Production"),
      p("Real-time view of orders currently being processed"),
      hr()
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("📌 Active Orders Status"),
        "This list shows all orders that are currently in production or scheduled to start soon."
      )
    )
  ),
  
  fluidRow(
    column(
      12,
      DT::dataTableOutput("active_production_table")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Order Management")
    )
  ),
  
  fluidRow(
    column(
      6,
      div(
        class = "panel panel-warning",
        div(
          class = "panel-heading",
          h4("Cancel Order")
        ),
        div(
          class = "panel-body",
          div(
            class = "form-group",
            label("Select Order to Cancel"),
            selectInput(
              "cancel_order_id",
              NULL,
              choices = c("" = ""),
              selectize = TRUE
            )
          ),
          div(
            class = "form-group",
            label("Cancellation Reason (Optional)"),
            textAreaInput(
              "cancellation_reason",
              NULL,
              rows = 3,
              placeholder = "e.g., Customer request, Quality issues"
            )
          ),
          actionButton(
            "cancel_order",
            "❌ Cancel Order",
            class = "btn btn-danger btn-lg"
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
          h4("Order Details")
        ),
        div(
          class = "panel-body",
          uiOutput("selected_order_details")
        )
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-warning",
        h5("⚠️ Cancellation Impact"),
        HTML(
          "When an order is cancelled:<br>
           • All allocated resources are freed up<br>
           • Other pending orders may be rescheduled to fill available slots<br>
           • Machines will be rebalanced automatically<br>
           • Cancellation reason is recorded for reference"
        )
      )
    )
  )
)
