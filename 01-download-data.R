# download lice count data

# Norway

# URL for data https://www.barentswatch.no/data/fishhealth/lice

# select
# - All localities
# - years 2012 onwards (2024 to replicate exactly)
# - Week 1 to present (43 to replicate exactly)
# - excel format
# The download and put into the data/norway directory

# It might be possible to download the data directly through the API, but it might need registration

warning("Please download the norwegian data manually from https://www.barentswatch.no/data/fishhealth/lice and save it to data/norway/lakselus_per_fisk.xlsx")

# Scotland

# URL for data https://scottishepa.maps.arcgis.com/apps/webappviewer/index.html

download.file("https://map.sepa.org.uk/sealice/ms_sea_lice.zip", destfile = "data/scotland/ms_sea_lice.zip")
