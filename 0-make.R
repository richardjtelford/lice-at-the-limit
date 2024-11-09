library(targets)

# prepare package list for renv
# tar_renv(extras = "visNetwork")

# run targets pipeline
tar_make()

# visualize the pipeline
tar_visnetwork()
