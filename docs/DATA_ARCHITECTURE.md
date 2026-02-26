# Hub & Spokes M&E System — Data Architecture

## System Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                        DATA SOURCES                              │
│                                                                  │
│   ┌─────────────┐         ┌──────────────────────────────────┐  │
│   │  Mobile App  │         │          DHIS2 (Existing)        │  │
│   │  (Field      │         │  • Routine health data           │  │
│   │   Workers)   │         │  • Facility reports              │  │
│   │              │         │  • EPI, ANC, FP registers        │  │
│   └──────┬───── ┘         └──────────────┬───────────────────┘  │
│          │                                │                      │
│          │  Direct writes                 │  Nightly ETL sync    │
│          │  (offline-first)               │  (Supabase Edge Fn)  │
│          ▼                                ▼                      │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │              SUPABASE (Central Data Hub)                  │  │
│   │                                                          │  │
│   │  ┌──────────┐  ┌──────────────┐  ┌──────────────────┐   │  │
│   │  │facilities │  │indicator_data│  │quarterly_summaries│  │  │
│   │  └──────────┘  └──────────────┘  └──────────────────┘   │  │
│   │  ┌──────────┐  ┌──────────────┐  ┌──────────────────┐   │  │
│   │  │indicators│  │dhis2_sync_log│  │ target_progress   │  │  │
│   │  └──────────┘  └──────────────┘  └──────────────────┘   │  │
│   │                                                          │  │
│   │  Auth • RLS Policies • Edge Functions • Realtime         │  │
│   └────────────────────────┬─────────────────────────────────┘  │
│                            │                                     │
│                            │  Reads (REST API / Realtime)        │
│                            ▼                                     │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │              CONSUMERS                                    │  │
│   │                                                          │  │
│   │   ┌──────────────┐         ┌──────────────────────┐      │  │
│   │   │  Web Dashboard│         │     Mobile App       │      │  │
│   │   │  (This app)   │         │  (Also reads own     │      │  │
│   │   │  • KPI cards  │         │   submitted data)    │      │  │
│   │   │  • Charts     │         │                      │      │  │
│   │   │  • Reports    │         │                      │      │  │
│   │   └──────────────┘         └──────────────────────┘      │  │
│   └──────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

## Data Flow Strategy

### 1. DHIS2 → Supabase (Automated Sync)

DHIS2 is the **existing source of truth** for routine health data. We don't replace it — we **sync from it**.

**How:**
- A **Supabase Edge Function** runs on a schedule (nightly or hourly)
- It calls the DHIS2 Web API to pull indicator values
- It transforms and inserts the data into `indicator_data`
- A `dhis2_sync_log` table tracks what was synced and when

**DHIS2 API Pattern:**
```
GET /api/analytics?
  dimension=dx:INDICATOR_UID
  &dimension=ou:ORG_UNIT_UID
  &dimension=pe:2025Q1
  &outputIdScheme=NAME
```

