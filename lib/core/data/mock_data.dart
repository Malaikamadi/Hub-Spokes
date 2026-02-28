import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';

class MockData {
  MockData._();

  // KPI Cards Data (legacy)
  static const List<KpiData> kpiCards = [
    KpiData(
      title: 'MATERNAL DEATHS',
      value: '137',
      changeText: '↓ 12% vs last Q',
      isPositive: true,
      subtitle: 'Goal: < 100/year',
    ),
    KpiData(
      title: 'NEONATAL DEATHS',
      value: '1,252',
      changeText: '↗ 5% vs last Q',
      isPositive: false,
      subtitle: 'Critical attention needed in Spokes',
    ),
    KpiData(
      title: 'FAMILY PLANNING',
      value: '78,831',
      changeText: '↗ 15%',
      isPositive: true,
      subtitle: 'New clients increasing',
    ),
    KpiData(
      title: 'FACILITY DELIVERIES',
      value: '31,892',
      changeText: '↗ 9%',
      isPositive: true,
      subtitle: 'Institutional Delivery Rate',
    ),
  ];

  // ─── Categorized KPI Indicators ───────────────────────────────────
  static final List<KpiCategory> kpiCategories = [
    KpiCategory(
      level: 'Impact',
      color: const Color(0xFFEF4444), // Red
      icon: Icons.trending_down_rounded,
      indicators: const [
        KpiIndicator(
          number: 1,
          name: 'Number of Maternal Deaths',
          value: '137',
          changeText: '↓ 12% vs last Q',
          isPositive: true,
          sdgTag: 'SDG 3.1.1',
          source: 'DHIS2, MPDSR/ECBDS',
          targetDescription: 'Goal: < 100/year. Reduce from 2015 baseline',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 2,
          name: 'Number of Under‑five Deaths',
          value: '1,252',
          changeText: '↗ 5% vs last Q',
          isPositive: false,
          sdgTag: 'SDG 3.2.1',
          source: 'DHIS2, MPDSR/ECBDS',
          targetDescription: 'SDG Target: ≤25 per 1,000 live births by 2030',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 3,
          name: 'Number of Neonatal Deaths',
          value: '847',
          changeText: '↓ 3% vs last Q',
          isPositive: true,
          sdgTag: 'SDG 3.2.2',
          source: 'DHIS2, MPDSR/ECBDS',
          targetDescription: 'SDG Target: ≤12 per 1,000 live births by 2030',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 4,
          name: 'Number of Stillbirths',
          value: '312',
          changeText: '↓ 8% vs last Q',
          isPositive: true,
          source: 'DHIS2, MPDSR/ECBDS',
          targetDescription: 'Target: < 350/year across hubs & spokes',
          status: 'On Track',
        ),
      ],
    ),
    KpiCategory(
      level: 'Outcome',
      color: const Color(0xFF3B82F6), // Blue
      icon: Icons.show_chart_rounded,
      indicators: const [
        KpiIndicator(
          number: 5,
          name: 'Modern Contraceptive Uptake (All Methods & Clients)',
          value: '78,831',
          changeText: '↗ 15%',
          isPositive: true,
          source: 'DHIS2, FP registers',
          targetDescription: 'Target: 20,000 new acceptors/quarter',
          status: 'On Track',
        ),
        KpiIndicator(
          number: 6,
          name: 'ANC 1st Visit Before 12 Weeks Gestation',
          value: '34.2%',
          changeText: '↗ 4% vs last Q',
          isPositive: true,
          source: 'DQA',
          targetDescription: 'Target: ≥22% of all ANC 1st visits',
          status: 'On Track',
        ),
        KpiIndicator(
          number: 7,
          name: 'Number of Antenatal Care 4+ Visits',
          value: '4,218',
          changeText: '↗ 7%',
          isPositive: true,
          source: 'DHIS2, ANC registers, ',
          targetDescription: 'Target: 4,500 contacts/quarter',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 8,
          name: 'Clients Receiving Post Abortion Care (PAC)',
          value: '1,345',
          changeText: '↗ 2%',
          isPositive: false,
          source: 'DHIS2, FF/PAC registers, theatre logs',
          targetDescription: 'Target: 1,500 clients/quarter',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 9,
          name: 'Children <1 Year Fully Immunized',
          value: '68.4%',
          changeText: '↗ 6%',
          isPositive: true,
          sdgTag: 'SDG 3.b.1',
          source: 'DHIS2, EPI/U5 registers',
          targetDescription: 'WHO Target: ≥90% coverage by 2030',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 10,
          name: 'Proportion of Under‑5 Children Treated for SAM (SAM Cured)',
          value: '82.1%',
          changeText: '↗ 3%',
          isPositive: true,
          source: 'DHIS2, Nutrition registers',
          targetDescription: 'Target: ≥75% cure rate',
          status: 'On Track',
        ),
        KpiIndicator(
          number: 11,
          name: 'Proportion of Caesarean Sections Conducted',
          value: '8.7%',
          changeText: '↗ 1.2%',
          isPositive: true,
          source: 'Theatre & delivery registers, DHIS2',
          targetDescription: 'WHO recommended range: 10–15%',
          status: 'Off Track',
        ),
      ],
    ),
    KpiCategory(
      level: 'Output',
      color: const Color(0xFFF59E0B), // Amber
      icon: Icons.assessment_rounded,
      indicators: const [
        KpiIndicator(
          number: 12,
          name: 'Proportion of Maternal Deaths Reviewed',
          value: '91.2%',
          changeText: '↗ 5%',
          isPositive: true,
          source: 'MPDSR Reports',
          targetDescription: 'Target: 100% of facility maternal deaths reviewed',
          status: 'On Track',
        ),
        KpiIndicator(
          number: 13,
          name: 'Proportion of Perinatal Deaths Reviewed',
          value: '78.6%',
          changeText: '↗ 8%',
          isPositive: true,
          source: 'MPDSR Reports 2025',
          targetDescription: 'Target: 100% of facility perinatal deaths reviewed',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 14,
          name: 'Proportion of Child Deaths Reviewed',
          value: '65.4%',
          changeText: '↗ 10%',
          isPositive: true,
          source: 'MPDSR Reports 2025',
          targetDescription: 'Target: 100% of facility child deaths reviewed',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 15,
          name: 'Outpatient Service Utilization',
          value: '58,412',
          changeText: '↗ 4%',
          isPositive: true,
          source: 'Perinatal death review forms/report, registers',
          targetDescription: 'Target: 60,000 visits/quarter',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 16,
          name: 'Bed Occupancy Rate (BOR)',
          value: '62.3%',
          changeText: '↓ 2%',
          isPositive: false,
          source: 'Child death review forms/report, registers',
          targetDescription: 'Target: ≥65% occupancy rate',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 17,
          name: 'Referrals Completed Between Spokes and Hubs',
          value: '74.8%',
          changeText: '↗ 6%',
          isPositive: true,
          source: 'DHIS2',
          targetDescription: 'Target: ≥80% successful referral completion',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 18,
          name: 'Facilities with Stock‑out of Essential Commodities',
          value: '3.2%',
          changeText: '↓ 1.8%',
          isPositive: true,
          source: 'DHIS2',
          targetDescription: 'Target: <5% stock-out rate',
          status: 'On Track',
        ),
      ],
    ),
    KpiCategory(
      level: 'Input',
      color: const Color(0xFF8B5CF6), // Purple
      icon: Icons.inventory_2_rounded,
      indicators: const [
        KpiIndicator(
          number: 19,
          name: 'Hubs‑Spokes Service Availability and Readiness Score',
          value: '76.5%',
          changeText: '↗ 3%',
          isPositive: true,
          source: 'Referral registers (spoke & hub), NEMS ',
          targetDescription: 'Target: ≥80% readiness score',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 20,
          name: 'Hubs Conducting at Least One Outreach to Spokes/Month',
          value: '84.1%',
          changeText: '↗ 5%',
          isPositive: true,
          source: 'DHIS2, stock reports, mSupply',
          targetDescription: 'Target: ≥90% of hubs conducting monthly outreach',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 21,
          name: 'Spokes Conducting at Least One Community Outreach/Month',
          value: '71.3%',
          changeText: '↗ 2%',
          isPositive: true,
          source: 'Supportive supervision reports',
          targetDescription: 'Target: ≥80% of spokes conducting monthly outreach',
          status: 'Off Track',
        ),
        KpiIndicator(
          number: 22,
          name: 'Facility Management Committee (FMC) Meetings Held',
          value: '68.9%',
          changeText: '↓ 4%',
          isPositive: false,
          source: 'FMC Minutes ',
          targetDescription: 'Target: 100% of FMCs meeting quarterly',
          status: 'Off Track',
        ),
      ],
    ),
  ];

