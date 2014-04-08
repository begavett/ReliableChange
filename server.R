# The MIT License (MIT)
# 
# Copyright (c) 2014 Brandon Gavett
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

library(shiny)

# Define server logic required to calculate various reliable change indices
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
      return(round(sqrt(2*input$CGITS^2*(1-input$TRR)),2))
    }
    if (input$RCI == "Speer") { 
      return(round(sqrt(2*input$CGITS^2*(1-input$TRR)),2))
    }
    if (input$RCI == "Chelune") {
      return(round(sqrt(2*input$CGITS^2*(1-input$TRR)),2))
    }
    if (input$RCI == "McSweeny") {
      return(round(input$CGRS*sqrt(1-input$TRR^2),2))
    }
    if (input$RCI == "Charter") {
      return(round(input$CGRS*sqrt(1-input$TRR^2),2))
    }
    if (input$RCI == "CH") {
      SE4 <- input$CGRS*sqrt(1-input$TRR^2)
      return(round(SE4*sqrt(1+(1/input$CGSS)+(((input$EITS-input$CGITM)^2)/((input$CGITS^2)*(input$CGSS-1)))),2))
    }
    if (input$RCI == "Temkin") {
      return(round(sqrt(input$CGITS^2 + input$CGRS^2 - 2*input$CGITS*input$CGRS*input$TRR),2))
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
  
  output$plot <- renderPlot({
    plot(input$OT2S, 1, type = "p", xlab = "Score", axes = FALSE, ylab = "", 
         pch = 16, xlim = c(input$CGITM-3*input$CGITS, input$CGITM+3*input$CGITS),
         ylim=c(.5, 1.5))
    axis(1)
    points(Yprime(), 1, pch = 17, col = "red")
    arrows(Yprime(), 1, LowerCI(), 1, col = "red", angle = 90)
    arrows(Yprime(), 1, UpperCI(), 1, col = "red", angle = 90)
    legend("top", pch = c(16, 17), col = c("black","red"), 
           c("Observed Time 2 Score", "Predicted Time 2 Score"))
  })
})
