# Replicate me if you can: Assessing measurement reliability of individual differences in reading across measurement occasions and methods

This repository contains the data and analysis pipeline for the paper:  
**"Replicate me if you can: Assessing measurement reliability of individual differences in reading across measurement occasions and methods"**

Our paper evaluates the stability and reliability of individual differences in reading behavior across **time (measurement occasions)** and **methods (eye-tracking vs. self-paced reading)**.  
The repository contains:  
- datasets of eye-tracking and self-paced reading measures,  
- psychometric scores,  
- R scripts for running temporal and cross-methodological reliability analyses,  
- R Markdown notebooks for extracting posteriors and generating the figures and tables from the paper.

---

## Data access

The annotated InDiCo data, model fits, and the results of the Bayesian correlation models can be pulled using:

```bash
cd measurement-reliability
sh pull_data.sh
```

---

## Repository structure

```
.
├── codebook.md                # Description of data fields and measures
├── data
│   ├── fit_input              # Prepared input data for reliability analyses
│   │   ├── et.csv             # Eye-tracking measures
│   │   └── spr.csv            # Self-paced reading measures
│   ├── psychometric_scores    # Psychometric assessment data
│   │   └── psychometric_scores.csv
│   └── reading_data           # Participant-level data
│       ├── pt_et.csv          # Eye-tracking data from Potsdam lab
│       ├── zh_et.csv          # Eye-tracking data from Zurich lab
│       └── zh_spr.csv         # Self-paced reading data from Zurich lab
├── README.md
├── results
│   └── rds_files              # Saved R model fits
├── src
│   ├── packages.R                             # R dependencies
│   ├── create_rt_session_files.R              # Create input files for reliability analysis scripts
│   ├── reliability_across_methods.R           # Cross-method reliability analysis
│   ├── reliability_across_occasions.R         # Temporal reliability analysis
│   ├── posterior_correlation_plot.Rmd         # Extract posterior distributions and generate plots/tables
│   ├── reliability_paradox_plots.Rmd          # Visualization of the results in the style of the reliability paradox
│   └── paradox_simulation.Rmd                 # Simulate and visualize the reliability paradox
└── stimuli
    └── lexical_features.csv   # Annotated lexical features used in some analyses
```

---

## Running the analyses

All scripts should be run from the root directory (`measurement-reliability`).

### 1. Reliability analyses

We provide two main R scripts to reproduce the core results. Both require running with `--vanilla` for a clean R session.

- **Across measurement occasions (temporal reliability):**  
  ```bash
  Rscript --vanilla src/reliability_across_occasions.R --measure FPRT
  ```
  use option --spillover to include spillover effects

- **Across methods (cross-method reliability):**  
  ```bash
  Rscript --vanilla src/reliability_across_methods.R --measure FPRT
  ```

These scripts fit Bayesian correlation models to estimate the reliability of individual differences.

**Available measures:** `FFD`, `FPReg`, `FPRT`, `N_FIX`, `RPD`, `SKIP`, `TFT`, `SPR`.

### 2. Extracting results and plotting

To reproduce the figures and tables in the paper:

- **Posterior correlations and summary tables:**  `src/posterior_correlation_plot.Rmd`

- **Reliability paradox visualizations:**  `src/reliability_paradox_plot_psy_correlation.Rmd`

Both scripts will generate figures and tables corresponding to those reported in the paper.

---

## Notes

- The raw experimental stimuli and full preprocessing pipeline (e.g., raw eye-tracking data) are not included here.
- Due to copyright restrictions, we are not permitted to distribute the original experimental stimulus texts in this repository.
- This repository is limited to the components necessary to replicate the **measurement reliability analyses**.
- All statistical analyses were performed in **R** with Bayesian hierarchical models. Dependencies are listed in `src/packages.R`.

