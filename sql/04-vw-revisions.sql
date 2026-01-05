-- 04_vw_covid_revisions.sql
-- Purpose: compute absolute + percent revisions and change flags.

CREATE OR REPLACE VIEW `project2-482922.Covid_Rates.vw_covid_revisions` AS
SELECT
  snapshot_date,
  prev_snapshot_date,
  State,
  AgeCategory_Legend,
  Type,

  cur_val,
  prev_val,
  (cur_val - prev_val) AS revision_abs,
  SAFE_DIVIDE(cur_val - prev_val, NULLIF(prev_val, 0)) AS revision_pct,
  CASE
    WHEN prev_val IS NULL THEN 0
    WHEN cur_val != prev_val THEN 1
    ELSE 0
  END AS flag_changed,
  CASE
    WHEN prev_val IS NULL THEN 0
    WHEN ABS(cur_val - prev_val) >= 1 THEN 1
    ELSE 0
  END AS flag_material_abs_1,
  CASE
    WHEN prev_val IS NULL THEN 0
    WHEN ABS(SAFE_DIVIDE(cur_val - prev_val, NULLIF(prev_val, 0))) >= 0.10 THEN 1
    ELSE 0
  END AS flag_material_pct_10

FROM `project2-482922.Covid_Rates.vw_covid_pairs`
WHERE prev_snapshot_date IS NOT NULL;
