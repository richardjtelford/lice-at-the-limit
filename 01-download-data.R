# download lice count data
library(rvest)
library(tidyverse)

#### Iceland ####
# Just data from arnarlax

# iceland
fs::dir_create("data/iceland")
fs::dir_create("data/iceland/pdf")


# get list of links on arnarlax website
links <- read_html("https://arnarlax.is/sustainability/quality/") |>
  html_nodes("a") |>
  html_attr("href") |>
  str_subset("pdf") |>
  str_subset("20231219-5.2.8-IPM-Arnarlax.pdf", negate = TRUE) |> # not a louse report
  str_replace("pdff", "pdf") # fix typo

# corrupt link
"https://arnarnes-G19-overview-lax.is/wp-content/uploads/Tjalda1.pdf"


# download pdfs
for (link in links) {
  cat("trying", basename(link), "\n")
  if (!file.exists(paste0("data/iceland/pdf/", basename(link)))) {
    tryCatch(
      {
        download.file(link, paste0("data/iceland/pdf/", basename(link)))
      },
      error = function(e) {
        cat("error with download", link, "\n")
      }
    )
    Sys.sleep(1)
  }
}


#### Norway ####

# URL for data https://www.barentswatch.no/data/fishhealth/lice

# select
# - All localities
# - years 2012 - 2024
# - Week 1 - 52
# - excel format
# The download and put into the data/norway directory

# It might be possible to download the data directly through the API, but it might need registration

fs::dir_create("data/norway")
message(
  "Please download the norwegian data manually from https://www.barentswatch.no/data/fishhealth/lice and save it to data/norway/lakselus_per_fisk.xlsx"
)

#### Scotland ####

# URL for data https://scottishepa.maps.arcgis.com/apps/webappviewer/index.html
fs::dir_create("data/scotland")
download.file(
  "https://map.sepa.org.uk/sealice/ms_sea_lice.zip",
  destfile = "data/scotland/ms_sea_lice.zip"
)


#### British Columbia Canada ####

# URL for data https://www.pac.dfo-mpo.gc.ca/aquaculture/reporting-rapports/index-eng.html
# https://open.canada.ca/data/en/dataset/3cafbe89-c98b-4b44-88f1-594e8d28838d/resource/f6a948f3-504c-34b0-ac30-58a6b06981e6

fs::dir_create("data/british-columbia")
download.file(
  url = "https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/3cafbe89-c98b-4b44-88f1-594e8d28838d/attachments/lice-count-dens-pou-2011-ongoing-rpt-pac-dfo-mpo-aquaculture-eng.csv",
  destfile = "data/british-columbia/lice-count-dens-pou-2011-ongoing-rpt-pac-dfo-mpo-aquaculture-eng.csv"
)

#### Ireland ####

# download reports from https://www.marine.ie/site-area/areas-activity/aquaculture/sea-lice/sea-lice

# ireland0 <- read_delim("data/ireland/lice-extracted.csv")
# ireland_filled <- ireland0 |>
#   drop_na(data) |>
#   fill(report, year, bay, company, site, species, cohort) |>
#   filter(!is.na(data))
#
# ireland_filled |>
#   count(report, year)
# nrow(ireland_filled)
#
# ireland_1 <- ireland_filled |>
#   filter(is.na(gravid_lep)) |>
#   filter(is.na(notes)) |>
#   filter(!str_detect(data, "-")) |>
#   select(-(gravid_lep:total_cal)) |># arrange(nchar(data)) |> select(-c(report, year, bay, company, species, cohort, notes))
#   separate_wider_regex(#too_few = "debug",
#     cols = data,
#     patterns = c(date = "\\d{2}/\\d{2}/\\d{4}",
#                    gravid_lep = "\\d+\\.\\d{2}",
#                 total_lep = "\\d+\\.\\d{2}",
#                   gravid_cal = "\\d+\\.\\d{2}",
#                   total_cal = "\\d+\\.\\d{2}")) |>
#   mutate(date = dmy(date),
#          self = FALSE,
#          across(gravid_lep:total_cal, as.numeric))
#
#
# ireland_2 <- ireland_filled |>
#   filter(!is.na(gravid_lep)) |>
#   rename(date = data) |>
#   mutate(date = dmy(date),
#          self = str_detect(gravid_cal, "-"),
#          gravid_cal = if_else(str_detect(gravid_cal, "-"), NA, gravid_cal),
#          gravid_cal = as.numeric(gravid_cal),
#          self = FALSE)
#
# ireland_3 <- ireland_filled |> # covid era data with self counts
#   filter(is.na(gravid_lep)) |>
#   filter(is.na(notes)) |>
#   filter(str_detect(data, "-")) |>
#   select(-(gravid_lep:total_cal)) |>
#   separate_wider_regex(#too_few = "debug",
#     cols = data,
#     patterns = c(date = "\\d{2}/\\d{2}/\\d{4}",
#                  gravid_lep = "\\d+\\.\\d{2}",
#                  total_lep = "\\d+\\.\\d{2}",
#                  gravid_cal = "-",
#                  total_cal = "\\d+\\.\\d{2}")) |>
#
#   mutate(self = TRUE,
#     date = dmy(date),
#     gravid_cal = NA,
#          across(gravid_lep:total_cal, as.numeric))
#
# # combine
# ireland <- bind_rows(ireland_1, ireland_2, ireland_3) |>
#   select(-notes)
#
#
#
# ireland |>
#   filter(gravid_lep > 0, species == "Atlantic salmon") |>
#   ggplot(aes(x = gravid_lep, fill = species)) +
#   geom_histogram(binwidth = 0.01, center = 0.005) +
#   coord_cartesian(xlim = c(0, 3))
#

### from pdf

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
)

extract_ireland_pdf <- function(file, start, end, too_few = "error", ...) {
  file <- file.path("data/ireland/pdf/", file)
  extract <- tabulapdf::extract_text(file, pages = start:end)
  extract |>
    str_split("\\n") |>
    unlist() |>
    str_trim() |>
    str_subset(".+") |> # remove empty rows
    str_subset("\\d{2}/\\d{2}/\\d{4} \\d") |>
    str_extract("\\d{2}/\\d{2}/\\d{4}.*") |>
    str_remove(" n[=|<]\\d{1,2}") |>
    tibble(x = _) |>
    separate_wider_regex(
      cols = x,
      too_few = too_few,
      patterns = c(
        date = "\\d{2}/\\d{2}/\\d{4}",
        " ",
        gravid_lep = "\\d+\\.\\d{2}",
        " ",
        total_lep = "\\d+\\.\\d{2}",
        " ",
        gravid_cal = "\\d+\\.\\d{2}",
        " ",
        total_cal = "\\d+\\.\\d{2}"
      )
    )
}


pdf_output <- pdfs |>
  filter(good) |>
  drop_na(start, end) |>
  pmap(safely(extract_ireland_pdf))


combined_pdf <- pdf_output |>
  map("result") |>
  list_rbind() |>
  mutate(date = dmy(date), gravid_lep = as.numeric(gravid_lep))

combined_pdf |>
  ggplot(aes(x = date, y = gravid_lep)) +
  geom_point()


bad_optput <- pdfs |>
  filter(good) |>
  filter(
    pdf_output |>
      map("error") |>
      map_lgl(negate(is.null))
  ) |>
  pmap(safely(extract_ireland_pdf))

bad_optput
