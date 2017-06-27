library(shiny)
library(plotly)
library(data.table)



function(input, output, session) {
  source('crypto_functions.R')
  
  nevek<- get_nevek()
  
  nev_label <- sapply(strsplit(nevek, "/"), "[[", 3)

  output$valaszto <- renderUI({
    checkboxGroupInput("cryptos", "Válasz",choiceNames =nev_label, 
                       choiceValues= nevek
                        )})
  
  my_list <- eventReactive(input$goButton, {
    input$cryptos
  })
  
  # my_list <- reactive({
  #   input$goButton
  #   return(input$cryptos)
  # 
  # })
  
  my_list_2 <- reactive({
    return(sapply(strsplit(input$cryptos, "/"), "[[", 3))
    
  })
  
  my_data <- reactive({
     adatom_teljes <- get_all_data(tickers = my_list())
     return(adatom_teljes)
   })
   
  output$datatablem <- renderDataTable({my_data()})
  
   my_plot <- reactive({
      
      tozsde_plot(number_of_days = input$integer, my_adatom = my_data(), list_of_markets =my_list_2() )
    })
  
   output$summary_plot <- renderPlotly({
     my_plot()
   })
  
  
  
}