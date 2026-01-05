-- 03_vw_covid_pairs.sql
-- Purpose: pair each row with its previous snapshot row (same State/Age/Type).

CREATE OR REPLACE VIEW `project2-482922.Covid_Rates.vw_covid_pairs` AS
SELECT
  snapshot_date,

  LAG(snapshot_date) OVER (
    PARTITION BY State, AgeCategory_Legend, Type
    ORDER BY snapshot_date
  ) AS prev_snapshot_date,

  State,
  AgeCategory_Legend,
  Type,

  metric_value AS cur_val,

  LAG(metric_value) OVER (
    PARTITION BY State, AgeCategory_Legend, Type
    ORDER BY snapshot_date
  ) AS prev_val
FROM `project2-482922.Covid_Rates.vw_covid_base`;
