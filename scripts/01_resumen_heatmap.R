
library(tidyverse)

data <- read_csv('~/Descargas/datos_estufas.csv') |> 
  set_names(c('comuna','fecha'))

data |> 
  mutate(fecha = dmy(fecha)) |> 
  group_by(comuna,year = floor_date(fecha,'1 year')) |> 
  summarize(cantidad = n()) |> 
  ggplot(aes(year,comuna, fill = cantidad)) + 
  geom_raster() +
  scale_fill_viridis_b(alpha = .6) +
  geom_text(aes(label  =cantidad)) +
  scale_x_date(date_labels = '%Y', expand = c(0,0)) +
  theme_bw()

facet_grid(.~comuna,scales = 'free')