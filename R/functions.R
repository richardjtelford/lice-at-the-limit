rdd_wrap <- function(.data, count_var, limit, xlim = c(0, 5), step = 0.01, xlabel = "Number of Adult Female Lice", ...) {
  counts <- .data |>
    drop_na({{count_var}}) |>
#    filter({{count_var}} > 0) |>
    pull({{count_var}})


  jump <-  rddensity(counts, c = limit, p = 3)

  xlim <- c(xlim[1] + step/2, xlim[2] - step/2)
  plot <- rdplotdensity(jump, counts, plotRange = xlim, histBreaks = seq(xlim[1], xlim[2], by = step), noPlot = TRUE, ylabel = "Density", xlabel = xlabel, histFillShade = 0.7, ...)

  list(jump = jump, plot = plot)


}


rdd_extract <- function(jump){
  tibble(
    T = jump$test$t_jk,
    p = jump$test$p_jk
  )

}
