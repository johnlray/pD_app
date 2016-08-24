# ui.R

list.of.packages <- c("ggplot2", "lattice","plotly","shiny","shinythemes")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages)
rm(new.packages)

library(ggplot2)
library(lattice)
library(plotly)
library(shiny)
library(shinythemes)

newpal <- c('#19969F', '#B5522E', '#7E8DCF', '#FCFDFC', '#E38E52', '#ADE4F6', '#121D9E', '#06091D', '#0F1651', '#1C295F', '#743E32', '#170D1A', '#160B0F', '#281516', '#353EA4', '#818DAC', '#E79C3F', '#FACC56', '#3A5DE7', '#B03516',"#5374EE")

load('data/app_data.RData')

shinyUI(
  # Use a fluid Boostrap layout
  fluidPage(
    titlePanel("Death Probability by Demographic Group"),
    
    # Generate a row with a sidebar
    sidebarLayout(
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("SEX", "Sex:",
                           selected = "Male",
                           choices = unique(baserate$SEX)),
       selectInput("RACE", "Race:",
                           selected = "Black",
                           choices = unique(baserate$RACE)),
        selectInput("EDUCD", "Education:",
                           selected = "High school",
                           choices = unique(baserate$EDUCD)),
        selectInput("MARST", "Marital Status:",
                           selected = "Never Married",
                           choices = unique(baserate$MARST)),
       numericInput(inputId = "AGE", label = "Age:", value = 25, min = 1, max = 96, width = '90px'),
        hr(),
        HTML(includeText('sidebar.html'))
        ),
        # Create a place for the plot
      mainPanel(
        plotlyOutput("basePlot"),
        plotlyOutput("stackPropPlot"),
        plotlyOutput("onebarPlot"),
        plotlyOutput("cumsumPlot"),
        plotlyOutput("densPlot"),
        #plotlyOutput("timePlot"),
        plotlyOutput("datePlot")
      )
      
    )
  )
)