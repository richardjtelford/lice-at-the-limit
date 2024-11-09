#### run rdds ####
run_rdd <- function(all_data) {
  rdds <- list(
    scotland = rdd_wrap(all_data$scotland, lice, 2, xlim = c(1.5, 2.5), step = 0.02), #
    britishColumbia = rdd_wrap(all_data$britishColumbia, lice, 3, xlim = c(2.5, 3.5), step = 0.02, xlabel = "Number of Motile Lice")
  )

  norway0.5 <- set_names(2012:2024) |>
    map(\(y) rdd_wrap(all_data$norway |> filter(year == y, limit != 0.2), lice, 0.5, xlim = c(0.2, 0.8)))

  norway0.2 <- set_names(2017:2024) |>
    map(\(y) rdd_wrap(all_data$norway |> filter(year == y, limit == 0.2), lice, 0.2, xlim = c(0.1, 0.3)))
  list(rdds = rdds, norway0.5 = norway0.5, norway0.2 = norway0.2)
}

# extract t  statistics from rdds objects
extract_t_stats <- function(rdds) {
  bcis_t <- map(rdds$rdds, "jump") |>
    map(rdd_extract) |>
    list_rbind(names_to = "wherewhen")

  norway_t <- bind_rows(
    `0.5` = map(rdds$norway0.5, "jump") |>
      map(rdd_extract) |>
      list_rbind(names_to = "year"),
    `0.2` = map(rdds$norway0.2, "jump") |>
      map(rdd_extract) |>
      list_rbind(names_to = "year"),
    .id = "limit"
  ) |>
    mutate(year = as.numeric(year))

  # combine
   bind_rows(
    bcis_t,
    norway_t |> #filter(limit == 0.5, year %in% c(2012, 2020)) |>
      mutate(wherewhen = paste0("n_", year))
  )
}

# preformat stats for text

extract_stats_text <- function(t_stats) {
  stats_text <- t_stats |>
    mutate(T = round(T, 2), p = format.pval(p, digits = 2, eps = 0.001)) |>
    purrr::transpose() |>
    (\(x)set_names(x, t_stats$wherewhen))() |>
    map(\(.x)glue::glue("t = {.x$T}, p = {.x$p}"))

  stats_text
}

### selected RDD plots
plot_rdds <- function(rdds) {
  rdds$rdds$britishColumbia$plot$Estplot +
    rdds$rdds$scotland$plot$Estplot +
    rdds$norway0.5$`2012`$plot$Estplot +
    rdds$norway0.5$`2020`$plot$Estplot +
    plot_annotation(tag_levels = "A") &
    theme(plot.tag.location = "plot")
}

### Norway t-statistics plot
plot_norway_t <- function(t_stats) {
  t_stats |>
    filter(str_detect(wherewhen, "n_\\d{4}")) |>
    ggplot(aes(x = year, y = T, colour = limit, linetype = limit)) +
    geom_line() +
    geom_point(fill = "white", shape = 21) +
    geom_point(aes(shape = p < 0.05)) +
    labs(y = "t-statistic for discontinuity", x = "Year", colour = "Lice limit", linetype = "Lice limit") +
    scale_color_brewer(palette = "Set1") +
    scale_shape_manual(values = c(1, 16))
}