  // Chart Data - Maternal Mortality Ratio
  static const List<ChartDataPoint> maternalMortalityData = [
    ChartDataPoint(month: 'Jan', hubValue: 2, spokeValue: 1),
    ChartDataPoint(month: 'Feb', hubValue: 3, spokeValue: 1.5),
    ChartDataPoint(month: 'Mar', hubValue: 5, spokeValue: 2),
    ChartDataPoint(month: 'Apr', hubValue: 7, spokeValue: 3),
    ChartDataPoint(month: 'May', hubValue: 10, spokeValue: 4),
    ChartDataPoint(month: 'Jun', hubValue: 12, spokeValue: 5),
    ChartDataPoint(month: 'Jul', hubValue: 18, spokeValue: 6),
    ChartDataPoint(month: 'Aug', hubValue: 14, spokeValue: 7),
    ChartDataPoint(month: 'Sep', hubValue: 11, spokeValue: 8),
    ChartDataPoint(month: 'Oct', hubValue: 10, spokeValue: 7),
    ChartDataPoint(month: 'Nov', hubValue: 9, spokeValue: 6),
    ChartDataPoint(month: 'Dec', hubValue: 8, spokeValue: 7),
  ];

  // Quarterly Data
  static const List<QuarterlyData> quarterlyData = [
    QuarterlyData(
      quarter: 'Q1',
      hubTotal: 10,
      spokeTotal: 4.5,
      monthlyData: [
        ChartDataPoint(month: 'Jan', hubValue: 2, spokeValue: 1),
        ChartDataPoint(month: 'Feb', hubValue: 3, spokeValue: 1.5),
        ChartDataPoint(month: 'Mar', hubValue: 5, spokeValue: 2),
      ],
    ),
    QuarterlyData(
      quarter: 'Q2',
      hubTotal: 29,
      spokeTotal: 12,
      monthlyData: [
        ChartDataPoint(month: 'Apr', hubValue: 7, spokeValue: 3),
        ChartDataPoint(month: 'May', hubValue: 10, spokeValue: 4),
        ChartDataPoint(month: 'Jun', hubValue: 12, spokeValue: 5),
      ],
    ),
    QuarterlyData(
      quarter: 'Q3',
      hubTotal: 43,
      spokeTotal: 21,
      monthlyData: [
        ChartDataPoint(month: 'Jul', hubValue: 18, spokeValue: 6),
        ChartDataPoint(month: 'Aug', hubValue: 14, spokeValue: 7),
        ChartDataPoint(month: 'Sep', hubValue: 11, spokeValue: 8),
      ],
    ),
    QuarterlyData(
      quarter: 'Q4',
      hubTotal: 27,
      spokeTotal: 20,
      monthlyData: [
        ChartDataPoint(month: 'Oct', hubValue: 10, spokeValue: 7),
        ChartDataPoint(month: 'Nov', hubValue: 9, spokeValue: 6),
        ChartDataPoint(month: 'Dec', hubValue: 8, spokeValue: 7),
      ],
    ),
  ];

