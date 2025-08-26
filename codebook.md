# Codebook
The codebook specifies the data types, possible values, and other information for each column in the data files.

## Table of contents

- [Word features](#word-features)
- [Participants](#participants)

## Word features
The word-level linguistic and lexical features, combined with reading measures (ET) or self-paced reading measures (SPR), plus psycholinguistic predictor variables.

### Common columns
These columns are present in **both ET and SPR** datasets.

| Column name                   | Possible values                           | Value type   | Description                                                                                                           |
|--------------------------------|------------------------------------------|--------------|-----------------------------------------------------------------------------------------------------------------------|
| subj_id                        | e.g., zh1, zh2 … (Zürich participants); pt1, pt2 … (Potsdam participants) | String       | Unique participant identifier. Prefix indicates data collection site (zh = Zürich, pt = Potsdam).                      |
| text_id                        | 0–11                                     | Integer      | Identifier of the text stimulus (matches `text_id` in [Reading measures](#reading-measures)).                         |
| screen_id                      | 1–n                                      | Integer      | Identifier of the screen on which the word was presented.                                                             |
| word_id                        | 1–n                                      | Integer      | Identifier of the word within the screen.                                                                             |
| session_id                     | e.g., “1”                                | String       | Identifier of the recording session.                                                                                  |
| word                           | token string                             | String       | The word as presented to the participant (surface form).                                                              |
| w_in_sent_id                   | ≥1                                       | Integer      | Position of the word in the sentence.                                                                                 |
| word_length                    | ≥1                                       | Integer      | Number of characters in the current word.                                                                             |
| word_length_word_n_minus_1/-2  | ≥1 or NA                                 | Integer      | Word length of the previous (n-1) or pre-previous (n-2) word.                                                         |
| lex_freq                       | continuous (log frequency values)        | Float        | Lexical frequency of the current word.                                                                                |
| lex_freq_word_n_minus_1/-2     | continuous or NA                         | Float        | Lexical frequency of previous (n-1) or pre-previous (n-2) word.                                                       |
| lex_freq_unk                   | TRUE/FALSE                               | Boolean      | Indicates whether the word frequency was unknown in the lexicon.                                                      |
| surprisal                      | continuous                               | Float        | Surprisal of the current word (negative log-probability from a language model).                                       |
| surprisal_word_n_minus_1/-2    | continuous or NA                         | Float        | Surprisal of the previous (n-1) or pre-previous (n-2) word.                                                           |
| n_rights, n_lefts              | integer                                  | Float        | Number of right or left dependents of the current word in the dependency parse.                                       |
| n_lefts_word_n_minus_1/-2      | integer or NA                            | Float        | Number of left dependents of the previous words.                                                                      |
| dep_distance                   | continuous                               | Float        | Dependency distance of the current word (head-dependent linear distance).                                             |
| dep_distance_word_n_minus_1/-2 | continuous or NA                         | Float        | Dependency distance of the previous (n-1, n-2) words.                                                                 |
| deps                           | e.g., “nk”, “oa”, “sb”, “ROOT”           | String       | Dependency relation label of the word (according to German dependency grammar, e.g., subject (sb), object (oa), root).|
| contains_punctuation           | {True, False}                            | Boolean      | Whether the token contains punctuation.                                                                               |
| session_label                  | e.g., “ET1”, “SPR1”                      | String       | Label for the recording session (e.g., Eye-tracking session, Self-paced reading session).                              |
| modality                       | {“ET”, “SPR”}                            | String       | Modality of the data collection (Eye-tracking = ET, Self-paced reading = SPR).                                        |

### ET-specific columns
These columns are present **only in the Eye-tracking (ET)** dataset.

| Column name                   | Possible values          | Value type   | Description                                                                                                           |
|--------------------------------|--------------------------|--------------|-----------------------------------------------------------------------------------------------------------------------|
| FFD                            | ≥0                       | Float        | First-fixation duration: duration of the first fixation on a word if this word is fixated in first-pass reading, otherwise 0. |
| SFD                            | ≥0                       | Float        | Single-fixation duration: duration of the only first-pass fixation on a word, 0 if the word was skipped or more than one fixation occurred in the first-pass (equals FFD in case of a single first-pass fixation). |
| FD                             | ≥0                       | Float        | First duration: duration of the first fixation on a word (identical to FFD if not skipped in the first-pass). |
| FPRT                           | ≥0                       | Float        | First-pass reading time: sum of the durations of all first-pass fixations on a word (0 if the word was skipped in the first-pass). |
| FRT                            | ≥0                       | Float        | First-reading time: sum of the duration of all fixations from first fixating the word until leaving the word for the first time. |
| TFT                            | ≥0                       | Float        | Total-fixation time: sum of all fixations on a word (FPRT+RRT). |
| RRT                            | ≥0                       | Float        | Re-reading time: sum of the durations of all fixations on a word that do not belong to the first-pass (TFT-FPRT). |
| RPD_inc                        | ≥0                       | Float        | Inclusive regression-path duration: Sum of all fixation durations starting from the first first-pass fixation on a word until fixation on a word to the right of this word (including all regressive fixations on previous words), 0 if the word was not fixated in the first-pass. |
| RPD_exc                        | ≥0                       | Float        | Exclusive regression-path duration: Sum of all fixation durations after initiating a first-pass regression from a word until fixating a word to the right of this word, without counting fixations on the word itself. |
| RBRT                           | ≥0                       | Float        | Right-bounded reading time: Sum of all fixation durations on a word until a word to the right of this word is fixated. |
| Fix                            | {0,1}                    | Categorical  | Fixation: 1 if the word was fixated, otherwise 0. |
| FPF                            | {0,1}                    | Categorical  | First-pass fixation: 1 if the word was fixated in the first-pass, otherwise 0. |
| RR                             | {0,1}                    | Categorical  | Re-reading: 1 if the word was fixated after the first-pass reading, otherwise 0. |
| FPReg                          | {0,1}                    | Categorical  | First-pass regression: 1 if a regression was initiated in the first-pass reading of the word, otherwise 0. |
| TRC_out                        | ≥0                       | Float        | Total count of outgoing regressions: total number of regressive saccades initiated from this word. |
| TRC_in                         | ≥0                       | Float        | Total count of incoming regressions: total number of regressive saccades landing on this word. |
| LP                             | ≥0                       | Float        | Landing position: position of the first saccade on the word expressed by ordinal position of the fixated character. |
| SL_in                          | Integer (±)              | Float        | Incoming saccade length: length of the saccade that leads to first fixation on a word in number of words; positive if progressive, negative if regression. |
| SL_out                         | Integer (±)              | Float        | Outgoing saccade length: length of the first saccade that leaves the word in number of words; positive if progressive, negative if regression; 0 if the word is never fixated. |
| TFC                            | ≥0                       | Float        | The total fixation count on the word. |

### SPR-specific columns
These columns are present **only in the Self-paced reading (SPR)** dataset.

| Column name | Possible values | Value type | Description                                                             |
|-------------|-----------------|------------|-------------------------------------------------------------------------|
| word_rt     | ≥0              | Float      | Word-level self-paced reading time in milliseconds.                     |

---

## Participants
Participant-level information including psychometric test scores and task performance.  
Psychometric tests were administered before the reading experiments. In Zürich (DILiLab), each participant completed two eye-tracking and two self-paced reading sessions.  

- Participant IDs follow the scheme:  
  - **zh1, zh2, …**: Zürich participants  
  - **pt1, pt2, …**: Potsdam participants  

Psychometric tests included:  

- **SLRT-II**: Lese- und Rechtschreibtest (word and pseudoword reading speed)  
- **MWT-B**: Mehrfachwahl-Wortschatz-Intelligenztest (vocabulary knowledge)  
- **RIAS**: Reynolds Intellectual Assessment Scales and Screening (verbal, non-verbal, and general intelligence indices)  
- **FAIR-2**: Frankfurter Aufmerksamkeits-Inventar (attention indices)  
- **WMC tasks**: working memory measures (MU, OS, SS, SSTM)  
- **Stroop and Simon tasks**: inhibitory control measures  

| Column name          | Possible values  | Value type | Description                                                                 |
|-----------------------|-----------------|------------|-----------------------------------------------------------------------------|
| subj                 | 1–n             | Integer    | Unique participant ID.                                                      |
| SLRTWord             | Integer         | Integer    | Word reading score (SLRT-II).                                               |
| SLRTPseudo           | Integer         | Integer    | Pseudoword reading score (SLRT-II).                                         |
| MWTPR                | Float           | Float      | Vocabulary knowledge score (MWT-B).                                         |
| RIASVixPR            | Float           | Float      | Verbal intelligence index (RIAS).                                           |
| RIASNixPR            | Float           | Float      | Non-verbal intelligence index (RIAS).                                       |
| RIASGixPR            | Float           | Float      | General intelligence index (RIAS).                                          |
| FAIRLPR, FAIRQPR, FAIRKPR | Integer    | Integer    | FAIR-2 attention test scores (various indices: L, Q, K).                     |
| MUmean, OSmean, SSmean, SSTMRelScore | Float | Float | Working memory task scores (Memory updating, Operation span, Symmetry span, Short-term memory). |
| total_memory         | Float/NA        | Float      | Composite working memory score.                                             |
| StrAccuracyEffect    | Float           | Float      | Stroop task accuracy effect.                                                |
| StrRTEffect          | Float           | Float      | Stroop task reaction time effect.                                           |
| SimAccuracyEffect    | Float           | Float      | Simon task accuracy effect.                                                 |
| SimRTEffect          | Float           | Float      | Simon task reaction time effect.                                            |
