# Hub & Spokes — Mobile App Developer Guide

## Overview

This document provides everything needed to build the mobile data collector app that feeds into the Hub & Spokes M&E web dashboard.

**Backend:** Supabase (PostgreSQL + REST API + Auth)  
**Supabase URL:** `https://dkcsahpirsmuyaetxhne.supabase.co`  
**Dashboard repo:** `github.com/Malaikamadi/Hub-Spokes`

---

## Architecture

```
Mobile App (you build this)
    ↓ writes to
Supabase REST API
    ↓ read by
Web Dashboard (already built)
```

Both apps share the **same Supabase project**, same auth, same tables.

---

## Authentication

Uses **Supabase Auth** (email + password).

### Sign Up
```
POST https://dkcsahpirsmuyaetxhne.supabase.co/auth/v1/signup
Content-Type: application/json
apikey: <ANON_KEY>

{
  "email": "user@mohs.gov.sl",
  "password": "securepassword",
  "data": {
    "full_name": "John Doe",
    "role": "M&E Officer"
  }
}
```

### Sign In
```
POST https://dkcsahpirsmuyaetxhne.supabase.co/auth/v1/token?grant_type=password
Content-Type: application/json
apikey: <ANON_KEY>

{
  "email": "user@mohs.gov.sl",
  "password": "securepassword"
}
```

**Response** includes `access_token` — use it as `Authorization: Bearer <token>` on all API calls.

---

## Database Tables

### 1. `facilities` (read-only from mobile)
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key |
| `name` | TEXT | e.g. "Kenema Hub", "Bo Spoke" |
| `type` | TEXT | `'Hub'` or `'Spoke'` |
| `district` | TEXT | e.g. "Kenema", "Bo" |
| `region` | TEXT | e.g. "Eastern", "Southern" |
| `is_active` | BOOLEAN | Filter by this |

### 2. `indicators` (read-only from mobile)
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key |
| `number` | INTEGER | 1-22, unique |
| `name` | TEXT | Indicator name |
| `result_level` | TEXT | `'Impact'`, `'Outcome'`, `'Output'`, `'Input'` |
| `data_source` | TEXT | e.g. "DHIS2, MPDSR/ECBDS" |
| `frequency` | TEXT | Usually "Quarterly" |
| `sdg_tag` | TEXT | e.g. "SDG 3.1.1" (nullable) |
| `unit` | TEXT | `'count'`, `'percentage'`, `'ratio'`, `'rate'` |
| `target_value` | TEXT | e.g. "< 100/year" |
| `target_description` | TEXT | Full target text |
| `sort_order` | INTEGER | Display order |

### 3. `indicator_data` (mobile writes here)
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Auto-generated |
| `indicator_id` | UUID | FK → indicators |
| `facility_id` | UUID | FK → facilities |
| `year` | INTEGER | e.g. 2025 |
| `quarter` | TEXT | `'Q1'`, `'Q2'`, `'Q3'`, `'Q4'` |
| `month` | TEXT | Optional: `'Jan'`..`'Dec'` |
| `value` | NUMERIC | The data value |
| `numerator` | NUMERIC | For ratios (optional) |
| `denominator` | NUMERIC | For ratios (optional) |
| `data_quality` | TEXT | `'Verified'`, `'Unverified'`, `'Estimated'` |
| `data_origin` | TEXT | **Set to `'mobile_app'`** |
| `entered_by` | UUID | Auth user ID |
| `notes` | TEXT | Optional notes |

### 4. `quarterly_summaries` (read-only, powers dashboard)
| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key |
| `indicator_id` | UUID | FK → indicators |
| `year` | INTEGER | e.g. 2025 |
| `quarter` | TEXT | Q1-Q4 |
| `hub_total` | NUMERIC | Sum of hub values |
| `spoke_total` | NUMERIC | Sum of spoke values |
| `combined_total` | NUMERIC | hub + spoke |
| `status` | TEXT | `'On Track'`, `'Off Track'`, `'No Target'` |

---

## API Endpoints (Supabase REST)

Base URL: `https://dkcsahpirsmuyaetxhne.supabase.co/rest/v1`

### Fetch all facilities
```
GET /facilities?is_active=eq.true&order=type,name
Authorization: Bearer <token>
apikey: <ANON_KEY>
```

### Fetch all indicators
```
GET /indicators?order=sort_order
Authorization: Bearer <token>
apikey: <ANON_KEY>
```

