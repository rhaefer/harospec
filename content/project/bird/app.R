library(shiny)
library(sf)
library(mapview)
library(leaflet)
library(osmdata)
library(gsheet)
library(tidyverse)
library(geojsonio)


ski.tab <- data.frame(gsheet2tbl("https://docs.google.com/spreadsheets/d/151RiUSQP0qMcUCGk9iO2zz7cdMbmOt64IiwzndeFWbI/edit?usp=sharing"))
ski.geo<-geojson_read("C:/Users/reidh/Documents/GitHub/rhaefer.github.io/ski_tours/all_ski_tours.geojson", what="sp") %>% st_as_sf()
ski <- ski.geo %>% left_join(ski.tab,  by="id")

bird <- data.frame(gsheet2tbl("https://docs.google.com/spreadsheets/d/1Lj1_ezsF_7_sfWFCYy0BCuic5iLayzpKsCGVyOE-5sQ/edit?usp=sharing")) %>%
  st_as_sf(coords=c("Longitude","Latitude"))

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

