# COVID Rates Revision Analysis (BigQuery + Tableau)

## Overview
This project analyzes how reported monthly COVID rates change across time by comparing each month to its previous snapshot. The goal is to quantify:
- **How often** values change (change frequency)
- **How large** changes are (revision magnitude)
- **How much data** is being compared (volume)

This type of analysis is useful for monitoring data quality, reporting stability, and revision patterns in public health datasets.

---

## Tools
- **Data Processing:** Google BigQuery (SQL)
- **Visualization:** Tableau Public

---

## Data
- BigQuery Project: `project2-482922`
- Dataset: `Covid_Rates`
- Raw Table: `raw_covid`
- Time Field: `_YearMonth` (converted to `snapshot_date`)
- Metric: `MonthlyRate`

---

## Methodology
### 1) Build snapshot time series
`_YearMonth` is parsed into a true `DATE` field (`snapshot_date`) to ensure correct time ordering.

### 2) Pair current vs. previous snapshot
Using window functions (`LAG`) partitioned by:
- `State`
- `AgeCategory_Legend`
- `Type`

Each record is paired with its previous month’s value.

### 3) Calculate revisions
For each record:
- `revision_abs = cur_val - prev_val`
- `revision_pct = (cur_val - prev_val) / prev_val` (stored as a proportion; 0.05 = 5%)

### 4) Aggregate into KPI-ready tables
A summary view aggregates revision behavior by