### Fetch indicators by level
```
GET /indicators?result_level=eq.Impact&order=sort_order
```

### Submit data entry
```
POST /indicator_data
Authorization: Bearer <token>
apikey: <ANON_KEY>
Content-Type: application/json
Prefer: return=representation

{
  "indicator_id": "uuid-of-indicator",
  "facility_id": "uuid-of-facility",
  "year": 2025,
  "quarter": "Q2",
  "month": "May",
  "value": 42,
  "numerator": null,
  "denominator": null,
  "data_quality": "Verified",
  "data_origin": "mobile_app",
  "notes": "Collected during supervision visit"
}
```

### Fetch submitted entries (for current user)
```
GET /indicator_data?entered_by=eq.<user_id>&order=created_at.desc
Authorization: Bearer <token>
apikey: <ANON_KEY>
```

### Fetch quarterly summaries (to show on mobile dashboard)
```
GET /quarterly_summaries?year=eq.2025&select=*,indicators(*)&order=quarter
Authorization: Bearer <token>
apikey: <ANON_KEY>
```

---

## Offline-First Pattern (Recommended)

```
┌─────────────────────────────┐
│        Mobile App           │
│                             │
│  1. User fills data form    │
│  2. Save to LOCAL DB first  │──► SQLite / Hive / Drift
│  3. Show as "Pending" ⏳    │
│                             │
│  When online:               │
│  4. POST to Supabase        │──► /rest/v1/indicator_data
│  5. Mark as "Synced" ✅     │
│  6. Handle errors → "Failed"│
└─────────────────────────────┘
```

### Local table schema (SQLite/Hive):
```sql
CREATE TABLE pending_entries (
  id TEXT PRIMARY KEY,          -- UUID, generated locally
  indicator_id TEXT NOT NULL,   -- Supabase indicator UUID
  indicator_name TEXT NOT NULL, -- For display while offline
  facility_id TEXT NOT NULL,    -- Supabase facility UUID
  facility_name TEXT NOT NULL,  -- For display while offline
  year INTEGER NOT NULL,
  quarter TEXT NOT NULL,
  month TEXT,
  value REAL NOT NULL,
  numerator REAL,
  denominator REAL,
  data_quality TEXT DEFAULT 'Unverified',
  notes TEXT,
  sync_status TEXT DEFAULT 'pending', -- 'pending', 'synced', 'failed'
  created_at TEXT NOT NULL,
  synced_at TEXT,
  error_message TEXT
);
```

### Cache reference data:
On first launch (or periodic refresh), fetch and cache:
- `GET /facilities` → store locally
- `GET /indicators` → store locally

This allows the data entry form to work **fully offline**.

---

## Key Rules

1. **Always set `data_origin = 'mobile_app'`** when inserting into `indicator_data`
2. **Always set `entered_by`** to the current auth user's UUID
3. **Unique constraint:** `(indicator_id, facility_id, year, quarter, month)` — don't submit duplicates
4. **Quarter mapping:** Q1 = Jan-Mar, Q2 = Apr-Jun, Q3 = Jul-Sep, Q4 = Oct-Dec
5. **Data quality** should default to `'Unverified'` for field-collected data

---

## Screens to Build

| # | Screen | Description |
|---|--------|-------------|
| 1 | **Login** | Email + password via Supabase Auth |
| 2 | **Home** | Quick stats (pending/synced count), action buttons |
| 3 | **Data Entry Form** | Select indicator → facility → period → value → save |
| 4 | **Entry History** | List of submitted entries with sync status |
| 5 | **Sync** | Manual sync button + auto-sync on connectivity |
| 6 | **Settings** | User profile, facility/indicator cache refresh |

---

## Tech Stack Recommendations

| Component | Recommended |
|-----------|------------|
| Framework | Flutter (Android + iOS) |
| Auth | `supabase_flutter` package |
| Local DB | `sqflite` or `drift` |
| Connectivity | `connectivity_plus` |
| State | `provider` or `riverpod` |
| HTTP | Built into `supabase_flutter` |

---

## Testing Checklist

- [ ] Can sign in with same credentials used on web dashboard
- [ ] Indicator & facility dropdowns populate (online)
- [ ] Data entry saves locally when offline
- [ ] Sync pushes data to Supabase when reconnected
- [ ] Submitted data appears on web dashboard under correct indicator/quarter
- [ ] Duplicate entries are rejected (unique constraint)
- [ ] `data_origin` shows as `'mobile_app'` in Supabase
