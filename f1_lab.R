library(tidyverse)
library(leaflet)

# read in multiple csv's

folder <- "data/"      # path to folder that holds multiple .csv files
file_list <- list.files(path=folder, pattern="*.csv") # create list of all .csv files in folder

# read in each .csv file in file_list and create a data frame with the same name as the .csv file
for (i in 1:length(file_list)){
  assign(file_list[i],
         read_csv(paste(folder, file_list[i], sep=''))
  )}

# fix broken names

circuits.csv[18,3] <- "Autódromo José Carlos Pace"
circuits.csv[20,3] <- "Nürburgring"
circuits.csv[25,3] <- "Autódromo Juan y Oscar Gálvez"
circuits.csv[27,3] <- "Autódromo Fernanda Pires da Silva"
circuits.csv[32,3] <- "Autódromo Hermanos Rodríguez"
circuits.csv[36,3] <- "Autódromo Internacional Nelson Piquet"
circuits.csv[49,3] <- "Montjuïc circuit"
circuits.csv[4,4] <- "Montmeló"
circuits.csv[18,4] <- "São Paulo"
circuits.csv[20,4] <- "Nürburg"

# explore winning drivers and constructors

# make a leaflet map that shows info from combined datasets (for the leaflet demo on Day 2)

# filter the data based on driver, constructor, and season?

leaflet(circuits.csv) %>% addTiles() %>% addMarkers(~lng, ~lat, popup=~name)

