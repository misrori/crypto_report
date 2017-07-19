library(shiny)
library(plotly)
library(data.table)



function(input, output, session) {
  source('crypto_functions.R')
  
  nevek<- get_nevek()
  
  nev_label <- sapply(strsplit(nevek, "/"), "[[", 3)

  output$valaszto <- renderUI({
    checkboxGroupInput("cryptos", "Válasz",choiceNames =nev_label, 
                       choiceValues= nevek, selected ="",
                        )})
  
  my_list <- eventReactive(input$goButton, {
    input$cryptos
  })
  

  
  my_list_2 <- eventReactive(input$goButton, {
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
   
   my_reactive_text <- reactive({
     if(nrow(my_data())==0){
       return("")
     }else{
       return("The plot is interactive, select the area, that you are most interested in!")
     }
     
     
   })
  
   output$my_text <- renderText(my_reactive_text())
  
  
}