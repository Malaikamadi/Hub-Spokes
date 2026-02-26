
-- ─── SEED FACILITIES ────────────────────────────────────────
INSERT INTO facilities (name, type, district, region) VALUES
  ('Kenema Hub',       'Hub',   'Kenema',    'Eastern'),
  ('Bo Hub',           'Hub',   'Bo',        'Southern'),
  ('Makeni Hub',       'Hub',   'Bombali',   'Northern'),
  ('Freetown Hub',     'Hub',   'Western',   'Western Area'),
  ('Kono Hub',         'Hub',   'Kono',      'Eastern'),
  ('Port Loko Hub',    'Hub',   'Port Loko', 'Northern'),
  ('Kenema Spoke',     'Spoke', 'Kenema',    'Eastern'),
  ('Bo Spoke',         'Spoke', 'Bo',        'Southern'),
  ('Makeni Spoke',     'Spoke', 'Bombali',   'Northern'),
  ('Freetown Spoke',   'Spoke', 'Western',   'Western Area'),
  ('Kono Spoke',       'Spoke', 'Kono',      'Eastern'),
  ('Port Loko Spoke',  'Spoke', 'Port Loko', 'Northern')
ON CONFLICT (name) DO NOTHING;

-- ─── SEED INDICATORS ────────────────────────────────────────
INSERT INTO indicators (number, name, result_level, data_source, sdg_tag, unit, target_value, target_description, is_positive_good, sort_order) VALUES
  -- Impact Level (4 indicators)
  (1,  'Number of Maternal Deaths',                           'Impact',   'DHIS2, MPDSR/ECBDS',                   'SDG 3.1.1', 'count',      '< 100/year',          'Goal: < 100/year. Reduce from 2015 baseline',   false, 1),
  (2,  'Number of Under-five Deaths',                         'Impact',   'DHIS2, MPDSR/ECBDS',                   'SDG 3.2.1', 'count',      '≤25/1000',            'SDG Target: ≤25 per 1,000 live births by 2030',  false, 2),
  (3,  'Number of Neonatal Deaths',                           'Impact',   'DHIS2, MPDSR/ECBDS',                   'SDG 3.2.2', 'count',      '≤12/1000',            'SDG Target: ≤12 per 1,000 live births by 2030',  false, 3),
  (4,  'Number of Stillbirths',                               'Impact',   'DHIS2, MPDSR/ECBDS',                   NULL,        'count',      '< 350/year',          'Target: < 350/year across hubs & spokes',        false, 4),

  -- Outcome Level (7 indicators)
  (5,  'Modern Contraceptive Uptake (All Methods & New)',      'Outcome',  'DHIS2, FP registers',                  NULL,        'count',      '20000/quarter',       'Target: 20,000 new acceptors/quarter',           true,  5),
  (6,  'ANC 1st Visit Before 12 Weeks Gestation',             'Outcome',  'DQA',                                  NULL,        'percentage', '≥22%',                'Target: ≥22% of all ANC 1st visits',             true,  6),
  (7,  'Number of Antenatal Care 4+ Visits',                  'Outcome',  'DHIS2, ANC registers',                 NULL,        'count',      '4500/quarter',        'Target: 4,500 contacts/quarter',                 true,  7),
  (8,  'Clients Receiving Post Abortion Care (PAC)',           'Outcome',  'DHIS2, FF/PAC registers, theatre logs', NULL,        'count',      '1500/quarter',        'Target: 1,500 clients/quarter',                  true,  8),
  (9,  'Children <1 Year Fully Immunized',                    'Outcome',  'DHIS2, EPI/U5 registers',              'SDG 3.b.1', 'percentage', '≥90%',                'WHO Target: ≥90% coverage by 2030',              true,  9),
  (10, 'Proportion of Under-5 Children Treated for SAM/MAM',  'Outcome',  'DHIS2, Nutrition registers',           NULL,        'percentage', '≥75%',                'Target: ≥75% cure rate',                         true,  10),
  (11, 'Proportion of Caesarean Sections Conducted',           'Outcome',  'Theatre & delivery registers, DHIS2',  NULL,        'percentage', '10-15%',              'WHO recommended range: 10–15%',                  true,  11),

  -- Output Level (7 indicators)
  (12, 'Maternal Death Review Rate',                           'Output',   'MPDSR Reports',                        NULL,        'percentage', '100%',                'Target: 100% of facility maternal deaths reviewed', true, 12),
  (13, 'Perinatal Death Review Rate',                          'Output',   'Perinatal death review forms/report, registers', NULL, 'percentage', '≥80%',             'Target: ≥80% of perinatal deaths reviewed',      true,  13),
  (14, 'Child Death Review Rate',                              'Output',   'Child death review forms/report, registers',   NULL, 'percentage', '≥75%',              'Target: ≥75% of child deaths reviewed',          true,  14),
  (15, 'OPD Attendance',                                       'Output',   'Perinatal death review forms/report, registers', NULL, 'count',    '60000/quarter',     'Target: 60,000 visits/quarter',                  true,  15),
  (16, 'Bed Occupancy Rate',                                   'Output',   'Child death review forms/report, registers',   NULL, 'percentage', '≥65%',              'Target: ≥65% occupancy rate',                    true,  16),
  (17, 'Referral Completion Rate',                             'Output',   'DHIS2',                                NULL,        'percentage', '≥80%',                'Target: ≥80% successful referral completion',    true,  17),
  (18, 'Essential Drug Stock-out Rate',                        'Output',   'DHIS2',                                NULL,        'percentage', '<5%',                 'Target: <5% stock-out rate',                     false, 18),

  -- Input Level (4 indicators)
  (19, 'Service Readiness Score',                              'Input',    'Referral registers (spoke & hub), NEMS', NULL,       'percentage', '≥80%',                'Target: ≥80% readiness score',                   true,  19),
  (20, 'Hub Outreach Coverage',                                'Input',    'DHIS2, stock reports, mSupply',        NULL,        'percentage', '≥90%',                'Target: ≥90% of hubs conducting monthly outreach', true, 20),
  (21, 'Spoke Outreach Coverage',                              'Input',    'Supportive supervision reports',       NULL,        'percentage', '≥80%',                'Target: ≥80% of spokes conducting monthly outreach', true, 21),
  (22, 'Facility Management Committee Meeting Rate',           'Input',    'FMC Minutes',                          NULL,        'percentage', '100%',                'Target: 100% of FMCs meeting quarterly',         true,  22)
