# Johns-Hopkins format

library(dplyr)

x = readr::read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv")
x$data <- lubridate::as_date(x$data)

x <- x %>%
  select(
    data, 
    denominazione_regione, 
    stato,
    lat, 
    long, 
    totale_casi,
    dimessi_guariti,
    deceduti
  ) %>%
  rename(
    `Province/State` = "denominazione_regione", 
    Lat = "lat",
    Long = "long"
  ) %>%
  mutate(
    data = format(data, format = "%m/%d/%y")
  ) %>%
  rename(`Country/Region` = stato) %>%
  mutate(`Country/Region` = "Italy")

x_confirmed <- x %>%
  select(-dimessi_guariti, -deceduti) %>%
  tidyr::pivot_wider(id_cols = c(`Province/State`, `Country/Region`,  "Lat", "Long"), names_from = data, values_from = totale_casi) %>% mutate_all(funs(tidyr::replace_na(.,0)))

readr::write_csv(x_confirmed, "johns-hopkins-format/time_series_19-covid-Confirmed_Italy.csv")

x_deaths <- x %>%
  select(-dimessi_guariti, -totale_casi) %>%
  tidyr::pivot_wider(id_cols = c(`Province/State`, `Country/Region`,  "Lat", "Long"), names_from = data, values_from = deceduti) %>% mutate_all(funs(tidyr::replace_na(.,0)))

readr::write_csv(x_deaths, "johns-hopkins-format/time_series_19-covid-Deaths_Italy.csv")

x_recovered <- x %>%
  select(-deceduti, -totale_casi) %>%
  tidyr::pivot_wider(id_cols = c(`Province/State`, `Country/Region`,  "Lat", "Long"), names_from = data, values_from = dimessi_guariti) %>% mutate_all(funs(tidyr::replace_na(.,0)))

readr::write_csv(x_recovered, "johns-hopkins-format/time_series_19-covid-Recovered_Italy.csv")
