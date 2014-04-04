# Reliable Change Index Shiny app

This is an application for Shiny that can be used to calculate reliable change indices.
To run this app, the user must download and install the free R software package from http://www.r-project.org
Once R is installed, the shiny package must be installed. In R, simply type the code below to install shiny.

```R
install.packages("shiny", dependencies = TRUE)
```

The easiest way to run the RCI Shiny app is by typing the code below into R.

```R
library(shiny)

runGitHub("ReliableChange", "begavett")
```