ON CONFLICT (number) DO NOTHING;


-- These are the aggregate values shown on the dashboard cards
DO $$
DECLARE
  v_ind_id UUID;
BEGIN
  -- Indicator 1: Number of Maternal Deaths
  SELECT id INTO v_ind_id FROM indicators WHERE number = 1;
  INSERT INTO quarterly_summaries (indicator_id, year, quarter, hub_total, spoke_total, combined_total, change_text, is_positive, status) VALUES
    (v_ind_id, 2025, 'Q1', 25, 10, 35,  '↓ 5% vs Q4',    true,  'Off Track'),
    (v_ind_id, 2025, 'Q2', 30, 12, 42,  '↗ 20% vs Q1',   false, 'Off Track'),
    (v_ind_id, 2025, 'Q3', 22, 8,  30,  '↓ 29% vs Q2',   true,  'Off Track'),
    (v_ind_id, 2025, 'Q4', 20, 10, 30,  '→ 0% vs Q3',    true,  'Off Track');

  -- Indicator 2: Under-five Deaths
  SELECT id INTO v_ind_id FROM indicators WHERE number = 2;
  INSERT INTO quarterly_summaries (indicator_id, year, quarter, hub_total, spoke_total, combined_total, change_text, is_positive, status) VALUES
    (v_ind_id, 2025, 'Q1', 200, 112, 312,  '↓ 3% vs Q4',    true,  'Off Track'),
    (v_ind_id, 2025, 'Q2', 220, 118, 338,  '↗ 8% vs Q1',    false, 'Off Track'),
    (v_ind_id, 2025, 'Q3', 210, 105, 315,  '↓ 7% vs Q2',    true,  'Off Track'),
    (v_ind_id, 2025, 'Q4', 198, 102, 300,  '↓ 5% vs Q3',    true,  'Off Track');

  -- Indicator 3: Neonatal Deaths
  SELECT id INTO v_ind_id FROM indicators WHERE number = 3;
  INSERT INTO quarterly_summaries (indicator_id, year, quarter, hub_total, spoke_total, combined_total, change_text, is_positive, status) VALUES
    (v_ind_id, 2025, 'Q1', 140, 70, 210,  '↓ 2% vs Q4',    true,  'Off Track'),
    (v_ind_id, 2025, 'Q2', 150, 75, 225,  '↗ 7% vs Q1',    false, 'Off Track'),
    (v_ind_id, 2025, 'Q3', 135, 68, 203,  '↓ 10% vs Q2',   true,  'Off Track'),
    (v_ind_id, 2025, 'Q4', 130, 65, 195,  '↓ 4% vs Q3',    true,  'Off Track');

  -- Indicator 5: Modern Contraceptive Uptake
  SELECT id INTO v_ind_id FROM indicators WHERE number = 5;
  INSERT INTO quarterly_summaries (indicator_id, year, quarter, hub_total, spoke_total, combined_total, change_text, is_positive, status) VALUES
    (v_ind_id, 2025, 'Q1', 11000, 7500, 18500,  '↗ 10% vs Q4',   true,  'Off Track'),
    (v_ind_id, 2025, 'Q2', 12000, 8200, 20200,  '↗ 9% vs Q1',    true,  'On Track'),
    (v_ind_id, 2025, 'Q3', 11500, 7800, 19300,  '↓ 4% vs Q2',    false, 'Off Track'),
    (v_ind_id, 2025, 'Q4', 12500, 8600, 21100,  '↗ 9% vs Q3',    true,  'On Track');
END $$;
