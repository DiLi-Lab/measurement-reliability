#!/usr/bin/env Rscript
rm(list = ls())

# load the necessary packages
source("src/packages.R")

option_list <- list(
  make_option(
    c("-m", "--measure"),
    type = "character", default = NULL,
    help = "reading measure to compare SPR with"
  )
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

n_cores <- parallel::detectCores()
options(mc.cores = n_cores)

ET_COMPARISON_MEASURE <- opt$measure

N_ITER <- 2000
N_WARMUP <- 1000

PRIOR_DIST <- c(
  prior(normal(6, 1), class = Intercept),
  prior(normal(0, 1), class = b),
  prior(exponential(2), class = sd),
  prior(exponential(2), class = sigma),
  prior(lkj(2), class = cor)
)
FAM <- "lognormal()"

et_measures_col <- c("FFD", "SFD", "FD", "FPRT", "FRT", "TFT", "RRT", "RPD_inc", "RPD_exc", "RBRT", "N_FIX", "FPReg", "SKIP")
et_measures_to_remove <- et_measures_col[et_measures_col != ET_COMPARISON_MEASURE]
spr_measures_col <- c("SPR")

spr <- read.csv("data/fit_input/spr.csv", header = TRUE, row.names = 1) %>%
  rename(SPR = word_rt) %>%
  gather(key = "measures", value = "value", all_of(spr_measures_col)) %>%
  mutate(
    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE)
  ) %>%
  filter(value <= (mean + 5 * sd)) %>%
  dplyr::select(-mean, -sd, -lex_freq_unk, -n_rights, -deps, -contains_punctuation) %>%
  mutate(subj_id = as.factor(subj_id)) %>%
  filter(measures == "SPR")

et <- read.csv("data/fit_input/et.csv", header = TRUE, row.names = 1) %>%
  mutate(SKIP = ifelse(FPRT == 0, 1, 0)) %>%
  gather(key = "measures", value = "value", all_of(ET_COMPARISON_MEASURE)) %>%
  group_by(measures) %>%
  mutate(
    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE)
  ) %>%
  filter((measures %in% c("N_FIX", "FPReg", "SKIP")) | value <= (mean + 5 * sd)) %>%
  dplyr::select(c(-mean, -sd, -Fix, -FPF, -RR, -TRC_out, -TRC_in, -LP, -SL_in, -SL_out, -lex_freq_unk, -n_rights, -deps, -contains_punctuation)) %>%
  dplyr::select(.dots = -et_measures_to_remove) %>%
  mutate(subj_id = as.factor(subj_id)) %>%
  filter(measures == ET_COMPARISON_MEASURE)

overlap_subj <- intersect(et$subj_id, spr$subj_id)
et_overlap <- et %>% filter(subj_id %in% overlap_subj)
spr_overlap <- spr %>% filter(subj_id %in% overlap_subj)
et_spr_merge <- bind_rows(et_overlap, spr_overlap)

et_spr_merge <- et_spr_merge %>%
  mutate(
    m1 = ifelse(session_label %in% c("ET1", "ET2"), 1, 0),
    m2 = ifelse(session_label %in% c("SPR1", "SPR2"), 1, 0)
  ) %>%
  filter(value > 0)

model <- brms::brm(
  value ~ 1 + m1 + word_length + lex_freq + surprisal + dep_distance + n_lefts +
    (word_length_word_n_minus_1 + lex_freq_word_n_minus_1 + surprisal_word_n_minus_1 + dep_distance_word_n_minus_1 + n_lefts_word_n_minus_1):m1 +
    (0 + m1 + m2 + (word_length + lex_freq + surprisal + dep_distance + n_lefts):m1 +
      (word_length + lex_freq + surprisal + dep_distance + n_lefts):m2 | subj_id),
  data = et_spr_merge,
  chains = 4,
  family = eval(parse(text = FAM)),
  warmup = N_WARMUP,
  iter = N_ITER,
  file = paste0("./results/", "ram_spillover_spr_vs", ET_COMPARISON_MEASURE),
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
