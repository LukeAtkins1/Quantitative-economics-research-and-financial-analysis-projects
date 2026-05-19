# Algorithmic Trading Strategy: EMA Crossover with Multi-Factor Filters

**Author:** Luke Atkins  
**Course:** R Lab Final Project — UC Santa Cruz (MS Quantitative Economics & Finance)  
**Date:** March 2025

---

## Overview

This project builds and backtests a rules-based algorithmic trading strategy using technical indicators. The strategy uses a combination of trend-following and momentum signals to generate buy and sell decisions, then benchmarks performance against a simple buy-and-hold approach.

Developed as part of a broader exploration of quantitative trading signals and their application to equity and cryptocurrency markets.

---

## Strategy Logic

**Buy Signal** (all conditions must be true):
- Golden Cross: 50-day EMA crosses above 200-day EMA (uptrend confirmation)
- RSI < 70 (not overbought)
- ATR > 1% of price (sufficient volatility to trade)
- ADX > 30 (strong directional trend)

**Sell Signal:**
- Death Cross: 50-day EMA crosses below 200-day EMA
- RSI > 30 (not in oversold territory)

**Stop-Loss:**
- Dynamic 5% trailing stop-loss applied on all long positions
- Position exits if price drops below the stop-loss level, regardless of signal state

**Look-Ahead Bias Prevention:**
- All signals are lagged by one period — trades execute the day after a signal fires

---

## What the Code Does

1. **Data fetch** — pulls SPY (S&P 500 ETF) daily OHLCV data from Yahoo Finance (2021-2023)
2. **Indicator calculation** — computes EMA(50), EMA(200), RSI(14), ATR(14), ADX(14)
3. **Signal generation** — encodes buy/sell/hold as +1/-1/0
4. **Stop-loss loop** — applies dynamic 5% stop-loss logic iteratively
5. **Return calculation** — multiplies daily asset returns by lagged signals
6. **Performance metrics** — annualized return and hit ratio
7. **Visualization** — cumulative and daily return comparison plots (strategy vs. buy-and-hold)

---

## Data

SPY (SPDR S&P 500 ETF Trust) price data fetched live from Yahoo Finance via the `quantmod` package. No data download required.

To apply this strategy to Bitcoin, change the ticker on line 38:
```r
getSymbols("BTC-USD", src = "yahoo", from = "2021-01-01", to = "2023-12-31")
```

---

## Requirements

```r
install.packages(c("quantmod", "TTR", "PerformanceAnalytics", "ggplot2", "plotly"))
```

---

## How to Run

1. Clone or download this repository
2. Open `ema_trading_strategy.R` in RStudio
3. Run the script — no external data files needed (price data fetches automatically)

---

## Results (SPY, 2021-2023)

| Metric | Value |
|---|---|
| Annualized Return | See console output |
| Hit Ratio | See console output |
| Benchmark | Buy-and-Hold SPY |

Results vary based on market conditions. The 2021-2023 window captures a full bull-to-bear-to-recovery cycle, providing a meaningful stress test for the strategy.

---

## Limitations

- Backtesting does not account for transaction costs, slippage, or bid-ask spreads
- EMA crossover strategies are inherently lagging — they perform better in trending markets and poorly in sideways/choppy conditions
- The ATR and ADX thresholds were set heuristically and would benefit from parameter optimization (e.g., grid search or walk-forward analysis)
- Single-asset backtest; results may not generalize across asset classes

---

## Skills Demonstrated

`R` `quantmod` `TTR` `PerformanceAnalytics` `algorithmic trading` `technical analysis` `backtesting` `stop-loss logic` `time-series analysis` `data visualization`
