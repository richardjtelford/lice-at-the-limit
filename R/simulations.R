# simulate count uncertainty
simulate_count_uncertainty <- function() {
  set.seed(42)
  nsim <- 10000
  nfish <- 100
  true <- runif(nsim, 0, 0.5)

  counted <- tibble(value = rpois(nsim, true * nfish) / nfish)

  #  rdd_sim <- rdd_wrap(counted, value, 0.5, xlim = c(0.3, 0.7), step = 0.01)

  p <- ggplot(counted, aes(x = value)) +
    geom_histogram(
      binwidth = 0.01,
      boundary = 0.005
    ) +
    geom_vline(xintercept = 0.5, colour = "#99151c", linetype = "dashed") +
    labs(
      x = "Simulated number of adult female lice per fish",
      y = "Number of surveys"
    )
  p
}



# simulate optimal stopping #
simulate_optimal_stopping <- function() {
  set.seed(42)

  # simulation
  nsim <- 10000
  true_mean <- 0.5
  threshold <- 0.5
  noriginal <- 50
  nextra <- 10


  opt_stop_sim <- tibble(
    true_mean = true_mean,
    count = rpois(nsim, noriginal * true_mean),
    extra = rpois(nsim, nextra * true_mean),
    original = count / noriginal,
    final = (count + extra) / (noriginal + nextra),
  ) |>
    mutate(final = if_else(original > threshold, final, original)) |>
    summarise(
      mean_original = mean(original),
      mean_stop = mean(final),
      thresh_original = mean(original > threshold) * 100,
      thresh_original = round(thresh_original, 1),
      thresh_final = mean(final > threshold) * 100,
      thresh_final = round(thresh_final, 1)
    ) |>
    mutate(
      nsim = nsim,
      threshold = threshold,
      true_mean = true_mean,
      noriginal = noriginal,
      nextra = nextra
    )

  opt_stop_sim
}
