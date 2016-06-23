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
  
  df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
  countries = read.csv("../../../data/countries.csv", stringsAsFactors = F)
  t = data.frame(abr = c("AU", "CA", "DE", "ES", "FR", "GB", "IT", "NL", "PT", "US"), country.name = c("Australia", "Canada", "Germany", "Spain", "France", "United Kingdom", "Italy", "Netherlands", "Portugal", "United States"))
  merged = merge(countries, t, by.x = "country_destination", by.y = "abr", all.x = T)
  all_countries = merge(df['COUNTRY'], merged, by.x = 'COUNTRY', by.y = 'country.name', all.x = T)
  all_countries$hover <- with(all_countries, paste(COUNTRY, '<br>', 
                                                   "Latitude: ", lat_destination, 
                                                   '<br>', "Longitude: ", lng_destination,
                                                   '<br>', "Distance from US (km): ", distance_km,
                                                   '<br>', "Size of country (km2): ", destination_km2,
                                                   '<br>', "Language: ", destination_language,
                                                   '<br>', "Levenshtein distance of language: ", language_levenshtein_distance))
  all_countries$pred = runif(nrow(all_countries), -1, 1)
  
  # light grey boundaries
  l <- list(color = toRGB("grey"), width = 0.5)
  
  # specify map projection/options
  g <- list(
    showframe = FALSE,
    showcoastlines = FALSE,
    projection = list(type = 'Robinson')
  )
  
  output$plot <- renderPlotly({
    plot_ly(all_countries, z = pred, 
            text = hover, 
            locations = COUNTRY,
            type = 'choropleth',
            marker = list(line = l),
            colorbar = list(title = "Percent more <br>likely to book"),
            colors = 'Blues', locationmode = "country names") %>% 
      layout(geo = g,
             title = 'Likelihood of booking')
  })

  
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