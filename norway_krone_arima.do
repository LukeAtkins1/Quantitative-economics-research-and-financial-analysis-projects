* ============================================================
* Norwegian Krone (NOK) REER Forecasting — ARIMA(0,1,1)
* Author: Luke Atkins
* Course: Econ 231 (International Finance) — UC Santa Cruz
* Date: April 2025
*
* Description:
*   This script develops an ARIMA time-series model to forecast
*   the Real Effective Exchange Rate (REER) of the Norwegian Krone.
*   The analysis was conducted as part of a broader macroeconomic
*   currency report examining Norway's economic fundamentals,
*   monetary policy, oil price dynamics, and sovereign wealth fund.
*
*   Methodology:
*     1. Import 30 years of monthly REER data from the BIS
*     2. Test for stationarity using Dickey-Fuller tests
*     3. Inspect ACF and PACF to determine ARIMA specification
*     4. Fit ARIMA(0,1,1) model — selected over ARIMA(1,1,1)
*        based on parameter significance and parsimony
*     5. Produce 1-year, 3-year, and 5-year dynamic forecasts
*        with 90% confidence intervals
*     6. Visualize forecasts with shaded confidence bands
*
*   Key finding: ARIMA(0,1,1) forecasts continued NOK depreciation
*   pressure across all horizons, consistent with declining oil
*   revenues and global energy transition dynamics.
*
* Data:
*   Source: Bank for International Settlements (BIS)
*   Series: Broad Real Effective Exchange Rate — Norway (monthly)
*   URL: https://data.bis.org/topics/EER
*   Sample: January 1995 to April 2025 (approx. 374 observations)
*   Download the CSV and update the file path below before running.
*
* Requirements:
*   Stata 16+ with time-series modules
* ============================================================

* ---- Setup ----
cd "YOUR_PROJECT_DIRECTORY_HERE"
import delimited "bis_reer_norway_monthly.csv", clear

* Generate monthly time index starting January 1995
generate t = tm(1995m1) + _n - 1
format t %tm
tsset t
order t, first

* Rename REER column
rename close reer_nor


* ============================================================
* SECTION 1: Stationarity Testing
* ============================================================

* Plot the REER series to inspect visually
tsline reer_nor, title("Norway REER — Monthly (1995-2025)") ///
    ytitle("REER Index") xtitle("Date")

* Dickey-Fuller test on levels — expect non-stationary (unit root)
* H0: series has a unit root (random walk without drift)
dfuller reer_nor

* Dickey-Fuller test on first differences — expect stationary
* First differencing removes the unit root
dfuller d.reer_nor


* ============================================================
* SECTION 2: ACF and PACF Analysis
* ============================================================

* Partial autocorrelation — helps identify AR order
* Strong spike at lag 1 initially suggested AR(1) component
pac d.reer_nor

* Autocorrelation — helps identify MA order
* MA(1) component dominant at lag 1 → supports ARIMA(0,1,1)
ac d.reer_nor


* ============================================================
* SECTION 3: ARIMA(0,1,1) Model — Selected Specification
*
* Model selection rationale:
*   - ARIMA(0,1,1) chosen over ARIMA(1,1,1) because:
*     * MA(1) parameter is highly significant in both specs
*     * AR(1) parameter is not significant in ARIMA(1,1,1)
*     * Simpler model is more parsimonious (lower AIC)
*     * Forecasts are more stable out-of-sample
* ============================================================

* Extend dataset to accommodate forecast periods
tsappend, add(60)   // Add 60 months (5 years) of empty observations


* --- 5-Year Forecast (starting Jan 2019, trained on pre-2019 data) ---
* Using full pre-2019 history to demonstrate long-run depreciation trend
arima reer_nor if t < tm(2019m1), arima(0,1,1)

predict ehatdy_5yr, dynamic(tm(2019m1)) y
predict sdhat_5yr, stdp

generate lower_5yr = ehatdy_5yr - 1.645 * sdhat_5yr if t >= tm(2019m1)
generate upper_5yr = ehatdy_5yr + 1.645 * sdhat_5yr if t >= tm(2019m1)
gen shade_5yr = t >= tm(2019m1)

twoway (rarea upper_5yr lower_5yr t if shade_5yr, color(gs14)) ///
       (tsline reer_nor if t <= tm(2025m12), lcolor(black)) ///
       (tsline ehatdy_5yr if t >= tm(2019m1), lcolor(blue)) ///
       (tsline lower_5yr if t >= tm(2019m1), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_5yr if t >= tm(2019m1), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("Forecast of Norway REER with ARIMA(0,1,1) — 5 Year") ///
       ytitle("REER Index") xtitle("Date")


* --- 3-Year Forecast (starting Jan 2022, trained on pre-2022 data) ---
arima reer_nor if t < tm(2022m1), arima(0,1,1)

predict ehatdy_3yr, dynamic(tm(2022m1)) y
predict sdhat_3yr, stdp

generate lower_3yr = ehatdy_3yr - 1.645 * sdhat_3yr if t >= tm(2022m1)
generate upper_3yr = ehatdy_3yr + 1.645 * sdhat_3yr if t >= tm(2022m1)
gen shade_3yr = t >= tm(2022m1)

twoway (rarea upper_3yr lower_3yr t if shade_3yr, color(gs14)) ///
       (tsline reer_nor if t <= tm(2025m12), lcolor(black)) ///
       (tsline ehatdy_3yr if t >= tm(2022m1), lcolor(blue)) ///
       (tsline lower_3yr if t >= tm(2022m1), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_3yr if t >= tm(2022m1), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("Forecast of Norway REER with ARIMA(0,1,1) — 3 Year") ///
       ytitle("REER Index") xtitle("Date")


* --- 1-Year Forecast (starting Jan 2024, trained on pre-2024 data) ---
arima reer_nor if t < tm(2024m1), arima(0,1,1)

predict ehatdy_1yr, dynamic(tm(2024m1)) y
predict sdhat_1yr, stdp

generate lower_1yr = ehatdy_1yr - 1.645 * sdhat_1yr if t >= tm(2024m1)
generate upper_1yr = ehatdy_1yr + 1.645 * sdhat_1yr if t >= tm(2024m1)
gen shade_1yr = t >= tm(2024m1)

twoway (rarea upper_1yr lower_1yr t if shade_1yr, color(gs14)) ///
       (tsline reer_nor if t <= tm(2025m1), lcolor(black)) ///
       (tsline ehatdy_1yr if t >= tm(2024m1), lcolor(blue)) ///
       (tsline lower_1yr if t >= tm(2024m1), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_1yr if t >= tm(2024m1), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("Forecast of Norway REER with ARIMA(0,1,1) — 1 Year") ///
       ytitle("REER Index") xtitle("Date")
