import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

/// Service for fetching M&E indicator data from Supabase.
///
/// Usage:
///   final service = DataService.instance;
///   final indicators = await service.getIndicators();
///   final q2Data = await service.getQuarterlySummaries(year: 2025, quarter: 'Q2');
class DataService {
  DataService._internal();
  static final DataService _instance = DataService._internal();
  static DataService get instance => _instance;

  SupabaseClient get _client => Supabase.instance.client;

  // ─── FACILITIES ─────────────────────────────────────────────

  /// Fetch all active facilities
  Future<List<Facility>> getFacilities() async {
    final response = await _client
        .from('facilities')
        .select()
        .eq('is_active', true)
        .order('type')
        .order('name');
    return (response as List).map((e) => Facility.fromJson(e)).toList();
  }

  /// Fetch only hubs
  Future<List<Facility>> getHubs() async {
    final response = await _client
        .from('facilities')
        .select()
        .eq('type', 'Hub')
        .eq('is_active', true)
        .order('name');
    return (response as List).map((e) => Facility.fromJson(e)).toList();
  }

  /// Fetch only spokes
  Future<List<Facility>> getSpokes() async {
    final response = await _client
        .from('facilities')
        .select()
        .eq('type', 'Spoke')
        .eq('is_active', true)
        .order('name');
    return (response as List).map((e) => Facility.fromJson(e)).toList();
  }

  // ─── INDICATORS ─────────────────────────────────────────────

  /// Fetch all indicator definitions
  Future<List<Indicator>> getIndicators() async {
    final response = await _client
        .from('indicators')
        .select()
        .order('sort_order');
    return (response as List).map((e) => Indicator.fromJson(e)).toList();
  }

  /// Fetch indicators grouped by result level
  Future<Map<String, List<Indicator>>> getIndicatorsByLevel() async {
    final indicators = await getIndicators();
    final grouped = <String, List<Indicator>>{};
    for (final ind in indicators) {
      grouped.putIfAbsent(ind.resultLevel, () => []).add(ind);
    }
    return grouped;
  }

  /// Fetch a single indicator by number
  Future<Indicator?> getIndicatorByNumber(int number) async {
    final response = await _client
        .from('indicators')
        .select()
        .eq('number', number)
        .maybeSingle();
    if (response == null) return null;
    return Indicator.fromJson(response);
  }

  // ─── INDICATOR DATA (raw values) ────────────────────────────

  /// Fetch indicator data for a specific indicator and period
  Future<List<IndicatorDataEntry>> getIndicatorData({
    required String indicatorId,
    int? year,
    String? quarter,
  }) async {
    var query = _client
        .from('indicator_data')
        .select('*, facilities(*), indicators(*)')
        .eq('indicator_id', indicatorId);

    if (year != null) query = query.eq('year', year);
    if (quarter != null) query = query.eq('quarter', quarter);

    final response = await query.order('year').order('quarter');
    return (response as List)
        .map((e) => IndicatorDataEntry.fromJson(e))
        .toList();
  }

  /// Fetch indicator data for a specific facility
  Future<List<IndicatorDataEntry>> getFacilityData({
    required String facilityId,
    int? year,
    String? quarter,
  }) async {
    var query = _client
        .from('indicator_data')
        .select('*, facilities(*), indicators(*)')
        .eq('facility_id', facilityId);

    if (year != null) query = query.eq('year', year);
    if (quarter != null) query = query.eq('quarter', quarter);

    final response = await query.order('year').order('quarter');
    return (response as List)
        .map((e) => IndicatorDataEntry.fromJson(e))
        .toList();
  }

  /// Insert a new data entry
  Future<IndicatorDataEntry> insertIndicatorData(
      IndicatorDataEntry entry) async {
    final response = await _client
        .from('indicator_data')
        .insert(entry.toJson())
        .select()
        .single();
    return IndicatorDataEntry.fromJson(response);
  }

  /// Update an existing data entry
  Future<void> updateIndicatorData(String id, Map<String, dynamic> updates) async {
    await _client.from('indicator_data').update(updates).eq('id', id);
  }

  // ─── QUARTERLY SUMMARIES ────────────────────────────────────

  /// Fetch quarterly summaries (dashboard KPI cards)
  Future<List<QuarterlySummary>> getQuarterlySummaries({
    int? year,
    String? quarter,
  }) async {
    var query = _client
        .from('quarterly_summaries')
        .select('*, indicators(*)');

    if (year != null) query = query.eq('year', year);
    if (quarter != null) query = query.eq('quarter', quarter);

    final response = await query.order('year').order('quarter');
    return (response as List)
        .map((e) => QuarterlySummary.fromJson(e))
        .toList();
  }

  /// Fetch the latest quarterly summary for each indicator
  Future<List<QuarterlySummary>> getLatestSummaries({int year = 2025}) async {
    final response = await _client
        .from('quarterly_summaries')
        .select('*, indicators(*)')
        .eq('year', year)
        .order('quarter', ascending: false);

    // Keep only the latest quarter per indicator
    final latest = <String, QuarterlySummary>{};
    for (final row in (response as List)) {
      final summary = QuarterlySummary.fromJson(row);
      latest.putIfAbsent(summary.indicatorId, () => summary);
    }
    return latest.values.toList();
  }

  /// Fetch summaries for a specific indicator (all quarters)
  Future<List<QuarterlySummary>> getIndicatorSummaries({
    required String indicatorId,
    int year = 2025,
  }) async {
    final response = await _client
        .from('quarterly_summaries')
        .select('*, indicators(*)')
        .eq('indicator_id', indicatorId)
        .eq('year', year)
        .order('quarter');
    return (response as List)
        .map((e) => QuarterlySummary.fromJson(e))
        .toList();
  }

  // ─── TARGET PROGRESS ────────────────────────────────────────

  /// Fetch target progress for a year
  Future<List<TargetProgressEntry>> getTargetProgress({
    int year = 2025,
  }) async {
    final response = await _client
        .from('target_progress')
        .select('*, indicators(*)')
        .eq('year', year);
    return (response as List)
        .map((e) => TargetProgressEntry.fromJson(e))
        .toList();
  }

  // ─── DISTRIBUTION DATA ──────────────────────────────────────

  /// Fetch facility-level distribution for a specific indicator & quarter
  Future<List<IndicatorDataEntry>> getDistributionData({
    required String indicatorId,
    required int year,
    required String quarter,
  }) async {
    final response = await _client
        .from('indicator_data')
        .select('*, facilities(*)')
        .eq('indicator_id', indicatorId)
        .eq('year', year)
        .eq('quarter', quarter)
        .order('value', ascending: false);
    return (response as List)
        .map((e) => IndicatorDataEntry.fromJson(e))
        .toList();
  }
}
