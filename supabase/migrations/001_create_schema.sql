-- ─── 1. FACILITIES ──────────────────────────────────────────
-- Each hub/spoke health facility
CREATE TABLE IF NOT EXISTS facilities (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE,
  type        TEXT NOT NULL CHECK (type IN ('Hub', 'Spoke')),
  district    TEXT NOT NULL,
  region      TEXT,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ─── 2. INDICATORS ──────────────────────────────────────────
-- The 22 KPI indicator definitions
CREATE TABLE IF NOT EXISTS indicators (
  id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  number              INTEGER NOT NULL UNIQUE,
  name                TEXT NOT NULL,
  result_level        TEXT NOT NULL CHECK (result_level IN ('Impact', 'Outcome', 'Output', 'Input')),
  definition          TEXT,
  data_source         TEXT,        -- e.g. 'DHIS2, MPDSR/ECBDS'
  frequency           TEXT DEFAULT 'Quarterly',
  sdg_tag             TEXT,        -- e.g. 'SDG 3.1.1'
  unit                TEXT DEFAULT 'count', -- 'count', 'percentage', 'ratio', 'rate'
  target_value        TEXT,        -- e.g. '< 100/year'
  target_description  TEXT,        -- e.g. 'Goal: < 100/year. Reduce from 2015 baseline'
  is_positive_good    BOOLEAN DEFAULT true, -- true = higher is better, false = lower is better
  sort_order          INTEGER DEFAULT 0,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);

-- ─── 3. INDICATOR DATA (quarterly) ─────────────────────────
-- Actual data values per indicator, per facility, per quarter
CREATE TABLE IF NOT EXISTS indicator_data (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  indicator_id    UUID NOT NULL REFERENCES indicators(id) ON DELETE CASCADE,
  facility_id     UUID NOT NULL REFERENCES facilities(id) ON DELETE CASCADE,
  year            INTEGER NOT NULL,
  quarter         TEXT NOT NULL CHECK (quarter IN ('Q1', 'Q2', 'Q3', 'Q4')),
  month           TEXT CHECK (month IN ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')),
  value           NUMERIC NOT NULL,
  numerator       NUMERIC,       -- For ratio/percentage indicators
  denominator     NUMERIC,       -- For ratio/percentage indicators
  data_quality    TEXT DEFAULT 'Verified' CHECK (data_quality IN ('Verified', 'Unverified', 'Estimated')),
  entered_by      UUID REFERENCES auth.users(id),
  notes           TEXT,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now(),
  UNIQUE (indicator_id, facility_id, year, quarter, month)
);

-- ─── 4. QUARTERLY SUMMARIES (materialized view) ────────────
-- Pre-aggregated quarterly totals per indicator
CREATE TABLE IF NOT EXISTS quarterly_summaries (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  indicator_id    UUID NOT NULL REFERENCES indicators(id) ON DELETE CASCADE,
  year            INTEGER NOT NULL,
  quarter         TEXT NOT NULL CHECK (quarter IN ('Q1', 'Q2', 'Q3', 'Q4')),
  hub_total       NUMERIC DEFAULT 0,
  spoke_total     NUMERIC DEFAULT 0,
  combined_total  NUMERIC DEFAULT 0,
  change_text     TEXT,          -- e.g. '↓ 12% vs last Q'
  is_positive     BOOLEAN,
  status          TEXT DEFAULT 'On Track' CHECK (status IN ('On Track', 'Off Track', 'No Target')),
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now(),
  UNIQUE (indicator_id, year, quarter)
);

-- ─── 5. TARGET PROGRESS ────────────────────────────────────
-- Track progress toward indicator targets
CREATE TABLE IF NOT EXISTS target_progress (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  indicator_id    UUID NOT NULL REFERENCES indicators(id) ON DELETE CASCADE,
  year            INTEGER NOT NULL,
  target_value    NUMERIC NOT NULL,
  current_value   NUMERIC NOT NULL,
  percentage      NUMERIC GENERATED ALWAYS AS (
    CASE WHEN target_value > 0 THEN ROUND((current_value / target_value) * 100, 1) ELSE 0 END
  ) STORED,
  created_at      TIMESTAMPTZ DEFAULT now(),
  UNIQUE (indicator_id, year)
);

-- ─── INDEXES ────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_indicator_data_indicator ON indicator_data(indicator_id);
CREATE INDEX IF NOT EXISTS idx_indicator_data_facility ON indicator_data(facility_id);
CREATE INDEX IF NOT EXISTS idx_indicator_data_period ON indicator_data(year, quarter);
CREATE INDEX IF NOT EXISTS idx_quarterly_summaries_indicator ON quarterly_summaries(indicator_id);
CREATE INDEX IF NOT EXISTS idx_quarterly_summaries_period ON quarterly_summaries(year, quarter);
CREATE INDEX IF NOT EXISTS idx_indicators_level ON indicators(result_level);

-- ─── ROW LEVEL SECURITY ────────────────────────────────────
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE indicators ENABLE ROW LEVEL SECURITY;
ALTER TABLE indicator_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE quarterly_summaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE target_progress ENABLE ROW LEVEL SECURITY;

-- Read access for all authenticated users
CREATE POLICY "Authenticated users can read facilities"
  ON facilities FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read indicators"
  ON indicators FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read indicator_data"
  ON indicator_data FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read quarterly_summaries"
  ON quarterly_summaries FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can read target_progress"
  ON target_progress FOR SELECT TO authenticated USING (true);

-- Write access for authenticated users (can be restricted further by role)
CREATE POLICY "Authenticated users can insert indicator_data"
  ON indicator_data FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update indicator_data"
  ON indicator_data FOR UPDATE TO authenticated USING (true);

-- ─── UPDATED_AT TRIGGER ────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_facilities
  BEFORE UPDATE ON facilities
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_indicators
  BEFORE UPDATE ON indicators
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_indicator_data
  BEFORE UPDATE ON indicator_data
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_quarterly_summaries
  BEFORE UPDATE ON quarterly_summaries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
