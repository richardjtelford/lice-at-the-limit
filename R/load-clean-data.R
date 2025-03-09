# norway
load_norway <- function(file) {
  norway <- readxl::read_excel(file) |>
    janitor::clean_names() |>
    select(
      year = ar,
      lice = voksne_hunnlus,
      mobile_lice = lus_i_bevegelige_stadier,
      limit = lusegrense_uke,
      week = uke,
      area = produksjonsomrade_id,
      site = lokalitetsnummer
    ) |>
    drop_na(lice) |>
    filter(year <= 2024)
  norway
}

# scotland
load_scotland <- function(file) {
  scotland <- read_delim(file) |>
    janitor::clean_names() |>
    select(year, lice = weekly_average_af) |>
    drop_na(lice) |>
    filter(year <= 2024)

  scotland
}

# britishColumbia
load_britishcolumbia <- function(file) {
  britishcolumbia <- read_delim(file, na = "n/a") |>
    janitor::clean_names() |>
    select(
      year,
      lice = average_l_salmonis_motiles_per_fish,
      adult_female = average_l_salmonis_females_per_fish
    ) |>
    drop_na(lice) |>
    filter(year <= 2024)

  britishcolumbia
}

# ireland
load_ireland <- function(file, ireland_2009) {
  ### from pdfs

  pdfs <- tribble(
    ~file,
    ~start,
    ~end,
    ~good,
    "Irish Fisheries Bulletin No 33.pdf",
    NA,
    NA,
    FALSE,
    "Irish Fisheries Bulletin No 45.pdf",
    25,
    35,
    TRUE,
    "Fisheries Bulletin No. 46.pdf",
    22,
    30,
    TRUE,
    "Irish Fisheries Bulletin No. 47 - Annual report 2017.pdf",
    24,
    34,
    TRUE,
    "Irish Fisheries Bulletin No. 48 - Annual report 2018.pdf",
    25,
    34,
    TRUE,
    "Irish Fisheries Bulletin No. 49 2019.pdf",
    23,
    30,
    TRUE,
    "Irish Fisheries Bulletin No. 50.pdf",
    27,
    36,
    TRUE,
    "Irish Fisheries Bulletin No. 52.pdf",
    26,
    35,
    TRUE,
    "Irish Fisheries Bulletin No40-National Survey of Sea Lice 2011.pdf",
    26,
    36,
    TRUE,
    "IrishFisheriesBulletin55.pdf",
    26,
    37,
    TRUE,
    "No 44 2014 National Survey of Sea Lice on Fish Farms in Ireland 2013 (with cover) A4.pdf",
    25,
    35,
    TRUE,
    "No.41. 2013. National Survey of sea lice on fish farms in Ireland 2012 (with cover) A4.pdf",
    26,
    36,
    TRUE,
    "No32 Irish Fisheries Bulletin.pdf",
    27,
    41,
    TRUE,
    "FisheriesBulletinNo.54.pdf",
    25,
    34,
    TRUE,
    "IFB no. 34.pdf",
    23,
    37,
    TRUE,
    "IFB No. 53 National survey of Sea lice in Fish farms 2021.pdf",
    26,
    35,
    TRUE
  ) |>
    semi_join(tibble(file = basename(file)), by = join_by(file))

  pdf_output <- pdfs |>
    filter(good) |>
    drop_na(start, end) |>
    pmap(safely(extract_ireland_pdf))

  combined_pdf <- pdf_output |>
    map("result") |>
    list_rbind() |>
    mutate(
      date = dmy(date),
      across(-date, as.numeric)
    ) |>
    rename(lice = gravid_lep, total_lice = total_lep) |>
    filter(year(date) > 2007) # different rules before 2008

  ## import 2009 data (corrupted pdf - cannot import with the others)
  ireland_2009_data <- read_delim(ireland_2009) |>
    mutate(date = dmy(date)) |>
    rename(lice = gravid_female, total_lice = total)

  bind_rows(combined_pdf, ireland_2009_data) |>
    mutate(
      year = year(date),
      date2 = set_year(date, 2020),
      limit = if_else(between(date2, ymd("2020-3-1"), ymd("2020-5-31")), 0.5, 2)
    ) |>
    select(-date2, -total_cal, -gravid_cal)
}

# load all data
load_all_data <- function(
  norway,
  scotland,
  britishColumbia,
  ireland,
  ireland_2009
) {
  norway <- load_norway(norway)
  scotland <- load_scotland(scotland)
  britishColumbia <- load_britishcolumbia(britishColumbia)
  ireland <- load_ireland(ireland, ireland_2009)

  list(
    norway = norway,
    scotland = scotland,
    britishColumbia = britishColumbia,
    ireland = ireland
  )
}


# find periods
find_periods <- function(all_data) {
  map(all_data, \(x) {
    glue("{min(x$year)}--{max(x$year)}")
  })
}
