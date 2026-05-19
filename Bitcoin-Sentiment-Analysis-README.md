# Bitcoin Social Media Sentiment vs. Price Analysis

**Author:** Luke Atkins  
**Course:** R Lab Final Project — UC Santa Cruz (MS Quantitative Economics & Finance)  
**Date:** March 2025

---

## Overview

This project analyzes the relationship between Bitcoin-related social media activity and BTC price movements. The core question: does the volume of Bitcoin mentions on Twitter correlate with price changes?

The script ingests a large dataset of Bitcoin tweets, cleans and processes hashtag and text data, fetches live BTC-USD price data from Yahoo Finance, merges the two sources by timestamp, and produces a dual-axis visualization showing tweet volume alongside price over time.

---

## What the Code Does

1. **Data ingestion** — loads a CSV of Bitcoin tweets (~440K rows) and inspects structure
2. **Hashtag cleaning** — strips Python-style list formatting from the hashtag column and splits into individual tags
3. **Bitcoin mention counting** — counts occurrences of "Bitcoin", "BTC", "btc" across hashtag and text body columns
4. **Tweet volume aggregation** — groups tweets by hour and counts mentions per time window
5. **Price data fetch** — pulls 30 days of BTC-USD closing prices from Yahoo Finance via `quantmod`
6. **Data merge** — joins hourly tweet volume with daily price data on timestamp
7. **Visualization** — dual-axis chart with BTC price as a line and tweet volume as bars

---

## Data Sources

- **Tweet data:** Publicly available Bitcoin tweets dataset  
  Recommended source: [Kaggle — Bitcoin Tweets by Kaushik Suresh](https://www.kaggle.com/datasets/kaushiksuresh147/bitcoin-tweets)  
  Download the CSV and save it to a `data/` folder in the project directory.

- **Price data:** Fetched live from Yahoo Finance via the `quantmod` package (no download required)

---

## Requirements

Install the following R packages before running:

```r
install.packages(c("tidyverse", "quantmod", "lubridate", "stringr", "readr", "ggplot2"))
```

---

## How to Run

1. Clone or download this repository
2. Download the Bitcoin tweets CSV from Kaggle and place it at `data/Bitcoin_tweetsexcel.csv`
3. Open `bitcoin_sentiment_analysis.R` in RStudio
4. Run the script section by section or all at once

---

## Key Findings

- Bitcoin tweet volume shows notable spikes that align with periods of elevated price volatility
- Hashtag analysis reveals "BTC" and "Bitcoin" dominate co-occurring tags, with periodic shifts toward altcoin references during price drawdowns
- The visualization suggests a potential lag relationship between social media activity and price movement, though causality requires further modeling (e.g., Granger causality tests)

---

## Limitations

- Twitter API access restrictions limit real-time data collection; this analysis uses a static historical dataset
- Daily price granularity vs. hourly tweet volume creates alignment challenges in the merged dataset
- Sentiment scoring (positive/negative/neutral classification) is not implemented in this version — a natural extension would be to apply VADER or a custom lexicon-based scorer to the tweet text

---

## Skills Demonstrated

`R` `tidyverse` `quantmod` `data wrangling` `time-series alignment` `text cleaning` `data visualization` `financial data APIs`
