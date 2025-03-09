# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)

library(conflicted) # fix conflicts
conflict_prefer_all("dplyr", quiet = TRUE)

# Set target options:
tar_option_set(
  packages = c("tidyverse", "here", "glue", "rddensity", "patchwork") # Packages that your targets need for their tasks.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  #### files to watch ####
  tar_target(
    name = norway_file,
    command = here("data/norway/lakselus_per_fisk.xlsx"),
    format = "file"
  ),
  tar_target(
    name = scotland_file,
    command = here("data/scotland/ms_sea_lice.csv"),
    format = "file"
  ),
  tar_target(
    name = britishColumbia_file,
    command = here(
      "data/british-columbia/lice-count-dens-pou-2011-ongoing-rpt-pac-dfo-mpo-aquaculture-eng.csv"
    ),
    format = "file"
  ),
  tar_target(
    name = ireland_file,
    command = file.path(
      "data/ireland/pdf",
      list.files(
        here::here("data/ireland/pdf/"),
        pattern = "\\.pdf$",
        recursive = TRUE
      )
    ),
    format = "file"
  ),
  tar_target(
    name = ireland_2009,
    command = here("data/ireland/lice-extracted.csv"),
    format = "file"
  ),
  tar_target(
    name = iceland_file,
    command = file.path(
      "data/iceland/pdf",
      list.files(
        here::here("data/iceland/pdf/"),
        pattern = "\\.pdf$",
        recursive = TRUE
      )
    ),
    format = "file"
  ),

  #### load data ####
  tar_target(
    name = all_data,
    command = load_all_data(
      norway = norway_file,
      scotland = scotland_file,
      britishColumbia = britishColumbia_file,
      ireland = ireland_file,
      ireland_2009 = ireland_2009,
      iceland = iceland_file
    )
  ),

  #### find periods ####
  tar_target(
    name = periods,
    command = find_periods(all_data)
  ),

  #### lice histograms ####
  tar_target(
    name = lice_hist,
    command = make_histograms(all_data)
  ),

  #### rdd ####
  tar_target(
    name = rdds,
    command = run_rdd(all_data)
  ),

  tar_target(
    name = t_stats,
    command = extract_t_stats(rdds)
  ),

  tar_target(
    name = stats_text,
    command = extract_stats_text(t_stats)
  ),

  tar_target(
    name = rdds_plots,
    command = plot_rdds(rdds)
  ),

  tar_target(
    name = norway_effect_plot,
    command = plot_norway_effect(t_stats)
  ),

  #### simulations ####
  tar_target(
    name = count_uncertainty,
    command = simulate_count_uncertainty()
  ),
  tar_target(
    name = optimal_stopping,
    command = simulate_optimal_stopping()
  ),

  #### more figures ####
  tar_target(
    name = fig_2013_plot,
    command = make_2013_plot(all_data)
  ),
  tar_target(
    name = fig_compliance_plot,
    command = make_compliance_plot(all_data)
  ),

  #### manuscript ####
  tar_quarto(
    name = manuscript,
    path = "lice-at-the-limit.qmd",
    extra_files = "lice.bib"
  )
)
