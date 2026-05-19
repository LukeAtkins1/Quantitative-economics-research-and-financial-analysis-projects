# ============================================================
# Bitcoin Social Media Sentiment vs. Price Analysis
# Author: Luke Atkins
# Course: R Lab Final Project — UC Santa Cruz
# Date: March 2025
#
# Description:
#   This script analyzes the relationship between Bitcoin-related
#   social media activity and BTC price movements. It ingests a
#   dataset of Bitcoin tweets, cleans and processes hashtag data,
#   fetches live BTC price data from Yahoo Finance, merges the
#   two sources by timestamp, and visualizes tweet volume
#   alongside price over time.
#
# Data:
#   Tweet data sourced from a publicly available Bitcoin tweets
#   dataset (e.g., Kaggle: "Bitcoin Tweets" by Kaushik Suresh).
#   Download the CSV and update the file path below before running.
#   Price data is fetched live from Yahoo Finance via quantmod.
#
# Requirements:
#   Install required packages before running:
#   install.packages(c("tidyverse", "quantmod", "lubridate",
#                      "stringr", "readr", "ggplot2"))
# ============================================================

# Clear workspace
rm(list = ls())

# ---- Load Libraries ----
library(tidyverse)       # Data manipulation and visualization
library(quantmod)        # Financial data from Yahoo Finance
library(lubridate)       # Date/time handling
library(stringr)         # String operations
library(readr)           # CSV reading
library(ggplot2)         # Plotting


# ============================================================
# SECTION 1: Load and Clean Tweet Data
# ============================================================

# Update this path to where you saved the Bitcoin tweets CSV
tweets <- read.csv("data/Bitcoin_tweetsexcel.csv")

# Inspect the data
colnames(tweets)
head(tweets)

# Clean hashtag column: remove brackets and quotes from list-formatted strings
tweets$hashtag_cleaned <- gsub("\\[|\\]|'", "", tweets$hashtag)

# Split comma-separated hashtags into individual tags
tweets$hashtag_split <- strsplit(tweets$hashtag_cleaned, ", ")

# Preview cleaned hashtags
head(tweets$hashtag_split)

# Count how many tweets reference Bitcoin/BTC in the hashtag column
btc_hashtag_count <- sum(sapply(tweets$hashtag_split, function(x) {
  sum(grepl("Bitcoin|BTC|btc", x, ignore.case = TRUE))
}))
cat("Bitcoin/BTC hashtag mentions:", btc_hashtag_count, "\n")

# Count Bitcoin references in the text body column (column K)
btc_text_count <- sum(grepl("bitcoin|Bitcoin|BTC|btc", tweets$K, ignore.case = TRUE))
cat("Bitcoin/BTC text body mentions:", btc_text_count, "\n")


# ============================================================
# SECTION 2: Aggregate Tweet Volume by Hour
# ============================================================

# Ensure timestamp column is in POSIXct format
tweets$created_at <- as.POSIXct(tweets$created_at,
                                 format = "%Y-%m-%d %H:%M:%S",
                                 tz = "UTC")

# Group tweets by hour and count volume
tweet_volume <- tweets %>%
  mutate(hour = floor_date(created_at, "hour")) %>%
  group_by(hour) %>%
  summarise(mentions = n(), .groups = "drop")

head(tweet_volume)


# ============================================================
# SECTION 3: Fetch Bitcoin Price Data from Yahoo Finance
# ============================================================

# Pull 30 days of BTC-USD daily closing prices
getSymbols("BTC-USD", src = "yahoo", from = Sys.Date() - 30, auto.assign = TRUE)

# Convert xts object to clean dataframe
btc_prices <- data.frame(Date = index(`BTC-USD`), coredata(`BTC-USD`)) %>%
  select(Date, Close = BTC.USD.Close)

# Convert Date to POSIXct for merging with hourly tweet data
btc_prices$Date <- as.POSIXct(btc_prices$Date)

head(btc_prices)


# ============================================================
# SECTION 4: Merge Tweet Volume with Price Data
# ============================================================

# Join on timestamp (tweet hour matches price date)
merged_data <- merge(tweet_volume, btc_prices,
                     by.x = "hour", by.y = "Date",
                     all.x = TRUE)

head(merged_data)


# ============================================================
# SECTION 5: Visualization — Price vs. Tweet Volume
# ============================================================

# Dual-axis chart: BTC price (line) and tweet volume (bars)
ggplot(merged_data, aes(x = hour)) +
  geom_line(aes(y = Close, color = "Bitcoin Price (USD)"), size = 1.2) +
  geom_bar(aes(y = mentions * 100, fill = "Tweet Volume"),
           stat = "identity", alpha = 0.4) +
  scale_y_continuous(
    name = "Bitcoin Price (USD)",
    sec.axis = sec_axis(~ . / 100, name = "Tweet Volume (hourly mentions)")
  ) +
  scale_color_manual(values = c("Bitcoin Price (USD)" = "orange")) +
  scale_fill_manual(values = c("Tweet Volume" = "steelblue")) +
  labs(
    title = "Bitcoin Price vs. Twitter Mention Volume",
    subtitle = "Hourly tweet volume overlaid with daily BTC-USD closing price",
    x = "Time",
    color = NULL,
    fill = NULL
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "top")
