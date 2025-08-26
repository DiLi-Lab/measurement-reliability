#!/usr/bin/env Rscript
rm(list = ls())

# load the necessary packages
source("src/packages.R")

option_list <- list(
  make_option(
    c("-m", "--measure"),
    type = "character", default = NULL,
    help = "reading measure to regress on"
  ),
  make_option(
    c("-s", "--spillover"),
    action = "store_true", default = FALSE,
    help = "include spillover predictors"
  )
)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

n_cores <- parallel::detectCores()
options(mc.cores = n_cores)

RESPONSE_VARIABLE <- opt$measure
spillover_formula <- value ~ 1 + s1 + word_length + lex_freq + surprisal + dep_distance + n_lefts + (0 + s1 + s2 + (word_length + lex_freq + surprisal + dep_distance + n_lefts + word_length_word_n_minus_1 + lex_freq_word_n_minus_1 + surprisal_word_n_minus_1 + dep_distance_word_n_minus_1 + n_lefts_word_n_minus_1):s1 + (word_length + lex_freq + surprisal + dep_distance + n_lefts + word_length_word_n_minus_1 + lex_freq_word_n_minus_1 + surprisal_word_n_minus_1 + dep_distance_word_n_minus_1 + n_lefts_word_n_minus_1):s2 | subj_id)
no_spillover_formula <- value ~ 1 + s1 + word_length + lex_freq + surprisal + dep_distance + n_lefts + (0 + s1 + s2 + (word_length + lex_freq + surprisal + dep_distance + n_lefts):s1 + (word_length + lex_freq + surprisal + dep_distance + n_lefts):s2 | subj_id)

N_ITER <- 2000
N_WARMUP <- 1000

if (opt$spillover) {
  model_formula <- spillover_formula
} else {
  model_formula <- no_spillover_formula
}

if (RESPONSE_VARIABLE %in% c("SPR", "FPRT", "RPD_inc", "TFT")) {
  PRIOR_DIST <- c(
    prior(normal(6, 1), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(exponential(2), class = sigma),
    prior(lkj(2), class = cor)
  )
  FAM <- "lognormal()"
} else if (RESPONSE_VARIABLE %in% c("FPReg", "SKIP")) {
  PRIOR_DIST <- c(
    prior(normal(0, 1), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(lkj(2), class = cor)
  )
  FAM <- "bernoulli(link = 'logit')"
} else if (RESPONSE_VARIABLE == "N_FIX") {
  PRIOR_DIST <- c(
    prior(normal(0, 1), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(lkj(2), class = cor)
  )
  FAM <- "zero_inflated_poisson()"
} else if (RESPONSE_VARIABLE == "FD") {
  PRIOR_DIST <- c(
    prior(normal(5.5, 0.1), class = Intercept),
    prior(normal(0, 0.1), class = b),
    prior(exponential(2), class = sd),
    prior(exponential(2), class = sigma),
    prior(lkj(2), class = cor)
  )
  FAM <- "lognormal()"
  N_ITER <- 4000
  N_WARMUP <- 2000
} else {
  stop("Invalid measure")
}

et_measures_col <- c("FFD", "SFD", "FD", "FPRT", "FRT", "TFT", "RRT", "RPD_inc", "RPD_exc", "RBRT", "N_FIX", "FPReg", "SKIP")
et_measures_to_remove <- et_measures_col[et_measures_col != RESPONSE_VARIABLE]
spr_measures_col <- c("SPR")

if (RESPONSE_VARIABLE == "SPR") {
  reading_data <- read.csv("data/fit_input/spr.csv", header = TRUE, row.names = 1) %>%
    rename(SPR = word_rt) %>%
    gather(key = "measures", value = "value", all_of(spr_measures_col)) %>%
    mutate(
      mean = mean(value, na.rm = TRUE),
      sd = sd(value, na.rm = TRUE)
    ) %>%
    filter(value <= (mean + 5 * sd)) %>%
    dplyr::select(-mean, -sd, -lex_freq_unk, -n_rights, -deps, -contains_punctuation) %>%
    mutate(subj_id = as.factor(subj_id)) %>%
    mutate(
      s1 = ifelse(session_label == "SPR1", 1, 0),
      s2 = ifelse(session_label == "SPR2", 1, 0)
    ) %>%
    filter(measures == RESPONSE_VARIABLE)
} else if (RESPONSE_VARIABLE %in% et_measures_col) {
  reading_data <- read.csv("data/fit_input/et.csv", header = TRUE, row.names = 1) %>%
    mutate(SKIP = ifelse(FPRT == 0, 1, 0)) %>%
    gather(key = "measures", value = "value", all_of(RESPONSE_VARIABLE)) %>%
    group_by(measures) %>%
    mutate(
      mean = mean(value, na.rm = TRUE),
      sd = sd(value, na.rm = TRUE)
    ) %>%
    filter((measures %in% c("N_FIX", "FPReg", "SKIP")) | value <= (mean + 5 * sd)) %>%
    dplyr::select(c(-mean, -sd, -Fix, -FPF, -RR, -TRC_out, -TRC_in, -LP, -SL_in, -SL_out, -lex_freq_unk, -n_rights, -deps, -contains_punctuation)) %>%
    dplyr::select(.dots = -et_measures_to_remove) %>%
    mutate(subj_id = as.factor(subj_id)) %>%
    mutate(
      s1 = ifelse(session_label == "ET1", 1, 0),
      s2 = ifelse(session_label == "ET2", 1, 0)
    ) %>%
    filter(measures == RESPONSE_VARIABLE)
} else {
  #  no valid measure
  stop("Invalid measure")
}

if (RESPONSE_VARIABLE %in% c("FD", "FPRT", "RPD_inc", "TFT", "SPR")) {
  reading_data <- reading_data %>%
    filter(value > 0)
}

model <- brms::brm(
  formula = model_formula,
  data = reading_data,
  chains = 4,
  family = eval(parse(text = FAM)),
  warmup = N_WARMUP,
  iter = N_ITER,
  file = paste0("./results/", "rao_spillover_", RESPONSE_VARIABLE),
  cores = n_cores,
  backend = "cmdstan",
  silent = 0,
  seed = 42,
  control = list(
    adapt_delta = 0.95,
    max_treedepth = 10
  ),
  prior = PRIOR_DIST
)

print("Done fitting models")
