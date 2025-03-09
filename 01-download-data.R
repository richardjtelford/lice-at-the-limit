# download lice count data
library(rvest)
library(tidyverse)

#### Iceland ####
# Just data from arnarlax

# iceland
fs::dir_create("data/iceland")
fs::dir_create("data/iceland/pdf")


# get list of links on arnarlax website
links_iceland <- read_html("https://arnarlax.is/sustainability/quality/") |>
  html_nodes("a") |>
  html_attr("href") |>
  str_subset("pdf") |>
  str_subset("20231219-5.2.8-IPM-Arnarlax.pdf", negate = TRUE) |> # not a louse report
  str_replace("pdff", "pdf") # fix typo

# corrupt link
"https://arnarnes-G19-overview-lax.is/wp-content/uploads/Tjalda1.pdf"


# download pdfs
for (link in links_iceland) {
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

fs::dir_create("data/norway")

# URL for data https://www.barentswatch.no/data/fishhealth/lice

# select
# - All localities
# - years 2012 - 2024
# - Week 1 - 52
# - excel format
# The download and put into the data/norway directory

# It should be possible to download the data directly through the API, but it needs authentication. More effort to set up authentication than to download manually.

# norway_download <- httr::GET(
#   url = "https://www.barentswatch.no/bwapi/v1/geodata/download/fishhealth?",
#
#   query = list(
#     "localityno" = "undefined",
#     "reporttype" = "lice",
#     "fromyear" = "2025",
#     "toyear" = "2025",
#     "fromweek" = "1",
#     "toweek" = "10",
#     "filetype" = "xlsx"
#   )
# )
#
#
# # save the file
# writeBin(norway_download$content, con = "data/norway/lakselus_per_fisk_tmp.xlsx")

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

fs::dir_create("data/ireland")
fs::dir_create("data/ireland/pdf")

# Website is erratic. Some links are direct to pdf, others are to a page with a link to the pdf
# Need to make list of pdf to download manually

# get list of links on www.marine.ie website
links_ireland <- c(
  `2023` = "https://www.marine.ie/sites/default/files/MIFiles/Docs/Aquaculture/IrishFisheriesBulletin55.pdf",
  `2022` = "https://www.marine.ie/sites/default/files/MIFiles/Docs/Aquaculture/FisheriesBulletinNo.54.pdf",
  `2021` = "https://www.marine.ie/sites/default/files/MIFiles/Docs/Aquaculture/IFB%20No.%2053%20%20National%20survey%20of%20Sea%20lice%20in%20Fish%20farms%202021.pdf",
  `2020` = "https://www.marine.ie/sites/default/files/MIFiles/docs/Aquaculture/Irish%20Fisheries%20Bulletin%20No.%2052.pdf",
  `2019` = "https://oar.marine.ie/bitstream/handle/10793/1590/Irish%20Fisheries%20Bulletin%20No.%2050.pdf?sequence=1&isAllowed=y",
  `2018` = "https://www.marine.ie/sites/default/files/MIFiles/Images/Aquaculture/Irish%20Fisheries%20Bulletin%20No.%2049%202019.pdf",
  `2017` = "https://oar.marine.ie/bitstream/handle/10793/1352/Irish%20Fisheries%20Bulletin%20No.%2048%20-%20Annual%20report%202018.pdf?sequence=5&isAllowed=y",
  `2016` = "https://www.marine.ie/sites/default/files/MIFiles/Docs/Aquaculture/Irish%20Fisheries%20Bulletin%20No.%2047%20-%20Annual%20report%202017.pdf",
  `2015` = "https://oar.marine.ie/bitstream/handle/10793/1146/Fisheries%20Bulletin%20No.%2046.pdf?sequence=1&isAllowed=y",
  `2014` = "https://oar.marine.ie/bitstream/handle/10793/1078/Irish%20Fisheries%20Bulletin%20No%2045.pdf?sequence=1&isAllowed=y",
  `2013` = "https://oar.marine.ie/bitstream/handle/10793/955/No%2044%202014%20National%20Survey%20of%20Sea%20Lice%20on%20Fish%20Farms%20in%20Ireland%202013%20%28with%20cover%29%20A4.pdf?sequence=1&isAllowed=y",
  `2012` = "https://oar.marine.ie/bitstream/handle/10793/861/No.41.%202013.%20National%20Survey%20of%20sea%20lice%20on%20fish%20farms%20in%20Ireland%202012%20%28with%20cover%29%20A4.pdf?sequence=6&isAllowed=y",
  `2011` = "https://oar.marine.ie/bitstream/handle/10793/776/Irish%20Fisheries%20Bulletin%20No40-National%20Survey%20of%20Sea%20Lice%202011.pdf?sequence=1&isAllowed=y",
  `2010` = "https://oar.marine.ie/bitstream/handle/10793/104/IFB%20no.%2034.pdf?sequence=1&isAllowed=y",
  `2009` = "https://oar.marine.ie/bitstream/handle/10793/32/Irish%20Fisheries%20Bulletin%20No%2033.pdf?sequence=1&isAllowed=y",
  `2008` = "https://oar.marine.ie/bitstream/handle/10793/196/No32%20Irish%20Fisheries%20Bulletin.pdf?sequence=1&isAllowed=y"
)

# download pdfs
for (link in links_ireland) {
  base <- basename(link) |> str_remove("\\?.*$")
  cat("trying", base, "\n")
  if (!file.exists(paste0("data/ireland/pdf/", base))) {
    tryCatch(
      {
        download.file(link, paste0("data/ireland/pdf/", base))
      },
      error = function(e) {
        cat("error with download", link, "\n")
      }
    )
    Sys.sleep(1)
  }
}
