# ============================================================
# Algorithmic Trading Strategy: EMA Crossover with Technical Indicators
# Author: Luke Atkins
# Course: R Lab Final Project — UC Santa Cruz
# Date: March 2025
#
# Description:
#   This script builds and backtests a technical indicator-based
#   trading strategy using S&P 500 (SPY) data as a proxy for
#   systematic equity analysis. The strategy uses:
#     - EMA Golden/Death Cross (50-day vs 200-day)
#     - RSI (Relative Strength Index) filter
#     - ATR (Average True Range) volatility filter
#     - ADX (Average Directional Index) trend strength filter
#     - Dynamic stop-loss logic (5% below entry)
#
#   Strategy returns are benchmarked against a simple
#   buy-and-hold approach using cumulative and daily return plots.
#
#   Note: Originally developed as part of a broader exploration
#   of quantitative trading signals and their application to
#   cryptocurrency and equity markets.
#
# Data:
#   SPY (S&P 500 ETF) price data fetched live from Yahoo Finance.
#   Date range: 2021-01-01 to 2023-12-31
#
# Requirements:
#   install.packages(c("quantmod", "TTR", "PerformanceAnalytics",
#                      "ggplot2", "plotly"))
# ============================================================

# Clear workspace
rm(list = ls())

# ---- Load Libraries ----
library(quantmod)             # Financial data and indicators
library(TTR)                  # Technical indicators (RSI, EMA, ATR, ADX)
library(PerformanceAnalytics) # Return and performance metrics
library(ggplot2)              # Static plots
library(plotly)               # Interactive plots


# ============================================================
# SECTION 1: Fetch Price Data
# ============================================================

# Fetch SPY (S&P 500 ETF) data from Yahoo Finance
# Change ticker to "BTC-USD" to apply to Bitcoin
getSymbols("SPY", src = "yahoo", from = "2021-01-01", to = "2023-12-31")
price_data <- `SPY`

# Extract closing prices and HLC (High-Low-Close) for indicator calculations
btc_prices <- Cl(price_data)


# ============================================================
# SECTION 2: Compute Technical Indicators
# ============================================================

# Exponential Moving Averages
ema_50  <- EMA(btc_prices, n = 50)   # Short-term trend
ema_200 <- EMA(btc_prices, n = 200)  # Long-term trend

# RSI: measures momentum (overbought > 70, oversold < 30)
rsi <- RSI(btc_prices, n = 14)

# ATR: measures volatility (Average True Range over 14 days)
atr <- ATR(HLC(price_data), n = 14)$atr

# ADX: measures trend strength (> 25 = strong trend)
adx <- ADX(HLC(price_data), n = 14)$ADX


# ============================================================
# SECTION 3: Define Buy and Sell Signals
# ============================================================

# Buy Signal: Golden Cross + RSI not overbought + sufficient volatility + strong trend
buy_signal <- ema_50 > ema_200 &   # Golden Cross
              rsi < 70 &            # Not overbought
              atr > 0.01 * btc_prices &  # Meaningful volatility
              adx > 30              # Strong directional trend

# Sell Signal: Death Cross + RSI not oversold
sell_signal <- ema_50 < ema_200 & rsi > 30

# Encode signals: 1 = Buy, -1 = Sell, 0 = Hold
signals <- ifelse(buy_signal, 1, ifelse(sell_signal, -1, 0))

# Lag signals by 1 period to prevent look-ahead bias
# (trade executes the day after the signal fires)
signals <- lag(signals, 1)


# ============================================================
# SECTION 4: Apply Stop-Loss Logic
# ============================================================

# Initialize stop-loss tracker
stop_loss_level <- rep(NA, length(btc_prices))

for (i in 2:length(signals)) {
  if (!is.na(signals[i])) {
    if (signals[i] == 1) {
      # New buy: set stop-loss 5% below entry price
      stop_loss_level[i] <- btc_prices[i] * 0.95

    } else if (signals[i] == -1 ||
               (!is.na(stop_loss_level[i-1]) && btc_prices[i] < stop_loss_level[i-1])) {
      # Sell if: sell signal fires OR price drops below stop-loss
      signals[i] <- -1
      stop_loss_level[i] <- NA

    } else {
      # Otherwise hold
      signals[i] <- 0
    }
  }
}


# ============================================================
# SECTION 5: Calculate Returns and Performance Metrics
# ============================================================

# Daily returns of the underlying asset
btc_returns <- dailyReturn(btc_prices)

# Strategy returns: apply signal to daily returns
strategy_returns <- btc_returns * signals
strategy_returns <- na.omit(strategy_returns)

# Performance summary
annualized_return <- Return.annualized(strategy_returns)
hit_ratio <- sum(strategy_returns > 0) / length(strategy_returns)

cat("--- Strategy Performance ---\n")
cat("Annualized Return:", round(annualized_return * 100, 2), "%\n")
cat("Hit Ratio (% of profitable days):", round(hit_ratio * 100, 2), "%\n")


# ============================================================
# SECTION 6: Benchmark vs. Buy-and-Hold
# ============================================================

buy_and_hold_returns <- dailyReturn(btc_prices)

# Cumulative returns
cumulative_strategy      <- cumprod(1 + strategy_returns) - 1
cumulative_buy_and_hold  <- cumprod(1 + buy_and_hold_returns) - 1
cumulative_returns <- merge(cumulative_strategy, cumulative_buy_and_hold)
colnames(cumulative_returns) <- c("Strategy", "Buy-and-Hold")


# ============================================================
# SECTION 7: Visualizations
# ============================================================

# Plot 1: Cumulative returns comparison
ggplot(fortify(cumulative_returns), aes(x = Index)) +
  geom_line(aes(y = Strategy, color = "Strategy"), size = 1) +
  geom_line(aes(y = `Buy-and-Hold`, color = "Buy-and-Hold"), size = 1) +
  scale_color_manual(values = c("Strategy" = "steelblue", "Buy-and-Hold" = "tomato")) +
  labs(
    title = "Cumulative Returns: EMA Crossover Strategy vs. Buy-and-Hold",
    subtitle = "SPY | 2021-2023 | 5% Stop-Loss | RSI + ATR + ADX Filters",
    x = "Date",
    y = "Cumulative Return",
    color = NULL
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "top")

# Plot 2: Daily returns comparison
comparison <- merge(strategy_returns, buy_and_hold_returns)
colnames(comparison) <- c("Strategy", "Buy-and-Hold")

ggplot(fortify(comparison), aes(x = Index)) +
  geom_line(aes(y = Strategy, color = "Strategy"), size = 0.8) +
  geom_line(aes(y = `Buy-and-Hold`, color = "Buy-and-Hold"), size = 0.8, alpha = 0.7) +
  scale_color_manual(values = c("Strategy" = "steelblue", "Buy-and-Hold" = "tomato")) +
  labs(
    title = "Daily Returns: Strategy vs. Buy-and-Hold",
    x = "Date",
    y = "Daily Return",
    color = NULL
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "top")
