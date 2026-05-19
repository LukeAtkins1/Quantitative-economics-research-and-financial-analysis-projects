* ============================================================
* ETF Portfolio ARIMA Return Forecasting
* Author: Luke Atkins
* Course: Econ 231 (International Finance) — UC Santa Cruz
* Date: 2025
*
* Description:
*   This script fits ARIMA models to monthly return data for two ETFs:
*     - BNDX: Vanguard Total International Bond ETF (bonds)
*     - MSCI: iShares MSCI ACWI ETF (global equities)
*
*   For each ETF, ARIMA models are estimated and used to produce
*   1-year, 3-year, and 5-year return forecasts with 90% confidence
*   intervals. Results are plotted as time-series charts with shaded
*   forecast bands.
*
*   Model specifications:
*     BNDX: ARIMA(1,0,0) — AR(1) process on monthly returns
*     MSCI: ARIMA(1,0,1) — ARMA(1,1) process on monthly returns
*
*   This analysis was part of a broader portfolio optimization project
*   that combined ARIMA forecasts with CAPM, Fama-French, and APT
*   asset pricing models to construct and evaluate a two-ETF portfolio.
*
* Data:
*   ARIMAfinalport.xlsx — monthly return data for BNDX and MSCI
*   Source: Yahoo Finance historical data
*   Sample period: June 2013 onward
*
* Requirements:
*   Stata 16+ with time-series modules
* ============================================================

* ---- Setup ----
cd "YOUR_PROJECT_DIRECTORY_HERE"
import excel "ARIMAfinalport.xlsx", firstrow clear

* Generate monthly time index starting June 2013
generate t = tm(2013m6) + _n - 1
format t %tm
tsset t
order t, first


* ============================================================
* SECTION 1: BNDX — Vanguard Total International Bond ETF
* ARIMA(1,0,0) — AR(1) model on monthly returns
* ============================================================

rename BNDXReturn return_bndx

* Fit ARIMA(1,0,0) model
arima return_bndx, arima(1,0,0)

* --- 1-Year Forecast (12 months) ---
tsappend, add(12)

predict fcast_BNDX1yr, dynamic(tm(2025m6)) y
predict se_BNDX1yr, stdp

gen lower_BNDX1yr = fcast_BNDX1yr - 1.645 * se_BNDX1yr
gen upper_BNDX1yr = fcast_BNDX1yr + 1.645 * se_BNDX1yr
gen shade_BNDX1yr = t >= tm(2025m6)

