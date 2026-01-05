-- 02_vw_covid_base.sql
-- Purpose: standardize time + metric types for consistent time ordering.

CREATE OR REPLACE VIEW `project2-482922.Covid_Rates.vw_covid_base` AS
SELECT
  -- Convert YYYYMM to a real DATE (first day of that month)
  PARSE_DATE('%Y%m', CAST(_YearMonth AS STRING)) AS snapshot_date,

  State,
  AgeCategory_Legend,
  Type,

  CAST(MonthlyRate AS FLOAT64) AS metric_value
FROM `project2-482922.Covid_Rates.raw_covid`
WHERE _YearMonth IS NOT NULL
  AND MonthlyRate IS NOT NULL;
