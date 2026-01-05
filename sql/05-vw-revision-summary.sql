-- 05_vw_covid_revision_summary_and_trends.sql
-- Purpose:
-- (A) summarize revision metrics by snapshot + dimension group
-- (B) create over-time trend table for dashboard lines
CREATE OR REPLACE VIEW `project2-482922.Covid_Rates.vw_covid_revision_summary` AS
SELECT
  snapshot_date,
  prev_snapshot_date,
  State,
  AgeCategory_Legend,
  Type,

  COUNT(*) AS rows_compared,

  SUM(flag_changed) AS changed_rows,
  SAFE_DIVIDE(SUM(flag_changed), COUNT(*)) AS pct_rows_changed,

  SUM(flag_material_abs_1) AS material_abs_1_count,
  SAFE_DIVIDE(SUM(flag_material_abs_1), COUNT(*)) AS pct_material_abs_1,

  SUM(flag_material_pct_10) AS material_pct_10_count,
  SAFE_DIVIDE(SUM(flag_material_pct_10), COUNT(*)) AS pct_material_pct_10,

  AVG(ABS(revision_abs)) AS avg_abs_revision,
  MAX(ABS(revision_abs)) AS max_abs_revision,

  AVG(ABS(revision_pct)) AS avg_pct_revision,
  MAX(ABS(revision_pct)) AS max_pct_revision

FROM `project2-482922.Covid_Rates.vw_covid_revisions`
GROUP BY
  snapshot_date,
  prev_snapshot_date,
  State,
  AgeCategory_Legend,
  Type;

--- Then
CREATE OR REPLACE VIEW `project2-482922.Covid_Rates.vw_covid_revision_trends` AS
SELECT
  snapshot_date,

  -- overall averages across all states/age/type for that month
  AVG(pct_rows_changed) AS avg_pct_rows_changed,
  AVG(avg_pct_revision) AS avg_revision_size_pct,
  SUM(rows_compared) AS total_rows_compared

FROM `project2-482922.Covid_Rates.vw_covid_revision_summary`
GROUP BY snapshot_date
ORDER BY snapshot_date;
