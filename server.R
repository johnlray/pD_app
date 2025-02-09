# server.R

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
library(ggiraph)

newpal <- c('#19969F', '#B5522E', '#7E8DCF', '#0A5879', '#E38E52', '#ADE4F6', '#121D9E', '#06091D', '#0F1651', '#1C295F', '#743E32', '#170D1A', '#160B0F', '#281516', '#353EA4', '#818DAC', '#E79C3F', '#FACC56', '#3A5DE7', '#B03516',"#5374EE")

load('data/app_data.RData')

# Define shiny server
shinyServer(function(input, output) {
  
    dat <- reactive({
      dat = baserate[baserate$SEX %in% input$SEX & baserate$RACE %in% input$RACE & baserate$EDUCD %in% input$EDUCD & baserate$MARST %in% input$MARST,]
      dat
      return(dat)
    })
    
    cause <- reactive({
      cause = nber_allyears[nber_allyears$SEX %in% input$SEX & nber_allyears$RACE %in% input$RACE & nber_allyears$EDUCD %in% input$EDUCD & nber_allyears$MARST %in% input$MARST,]
      cause$Proportion = cause$one/ave(cause$one, cause$AGE, FUN = sum)
      cause$Percent = paste0(round(cause$Proportion*100,3),"%")
      cause$Cause = gsub("'", "", cause$Cause)
      return(cause)
    })
    
    oneyear <- reactive({
      oneyear = nber_allyears[nber_allyears$SEX %in% input$SEX & nber_allyears$RACE %in% input$RACE & nber_allyears$EDUCD %in% input$EDUCD & nber_allyears$MARST %in% input$MARST & nber_allyears$AGE == input$AGE,]
      oneyear$Proportion = oneyear$one/ave(oneyear$one, oneyear$AGE, FUN = sum)
      oneyear$Percent = paste0(round(oneyear$Proportion*100,3),"%")
      return(oneyear)
    })

    one_age <- reactive({
      one_age = nber[nber$SEX %in% input$SEX & nber$RACE %in% input$RACE & nber$EDUCD %in% input$EDUCD & nber$MARST %in% input$MARST & nber$AGE == input$AGE,]
      one_age$Proportion = one_age$one/ave(one_age$one, one_age$AGE, FUN = sum)
      one_age$Percent = paste0(round(one_age$Proportion*100,3),"%")
      return(one_age)
    })
    
    yearDeath <- reactive({
      yearDeath = baserate[baserate$SEX %in% input$SEX & baserate$RACE %in% input$RACE & baserate$EDUCD %in% input$EDUCD & baserate$MARST %in% input$MARST & baserate$AGE == input$AGE,'prDeath']
      yearDeath = round(yearDeath, 5)
      return(yearDeath)
    })
    
    month_day <- reactive({
      week_month <- week_month[week_month$SEX %in% input$SEX & week_month$RACE %in% input$RACE & week_month$EDU %in% input$EDUCD & week_month$MARITAL %in% input$MARST & week_month$AGE == input$AGE,]
      return(week_month)
    })

    output$basePlot = renderggiraph( {
      gg <- ggplot(dat(), aes(x = AGE, y = prDeath, label = plab, data_id = as.character(AGE), tooltip = as.character(round(prDeath,4)), size = 2)) + 
        geom_point_interactive(cex = 0.25, color = 'gray') + 
        geom_smooth(method="loess", color = 'black', size = 1) + 
        geom_vline(xintercept = input$AGE, color = 'red') +
        annotate("text", x = input$AGE + 1, y = .1, color = 'red', label = yearDeath()) + 
        theme_classic() +
        xlab("Age") +
        ylab("~p(Death)") +
        ggtitle("Approximate Probability of Death for Someone Like You, by Age") +
        geom_vline(xintercept = 96) +
        annotate("text", x = 100, y = .01, label = c("Sample Max"), size = 3) + xlim(0,105)
      
      ggiraph(code = print(gg), hover_css = "fill:red;" )
    })
    
    output$stackPropPlot = renderggiraph({
      ggs <- ggplot(cause(), aes(x = AGE, y = Proportion, fill = Cause, label = Percent, tooltip = paste0(Cause,": ",Percent), data_id = Cause)) +
        geom_bar_interactive(position = "fill",stat = "identity") +
        xlab("Age") +
        ylab("~p(Death) (proportion of year total)") +
        ggtitle("Proportion of Deaths in CDC Data") +
        theme_classic() +
        theme(legend.position = 'NULL') +
        scale_fill_manual(values = newpal)

      ggiraph(code = print(ggs), hover_css = "fill:red;" )
    })
    
    output$onebarPlot = renderggiraph({
      ggyp <- ggplot(oneyear(), aes(x = AGE, y = Proportion, label = Percent, fill = Cause, tooltip = paste0(Cause,": ",Percent), data_id = Cause)) +
        geom_bar_interactive(position = 'fill', stat='identity') +
        xlab("") +
        ylab("Proportion of Total Causes") +
        ggtitle("Proportion of Deaths in NBER Data for Someone Like You") +
        theme_classic() +
        theme(legend.position = 'NULL') +
        scale_fill_manual(values = newpal) +
        scale_x_discrete(breaks=c(input$AGE),
                         labels=c(input$AGE))

      ggiraph(code = print(ggyp), hover_css = "fill:red;" )
    })
    
  output$cumsumPlot = renderggiraph({
    ggc <- ggplot(dat(), aes(x = AGE, y = cumsum(prDeath)/sum(prDeath), label = plab, tooltip = cumsum(prDeath)/sum(prDeath), data_id = cumsum(prDeath)/sum(prDeath))) +
      geom_line() +
      geom_vline(xintercept = 96) +
      annotate("text", x = 100, y = .01, label = c("Sample Max"), size = 3) + xlim(0,105) +
      theme_classic() + xlab("Age") + ylab("~p(Death)") + ggtitle("Cumulative Death-Probability Sum")
    
    ggiraph(code = print(ggc), hover_css = "fill:red;" )
  })

    #output$densPlot = renderggiraph({
  #ggdens <- ggplot(cause(), aes(x = AGE, y = Percent, color = Cause, label = Cause, tooltip = Cause, data_id = Cause)) +
    #geom_density() +
    #geom_point_interactive() +
    #xlab("Age") +
    #ylab("~p(Death) (share of total)") +
    #ggtitle("Relative Risk of Cause of Death for People Like You\n(a.k.a., 'when is cause X riskiest?')") +
    #theme_classic() +
    #theme(legend.position = 'NULL') +
    #scale_color_manual(values = newpal)

    #ggiraph(code = print(ggdens), hover_css = "fill:red;" )
  #})
  
  # By month and day of week
  output$datePlot = renderggiraph({
    ggdate <- ggplot(month_day(), aes(x = DAY, fill = DAY, y = one, tooltip = DAY, data_id = DAY)) + 
      geom_point_interactive(aes(color = DAY)) +
      #ylim(0.75, 1) +
      facet_wrap( ~ MONTH) +
      xlab("") +
      ylab("N of Deaths of Someone Like You in CDC Data") +
      ggtitle("Number of Deaths of People Like You Per Day of Week, Per Month") +
      scale_fill_manual(values = newpal) +
      theme_classic() +
      theme(legend.position = 'NULL')

      ggiraph(code = print(ggdate), hover_css = "fill:red;" )
    })
})