library(targets)

# prepare package list for renv
# tar_renv(extras = "visNetwork")

# run targets pipeline
tar_make()

# visualize the pipeline
tar_visnetwork()

# zip tex file
zip::zip(
  "manuscript.zip",
  c(
    "lice-at-the-limit.tex",
    list.files("lice-at-the-limit_files/figure-pdf/", full.names = TRUE),
    "aft.cls"
  )
)
