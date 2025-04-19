library(terra)
library(sf)
library(tidyverse)

co <- rast('data/raw/CO_Stack_2018_2025.tif')

df <- global(co,'mean',na.rm = TRUE)

dates <- seq(ymd("20180701"),ymd("20250401"),by = '1 month')

data <- tibble(dates=dates,co=df$mean)

ggplot(data,aes(dates,co)) +
  geom_point() + 
  geom_line() + 
  geom_smooth() +
  scale_x_date(date_breaks = "3 months",date_labels = "%Y-%b") +
  theme_bw()
