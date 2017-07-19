library(shiny)
library(plotly)
library(DT)
library(data.table)
library(plotly)

library(shinycssloaders)

# for spinners 2-3 match the background color of wellPanel
options(spinner.color.background="#F5F5F5")


navbarPage(
  title="Crypto report",
  tabPanel("Elemzés",
           sidebarLayout(
             sidebarPanel(
              sliderInput("integer", "Number of days before:", min=1, max=2000, value=100),
              actionButton("goButton", "Get plot!"),
              uiOutput('valaszto')
             ),
             mainPanel(
               withSpinner(plotlyOutput('summary_plot'),type = 4),
               h2(textOutput('my_text'), align='center')
             )
           )
           
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  )# http://bootswatch.com/#Grafikon_tab
  
  
  
)#nav