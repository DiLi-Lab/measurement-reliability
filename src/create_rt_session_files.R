#!/usr/bin/env Rscript
rm(list=ls())

# load the necessary packages
source("src/packages.R")

# Preprocessing
preprocess <- function(reading_df) {
  # Placeholder value for NAs
  placeholder_value <- 1e20

  reading_df$dep_distance_word_n_minus_1[is.na(reading_df$dep_distance_word_n_minus_1)] <- placeholder_value
  reading_df$dep_distance_word_n_minus_2[is.na(reading_df$dep_distance_word_n_minus_2)] <- placeholder_value

  # Set dep_distance < 0 to 0
  reading_df[reading_df$dep_distance < 0, ]$dep_distance <- 0
  reading_df[reading_df$dep_distance_word_n_minus_1 < 0, ]$dep_distance_word_n_minus_1 <- 0
  reading_df[reading_df$dep_distance_word_n_minus_2 < 0, ]$dep_distance_word_n_minus_2 <- 0

  reading_df$dep_distance_word_n_minus_1[reading_df$dep_distance_word_n_minus_1 == placeholder_value] <- NA
  reading_df$dep_distance_word_n_minus_2[reading_df$dep_distance_word_n_minus_2 == placeholder_value] <- NA

  # Remove rows that only consist of digits
  reading_df <- reading_df[reading_df$word != "-", ]
  reading_df <- reading_df[!grepl("[^O][0-9][.,]?[^A-Za-z][^-S]", reading_df$word), ]

  # Convert columns to factors
  reading_df$subj_id <- as.factor(reading_df$subj_id)
  reading_df$session_id <- factor(reading_df$session_id)
  reading_df$session_label <- as.factor(reading_df$session_label)

  # Handle lex_freq_word_n_minus_* columns
  reading_df$lex_freq <- as.numeric(reading_df$lex_freq)
  reading_df$lex_freq_word_n_minus_1[is.na(reading_df$lex_freq_word_n_minus_1)] <- placeholder_value
  reading_df$lex_freq_word_n_minus_2[is.na(reading_df$lex_freq_word_n_minus_2)] <- placeholder_value

  # Calculate minimum lex_freq excluding placeholders
  min_lex_freq <- min(reading_df$lex_freq[reading_df$lex_freq > 0], na.rm = TRUE)

  # Replace invalid values for lex_freq_word_n_minus_* columns
  reading_df$lex_freq <- as.numeric(reading_df$lex_freq)
  reading_df$lex_freq[reading_df$lex_freq <= 0 ] <- min_lex_freq
  reading_df$lex_freq_word_n_minus_1 <- as.numeric(reading_df$lex_freq_word_n_minus_1)
  reading_df$lex_freq_word_n_minus_1[reading_df$lex_freq_word_n_minus_1 <= 0 ] <- min_lex_freq
  reading_df$lex_freq_word_n_minus_2 <- as.numeric(reading_df$lex_freq_word_n_minus_2)
  reading_df$lex_freq_word_n_minus_2[reading_df$lex_freq_word_n_minus_2 <= 0 ] <- min_lex_freq

  # Restore lex_freq_word_n_minus_* placeholders to NA
  reading_df$lex_freq_word_n_minus_1[reading_df$lex_freq_word_n_minus_1 == placeholder_value] <- NA
  reading_df$lex_freq_word_n_minus_2[reading_df$lex_freq_word_n_minus_2 == placeholder_value] <- NA

  # Log transformations
  reading_df$lex_freq <- log(reading_df$lex_freq)
  reading_df$lex_freq_word_n_minus_1 <- log(reading_df$lex_freq_word_n_minus_1)
  reading_df$lex_freq_word_n_minus_2 <- log(reading_df$lex_freq_word_n_minus_2)

  reading_df <- normalize(reading_df)
  return(reading_df)
}

normalize <- function(reading_df) {
  # normalize all predictors
  reading_df$lex_freq <- as.vector(scale(reading_df$lex_freq))
  reading_df$lex_freq_word_n_minus_1 <- as.vector(scale(reading_df$lex_freq_word_n_minus_1))
  reading_df$lex_freq_word_n_minus_2 <- as.vector(scale(reading_df$lex_freq_word_n_minus_2))
  reading_df$surprisal <- as.vector(scale(reading_df$surprisal))
  reading_df$surprisal_word_n_minus_1 <- as.vector(scale(reading_df$surprisal_word_n_minus_1))
  reading_df$surprisal_word_n_minus_2 <- as.vector(scale(reading_df$surprisal_word_n_minus_2))
  reading_df$word_length <- as.vector(scale(reading_df$word_length))
  reading_df$word_length_word_n_minus_1 <- as.vector(scale(reading_df$word_length_word_n_minus_1))
  reading_df$word_length_word_n_minus_2 <- as.vector(scale(reading_df$word_length_word_n_minus_2))
  reading_df$dep_distance <- as.vector(scale(reading_df$dep_distance))
  reading_df$dep_distance_word_n_minus_1 <- as.vector(scale(reading_df$dep_distance_word_n_minus_1))
  reading_df$dep_distance_word_n_minus_2 <- as.vector(scale(reading_df$dep_distance_word_n_minus_2))
  reading_df$n_lefts <- as.vector(scale(reading_df$n_lefts))
  reading_df$n_lefts_word_n_minus_1 <- as.vector(scale(reading_df$n_lefts_word_n_minus_1))
  reading_df$n_lefts_word_n_minus_2 <- as.vector(scale(reading_df$n_lefts_word_n_minus_2))
  return(reading_df)
}

zh_et <- read.csv(file = "data/reading_data/zh_et.csv", header = TRUE)
# add "zh" to all subj_ids in zh
zh_et$subj_id <- paste0("zh", zh_et$subj_id)
pt_et <- read.csv(file = "data/reading_data/pt_et.csv", header = TRUE)
# add "pt" to all subj_ids in pt
pt_et$subj_id <- paste0("pt", pt_et$subj_id)
all_et <- rbind(zh_et, pt_et)
all_et$modality <-  "ET"
only_et_columns <- colnames(all_et)[7:26]

zh_spr <- read.csv(file = "data/reading_data/zh_spr.csv", header = TRUE)
zh_spr$subj_id <- paste0("zh", zh_spr$subj_id)
zh_spr$modality <- "SPR"
only_spr_columns <- "word_rt"

# combine et and spr data, preprocess together, then split again
all_et_spr <- bind_rows(all_et, zh_spr)
all_et_spr_preproc <- preprocess(all_et_spr)

# split
all_et_preproc <- all_et_spr_preproc[all_et_spr_preproc$modality == "ET",]
indico_spr_preproc <- all_et_spr_preproc[all_et_spr_preproc$modality == "SPR",]

# remove columns only_spr_columns from et data
all_et_preproc <- all_et_preproc[, !(colnames(all_et_preproc) %in% only_spr_columns)]
# remove columns only_et_columns from spr data
indico_spr_preproc <- indico_spr_preproc[, !(colnames(indico_spr_preproc) %in% only_et_columns)]

write.csv(all_et_preproc, file = "data/model_input/et.csv")
write.csv(indico_spr_preproc, file = "data/model_input/spr.csv")