**What syncs from DHIS2:**
| Data | DHIS2 Source | Supabase Table |
|------|-------------|----------------|
| Maternal Deaths | MPDSR program | `indicator_data` (indicator #1) |
| Under-5 Deaths | MPDSR program | `indicator_data` (indicator #2) |
| ANC visits | ANC Register datasets | `indicator_data` (indicator #7) |
| FP uptake | FP Register datasets | `indicator_data` (indicator #5) |
| EPI coverage | EPI datasets | `indicator_data` (indicator #9) |

### 2. Mobile App → Supabase (Direct Writes)

The mobile app is for **field-level data** that may NOT be in DHIS2, or needs to be captured earlier.

**What the mobile app collects:**
| Data Type | Example | Why not DHIS2? |
|-----------|---------|----------------|
| Death reviews (MPDSR) | Maternal death review forms | Detailed narrative, not in DHIS2 |
| Supportive supervision | Supervision checklists | Not a DHIS2 dataset |
| FMC meeting minutes | Committee reports | Qualitative data |
| Stock reports | Drug stock levels | Needs real-time tracking |
| Referral tracking | Referral outcomes | Cross-facility data |
| Service readiness | SARA assessment scores | Periodic assessments |

**Offline-first approach:**
```
Mobile App
    ↓
Local SQLite (offline cache)
    ↓ (when online)
Supabase (via REST API)
    ↓ (auto-aggregated)
quarterly_summaries table
    ↓ (displayed on)
Web Dashboard
```

### 3. Supabase → Web Dashboard & Mobile App (Reads)

Both the web dashboard and mobile app **read from the same Supabase tables**. This ensures:
- Single source of truth
- Consistent data across platforms
- Real-time updates via Supabase Realtime

---

## Data Origin Tracking

Every record in `indicator_data` tracks WHERE it came from:

```sql
-- Add to indicator_data table
data_origin TEXT DEFAULT 'manual' CHECK (
  data_origin IN ('dhis2', 'mobile_app', 'manual', 'computed')
),
dhis2_uid TEXT,              -- Original DHIS2 data element UID
sync_batch_id TEXT,          -- Which sync batch brought this in
```

This lets you:
- Show "Source: DHIS2" or "Source: Field Report" on cards
- Audit where each number came from
- Resolve conflicts (DHIS2 value vs manually entered value)

---

## Conflict Resolution Strategy

When the same indicator has data from BOTH DHIS2 and the mobile app:

| Priority | Rule |
|----------|------|
| 1 | **DHIS2 is authoritative** for routine aggregate data (ANC visits, deliveries, etc.) |
| 2 | **Mobile app is authoritative** for death reviews, supervision, and qualitative data |
| 3 | If both exist for the same indicator/facility/quarter, use the **most recent** entry |
| 4 | Flag conflicts for **manual review** by M&E officers |

---

## Database Additions Needed

### New table: `dhis2_sync_log`
```sql
CREATE TABLE dhis2_sync_log (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sync_type    TEXT NOT NULL,       -- 'full', 'incremental'
  started_at   TIMESTAMPTZ NOT NULL,
  completed_at TIMESTAMPTZ,
  status       TEXT DEFAULT 'running', -- 'running', 'success', 'failed'
  records_synced INTEGER DEFAULT 0,
  error_message TEXT,
  metadata     JSONB                -- Store DHIS2 API response details
);
```

### New table: `dhis2_indicator_map`
```sql
-- Maps our indicators to DHIS2 data element UIDs
CREATE TABLE dhis2_indicator_map (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  indicator_id  UUID REFERENCES indicators(id),
  dhis2_uid     TEXT NOT NULL,        -- DHIS2 data element UID
  dhis2_name    TEXT,                 -- Name in DHIS2
  transform     TEXT DEFAULT 'direct' -- 'direct', 'sum', 'average', 'ratio'
);
```

### New table: `dhis2_facility_map`
```sql
-- Maps our facilities to DHIS2 org unit UIDs
CREATE TABLE dhis2_facility_map (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  facility_id   UUID REFERENCES facilities(id),
  dhis2_uid     TEXT NOT NULL,         -- DHIS2 org unit UID
  dhis2_name    TEXT                    -- Name in DHIS2
);
```

---

## Recommended Implementation Order

### Phase 1: Now (Web Dashboard) ✅
- [x] Supabase schema created
- [x] Seed data inserted
- [x] Dart models created
- [x] DataService created
- [x] Dashboard connected to Supabase

### Phase 2: DHIS2 Integration
1. Set up `dhis2_indicator_map` and `dhis2_facility_map` tables
2. Create a Supabase Edge Function to sync DHIS2 data
3. Add `data_origin` column to `indicator_data`
4. Schedule the sync (hourly or nightly via Supabase cron)

### Phase 3: Mobile App
1. Flutter mobile app with offline-first SQLite
2. Data entry forms for indicators NOT in DHIS2
3. Sync queue: local → Supabase when online
4. Read dashboard data from same Supabase tables

### Phase 4: Real-time
1. Enable Supabase Realtime on `quarterly_summaries`
2. Web dashboard auto-updates when new data arrives
3. Push notifications to mobile app for data quality alerts
