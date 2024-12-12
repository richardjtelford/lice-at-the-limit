# norway
load_norway <- function(file){
  norway <- readxl::read_excel(file) |>
    janitor::clean_names() |>
    select(year = ar, lice = voksne_hunnlus, limit = lusegrense_uke, week = uke, area = produksjonsomrade_id, site = lokalitetsnummer) |>
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
  ### from pdfs

  pdfs <- tribble(~ file, ~ start, ~ end, ~ good,
                  "Irish Fisheries Bulletin No 33.pdf", NA, NA, FALSE,
                  "Irish Fisheries Bulletin No 45.pdf", 25, 35, TRUE,
                  "Fisheries Bulletin No. 46.pdf", 22, 30, TRUE,
                  "Irish Fisheries Bulletin No. 47 - Annual report 2017.pdf", 24, 34, TRUE,
                  "Irish Fisheries Bulletin No. 48 - Annual report 2018.pdf",  25, 34, TRUE,
                  "Irish Fisheries Bulletin No. 49 2019.pdf",  23, 30, TRUE,
                  "Irish Fisheries Bulletin No. 50.pdf",  27, 36, TRUE,
                  "Irish Fisheries Bulletin No. 52.pdf",  26, 35, TRUE,
                  "Irish Fisheries Bulletin No40-National Survey of Sea Lice 2011.pdf",  26, 36, TRUE,
                  "IrishFisheriesBulletin55.pdf",  26, 37, TRUE,
                  "No 44 2014 National Survey of Sea Lice on Fish Farms in Ireland 2013 (with cover) A4.pdf",  25, 35, TRUE,
                  "No.41. 2013. National Survey of sea lice on fish farms in Ireland 2012 (with cover) A4.pdf",  26, 36, TRUE,
                  "No32 Irish Fisheries Bulletin.pdf",  27, 41, TRUE,
                  "FisheriesBulletinNo.54.pdf", 25, 34, TRUE,
                  "IFB no. 34.pdf", 23, 37, TRUE,
                  "IFB No. 53 National survey of Sea lice in Fish farms 2021.pdf",  26, 35, TRUE) |>
    semi_join(tibble(file = basename(file)))


  pdf_output <- pdfs |>
    filter(good) |>
    drop_na(start, end) |>
    pmap(safely(extract_ireland_pdf))

  combined_pdf <- pdf_output |>
    map("result") |>
    list_rbind() |>
    mutate(date = dmy(date),
           gravid_lep = as.numeric(gravid_lep),
           total_lep = as.numeric(total_lep),
           year = year(date)) |>
    rename(lice = gravid_lep, total_lice = total_lep) |>
    filter(year(date) > 2007) |> # different rules before 2008
    mutate(date2 = set_year(date, 2020),
           limit = if_else(between(date2, ymd("2020-3-1"), ymd("2020-5-31")), 0.5, 2)) |>
    select(-date2)

  combined_pdf
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
