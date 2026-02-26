/// Dart models matching the Supabase database schema.
/// These models handle JSON serialization for the Supabase REST API.

class Facility {
  final String id;
  final String name;
  final String type; // 'Hub' or 'Spoke'
  final String district;
  final String? region;
  final bool isActive;
  final DateTime? createdAt;

  const Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.district,
    this.region,
    this.isActive = true,
    this.createdAt,
  });

  bool get isHub => type == 'Hub';

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      district: json['district'] as String,
      region: json['region'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'district': district,
        'region': region,
        'is_active': isActive,
      };
}

class Indicator {
  final String id;
  final int number;
  final String name;
  final String resultLevel; // 'Impact', 'Outcome', 'Output', 'Input'
  final String? definition;
  final String? dataSource;
  final String frequency;
  final String? sdgTag;
  final String unit; // 'count', 'percentage', 'ratio', 'rate'
  final String? targetValue;
  final String? targetDescription;
  final bool isPositiveGood;
  final int sortOrder;

  const Indicator({
    required this.id,
    required this.number,
    required this.name,
    required this.resultLevel,
    this.definition,
    this.dataSource,
    this.frequency = 'Quarterly',
    this.sdgTag,
    this.unit = 'count',
    this.targetValue,
    this.targetDescription,
    this.isPositiveGood = true,
    this.sortOrder = 0,
  });

  factory Indicator.fromJson(Map<String, dynamic> json) {
    return Indicator(
      id: json['id'] as String,
      number: json['number'] as int,
      name: json['name'] as String,
      resultLevel: json['result_level'] as String,
      definition: json['definition'] as String?,
      dataSource: json['data_source'] as String?,
      frequency: json['frequency'] as String? ?? 'Quarterly',
      sdgTag: json['sdg_tag'] as String?,
      unit: json['unit'] as String? ?? 'count',
      targetValue: json['target_value'] as String?,
      targetDescription: json['target_description'] as String?,
      isPositiveGood: json['is_positive_good'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'result_level': resultLevel,
        'definition': definition,
        'data_source': dataSource,
        'frequency': frequency,
        'sdg_tag': sdgTag,
        'unit': unit,
        'target_value': targetValue,
        'target_description': targetDescription,
        'is_positive_good': isPositiveGood,
        'sort_order': sortOrder,
      };
}

class IndicatorDataEntry {
  final String id;
  final String indicatorId;
  final String facilityId;
  final int year;
  final String quarter; // 'Q1', 'Q2', 'Q3', 'Q4'
  final String? month;
  final double value;
  final double? numerator;
  final double? denominator;
  final String dataQuality;
  final String? enteredBy;
  final String? notes;
  final DateTime? createdAt;

  // Joined fields (populated when fetching with joins)
  final Facility? facility;
  final Indicator? indicator;

  const IndicatorDataEntry({
    required this.id,
    required this.indicatorId,
    required this.facilityId,
    required this.year,
    required this.quarter,
    this.month,
    required this.value,
    this.numerator,
    this.denominator,
    this.dataQuality = 'Verified',
    this.enteredBy,
    this.notes,
    this.createdAt,
    this.facility,
    this.indicator,
  });

  factory IndicatorDataEntry.fromJson(Map<String, dynamic> json) {
    return IndicatorDataEntry(
      id: json['id'] as String,
      indicatorId: json['indicator_id'] as String,
      facilityId: json['facility_id'] as String,
      year: json['year'] as int,
      quarter: json['quarter'] as String,
      month: json['month'] as String?,
      value: (json['value'] as num).toDouble(),
      numerator: (json['numerator'] as num?)?.toDouble(),
      denominator: (json['denominator'] as num?)?.toDouble(),
      dataQuality: json['data_quality'] as String? ?? 'Verified',
      enteredBy: json['entered_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      facility: json['facilities'] != null
          ? Facility.fromJson(json['facilities'] as Map<String, dynamic>)
          : null,
      indicator: json['indicators'] != null
          ? Indicator.fromJson(json['indicators'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'indicator_id': indicatorId,
        'facility_id': facilityId,
        'year': year,
        'quarter': quarter,
        'month': month,
        'value': value,
        'numerator': numerator,
        'denominator': denominator,
        'data_quality': dataQuality,
        'notes': notes,
      };
}

class QuarterlySummary {
  final String id;
  final String indicatorId;
  final int year;
  final String quarter;
  final double hubTotal;
  final double spokeTotal;
  final double combinedTotal;
  final String? changeText;
  final bool? isPositive;
  final String status; // 'On Track', 'Off Track', 'No Target'

  // Joined field
  final Indicator? indicator;

  const QuarterlySummary({
    required this.id,
    required this.indicatorId,
    required this.year,
    required this.quarter,
    required this.hubTotal,
    required this.spokeTotal,
    required this.combinedTotal,
    this.changeText,
    this.isPositive,
    this.status = 'On Track',
    this.indicator,
  });

  factory QuarterlySummary.fromJson(Map<String, dynamic> json) {
    return QuarterlySummary(
      id: json['id'] as String,
      indicatorId: json['indicator_id'] as String,
      year: json['year'] as int,
      quarter: json['quarter'] as String,
      hubTotal: (json['hub_total'] as num?)?.toDouble() ?? 0,
      spokeTotal: (json['spoke_total'] as num?)?.toDouble() ?? 0,
      combinedTotal: (json['combined_total'] as num?)?.toDouble() ?? 0,
      changeText: json['change_text'] as String?,
      isPositive: json['is_positive'] as bool?,
      status: json['status'] as String? ?? 'On Track',
      indicator: json['indicators'] != null
          ? Indicator.fromJson(json['indicators'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'indicator_id': indicatorId,
        'year': year,
        'quarter': quarter,
        'hub_total': hubTotal,
        'spoke_total': spokeTotal,
        'combined_total': combinedTotal,
        'change_text': changeText,
        'is_positive': isPositive,
        'status': status,
      };
}

class TargetProgressEntry {
  final String id;
  final String indicatorId;
  final int year;
  final double targetValue;
  final double currentValue;
  final double percentage;

  // Joined field
  final Indicator? indicator;

  const TargetProgressEntry({
    required this.id,
    required this.indicatorId,
    required this.year,
    required this.targetValue,
    required this.currentValue,
    required this.percentage,
    this.indicator,
  });

  factory TargetProgressEntry.fromJson(Map<String, dynamic> json) {
    return TargetProgressEntry(
      id: json['id'] as String,
      indicatorId: json['indicator_id'] as String,
      year: json['year'] as int,
      targetValue: (json['target_value'] as num).toDouble(),
      currentValue: (json['current_value'] as num).toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      indicator: json['indicators'] != null
          ? Indicator.fromJson(json['indicators'] as Map<String, dynamic>)
          : null,
    );
  }
}
