# ETF Portfolio Construction & ARIMA Return Forecasting

**Author:** Luke Atkins  
**Course:** Econ 231 (International Finance) — UC Santa Cruz (MS Quantitative Economics & Finance)  
**Date:** 2025

---

## Overview

This project constructs and evaluates a two-ETF investment portfolio using a combination of asset pricing models and time-series forecasting. The analysis selects two ETFs across different asset classes and geographies, fits ARIMA models to forecast future returns, and applies mean-variance optimization to identify the optimal portfolio allocation.

**ETFs Analyzed:**
- **BNDX** — Vanguard Total International Bond ETF (international fixed income)
- **MSCI** — iShares MSCI ACWI ETF (global equities, developed and emerging markets)

---

## What the Code Does

### ARIMA Forecasting (`etf_arima_forecasting.do`)

1. **Data import** — loads monthly return data from Excel into Stata time-series format
2. **Model estimation:**
   - BNDX: `ARIMA(1,0,0)` — AR(1) process on stationary monthly returns
   - MSCI: `ARIMA(1,0,1)` — ARMA(1,1) process on monthly returns
3. **Multi-horizon forecasting** — produces 1-year, 3-year, and 5-year dynamic forecasts for each ETF
4. **Confidence intervals** — generates 90% confidence bands using forecast standard errors
5. **Visualization** — time-series plots with shaded forecast regions for all six forecast horizons

### Portfolio Optimization (`ARIMAfinalport.xlsx`)

The accompanying Excel file contains:
- Monthly price and return data for BNDX and MSCI (2013-2017)
- Calculated expected returns, variances, and covariance
- Portfolio frontier table across weight combinations (0% to 100% in each ETF)
- Optimal portfolio weights identified via Sharpe ratio maximization

**Key Portfolio Statistics (Optimal Allocation):**

| Metric | Value |
|---|---|
| Tech/Equity Weight (MSCI) | 74.95% |
| Bond Weight (BNDX) | 25.05% |
| Portfolio Expected Return | 1.00% / month |
| Portfolio Std Deviation | 3.18% / month |
| Sharpe Ratio | 0.1585 |
| Covariance (BNDX, MSCI) | -0.000330 |

The negative covariance between the two ETFs confirms meaningful diversification benefits — equity and international bond returns move in opposite directions, reducing overall portfolio volatility.

---

## Asset Pricing Models Applied

In addition to the ARIMA forecasting, the full project applied three asset pricing frameworks to evaluate each ETF:

- **CAPM** — estimated beta and expected return relative to market benchmark
- **Fama-French 3-Factor Model** — controlled for size (SMB) and value (HML) factors
- **APT (Arbitrage Pricing Theory)** — multi-factor sensitivity analysis

---

## Data

- **Return data:** Monthly closing prices sourced from Yahoo Finance
- **Sample period:** June 2013 onward
- **File:** `ARIMAfinalport.xlsx` (included in repository)

---

## Requirements

Stata 16+ with time-series capabilities. No additional packages required beyond base Stata.

To run:
1. Open `etf_arima_forecasting.do` in Stata
2. Update the `cd` path on line 1 to your local project directory
3. Ensure `ARIMAfinalport.xlsx` is in the same folder
4. Run the script

---

## Key Findings

- BNDX returns are best modeled as a simple AR(1) process, consistent with mild return persistence in international bond markets
- MSCI returns exhibit both autoregressive and moving average components (ARMA(1,1)), reflecting more complex equity return dynamics
- Both ETFs show mean-reverting behavior in the short term, with forecast confidence intervals widening significantly at the 3- and 5-year horizons
- The optimal portfolio allocates approximately 75% to global equities and 25% to international bonds, exploiting the negative covariance to reduce portfolio variance relative to either asset held alone

---

## Skills Demonstrated

`Stata` `ARIMA modeling` `time-series forecasting` `portfolio optimization` `mean-variance analysis` `Sharpe ratio` `efficient frontier` `asset pricing (CAPM, Fama-French, APT)` `financial econometrics` `data visualization`
