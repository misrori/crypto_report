library(shiny)
library(plotly)
library(DT)
library(data.table)
library(plotly)


navbarPage(
  title="Crypto report",
  tabPanel("Elemzés",
           sidebarLayout(
             sidebarPanel(
              sliderInput("integer", "Number of days before:", min=0, max=2000, value=50),
              actionButton("goButton", "Go!"),
              uiOutput('valaszto')
             ),
             mainPanel(
               plotlyOutput('summary_plot')
             )
           )
           
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  )# http://bootswatch.com/#Grafikon_tab
  
  
  
)#nav