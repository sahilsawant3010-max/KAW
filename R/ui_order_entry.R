# ============================================================================
# ORDER ENTRY UI MODULE
# ============================================================================

fluidPage(
  fluidRow(
    column(
      12,
      h2("Create New Order"),
      p("Enter plate details and select scheduling mode for automatic allocation"),
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
          h4("Order Details")
        ),
        div(
          class = "panel-body",
          
          # Plate Type
          div(
            class = "form-group",
            label("Plate Type *"),
            selectInput(
              "order_plate_type",
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
          ),
          
          # Plate Size
          div(
            class = "form-group",
            label("Plate Size *"),
            selectInput(
              "order_plate_size",
              NULL,
              choices = c(
                "",
                "24*48",
                "30*60",
                "30*66",
                "36*72",
                "36*78",
                "40*80",
                "42*84",
                "45*90",
                "50*100"
              )
            )
          ),
          
          # Quantity
          div(
            class = "form-group",
            label("Quantity (Number of Plates) *"),
            numericInput(
              "order_quantity",
              NULL,
              value = 0,
              min = 1,
              step = 1
            )
          ),
          
          # Operation Type
          div(
            class = "form-group",
            label("Operation Type *"),
            selectInput(
              "order_operation",
              NULL,
              choices = c(
                "",
                "Planning",
                "Grooving"
              )
            )
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
          h4("Scheduling Options")
        ),
        div(
          class = "panel-body",
          
          # Scheduling Mode
          div(
            class = "form-group",
            label("Scheduling Mode"),
            selectInput(
              "scheduling_mode",
              NULL,
              choices = c(
                "Fast",
                "Moderate",
                "Minimum Cost"
              ),
              selected = "Moderate"
            ),
            tags$small(
              "Fast: Minimize completion time | Moderate: Balance cost and time | Minimum Cost: Minimize total cost",
              style = "color: #7f8c8d; display: block; margin-top: 10px;"
            )
          ),
          
          # Mode Info Box
          div(
            class = "alert alert-info",
            h5("ℹ️ About Scheduling Modes"),
            HTML(
              "<strong>Fast Mode:</strong> Orders completed as early as possible<br>
               <strong>Moderate Mode:</strong> Balance cost and completion time (Recommended)<br>
               <strong>Minimum Cost Mode:</strong> Minimize machining cost"
            )
          )
        )
      )
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        style = "margin: 20px 0;",
        actionButton(
          "submit_order",
          "✅ Submit Order",
          class = "btn btn-success btn-lg",
          width = "200px"
        ),
        actionButton(
          "clear_order",
          "🔄 Clear Form",
          class = "btn btn-secondary btn-lg",
          width = "200px"
        )
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Order Information"),
      div(
        class = "alert alert-warning",
        HTML(
          "<strong>📌 Note:</strong> When you create an order, it will automatically be scheduled for both Planning and Grooving operations.<br>
           The system will allocate plates to machines based on current loads and your selected scheduling mode."
        )
      )
    )
  )
)
