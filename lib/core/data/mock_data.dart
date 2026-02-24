import '../models/dashboard_models.dart';

class MockData {
  MockData._();

  // KPI Cards Data
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

  // Target Progress Data
  static const List<TargetProgressItem> targetProgress = [
    TargetProgressItem(name: 'ANC 4+ Visits', percentage: 72),
    TargetProgressItem(name: 'Skilled Birth Attend.', percentage: 85),
    TargetProgressItem(name: 'Penta 3 Coverage', percentage: 45),
  ];

  // M&E Framework Data
  static const List<FrameworkLevel> frameworkLevels = [
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
