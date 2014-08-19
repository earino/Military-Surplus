
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(maps)
library(plyr)
library(dplyr)
library(mapproj)

shinyUI(fluidPage(

  # Application title
  titlePanel("Millions Spent in Military Surplus Gear"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("state", "Which State", c(NA, state.name))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("mapPlot")
    )
  )
))
