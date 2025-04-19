library(sf)
library(terra)
library(tidyverse)

comunas <- read_sf('data/processed/comunas_RM.gpkg')
co <- rast('data/raw/CO_Stack_2018_2025.tif')

df <- terra::extract(co,comunas,'mean',na.rm = TRUE)

df |> 
  cbind(comunas['NOM_COM'] |> st_drop_geometry()) |> 
  select(-ID) |> 
  pivot_longer(-NOM_COM) |> 
  mutate(dates = paste0(substr(name,4,10),'_01') |> ymd()) |> 
  select(-name) |> 
  ggplot(aes(dates,value,colour= NOM_COM)) + 
  geom_point() + 
  geom_line() 
  facet_grid(NOM_COM~.)

