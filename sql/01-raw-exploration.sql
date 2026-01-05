-- Purpose: sanity-check the raw table and confirm key fields exist.

-- Check field coverage
SELECT
  COUNT(*) AS n_rows,
  COUNTIF(_YearMonth IS NULL) AS missing_yearmonth,
  COUNTIF(MonthlyRate IS NULL) AS missing_monthlyrate,
  COUNTIF(State IS NULL) AS missing_state,
  COUNTIF(AgeCategory_Legend IS NULL) AS missing_age,
  COUNTIF(Type IS NULL) AS missing_type
FROM `project2-482922.Covid_Rates.raw_covid`;

-- Distribution checks (helps interpret revisions)
SELECT
  APPROX_QUANTILES(MonthlyRate, 20) AS monthlyrate_quantiles
FROM `project2-482922.Covid_Rates.raw_covid`
WHERE MonthlyRate IS NOT NULL;

-- Time range check (after parsing YYYYMM)
SELECT
  MIN(PARSE_DATE('%Y%m', CAST(_YearMonth AS STRING))) AS min_snapshot_date,
  MAX(PARSE_DATE('%Y%m', CAST(_YearMonth AS STRING))) AS max_snapshot_date
FROM `project2-482922.Covid_Rates.raw_covid`
WHERE _YearMonth IS NOT NULL;
