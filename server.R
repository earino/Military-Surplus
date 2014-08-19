
# This is the server logic for a Shiny web application.
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

military <- read.csv("1033-program-foia-may-2014.csv")

shinyServer(function(input, output) {

  output$mapPlot <- renderPlot({
    if (input$state != "NA") {
      map_of_state = map_data("county")
      state_of_interest = state.abb[match(input$state, state.name)]
      #state_of_interest = state.abb[match("Texas", state.name)]
      
      
      expenditures <- military %>% filter(State == state_of_interest) %>% group_by(State, County) %>% summarise(Thousands = sum(Acquisition.Cost)/1000) 
      expenditures$region <- tolower(state.name[match(expenditures$State, state.abb)])
      expenditures$subregion <- tolower(expenditures$County)
      expenditures <- expenditures[complete.cases(expenditures),]
      military_map <- map_of_state %>% left_join(expenditures)
      military_map <- subset(military_map, region == tolower(input$state))
      military_map$Thousands <- ifelse(is.na(military_map$Thousands), 0, military_map$Thousands)
     #military_map <- military_map[complete.cases(military_map),]
      p <- ggplot(military_map, aes(x=long, y=lat, group=group, fill=Thousands)) +
            scale_fill_gradient2(low="#559999", mid="grey90", high="#ff0000") +
            geom_polygon(colour="black") + coord_map("polyconic") + xlab("") + ylab("") + 
            ggtitle("Thousands of Dollars of Transferred Military Surplus Gear")
      
      print(p)
    }
    else {
      state_map <- map_data("state")
      
      expenditures <- military %>% group_by(State) %>% summarise(Millions = sum(Acquisition.Cost)/1000000) 
      expenditures$region <- tolower(state.name[match(expenditures$State, state.abb)])
      expenditures <- expenditures[complete.cases(expenditures),]
      
      military_map <- state_map %>% left_join(expenditures)
      
      p <- ggplot(military_map, aes(x=long, y=lat, group=group, fill=Millions)) +
            scale_fill_gradient2(low="#559999", mid="grey90", high="#ff0000") +
            geom_polygon(colour="black") + coord_map("polyconic") + xlab("") + ylab("") + 
            ggtitle("Millions of Dollars of Transferred Military Surplus Gear")     
      
      print(p)
    }
  })

})
