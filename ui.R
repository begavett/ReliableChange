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

shinyUI(fluidPage(
  # Application Title
  title= "Reliable Change Calculator",
  fluidRow(
    column(3,
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
           numericInput("EITS", "Examinee's Initial Test Score:",0)),
    
    column(3,
           numericInput("CGITM", "Control Group Initial Test Mean:",0),
           numericInput("CGITS", "Control Group Initial Test SD:",0),
           numericInput("CGRM", "Control Group Retest Mean:",0),
           numericInput("CGRS", "Control Group Retest SD:",0)),
    
    column(3,
           numericInput("TRR", "Test-Retest Reliability:",0,min=0,max=1),
           numericInput("CGSS", "Control Sample Size (N):",0,min=0),
           numericInput("OT2S", "Observed Time 2 Score:",0),
           submitButton("Calculate")),
    
    column(3,
           h4("Reliable Change Values"),
           br(),
           textOutput("PT2S"),
           textOutput("SE"),
           textOutput("LowerCI"),
           textOutput("UpperCI"),
           textOutput("zscore"))
    
    ),  
  
  hr(),
  
  plotOutput("plot")
))
