# Norwegian Krone (NOK) REER Forecasting — ARIMA Time-Series Analysis

**Author:** Luke Atkins  
**Course:** Econ 231 (International Finance) — UC Santa Cruz (MS Quantitative Economics & Finance)  
**Date:** April 2025

---

## Overview

This project develops an ARIMA time-series model to forecast the Real Effective Exchange Rate (REER) of the Norwegian Krone (NOK). The analysis is part of a comprehensive macroeconomic currency report that integrates econometric forecasting with fundamental economic analysis covering Norway's oil sector, sovereign wealth fund, monetary policy, and PPP dynamics.

The full written report is included in this repository: `econ_231_Currency_report_Luke_Atkins.pdf`

---

## Research Question

Can an ARIMA model fitted to 30 years of Norway's REER data produce reliable short-, medium-, and long-term forecasts? What do those forecasts imply for NOK currency positioning?

---

## Methodology

### Step 1 — Stationarity Testing
- Plotted the REER series visually to identify trends
- Applied **Dickey-Fuller test** on levels: confirmed non-stationarity (unit root present, p = 0.78)
- Applied **Dickey-Fuller test on first differences**: confirmed stationarity (p = 0.000)
- Conclusion: series is integrated of order 1 → I(1) → requires first differencing

### Step 2 — Model Identification
- Inspected **ACF** (Autocorrelation Function) and **PACF** (Partial Autocorrelation Function) on first-differenced series
- ACF showed significant spike at lag 1 → MA(1) component
- PACF showed no significant spikes after lag 1 → no AR component needed
- Competing specs tested: ARIMA(1,1,1) vs ARIMA(0,1,1)

### Step 3 — Model Selection
**Selected: ARIMA(0,1,1)**

| Criteria | ARIMA(1,1,1) | ARIMA(0,1,1) |
|---|---|---|
| AR(1) parameter | Not significant | N/A |
| MA(1) parameter | Significant | Significant |
| Parsimony | More complex | Simpler |
| Selected | No | Yes |

The simpler model produced stronger, more statistically significant parameters and more stable out-of-sample forecasts.

### Step 4 — Forecasting
Three dynamic forecasts produced with 90% confidence intervals:
- **1-year forecast** — model trained on data through Dec 2023, forecast from Jan 2024
- **3-year forecast** — model trained on data through Dec 2021, forecast from Jan 2022
- **5-year forecast** — model trained on data through Dec 2018, forecast from Jan 2019

---

## Key Findings

- All three forecast horizons predict **continued NOK depreciation** in REER terms
- **Short-term depreciation** driven by weaker oil revenues and global economic uncertainty
- **Long-term depreciation** reflects structural shift away from fossil fuels and persistent weakness in oil prices relative to 2013/2014 highs
- **Medium-term** outlook depends on success of domestic policy pivot and recovery in external demand
- Despite depreciation pressure, the Krone remains **fundamentally supported** by the Government Pension Fund Global (world's largest sovereign wealth fund), providing a long-term buffer

**Investment recommendation:** Cautious short-term stance on NOK assets; more constructive medium-to-long-term view once oil markets and domestic consumption stabilize.

---

## Broader Macroeconomic Context

The written report integrates the ARIMA analysis with:
- GDP component analysis (oil vs. mainland Norway)
- PPP analysis using the Big Mac Index and relative CPI
- IS/LM and FX (FRDR) model analysis of monetary policy transmission
- Sovereign wealth fund dynamics and fiscal flexibility
- Norway's COVID-19 recovery trajectory and rate cycle

---

## Data

- **Source:** Bank for International Settlements (BIS)
- **Series:** Broad Real Effective Exchange Rate — Norway (monthly, 2010=100)
- **URL:** https://data.bis.org/topics/EER
- **Sample:** January 1995 to April 2025 (~374 monthly observations)

To replicate: download the BIS REER data for Norway as a CSV, save it as `bis_reer_norway_monthly.csv` in your project directory, and update the `cd` path in the do-file.

---

## Files in This Repository

| File | Description |
|---|---|
| `norway_krone_arima.do` | Stata do-file: stationarity tests, model estimation, forecasting, plots |
| `econ_231_Currency_report_Luke_Atkins.pdf` | Full written report with economic analysis and findings |

---

## Requirements

Stata 16+ with time-series capabilities. No additional packages required.

**To run:**
1. Download BIS REER data for Norway (link above)
2. Save CSV as `bis_reer_norway_monthly.csv` in your project folder
3. Update the `cd` path at the top of `norway_krone_arima.do`
4. Run the script in Stata

---

## Skills Demonstrated

`Stata` `ARIMA modeling` `Dickey-Fuller stationarity testing` `ACF/PACF analysis` `dynamic forecasting` `confidence interval construction` `time-series visualization` `macroeconomic analysis` `currency analysis` `monetary policy` `sovereign wealth funds` `PPP analysis`