twoway (rarea upper_BNDX1yr lower_BNDX1yr t if shade_BNDX1yr, color(gs14)) ///
       (tsline return_bndx if t < tm(2025m6), lcolor(black)) ///
       (tsline fcast_BNDX1yr if t >= tm(2025m6), lcolor(blue)) ///
       (tsline lower_BNDX1yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_BNDX1yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("1-Year Forecast of BNDX Monthly Return (ARIMA)") ///
       ytitle("Monthly Return") xtitle("Date")

* --- 3-Year Forecast (36 months total) ---
tsappend, add(24)

predict fcast_BNDX3yr, dynamic(tm(2025m6)) y
predict se_BNDX3yr, stdp

gen lower_BNDX3yr = fcast_BNDX3yr - 1.645 * se_BNDX3yr
gen upper_BNDX3yr = fcast_BNDX3yr + 1.645 * se_BNDX3yr
gen shade_BNDX3yr = t >= tm(2025m6)

twoway (rarea upper_BNDX3yr lower_BNDX3yr t if shade_BNDX3yr, color(gs14)) ///
       (tsline return_bndx if t < tm(2025m6), lcolor(black)) ///
       (tsline fcast_BNDX3yr if t >= tm(2025m6), lcolor(blue)) ///
       (tsline lower_BNDX3yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_BNDX3yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("3-Year Forecast of BNDX Monthly Return (ARIMA)") ///
       ytitle("Monthly Return") xtitle("Date")

* --- 5-Year Forecast (60 months total) ---
tsappend, add(24)

predict fcast_BNDX5yr, dynamic(tm(2025m6)) y
predict se_BNDX5yr, stdp

gen lower_BNDX5yr = fcast_BNDX5yr - 1.645 * se_BNDX5yr
gen upper_BNDX5yr = fcast_BNDX5yr + 1.645 * se_BNDX5yr
gen shade_BNDX5yr = t >= tm(2025m6)

twoway (rarea upper_BNDX5yr lower_BNDX5yr t if shade_BNDX5yr, color(gs14)) ///
       (tsline return_bndx if t < tm(2025m6), lcolor(black)) ///
       (tsline fcast_BNDX5yr if t >= tm(2025m6), lcolor(blue)) ///
       (tsline lower_BNDX5yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_BNDX5yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("5-Year Forecast of BNDX Monthly Return (ARIMA)") ///
       ytitle("Monthly Return") xtitle("Date")


* ============================================================
* SECTION 2: MSCI — iShares MSCI ACWI ETF
* ARIMA(1,0,1) — ARMA(1,1) model on monthly returns
* ============================================================

rename MSCIReturn return_msci

* Fit ARIMA(1,0,1) model
arima return_msci, arima(1,0,1)

* --- 1-Year Forecast ---
tsappend, add(12)

predict fcast_msci_1yr, dynamic(tm(2025m6)) y
predict se_msci_1yr, stdp

gen lower_msci_1yr = fcast_msci_1yr - 1.645 * se_msci_1yr
gen upper_msci_1yr = fcast_msci_1yr + 1.645 * se_msci_1yr
gen shade_msci_1yr = t >= tm(2025m6)

twoway (rarea upper_msci_1yr lower_msci_1yr t if shade_msci_1yr, color(gs14)) ///
       (tsline return_msci if t < tm(2025m6), lcolor(black)) ///
       (tsline fcast_msci_1yr if t >= tm(2025m6), lcolor(blue)) ///
       (tsline lower_msci_1yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_msci_1yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("1-Year Forecast of MSCI Monthly Return (ARIMA)") ///
       ytitle("Monthly Return") xtitle("Date")

* --- 3-Year Forecast ---
tsappend, add(24)

predict fcast_msci_3yr, dynamic(tm(2025m6)) y
predict se_msci_3yr, stdp

gen lower_msci_3yr = fcast_msci_3yr - 1.645 * se_msci_3yr
gen upper_msci_3yr = fcast_msci_3yr + 1.645 * se_msci_3yr
gen shade_msci_3yr = t >= tm(2025m6)

twoway (rarea upper_msci_3yr lower_msci_3yr t if shade_msci_3yr, color(gs14)) ///
       (tsline return_msci if t < tm(2025m6), lcolor(black)) ///
       (tsline fcast_msci_3yr if t >= tm(2025m6), lcolor(blue)) ///
       (tsline lower_msci_3yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_msci_3yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("3-Year Forecast of MSCI Monthly Return (ARIMA)") ///
       ytitle("Monthly Return") xtitle("Date")

* --- 5-Year Forecast ---
tsappend, add(24)

predict fcast_msci_5yr, dynamic(tm(2025m6)) y
predict se_msci_5yr, stdp

gen lower_msci_5yr = fcast_msci_5yr - 1.645 * se_msci_5yr
gen upper_msci_5yr = fcast_msci_5yr + 1.645 * se_msci_5yr
gen shade_msci_5yr = t >= tm(2025m6)

twoway (rarea upper_msci_5yr lower_msci_5yr t if shade_msci_5yr, color(gs14)) ///
       (tsline return_msci if t < tm(2025m6), lcolor(black)) ///
       (tsline fcast_msci_5yr if t >= tm(2025m6), lcolor(blue)) ///
       (tsline lower_msci_5yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)) ///
       (tsline upper_msci_5yr if t >= tm(2025m6), lpattern(dash) lcolor(gs10)), ///
       legend(order(2 "Actual" 3 "Forecast" 4 "Lower 90% CI" 5 "Upper 90% CI")) ///
       title("5-Year Forecast of MSCI Monthly Return (ARIMA)") ///
       ytitle("Monthly Return") xtitle("Date")
