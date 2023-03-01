library(shiny)
library(httr)
library(jsonlite)

# Define the UI
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel("Shiny-Chat-GPT"),
  sidebarLayout(
    sidebarPanel(
    textInput("user_input", "Enter your message:"),
    hr(),
    actionButton("submit_button", "sumbit")
    ),
  mainPanel(
    htmlOutput("bot_output")
     
    )
  )
)

# Define the server
server <- function(input, output) {
  # Define the API endpoint and API key
  endpoint <- "https://api.openai.com/v1/completions"
  api_key <- "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"
  
  # Define the function to generate the response
  generate_response <- function(prompt) {
    response <- POST(endpoint,
                     add_headers("Content-Type" = "application/json",
                                 "Authorization" = paste("Bearer", api_key)),
                     body = paste0('{"model": "text-davinci-003", "prompt": "',input$user_input, '", "temperature": 0.1, "max_tokens": 1000}'))
    response_text <- content(response, "text")
    response_json <- fromJSON(response_text)
    generated_text <- response_json$choices$text
    return(generated_text)
  }
  
  # Define the event handler for the submit button
  observeEvent(input$submit_button, {
    output$bot_output <- renderUI({
      HTML(paste(generate_response()))
      })
  })
}

# Run the app
shinyApp(ui, server)
