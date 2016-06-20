#####By Ruonan Ding#########
############################

library(shiny)
library(shinydashboard)
library(shinythemes)

shinyUI(navbarPage("Airbnb",   id = "nav",
         theme = shinytheme("flatly"),
   
         tabPanel("Map",
           fluidRow(
             box(            
              title = "Title", 
              htmlOutput("GeoLayer1"),
              "Hello",
              width = 12
             )
           )
         ),
         tabPanel("About the Data",
                  fluidRow(
                    box("Data")
                  )
         ),
         tabPanel("About Us",
            fluidRow(
              box(
                title = h2("Rob Castellano, Zi Jin, Yannick Kimmel, Michael Winfield"),
                br(),
                htmlOutput("aboutus"),
                width = 12)
            )
         )
      )
)


