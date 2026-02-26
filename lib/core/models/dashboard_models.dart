import 'package:flutter/material.dart';

class KpiData {
  final String title;
  final String value;
  final String changeText;
  final bool isPositive;
  final String subtitle;

  const KpiData({
    required this.title,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.subtitle,
  });
}

class KpiIndicator {
  final int number;
  final String name;
  final String value;
  final String changeText;
  final bool isPositive;
  final String? sdgTag;
  final String source;
  final String targetDescription;
  final String status; // 'On Track', 'Off Track', 'No Target'

  const KpiIndicator({
    required this.number,
    required this.name,
    required this.value,
    required this.changeText,
    required this.isPositive,
    this.sdgTag,
    this.source = 'DHIS2, 2025',
    this.targetDescription = '',
    this.status = 'On Track',
  });
}

class KpiCategory {
  final String level;
  final Color color;
  final IconData icon;
  final List<KpiIndicator> indicators;

  const KpiCategory({
    required this.level,
    required this.color,
    required this.icon,
    required this.indicators,
  });
}

class ChartDataPoint {
  final String month;
  final double hubValue;
  final double spokeValue;

  const ChartDataPoint({
    required this.month,
    required this.hubValue,
    required this.spokeValue,
  });
}

class QuarterlyData {
  final String quarter; // 'Q1', 'Q2', 'Q3', 'Q4'
  final List<ChartDataPoint> monthlyData; // 3 months per quarter
  final double hubTotal;
  final double spokeTotal;

  const QuarterlyData({
    required this.quarter,
    required this.monthlyData,
    required this.hubTotal,
    required this.spokeTotal,
  });
}

class FacilityData {
  final String facilityName;
  final double value;
  final bool isHub; // true = Hub, false = Spoke

  const FacilityData({
    required this.facilityName,
    required this.value,
    required this.isHub,
  });
}

class TargetProgressItem {
  final String name;
  final double percentage;

  const TargetProgressItem({
    required this.name,
    required this.percentage,
  });
}

class IndicatorItem {
  final int number;
  final String name;
  final String definition;
  final String frequency;
  final String target;
  final String source;

  const IndicatorItem({
    required this.number,
    required this.name,
    required this.definition,
    required this.frequency,
    required this.target,
    required this.source,
  });
}

class FrameworkLevel {
  final String name;
  final int indicatorCount;
  final List<IndicatorItem> indicators;

  const FrameworkLevel({
    required this.name,
    required this.indicatorCount,
    required this.indicators,
  });
}