  // Facility distribution data per quarter
  static const Map<String, List<FacilityData>> facilityDistribution = {
    'Q1': [
      FacilityData(facilityName: 'Kenema Hub', value: 3, isHub: true),
      FacilityData(facilityName: 'Bo Hub', value: 2, isHub: true),
      FacilityData(facilityName: 'Makeni Hub', value: 2, isHub: true),
      FacilityData(facilityName: 'Freetown Hub', value: 1.5, isHub: true),
      FacilityData(facilityName: 'Kono Hub', value: 1, isHub: true),
      FacilityData(facilityName: 'Port Loko Hub', value: 0.5, isHub: true),
      FacilityData(facilityName: 'Kenema Spoke', value: 1.5, isHub: false),
      FacilityData(facilityName: 'Bo Spoke', value: 1, isHub: false),
      FacilityData(facilityName: 'Makeni Spoke', value: 0.8, isHub: false),
      FacilityData(facilityName: 'Freetown Spoke', value: 0.5, isHub: false),
      FacilityData(facilityName: 'Kono Spoke', value: 0.4, isHub: false),
      FacilityData(facilityName: 'Port Loko Spoke', value: 0.3, isHub: false),
    ],
    'Q2': [
      FacilityData(facilityName: 'Kenema Hub', value: 8, isHub: true),
      FacilityData(facilityName: 'Bo Hub', value: 6, isHub: true),
      FacilityData(facilityName: 'Makeni Hub', value: 5, isHub: true),
      FacilityData(facilityName: 'Freetown Hub', value: 4, isHub: true),
      FacilityData(facilityName: 'Kono Hub', value: 3.5, isHub: true),
      FacilityData(facilityName: 'Port Loko Hub', value: 2.5, isHub: true),
      FacilityData(facilityName: 'Kenema Spoke', value: 3.5, isHub: false),
      FacilityData(facilityName: 'Bo Spoke', value: 2.5, isHub: false),
      FacilityData(facilityName: 'Makeni Spoke', value: 2, isHub: false),
      FacilityData(facilityName: 'Freetown Spoke', value: 1.5, isHub: false),
      FacilityData(facilityName: 'Kono Spoke', value: 1.5, isHub: false),
      FacilityData(facilityName: 'Port Loko Spoke', value: 1, isHub: false),
    ],
    'Q3': [
      FacilityData(facilityName: 'Kenema Hub', value: 12, isHub: true),
      FacilityData(facilityName: 'Bo Hub', value: 9, isHub: true),
      FacilityData(facilityName: 'Makeni Hub', value: 7, isHub: true),
      FacilityData(facilityName: 'Freetown Hub', value: 6, isHub: true),
      FacilityData(facilityName: 'Kono Hub', value: 5, isHub: true),
      FacilityData(facilityName: 'Port Loko Hub', value: 4, isHub: true),
      FacilityData(facilityName: 'Kenema Spoke', value: 5, isHub: false),
      FacilityData(facilityName: 'Bo Spoke', value: 4, isHub: false),
      FacilityData(facilityName: 'Makeni Spoke', value: 4, isHub: false),
      FacilityData(facilityName: 'Freetown Spoke', value: 3, isHub: false),
      FacilityData(facilityName: 'Kono Spoke', value: 3, isHub: false),
      FacilityData(facilityName: 'Port Loko Spoke', value: 2, isHub: false),
    ],
    'Q4': [
      FacilityData(facilityName: 'Kenema Hub', value: 8, isHub: true),
      FacilityData(facilityName: 'Bo Hub', value: 6, isHub: true),
      FacilityData(facilityName: 'Makeni Hub', value: 4.5, isHub: true),
      FacilityData(facilityName: 'Freetown Hub', value: 3.5, isHub: true),
      FacilityData(facilityName: 'Kono Hub', value: 3, isHub: true),
      FacilityData(facilityName: 'Port Loko Hub', value: 2, isHub: true),
      FacilityData(facilityName: 'Kenema Spoke', value: 5, isHub: false),
      FacilityData(facilityName: 'Bo Spoke', value: 4, isHub: false),
      FacilityData(facilityName: 'Makeni Spoke', value: 3.5, isHub: false),
      FacilityData(facilityName: 'Freetown Spoke', value: 3, isHub: false),
      FacilityData(facilityName: 'Kono Spoke', value: 2.5, isHub: false),
      FacilityData(facilityName: 'Port Loko Spoke', value: 2, isHub: false),
    ],
  };

