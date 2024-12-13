make_2013_plot <- function(all_data) {

norway_example <- all_data$norway |>
    filter(site == 11738, year == 2013) |> # site chosen because it had data throughout year and some data > 0.5
  mutate(newlice = if_else(lice > 0.5, lice * 0.1, lice))

excess <- norway_example |> summarise(lm = mean(lice), nlm = mean(newlice), rat = (lm - nlm)/nlm) |>
  mutate(pc = round(rat * 100, 1))


plot <- norway_example |>
  ggplot(aes(x = week, y = lice)) +
  geom_area(fill = "grey") +
  geom_ribbon(aes(ymin = newlice, ymax = lice), fill = "#99151c") +
  geom_line() +
  geom_line(aes(y = newlice), linetype = "dashed") +
  labs(x = "Week", y = "Lice count")

list(plot = plot, excess = pull(excess, pc))
}


####
make_compliance_plot <- function(all_data){

  bind_rows(
    Norway = all_data$norway |>
      filter(limit != "Ukjent") |>
      mutate(limit = as.numeric(limit)) |>
      group_by(limit, year) |>
      summarise(below = mean(lice <= limit), .groups = "drop") |>
      mutate(limit = if_else(limit == 0.2, "Smolt migration", "Rest of year")),

    Scotland = all_data$scotland |>
      mutate(limit = 2) |>
      group_by(year, limit) |>
      summarise(below = mean(lice <= limit), .groups = "drop") |>
      mutate(limit = "Rest of year"),

    `British Columbia` = all_data$britishColumbia |>
      mutate(limit = 3) |>
      group_by(year, limit) |>

      summarise(below = mean(lice <= limit), .groups = "drop") |>
      mutate(limit = "Rest of year"),

    Ireland = all_data$ireland |>
      group_by(year, limit) |>
      summarise(below = mean(lice <= limit), .groups = "drop")|>
      mutate(limit = if_else(limit == 0.5, "Smolt migration", "Rest of year")),

    .id = "country"
  ) |>
    mutate(limit = factor(limit, levels = c("Smolt migration", "Rest of year"))) |>
    ggplot(aes(x = year, y = below, colour  = limit, shape = limit, linetype = limit)) +
    geom_point() +
    geom_line() +
    facet_wrap(vars(country)) +
    scale_y_continuous(labels = scales::label_percent()) +
    scale_colour_brewer(palette = "Set1") +
    labs(x = "Year", y = "Percent compliance", colour = "Season", shape = "Season", linetype = "Season") +
    theme(
      legend.position = "bottom"
    )

}
