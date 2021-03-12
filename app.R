# Lessson 4; process some inputs!
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson4/
# Reactive output automatically responds when your user toggles a widget.
#   (unless you have submit widget)

# make a folder census-app
# put an app.R file into it

# we are going to take some values from the ui.  
#   process them on the server.
#   then display them on the ui.
# We need to add something to the ui to diplay...


# Shiny provides a family of functions that turn R objects into 
#   output for your user interface. Each function creates a 
#   specific type of output.
# 
# Output-function	  Creates
# dataTableOutput	  DataTable
# htmlOutput	      raw HTML
# imageOutput	      image
# plotOutput	      plot
# tableOutput	      table
# textOutput	      text
# uiOutput	        raw HTML
# verbatimTextOutput	text
library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)