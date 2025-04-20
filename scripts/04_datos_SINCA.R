library(tidyverse)
library(readxl)

hojas <- readxl::excel_sheets('data/raw/CO_estaciones_RM.xlsx')

#### Cargar los datos
data <- hojas |> 
  map_df(\(h){
    d <- read_xlsx('data/raw/CO_estaciones_RM.xlsx',sheet = h,col_types = 'text')
    d |> mutate(estacion = h)
  })

### Ordenar los datos

data <- data |> mutate(
  date = ymd(`FECHA (YYMMDD)`),
  value = ifelse(is.na(`Registros validados`),`Registros no validados`,`Registros validados`) |> as.numeric()
  ) |> 
  select(estacion,date,value)

### Promedio mensual

data_mean_mes <- data |> 
  group_by(estacion,mes =floor_date(date,'1 month')) |>
  summarize(value_mes = mean(value,na.rm = TRUE))

### graficar series de tiempo

data_mean_mes |> 
  #filter(mes >= ymd("20180101")) |> 
  ggplot(aes(mes,value_mes,colour=estacion)) + 
  geom_point(size=.2) + 
  geom_line(size=.2) +
  facet_grid(estacion~.,scales = 'free') +
  scale_x_date(date_breaks = "6 months",date_labels = "%Y-%m",expand = c(0,0)) +
  scale_colour_viridis_d() +
  theme_bw() +
  theme(axis.text.x = element_text(angle=90))
