# ============================================================================
# LOGIN UI MODULE
# ============================================================================

#' Create login UI
create_login_ui <- function() {
  fluidPage(
    theme = shinytheme("flatly"),
    
    tags$head(
      tags$style(HTML("
        body { 
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          display: flex;
          justify-content: center;
          align-items: center;
          min-height: 100vh;
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
          background: white;
          padding: 50px;
          border-radius: 10px;
          box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
          max-width: 400px;
          width: 100%;
        }
        .login-title {
          text-align: center;
          font-size: 32px;
          font-weight: bold;
          color: #2c3e50;
          margin-bottom: 30px;
        }
        .login-subtitle {
          text-align: center;
          color: #7f8c8d;
          margin-bottom: 30px;
          font-size: 14px;
        }
        .form-group {
          margin-bottom: 20px;
        }
        .form-group label {
          font-weight: 600;
          color: #2c3e50;
          display: block;
          margin-bottom: 8px;
        }
        .form-group input {
          width: 100%;
          padding: 12px;
          border: 1px solid #bdc3c7;
          border-radius: 5px;
          font-size: 14px;
        }
        .form-group input:focus {
          border-color: #667eea;
          box-shadow: 0 0 5px rgba(102, 126, 234, 0.5);
        }
        .login-btn {
          width: 100%;
          padding: 12px;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          border: none;
          border-radius: 5px;
          font-size: 16px;
          font-weight: 600;
          cursor: pointer;
          transition: transform 0.2s;
        }
        .login-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .login-footer {
          text-align: center;
          margin-top: 20px;
          font-size: 12px;
          color: #95a5a6;
        }
      "))
    ),
    
    div(
      class = "login-container",
      
      div(class = "login-title", "🏭 KAW Queue Scheduler"),
      div(class = "login-subtitle", "Manufacturing Operations Management System"),
      
      div(
        class = "form-group",
        tags$label("Administrator Password"),
        passwordInput("login_password", NULL, placeholder = "Enter your password")
      ),
      
      actionButton(
        "login_btn",
        "Login",
        class = "login-btn",
        width = "100%"
      ),
      
      div(
        class = "login-footer",
        "Secure access to manufacturing scheduling system"
      )
    )
  )
}
