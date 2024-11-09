# norway
load_norway <- function(file){
  norway <- readxl::read_excel(file) |>
    janitor::clean_names() |>
    select(year = ar, lice = voksne_hunnlus, limit = lusegrense_uke) |>
    drop_na(lice)
  norway
}

# scotland
load_scotland <- function(file){
  scotland <- read_delim(file) |>
    janitor::clean_names() |>
    select(year, lice = weekly_average_af) |>
    drop_na(lice)

  scotland
}

# britishColumbia
load_britishcolumbia <- function(file){
  britishcolumbia <- read_delim(file, na = "n/a") |>
    janitor::clean_names() |>
    select(year, lice = average_l_salmonis_motiles_per_fish ) |>
    drop_na(lice)

  britishcolumbia
}

# ireland
load_ireland <- function(file){
  ireland <- readxl::read_excel(file, sheet = 2, skip = 1) |>
    janitor::clean_names() |>
    mutate(year = year(date)) |>
    select(year, lice = lep_f_eggs) |>
    drop_na(lice)

  ireland
}

# load all data
load_all_data <- function(norway, scotland, britishColumbia, ireland){
  norway <- load_norway(norway)
  scotland <- load_scotland(scotland)
  britishColumbia <- load_britishcolumbia(britishColumbia)
  ireland <- load_ireland(ireland)

  list(norway = norway, scotland = scotland, britishColumbia = britishColumbia, ireland = ireland)
}


# find periods
find_periods <- function(all_data){
  map(all_data, \(x){
    glue("{min(x$year)}--{max(x$year)}")
  })
}
