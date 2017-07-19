library(rvest)
library(data.table)


get_crypto_data <- function(crypto){
  my_date <- gsub('-', '',Sys.Date())

  link <- paste('https://coinmarketcap.com',crypto,'historical-data/?start=20000101&end=',my_date, sep = "")

  adat_help <-read_html(link)%>%
    html_nodes("table") %>%
    html_table()
  if(nrow(adat_help[[1]])>0){
    adat <- adat_help[[1]][,c(1,5)]
    
  }else{
    adat <- adat_help[[2]][,c(1,5)]
  }

  
  adat$Date <-gsub( 'Jan', '01',adat$Date)
  adat$Date <-gsub( 'Feb', '02',adat$Date)
  adat$Date <-gsub( 'Mar', '03',adat$Date)
  adat$Date <-gsub( 'Apr', '04',adat$Date)
  adat$Date <-gsub( 'May', '05',adat$Date)
  adat$Date <-gsub( 'Jun', '06',adat$Date)
  adat$Date <-gsub( 'Jul', '07',adat$Date)
  adat$Date <-gsub( 'Aug', '08',adat$Date)
  adat$Date <-gsub( 'Sep', '09',adat$Date)
  adat$Date <-gsub( 'Oct', '10',adat$Date)
  adat$Date <-gsub( 'Nov', '11',adat$Date)
  adat$Date <-gsub( 'Dec', '12',adat$Date)
  adat$Date <-gsub( ',', '',adat$Date)
  
  adat$Date <- as.Date(gsub(',','',adat$Date), format = "%m %d %Y")
  setorder(adat,Date)
  return(adat)
}


get_all_data <- function(tickers){
  
  adat <- data.table()
  
  for (i in tickers){
    tmp <- get_crypto_data(i)
    tmp$ticker <- strsplit(i, "/")[[1]][3]
    adat <- rbind(adat,tmp)
    
  }
return(adat)
}


get_nevek <- function(){

link <- paste('https://coinmarketcap.com/')
nevek <-read_html(link)%>%
  html_nodes(".currency-name a") %>%
  html_attr("href")
}

tozsde_plot <- function(number_of_days, my_adatom, list_of_markets){
  if(nrow(my_adatom)==0){
    return(plotly_empty())
  }
  
  my_days <- sort(unique(my_adatom$Date), decreasing = T)[c(1:number_of_days)]
  adatom <- data.table(my_adatom[my_adatom$Date %in% my_days,])
  setorder(adatom, ticker, Date)
  
  
  for (i in list_of_markets) {
    baseline <- adatom[ticker == i, Close][1]
    adatom[ticker == i, change := (Close/baseline-1)*100]
  }
  
  
  f <- list(
    family = "Courier New, monospace",
    size = 18,
    color = "#7f7f7f"
  )
  x <- list(
    title = "Date",
    titlefont = f
  )
  y <- list(
    title = "Change (%)",
    titlefont = f
  )
  
  m <- list(
    l = 100,
    r = 100,
    b = 10,
    t = 150,
    pad = 4
  )
  p<-plot_ly(adatom, x = ~Date, y = ~change, color =~ticker, text= paste(adatom$ticker,adatom$Close))%>%
    add_lines()%>%layout(title = paste('Started',min(adatom$Date)), xaxis = x, yaxis = y)
    
  return(p)
  
}