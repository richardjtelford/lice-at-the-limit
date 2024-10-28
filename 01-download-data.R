# download lice count data

#### Norway ####

# URL for data https://www.barentswatch.no/data/fishhealth/lice

# select
# - All localities
# - years 2012 onwards (2024 to replicate exactly)
# - Week 1 to present (43 to replicate exactly)
# - excel format
# The download and put into the data/norway directory

# It might be possible to download the data directly through the API, but it might need registration

fs::dir_create("data/norway")
warning("Please download the norwegian data manually from https://www.barentswatch.no/data/fishhealth/lice and save it to data/norway/lakselus_per_fisk.xlsx")

#### Scotland ####

# URL for data https://scottishepa.maps.arcgis.com/apps/webappviewer/index.html
fs::dir_create("data/scotland")
download.file("https://map.sepa.org.uk/sealice/ms_sea_lice.zip", destfile = "data/scotland/ms_sea_lice.zip")


#### British Columbia Canada

# URL for data https://www.pac.dfo-mpo.gc.ca/aquaculture/reporting-rapports/index-eng.html
# https://open.canada.ca/data/en/dataset/3cafbe89-c98b-4b44-88f1-594e8d28838d/resource/f6a948f3-504c-34b0-ac30-58a6b06981e6

fs::dir_create("data/british-columbia")
download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/3cafbe89-c98b-4b44-88f1-594e8d28838d/attachments/lice-count-dens-pou-2011-ongoing-rpt-pac-dfo-mpo-aquaculture-eng.csv", destfile = "data/british-columbia/lice-count-dens-pou-2011-ongoing-rpt-pac-dfo-mpo-aquaculture-eng.csv")
