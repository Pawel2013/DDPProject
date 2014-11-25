
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel(h2("Kernel density estimation", style="color:brown")),
  
  # Sidebar with inputs
  sidebarLayout(
    sidebarPanel(h4("Inputs", style ="color:red"),
                 
      selectInput("symbol", label = h6("Select symbol for exchange rate"),
                  choices = c("EUR/PLN", "USD/PLN", "GBP/PLN", "CHF/PLN"), 
                  selected = "EUR/PLN"),
      
      radioButtons("bwe", label = h6("Select bandwith estimation method"),
                   choices = c("nrd0", "nrd", "ucv", "bcv", "SJ-ste", "Sj-dpi"), 
                   selected = "nrd0"),

      checkboxInput("ShowAllBwe", label = "All estimation methods", value = FALSE),
      
      sliderInput("bwa",
                  h6("Select bandwith adjustment:"),
                  min = 0.25,
                  max = 4.0,
                  value = 1.0),
      
      radioButtons("kernel", label = h6("Select kernel method"),
                   choices = c("gaussian", "epanechnikov", "rectangular", "triangular", "biweight", "cosine"),
                   selected = "gaussian"),
      
      checkboxInput("ShowAllKernels", label = "All kernel methods", value = FALSE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(h4("Outputs", align = "center",  style ="color:red"),
      
      tabsetPanel(
        
        tabPanel("Returns density estimation",
          plotOutput("kernelPlot")         
        ),
        
        tabPanel("Returns in time",
          plotOutput("fxratesPlot")         
        ),
        
        tabPanel("Density estimation summary",
          verbatimTextOutput("summaryPrint")         
        ),
        
        tabPanel("Data", dataTableOutput("data")),
        
        tabPanel("Documentation",
                 htmlOutput("doc")),
        
        selected = "Documentation"
        
      )
    )
  )
))