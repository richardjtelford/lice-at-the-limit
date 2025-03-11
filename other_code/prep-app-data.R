# prepare data for shiny app
# minimise size of dataset, save as RDS with consistent code
# year, count, (PA)
# one file per country

# load data

norway <- readxl::read_excel(here("data/norway/lakselus_per_fisk.xlsx")) |>
  janitor::clean_names()

scotland <- read_delim(here("data/scotland/ms_sea_lice.zip")) |>
  janitor::clean_names()

britishcolumbia <- read_delim(here("data/british-columbia/lice-count-dens-pou-2011-ongoing-rpt-pac-dfo-mpo-aquaculture-eng.csv"), na = "n/a") |>
  janitor::clean_names()

ireland <- NULL

# harmonise data

norway_small <- norway |>
  select(year = ar, adult_f = voksne_hunnlus, limit = lusegrense_uke, area = produksjonsomrade_id) |>
  drop_na(adult_f) |>
    mutate(year = as.integer(year), area = as.integer(area), limit = factor(limit))




# save data
write_rds(norway_small, "app/data/norway.rds")

