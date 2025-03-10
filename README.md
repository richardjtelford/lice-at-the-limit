
# Lice at the limit

<!-- badges: start -->
<!-- badges: end -->

This repository contains code to reproduce Telford (2024) "Lice at the limits: circumvention of regulatory limits on salmon lice counts in aquaculture facilities"

To reproduce the manuscript, install R 4.4.2 and RStudio. Then clone the repo, and open the `lice-at-the-limit.Rproj` file using RStudio. This will open the project.

The project uses `renv` to manage the package dependencies. Run `renv::restore()` to install the correct version of all packages used.

The next step is to download the lice count data. R script `01-download-data.R` helps with this.
It will 
 
 - Download Icelandic louse data
-  Download Irish louse data 
 - Download Scottish louse data
 - Download British Columbian louse data
 - Give instructions for downloading Norwegian louse data
 
 The Norwegian data need downloading manually - there is an API but registration as complex as simply downloading the data.

The pipeline that processes all the data and produces the manuscript is managed by the `targets` package. File `0-make.R` will initiate the process.
