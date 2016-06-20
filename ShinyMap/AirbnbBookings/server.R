#####By Ruonan Ding#########
############################

library(shiny)
library(dplyr)
library(ggplot2)
library(countrycode)
library(googleVis)
library(shinydashboard)
library(shinythemes)


shinyServer(function(input, output, session) {
  # output$GeoLayer1 <- renderGvis({
  #   gvisGeoChart(e, "country.name", "index",
  #                options=list(width=800,height=450, colors= "['green']",
  #                             title = "The Intermediaries Countries that faciliated USA Entities",
  #                             legend = 'none'))
  #   
  # })
  
  countries = read.csv("../../../data/countries.csv", stringsAsFactors = F)
  t = data.frame(abr = c("AU", "CA", "DE", "ES", "FR", "GB", "IT", "NL", "PT", "US"), country.name = c("Australia", "Canada", "Germany", "Spain", "France", "United Kingdom", "Italy", "Netherlands", "Portugal", "United States"))
  merged = merge(countries, t, by.x = "country_destination", by.y = "abr", all.x = T)
  merged$html.tooltip1 = c(HTML('a<b>e</b>'), paste(br(), '5'))
  merged$html.tooltip2 = c('Im tryingt this really long line to see what happends....Inot w dcjnwicuwnkdcjnwkdjcnwlidcnejnc', 'd')
  
  output$GeoLayer1 <- renderGvis({
    gvisGeoMap(merged, locationvar = "country.name", hovervar = "html.tooltip1",
                 options=list(width=800,height=450, colors= "['green']", tooltip = "{isHtml: 'true'}",
                              title = "Title",
                              legend = 'none'))
    
  })
  # 
  # au = data.frame(name = "Australia", been = "Rob has not been here")
  # ca = data.frame(name = "Canada", been = "Rob has been here")
  # de = list(name = "Germany", been = "Rob has been here")
  # es = list(name = "Spain", been = "Rob has been here")
  # fr = list(name = "France", been = "Rob has been here")
  # gb = list(name = "United Kingdom", been = "Rob has been here")
  # it = list(name = "Italy", been = "Rob has not been here")
  # nl = list(name = "Netherlands", been = "Rob has not been here")
  # pt = list(name = "Portugal", been = "Rob has been here")
  # us = list(name = "United States", been = "Rob has been here")
  # 
  # 
  # countries = data.frame(rbind(au, ca))
  # countries = data.frame(rbind(au, ca, de, es, fr, gb, it, nl, pt, us))
  # 
  # nums = c(1, 2)
  # nums2 = c(3, 4)
  # y = data.frame(cbind(countries, nums, nums2))
  # 
  output$aboutus <- renderUI({
  HTML(paste(
    h3("Rob Castellano:"),
    h3("Zi Jin:"),
    h3("Yannick Kimmel:"),
    h3("Michael Winfield:")
    )
  )
})
})