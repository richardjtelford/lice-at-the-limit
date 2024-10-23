
# Lice at the limit

<!-- badges: start -->
<!-- badges: end -->

This repository contains code to reproduce Telford et qui (2024) "Lice at the limit: impact of regulatory limits on lice counts in Norway and Scotland". 

To reproduce the manuscript, first clone the repo, then using RStudio open the `lice-at-the-limit.Rproj` file. This will open the project in RStudio.

The project uses `renv` to manage the package dependencies, which should be installed automatically.

The next step is to download the lice count data. R script `01-download-data.R` might do this. 
Or it might just say where the data can be downloaded from and which directories they need to be put in.

Now the quarto file `lice-at-the-limit.qmd` can be rendered to produce the manuscript by clicking on the blue render button.
