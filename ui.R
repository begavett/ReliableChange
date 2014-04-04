library(shiny)

shinyUI(pageWithSidebar(
  # Application Title
  headerPanel("Reliable Change Calculator"),
  
  #Sidebar with controls to enter test scores, etc.
  sidebarPanel(
    selectInput("RCI","Reliable Change Model:",
                choices=list("Jacobson & Truax (1991)" = "JT",
                             "Speer (1992)" = "Speer",
                             "Chelune et al. (1993)" = "Chelune",
                             "McSweeny et al. (1993)" = "McSweeny",
                             "Charter (1996)" = "Charter",
                             "Crawford & Howell (1998)" = "CH",
                             "Temkin et al. (1999)" = "Temkin",
                             "Iverson et al. (2003)" = "Iverson",
                             "Maassen et al. (2006)" = "Maassen"),multiple=FALSE),
    numericInput("CI", "Confidence Interval (%):",95,min=0,max=100),
    numericInput("EITS", "Examinee's Initial Test Score:",0),
    numericInput("CGITM", "Control Group Initial Test Mean:",0),
    numericInput("CGITS", "Control Group Initial Test SD:",0),
    numericInput("CGRM", "Control Group Retest Mean:",0),
    numericInput("CGRS", "Control Group Retest SD:",0),
    numericInput("TRR", "Test-Retest Reliability:",0,min=0,max=1),
    numericInput("CGSS", "Control Sample Size (N):",0,min=0),
  numericInput("OT2S", "Observed Time 2 Score:",0),
  submitButton("Calculate")),
  
  mainPanel(textOutput("PT2S"),
            textOutput("SE"),
            textOutput("LowerCI"),
            textOutput("UpperCI"),
            textOutput("zscore"))
  
))