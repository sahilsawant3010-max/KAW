# ============================================================================
# TIMELINE TRACKING UI MODULE
# ============================================================================

#' Create timeline tracking UI
create_timeline_tracking_ui <- function() {
  fluidPage(
    fluidRow(
      column(
        12,
        h2("Live Timeline Tracking"),
        p("Gantt chart view of all machines and their scheduled orders"),
        hr()
      )
    ),
    
    fluidRow(
      column(
        12,
        div(
          class = "alert alert-info",
          h5("📈 Gantt Chart Visualization"),
          "This chart shows the timeline for all machines. Each bar represents an order with its scheduled start and end dates."
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Gantt Chart - All Machines")
      )
    ),
    
    fluidRow(
      column(
        12,
        plotly::plotlyOutput(
          "timeline_gantt_chart",
          height = "600px"
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Timeline Statistics")
      )
    ),
    
    fluidRow(
      column(
        4,
        div(
          class = "panel panel-primary",
          div(
            class = "panel-heading",
            "Earliest Start Date"
          ),
          div(
            class = "panel-body",
            textOutput("timeline_earliest_start")
          )
        )
      ),
      column(
        4,
        div(
          class = "panel panel-info",
          div(
            class = "panel-heading",
            "Latest Completion Date"
          ),
          div(
            class = "panel-body",
            textOutput("timeline_latest_completion")
          )
        )
      ),
      column(
        4,
        div(
          class = "panel panel-success",
          div(
            class = "panel-heading",
            "Total Production Days"
          ),
          div(
            class = "panel-body",
            textOutput("timeline_total_days")
          )
        )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Machine Load Over Time")
      )
    ),
    
    fluidRow(
      column(
        12,
        plotly::plotlyOutput("timeline_load_chart")
      )
    ),
    
    hr(),
    
    fluidRow(
      column(
        12,
        h3("Options")
      )
    ),
    
    fluidRow(
      column(
        12,
        actionButton(
          "refresh_timeline",
          "🔄 Refresh Timeline",
          class = "btn btn-primary"
        ),
        actionButton(
          "export_timeline_image",
          "📷 Export as Image",
          class = "btn btn-info"
        ),
        actionButton(
          "export_timeline_pdf",
          "📋 Export as PDF",
          class = "btn btn-danger"
        )
      )
    )
  )
}

create_gantt_chart <- function(orders, machines) {
  # Create a simple Gantt chart using plotly
  if (nrow(orders) == 0) {
    return(plot_ly() %>% 
      layout(title = "No orders scheduled yet"))
  }
  
  # Prepare data
  gantt_data <- data.frame(
    Order = orders$order_id,
    Machine = "Machine",
    Start = orders$created_date,
    End = orders$expected_completion_date
  )
  
  plot_ly(
    gantt_data,
    x = ~Start,
    y = ~Order,
    type = 'bar',
    orientation = 'h',
    marker = list(color = '#3498db')
  ) %>%
    layout(
      title = "Production Timeline - Gantt Chart",
      xaxis = list(title = "Date"),
      yaxis = list(title = "Order ID"),
      height = 400
    )
}

fluidPage(
  fluidRow(
    column(
      12,
      h2("Live Timeline Tracking"),
      p("Gantt chart view of all machines and their scheduled orders"),
      hr()
    )
  ),
  
  fluidRow(
    column(
      12,
      div(
        class = "alert alert-info",
        h5("📈 Gantt Chart Visualization"),
        "This chart shows the timeline for all machines. Each bar represents an order with its scheduled start and end dates."
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Gantt Chart - All Machines")
    )
  ),
  
  fluidRow(
    column(
      12,
      plotly::plotlyOutput(
        "timeline_gantt_chart",
        height = "600px"
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Timeline Statistics")
    )
  ),
  
  fluidRow(
    column(
      4,
      div(
        class = "panel panel-primary",
        div(
          class = "panel-heading",
          "Earliest Start Date"
        ),
        div(
          class = "panel-body",
          textOutput("timeline_earliest_start")
        )
      )
    ),
    column(
      4,
      div(
        class = "panel panel-info",
        div(
          class = "panel-heading",
          "Latest Completion Date"
        ),
        div(
          class = "panel-body",
          textOutput("timeline_latest_completion")
        )
      )
    ),
    column(
      4,
      div(
        class = "panel panel-success",
        div(
          class = "panel-heading",
          "Total Production Days"
        ),
        div(
          class = "panel-body",
          textOutput("timeline_total_days")
        )
      )
    )
  ),
  
  hr(),
  
  fluidRow(
    column(
      12,
      h3("Machine Load Over Time")
    )
  ),
  
  fluidRow(
    column(
      12,
      plotly::plotlyOutput("timeline_load_chart")
    )
  )
)
