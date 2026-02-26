-- ─── Add data_origin to indicator_data ─────────────────────
ALTER TABLE indicator_data
  ADD COLUMN IF NOT EXISTS data_origin TEXT DEFAULT 'manual'
    CHECK (data_origin IN ('dhis2', 'mobile_app', 'manual', 'computed')),
  ADD COLUMN IF NOT EXISTS dhis2_uid TEXT,
  ADD COLUMN IF NOT EXISTS sync_batch_id TEXT;

-- ─── DHIS2 Indicator Mapping ───────────────────────────────
-- Maps Hub & Spokes indicators to DHIS2 data element UIDs
CREATE TABLE IF NOT EXISTS dhis2_indicator_map (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  indicator_id  UUID NOT NULL REFERENCES indicators(id) ON DELETE CASCADE,
  dhis2_uid     TEXT NOT NULL,
  dhis2_name    TEXT,
  transform     TEXT DEFAULT 'direct' CHECK (transform IN ('direct', 'sum', 'average', 'ratio')),
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT now(),
  UNIQUE (indicator_id, dhis2_uid)
);

-- ─── DHIS2 Facility Mapping ────────────────────────────────
-- Maps Hub & Spokes facilities to DHIS2 org unit UIDs
CREATE TABLE IF NOT EXISTS dhis2_facility_map (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  facility_id   UUID NOT NULL REFERENCES facilities(id) ON DELETE CASCADE,
  dhis2_uid     TEXT NOT NULL,
  dhis2_name    TEXT,
  dhis2_level   INTEGER,
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT now(),
  UNIQUE (facility_id, dhis2_uid)
);

-- ─── DHIS2 Sync Log ────────────────────────────────────────
-- Tracks every sync attempt for auditing
CREATE TABLE IF NOT EXISTS dhis2_sync_log (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sync_type       TEXT NOT NULL CHECK (sync_type IN ('full', 'incremental')),
  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at    TIMESTAMPTZ,
  status          TEXT DEFAULT 'running' CHECK (status IN ('running', 'success', 'failed')),
  records_synced  INTEGER DEFAULT 0,
  records_failed  INTEGER DEFAULT 0,
  error_message   TEXT,
  metadata        JSONB,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- ─── RLS for new tables ────────────────────────────────────
ALTER TABLE dhis2_indicator_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE dhis2_facility_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE dhis2_sync_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read dhis2_indicator_map"
  ON dhis2_indicator_map FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read dhis2_facility_map"
  ON dhis2_facility_map FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read dhis2_sync_log"
  ON dhis2_sync_log FOR SELECT TO authenticated USING (true);

-- ─── Indexes ───────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_indicator_data_origin ON indicator_data(data_origin);
CREATE INDEX IF NOT EXISTS idx_dhis2_indicator_map_uid ON dhis2_indicator_map(dhis2_uid);
CREATE INDEX IF NOT EXISTS idx_dhis2_facility_map_uid ON dhis2_facility_map(dhis2_uid);
CREATE INDEX IF NOT EXISTS idx_dhis2_sync_log_status ON dhis2_sync_log(status);

-- ─── Aggregation Function ──────────────────────────────────
-- Call this after inserting new data to refresh quarterly summaries
CREATE OR REPLACE FUNCTION refresh_quarterly_summary(
  p_indicator_id UUID,
  p_year INTEGER,
  p_quarter TEXT
)
RETURNS void AS $$
DECLARE
  v_hub_total NUMERIC;
  v_spoke_total NUMERIC;
BEGIN
  -- Sum hub values
  SELECT COALESCE(SUM(id2.value), 0) INTO v_hub_total
  FROM indicator_data id2
  JOIN facilities f ON f.id = id2.facility_id
  WHERE id2.indicator_id = p_indicator_id
    AND id2.year = p_year
    AND id2.quarter = p_quarter
    AND f.type = 'Hub';

  -- Sum spoke values
  SELECT COALESCE(SUM(id2.value), 0) INTO v_spoke_total
  FROM indicator_data id2
  JOIN facilities f ON f.id = id2.facility_id
  WHERE id2.indicator_id = p_indicator_id
    AND id2.year = p_year
    AND id2.quarter = p_quarter
    AND f.type = 'Spoke';

  -- Upsert the summary
  INSERT INTO quarterly_summaries (indicator_id, year, quarter, hub_total, spoke_total, combined_total)
  VALUES (p_indicator_id, p_year, p_quarter, v_hub_total, v_spoke_total, v_hub_total + v_spoke_total)
  ON CONFLICT (indicator_id, year, quarter)
  DO UPDATE SET
    hub_total = v_hub_total,
    spoke_total = v_spoke_total,
    combined_total = v_hub_total + v_spoke_total,
    updated_at = now();
END;
$$ LANGUAGE plpgsql;
