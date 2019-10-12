library(shiny)
library(sf)
library(mapview)
library(leaflet)
library(osmdata)
library(gsheet)
library(tidyverse)
library(geojsonio)
library(shinydashboard)

bird<-read_csv("content/project/bird/MyEBirdData.csv") %>%
  st_as_sf(coords=c("Longitude","Latitude"))


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)
server <- function(input, output) { }
shinyApp(ui, server)

# Define UI for application that draws a histogram
ui <- fluidPage(
   # Application title
   titlePanel("Bird Observations"),
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("counts",
                     "Number of Species Observed",
                     min = 1,
                     max = 10,
                     value = 1)
      ),
      mainPanel(
         plotOutput("bird_plot"),
         leafletOutput("bird_map")
      )
   )
)
server <- function(input, output) {
   output$bird_plot <- renderPlot({
     bird %>%  
       filter(Count==input$counts) %>%
       ggplot(aes(Common.Name, Count)) + 
       geom_bar(stat="identity") +
       theme(axis.text.x = element_text(angle=45, hjust=1))
   })
   output$bird_map <- renderLeaflet({
     bird %>%
    filter(Count==input$counts) %>%
     leaflet() %>%
      addTiles() %>%
       addCircleMarkers()
})
}
# Run the application 
shinyApp(ui = ui, server = server)

