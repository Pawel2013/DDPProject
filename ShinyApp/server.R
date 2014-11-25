
library(shiny)

##########
source("./KDE.R")
##########

shinyServer(function(input, output) {

  output$kernelPlot <- renderPlot({ 

    symbol <- switch(input$symbol,
       "EUR/PLN" = EUR,
       "USD/PLN" = USD,
       "GBP/PLN" = GBP,
       "CHF/PLN" = CHF)
    
    # We have to find maximum probability
    h <- hist(symbol, probability=TRUE,main=names(symbol), col="lightblue", plot=FALSE)
    Max <- max(h$density)
    
    if (input$ShowAllBwe == FALSE && input$ShowAllKernels == FALSE)
    {
      dens <- density(symbol, bw=input$bwe, kernel=input$kernel, adjust=input$bwa);
      # We must correct if Max for histogram is < Max for density
      if (Max < max(dens$y))
      {
        Max <-  max(dens$y) 
      }
      Max <- Max;
      # We plot histogram
      hist(symbol, probability=TRUE,ylim=c(0,Max),main=names(symbol), col="lightblue", plot=TRUE)
      # We plot lines of density
      lines(dens, col="red", lwd=2);
      Kernel <- c(as.character(input$kernel) , as.character(input$bwe))
      # We add legend
      legend("topright",legend=c("Histogram",Kernel),lty=c(NA,1,NA), lwd=c(NA,2,NA), pch = c(15, NA,NA),
             col = c("lightblue", 2), merge=TRUE,inset=.01,cex=1.1,adj=0, text.font=1)
    }
    if (input$ShowAllBwe == TRUE && input$ShowAllKernels == FALSE)
    {
      bandWidthMethodsChart(symbol, bandWidthMethods, Max) 
    }
    if (input$ShowAllBwe == FALSE && input$ShowAllKernels == TRUE)
    {
      kernelMethodsChart(symbol, kernelMethods, Max) 
    }
    
  }) 
  
  output$fxratesPlot <- renderPlot({
    
    symbol <- switch(input$symbol,
                     "EUR/PLN" = EUR,
                     "USD/PLN" = USD,
                     "GBP/PLN" = GBP,
                     "CHF/PLN" = CHF)

    myTheme <- chartTheme('white',up.col='blue',dn.col='blue', bg.col='white')
    chartSeries(symbol, theme=myTheme, name=names(symbol))
    
  })
  
  output$summaryPrint <- renderPrint({
    
    symbol <- switch(input$symbol,
                     "EUR/PLN" = EUR,
                     "USD/PLN" = USD,
                     "GBP/PLN" = GBP,
                     "CHF/PLN" = CHF)
    kde <- density(symbol, bw=input$bwe, kernel=input$kernel, adjust=input$bwa)
    print(kde)
    
  })
  
  output$data <- renderDataTable({
    symbol <- switch(input$symbol,
                     "EUR/PLN" = EUR,
                     "USD/PLN" = USD,
                     "GBP/PLN" = GBP,
                     "CHF/PLN" = CHF)
    
    x = symbol
    # We need to extract dates
    Dates = index(x)
    
    newdf = data.frame(Dates,x)
    newdf
  })
  
  #getPage<-function() {
  #  return(includeHTML("include.html"))
  #}
  
  
  output$doc <- renderUI({
    HTML("
          <html>
          <head> 
            <title>Kernel density estimation - DEMO</title>
          </head> 
          <body>
          <h4 style='color:brown' > Documentation </h5>
          <p>This is shiny application developed as course project for 'Developing Data Products' course at Coursera. I didn't want to reinvent the wheel and don't know all very sophisticated datasets available in R with it's packages.</p>
          <p>I decided to make things as simple as possible. As a result prepared app based on <strong style='color:blue'>stat</strong> and <strong style='color:blue'>quantmod</strong> package showing the problem of estimating uknown probability density function.</p>
          <p>Data comes from <a href='http://www.oanda.com'>oanda</a> and represents 4 different foreign exchange rates (daily rates of return are calculated) from the beginning of the year. Kernel density estimator has the following form.</p>        
          <img src='Equation.png'> 
          <p>More can be found here <a href='http://en.wikipedia.org/wiki/Kernel_density_estimation'>Kernel density estimation</a> </p>
          <h5 style='color:brown' >Instructions:</h3>
          <p><strong>1</strong> Choose one of the preloaded exchange rates - you can see time series in second tab</p>
          <p><strong>2</strong> Select one of the bandwidth selection methods (first radio buttons group) or check all of them, compare the <strong style='color:green'>results - plots in first tab</strong> </p>
          <p><strong>3</strong> Select one of the kernel methods (second radio buttons group) or check all available kernels (checkbox), see the influence of kernel choice</p>
          <p><strong>4</strong> Try to move slider and observe how bandtwith adjustement change the shape of estimated density funtion.</p>
          <p><strong>5</strong> Data can be seen in 'Data' tab and summary in 'Density estimation summary' tab </p>
          <p  style='color:brown'>Presentation can be seen here <a href='http://rpubs.com/Pawel2013/44643'>Presentation</a>, github repo is available at this link <a href='https://github.com/Pawel2013/DDPProject/tree/master'>GitHub Repo</a> </p>
          </body>          
          </html>
         ")
  })

})