  // Target Progress Data
  static const List<TargetProgressItem> targetProgress = [
    TargetProgressItem(name: 'ANC 4+ Visits', percentage: 72),
    TargetProgressItem(name: 'Skilled Birth Attend.', percentage: 85),
    TargetProgressItem(name: 'Penta 3 Coverage', percentage: 45),
  ];

  // M&E Framework Data
  static List<FrameworkLevel> frameworkLevels = [
    FrameworkLevel(
      name: 'Impact Level',
      indicatorCount: 4,
      indicators: [
        IndicatorItem(
          number: 1,
          name: 'Maternal Mortality Ratio',
          definition:
              'Count of all maternal deaths (pregnancy to 42 days postpartum) occurring in hub and spoke facilities.',
          frequency: 'Quarterly',
          target: '35',
          source: 'DHIS2, MPDSR',
        ),
        IndicatorItem(
          number: 2,
          name: 'Under-five Mortality Rate',
          definition:
              'Count of all facility deaths among children under 5 years.',
          frequency: 'Quarterly',
          target: '55',
          source: 'DHIS2, MPDSR',
        ),
        IndicatorItem(
          number: 3,
          name: 'Neonatal Mortality Rate',
          definition:
              'Count of all deaths among liveborn infants in first 28 days of life.',
          frequency: 'Quarterly',
          target: '300',
          source: 'DHIS2, MPDSR',
        ),
        IndicatorItem(
          number: 4,
          name: 'Number of Stillbirths',
          definition:
              'Count of fresh (intrapartum) stillbirths occurring in facilities.',
          frequency: 'Quarterly',
          target: '350',
          source: 'DHIS2, MPDSR',
        ),
      ],
    ),
    FrameworkLevel(
      name: 'Outcome Level',
      indicatorCount: 5,
      indicators: [
        IndicatorItem(
          number: 5,
          name: 'Modern Contraceptive Uptake',
          definition:
              'Number of women 15–49 years who received modern contraceptive methods.',
          frequency: 'Quarterly',
          target: '20,000',
          source: 'DHIS2, FP registers',
        ),
        IndicatorItem(
          number: 6,
          name: 'ANC 1st visit before 12 weeks',
          definition:
              '(# of women attending ANC1 <12 weeks/Total ANC 1st visit)×100',
          frequency: 'Quarterly',
          target: '22%',
          source: 'DHIS2, ANC registers',
        ),
        IndicatorItem(
          number: 7,
          name: 'Antenatal care 4+ visits',
          definition:
              'Count of pregnant women who have completed ANC 4 contacts.',
          frequency: 'Quarterly',
          target: '4500',
          source: 'DHIS2, ANC registers',
        ),
        IndicatorItem(
          number: 8,
          name: 'Post Abortion Care (PAC) Clients',
          definition:
              'Count of clients treated for complications of abortion.',
          frequency: 'Quarterly',
          target: '1500',
          source: 'DHIS2, PAC registers',
        ),
        IndicatorItem(
          number: 9,
          name: 'Children <1 year fully immunized',
          definition:
              '(Number of children <1 year fully immunized ÷ Total children <1 year) × 100',
          frequency: 'Quarterly',
          target: '4000',
          source: 'DHIS2, EPI registers',
        ),
      ],
    ),
    FrameworkLevel(
      name: 'Output Level',
      indicatorCount: 2,
      indicators: [
        IndicatorItem(
          number: 14,
          name: 'Outpatient Service Utilization',
          definition: 'Number of out patients Visits',
          frequency: 'Quarterly',
          target: '60000',
          source: 'DHIS2',
        ),
        IndicatorItem(
          number: 15,
          name: 'Bed Occupancy Rate',
          definition:
              'Total Inpatient Days/ Beds × Days in Period × 100',
          frequency: 'Quarterly',
          target: '65%',
          source: 'DHIS2, General Register',
        ),
      ],
    ),
    FrameworkLevel(
      name: 'Input/Process Level',
      indicatorCount: 1,
      indicators: [
        IndicatorItem(
          number: 17,
          name: 'Stock-out of essential commodities',
          definition:
              'Proportion of facilities with stock-out of essential commodities',
          frequency: 'Quarterly',
          target: '<5%',
          source: 'DHIS2, Stock reports',
        ),
      ],
    ),
  ];

  // Dropdown options for chart
  static const List<String> chartDropdownOptions = [
    'Maternal Mortality Ratio',
    'Neonatal Mortality Rate',
    'Under-five Mortality Rate',
    'Family Planning Uptake',
    'Facility Deliveries',
  ];
}
