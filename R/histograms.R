# make histograms


make_histograms <- function(all_data){


  scotland <- all_data$scotland |>
    mutate(group = glue::glue("Scotland {min(year)}-{max(year)}"),
           limit = 2)

  norway <- all_data$norway |>
    mutate(group = case_when(
      year == 2012 ~ "Norway 2012",
      between(year, 2017, 2024) & limit == 0.2 ~ "Norway 2017-2024 during smolt migration",
      between(year, 2017, 2024) & limit == 0.5 ~ "Norway 2017-2024 ex smolt season",
      between(year, 2013, 2016) & limit == 0.5 ~ "Norway 2013-2016",
      .default = "other"
    )) |>
    filter(group != "other") |>
    mutate(limit = as.numeric(limit)) # NA warning from 2012 data

  plot_data <- bind_rows(scotland, norway) |>
    mutate(group = factor(group, levels = c("Scotland 2021-2023", "Norway 2012", "Norway 2013-2016", "Norway 2017-2024 during smolt migration", "Norway 2017-2024 ex smolt season")))


  lice_hist <- plot_data |>
    filter(group %in% c("Scotland 2021-2023", "Norway 2012", "Norway 2013-2016", "Norway 2017-2024 ex smolt season")) |>
    filter(lice > 0) |>
    ggplot(aes(x = lice)) +
    geom_vline(aes(xintercept = limit), colour = "#99151c", linetype = "dashed") +
    geom_histogram(binwidth = 0.01, boundary = 0.005) +
    scale_x_continuous(expand = c(0.01, 0.01)) +
    coord_cartesian(xlim = c(0, 3)) +
    facet_wrap(facets = vars(group), scales = "free_y", ncol = 2) +
    labs(x = "Mean number of adult female lice per fish", y = "Number of surveys")

  lice_hist
}
