# Codebook
The codebook specifies the data types and other information for each column in the data files.

## Table of contents

- [Word features](#word-features)
- [Participants](#participants)

## Word features
The word-level linguistic and lexical features, combined with reading measures (ET) or self-paced reading measures (SPR), plus psycholinguistic predictor variables.

### Common columns
These columns are present in **both ET and SPR** datasets.

| Column name | Value type | Description |
|--------------------------------|--------------|-----------------------------------------------------------------------------------------------------------------------|
| subj_id | String | Unique participant identifier. Prefix indicates data collection site (zh = Zürich, pt = Potsdam). |
| text_id | Integer | Identifier of the text stimulus. |
| screen_id | Integer | Identifier of the screen on which the word was presented. |
| word_id | Integer | Identifier of the word within the screen. |
| session_id | String | Identifier of the recording session. |
| w_in_sent_id | Integer | Position of the word in the sentence. |
| word_length | Integer | Number of characters in the current word. |
| word_length_word_n_minus_1/-2 | Integer | Word length of the previous (n-1) or pre-previous (n-2) word. |
| lex_freq | Float | Normalized lemma frequency for the current word (lemma-based). Values come from an external lexicon/website and are normalized by dividing by a constant of ~122.323 (as provided by the dlexdb). |
| lex_freq_word_n_minus_1/-2 | Float | Normalized lemma frequency for the previous (n-1) or pre-previous (n-2) word |
| lex_freq_unk | Boolean | Indicates whether the word frequency was unknown in the lexicon. |
| surprisal | Float | Surprisal of the current word (negative log-probability from a language model). |
| surprisal_word_n_minus_1/-2 | Float | Surprisal of the previous (n-1) or pre-previous (n-2) word. |
| n_rights, n_lefts | Float | Number of right or left dependents of the current word in the dependency parse. |
| n_lefts_word_n_minus_1/-2 | Float | Number of left dependents of the previous words. |
| dep_distance | Float | Dependency distance of the current word (head-dependent linear distance). |
| dep_distance_word_n_minus_1/-2 | Float | Dependency distance of the previous (n-1, n-2) words. |
| deps | String | Dependency relation label of the word (according to German dependency grammar, e.g., subject (sb), object (oa), root). |
| contains_punctuation | Boolean | Whether the token contains punctuation. |
| session_label | String | Label for the recording session (e.g., Eye-tracking session, Self-paced reading session). |
| modality | String | Modality of the data collection (Eye-tracking = ET, Self-paced reading = SPR). |

### ET-specific columns
These columns are present **only in the Eye-tracking (ET)** dataset. All durations are in milli-seconds.

| Column name | Value type | Description |
|--------------------------------|--------------|-----------------------------------------------------------------------------------------------------------------------|
| FFD | Float | First-fixation duration: duration of the first fixation on a word if this word is fixated in first-pass reading, otherwise 0. |
| SFD | Float | Single-fixation duration: duration of the only first-pass fixation on a word, 0 if the word was skipped or more than one fixation occurred in the first-pass (equals FFD in case of a single first-pass fixation). |
| FD | Float | First duration: duration of the first fixation on a word (identical to FFD if not skipped in the first-pass). |
| FPRT | Float | First-pass reading time: sum of the durations of all first-pass fixations on a word (0 if the word was skipped in the first-pass). |
| FRT | Float | First-reading time: sum of the duration of all fixations from first fixating the word until leaving the word for the first time. |
| TFT | Float | Total-fixation time: sum of all fixations on a word (FPRT+RRT). |
| RRT | Float | Re-reading time: sum of the durations of all fixations on a word that do not belong to the first-pass (TFT-FPRT). |
| RPD_inc | Float | Inclusive regression-path duration: Sum of all fixation durations starting from the first first-pass fixation on a word until fixation on a word to the right of this word (including all regressive fixations on previous words), 0 if the word was not fixated in the first-pass. |
| RPD_exc | Float | Exclusive regression-path duration: Sum of all fixation durations after initiating a first-pass regression from a word until fixating a word to the right of this word, without counting fixations on the word itself. |
| RBRT | Float | Right-bounded reading time: Sum of all fixation durations on a word until a word to the right of this word is fixated. |
| Fix | Categorical | Fixation: 1 if the word was fixated, otherwise 0. |
| FPF | Categorical | First-pass fixation: 1 if the word was fixated in the first-pass, otherwise 0. |
| RR | Categorical | Re-reading: 1 if the word was fixated after the first-pass reading, otherwise 0. |
| FPReg | Categorical | First-pass regression: 1 if a regression was initiated in the first-pass reading of the word, otherwise 0. |
| TRC_out | Float | Total count of outgoing regressions: total number of regressive saccades initiated from this word. |
| TRC_in | Float | Total count of incoming regressions: total number of regressive saccades landing on this word. |
| SL_in | Float | Incoming saccade length: length of the saccade that leads to first fixation on a word in number of words; positive if progressive, negative if regression. |
| SL_out | Float | Outgoing saccade length: length of the first saccade that leaves the word in number of words; positive if progressive, negative if regression; 0 if the word is never fixated. |
| TFC | Float | The total fixation count on the word. |

### SPR-specific columns
These columns are present **only in the Self-paced reading (SPR)** dataset.

| Column name | Value type | Description |
|-------------|------------|-------------------------------------------------------------------------|
| word_rt | Float | Word-level self-paced reading time in milliseconds. |

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

| Column name | Value type | Description |
|-----------------------|------------|-----------------------------------------------------------------------------|
| subj | Integer | Unique participant ID. |
| SLRTWord | Integer | Word reading score (SLRT-II). |
| SLRTPseudo | Integer | Pseudoword reading score (SLRT-II). |
| MWTPR | Float | Vocabulary knowledge score (MWT-B). |
| RIASVixPR | Float | Verbal intelligence index (RIAS). |
| RIASNixPR | Float | Non-verbal intelligence index (RIAS). |
| RIASGixPR | Float | General intelligence index (RIAS). |
| FAIRLPR, FAIRQPR, FAIRKPR | Integer | FAIR-2 attention test scores (various indices: L, Q, K). |
| MUmean, OSmean, SSmean, SSTMRelScore | Float | Working memory task scores (Memory updating, Operation span, Symmetry span, Short-term memory). |
| total_memory | Float | Composite working memory score. |
| StrAccuracyEffect | Float | Stroop task accuracy effect. |
| StrRTEffect | Float | Stroop task reaction time effect. |
| SimAccuracyEffect | Float | Simon task accuracy effect. |
| SimRTEffect | Float | Simon task reaction time effect. |
