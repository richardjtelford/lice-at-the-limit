rdd_wrap <- function(
  .data,
  count_var,
  limit,
  xlim = c(0, 5),
  step = 0.01,
  xlabel = "Number of Adult Female Lice",
  include_zero = FALSE,
  ...
) {
  counts <- .data |>
    drop_na({{ count_var }}) |>
    filter({{ count_var }} > if_else(include_zero, -1, 0)) |>
    pull({{ count_var }})

  jump <- rddensity(counts, c = limit, p = 3)

  xlim <- c(xlim[1] + step / 2, xlim[2] - step / 2)
  plot <- rdplotdensity(
    jump,
    counts,
    plotRange = xlim,
    histBreaks = seq(xlim[1], xlim[2], by = step),
    noPlot = TRUE,
    ylabel = "Density",
    xlabel = xlabel,
    histFillShade = 0.7,
    ...
  )

  list(jump = jump, plot = plot)
}


rdd_extract <- function(rdd) {
  tibble(
    T = rdd$jump$test$t_jk,
    p = rdd$jump$test$p_jk,
    before = rdd$plot$Estl$Estimate[nrow(rdd$plot$Estl$Estimate), "f_p"],
    after = rdd$plot$Estr$Estimate[1, "f_p"]
  )
}


## extract data from irish pdfs

extract_ireland_pdf <- function(file, start, end, too_few = "error", ...) {
  file <- file.path("data/ireland/pdf/", file)
  extract <- tabulapdf::extract_text(file, pages = start:end)
  extracted_tibble <- extract |>
    str_split("\\n") |>
    unlist() |>
    str_trim() |>
    str_subset(".+") |> # remove empty rows
    str_subset("\\d{2}/\\d{2}/\\d{4} \\d") |>
    str_extract("\\d{2}/\\d{2}/\\d{4}.*") |>
    str_remove(" n[=|<]\\d{1,2}") |>
    tibble(x = _)

  complete <- extracted_tibble |>
    filter(str_detect(
      x,
      "\\d{2}/\\d{2}/\\d{4} \\d+\\.\\d{2} \\d+\\.\\d{2} \\d+\\.\\d{2} \\d+\\.\\d{2}"
    )) |>
    separate_wider_regex(
      cols = x,
      too_few = too_few,
      patterns = c(
        date = "\\d{2}/\\d{2}/\\d{4}",
        " ",
        gravid_lep = "\\d+\\.\\d{2}",
        " ",
        total_lep = "\\d+\\.\\d{2}",
        " ",
        gravid_cal = "\\d+\\.\\d{2}",
        " ",
        total_cal = "\\d+\\.\\d{2}"
      )
    )

  col_missing <- extracted_tibble |> # 2020 covid data
    filter(str_detect(
      x,
      "\\d{2}/\\d{2}/\\d{4} \\d+\\.\\d{2} \\d+\\.\\d{2}  \\d+\\.\\d{2}"
    )) |>
    separate_wider_regex(
      cols = x,
      too_few = too_few,
      patterns = c(
        date = "\\d{2}/\\d{2}/\\d{4}",
        " ",
        gravid_lep = "\\d+\\.\\d{2}",
        " ",
        total_lep = "\\d+\\.\\d{2}",
        "  ",
        total_cal = "\\d+\\.\\d{2}"
      )
    )

  with_hyphen <- extracted_tibble |> # 2021 covid data
    filter(str_detect(x, "-")) |>
    separate_wider_regex(
      cols = x,
      too_few = too_few,
      patterns = c(
        date = "\\d{2}/\\d{2}/\\d{4}",
        " ",
        gravid_lep = "\\d+\\.\\d{2}",
        " ",
        total_lep = "\\d+\\.\\d{2}",
        " ",
        gravid_cal = "-",
        " ",
        total_cal = "\\d+\\.\\d{2}"
      )
    ) |>
    mutate(gravid_cal = na_if(gravid_cal, "-"))

  bind_rows(complete, with_hyphen, col_missing)
}

# set_year function to help identify time periods
set_year <- function(date, year) {
  year(date) <- year
  date
}


# extract text from iceland pdfs
extract_iceland <- function(file) {
  print(file)
  ice <- tabulapdf::extract_text(file) |>
    str_split_1("\n") |>
    str_subset("ASC", negate = TRUE)

  ice2 <- ice[-(1:(1 + str_which(ice, "Lice")))] |>
    str_subset("Average|number", negate = TRUE) |>
    tibble(x = _) |>
    mutate(what = if_else(str_detect(x, "/"), "date", "lice"))

  if (ice2[nrow(ice2), "x"] == "") {
    ice2 <- ice2[-nrow(ice2), ]
  }

  ice3 <- ice2 |>
    filter(what == "lice") |>
    mutate(lice = as.numeric(x)) |>
    select(lice)

  ice3
}
