library(shiny)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  Yprime <- reactive({
    if (input$RCI == "JT") {
      return(round(input$EITS,2))
    }
    if (input$RCI == "Speer") { 
      return(round(input$CGRM + input$TRR*(input$EITS - input$CGITM),2))
    }
    if (input$RCI == "Chelune") {
      return(round(input$EITS + (input$CGRM - input$CGITM),2))
    }
    if (input$RCI == "McSweeny") {
      b <- input$TRR * (input$CGRS/input$CGITS)
      a <- input$CGRM - b*input$CGITM
      return(round(b*input$EITS + a,2))
    }
    if (input$RCI == "Charter") {
      return(round(input$CGRM + input$TRR * (input$EITS - input$CGITM),2))
    }
    if (input$RCI == "CH") {
      b <- input$TRR * (input$CGRS/input$CGITS)
      a <- input$CGRM - b*input$CGITM
      return(round(b*input$EITS + a,2))
    }
    if (input$RCI == "Temkin") {
      return(round(input$EITS + (input$CGRM - input$CGITM),2))
    }
    if (input$RCI == "Iverson") {
      return(round(input$EITS + (input$CGRM - input$CGITM),2))
    }
    if (input$RCI == "Maassen") {
      badj <- input$CGRS/input$CGITS
      aadj <- input$CGRM - badj*input$CGITM
      return(round(badj*input$EITS + aadj,2))
    }})
  
  
  SE <- reactive({
    if (input$RCI == "JT") {
      return(round(sqrt(2*input$CGITS*(1-input$TRR)),2))
    }
    if (input$RCI == "Speer") { 
      return(round(sqrt(2*input$CGITS*(1-input$TRR)),2))
    }
    if (input$RCI == "Chelune") {
      return(round(sqrt(2*input$CGITS*(1-input$TRR)),2))
    }
    if (input$RCI == "McSweeny") {
      return(round(input$CGRS*sqrt(1-input$TRR^2),2))
    }
    if (input$RCI == "Charter") {
      return(round(input$CGRS*sqrt(1-input$TRR^2),2))
    }
    if (input$RCI == "CH") {
      SE4 <- sqrt(2*input$CGITS*(1-input$TRR))
      return(round(SE4*sqrt(1+(1/input$CGSS)+(((input$EITS-input$CGITM)^2)/((input$CGITS^2)*(input$CGSS-1)))),2))
    }
    if (input$RCI == "Temkin") {
      return(round(sqrt(input$CGITS^2 + input$CGRS^2 + 2*input$CGITS*input$CGRS*input$TRR),2))
    }
    if (input$RCI == "Iverson") {
      return(round(sqrt((input$CGITS^2 + input$CGRS^2)*(1-input$TRR)),2))
    }
    if (input$RCI == "Maassen") {
      return(round(sqrt((input$CGITS^2 + input$CGRS^2)*(1-input$TRR)),2))
    }
  })
  LowerCI <- reactive({round(Yprime()+(qnorm((100-input$CI)/200)*SE()),2)})
  UpperCI <- reactive({round(Yprime()+(qnorm((100-input$CI)/200,lower.tail=FALSE)*SE()),2)})
  zscore <- reactive({round((input$OT2S - Yprime())/SE(),2)})

  output$RCI <- renderText(input$RCI)
  output$PT2S <- renderText(paste0("Predicted Time 2 Score: ", Yprime()))
  output$SE <- renderText(paste0("Standard Error: ", SE()))
  output$LowerCI <- renderText({paste0("Lower Band of ", as.numeric(input$CI), "% Interval: ", LowerCI())})
  output$UpperCI <- renderText({paste0("Upper Band of ", as.numeric(input$CI), "% Interval: ", UpperCI())})
  output$zscore <- renderText({paste0("z-score: ", zscore())})
})