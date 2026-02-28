import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/dashboard_models.dart';
import '../../core/models/database_models.dart' as db;
import '../../core/services/data_service.dart';
import 'widgets/kpi_category_section.dart';
import 'widgets/dashboard_filter_panel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<KpiCategory> _categories = [];
  bool _isLoading = true;
  bool _isLive = false; // true = data from Supabase, false = mock

  @override
  
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Try fetching from Supabase
      final indicators = await DataService.instance.getIndicators();
      final summaries =
          await DataService.instance.getLatestSummaries(year: 2025);

      if (indicators.isNotEmpty) {
        // Build the summary lookup: indicatorId -> latest QuarterlySummary
        final summaryMap = <String, db.QuarterlySummary>{};
        for (final s in summaries) {
          summaryMap[s.indicatorId] = s;
        }

        // Group indicators by result level and build KpiCategory objects
        final levelConfig = {
          'Impact': (color: const Color(0xFFEF4444), icon: Icons.trending_down_rounded),
          'Outcome': (color: const Color(0xFF3B82F6), icon: Icons.show_chart_rounded),
          'Output': (color: const Color(0xFFF59E0B), icon: Icons.assessment_rounded),
          'Input': (color: const Color(0xFF8B5CF6), icon: Icons.inventory_2_rounded),
        };

        final grouped = <String, List<db.Indicator>>{};
        for (final ind in indicators) {
          grouped.putIfAbsent(ind.resultLevel, () => []).add(ind);
        }

        final categories = <KpiCategory>[];
        for (final level in ['Impact', 'Outcome', 'Output', 'Input']) {
          final inds = grouped[level];
          if (inds == null || inds.isEmpty) continue;

          final config = levelConfig[level]!;
          categories.add(KpiCategory(
            level: level,
            color: config.color,
            icon: config.icon,
            indicators: inds.map((ind) {
              final summary = summaryMap[ind.id];
              return KpiIndicator(
                number: ind.number,
                name: ind.name,
                value: summary != null
                    ? _formatValue(summary.combinedTotal, ind.unit)
                    : '—',
                changeText: summary?.changeText ?? '',
                isPositive: summary?.isPositive ?? true,
                sdgTag: ind.sdgTag,
                source: ind.dataSource ?? '',
                targetDescription: ind.targetDescription ?? '',
                status: summary?.status ?? 'No Target',
              );
            }).toList(),
          ));
        }

        if (mounted) {
          setState(() {
            _categories = categories;
            _isLoading = false;
            _isLive = true;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint('Supabase fetch failed, using mock data: $e');
    }

    // Fallback to mock data
    if (mounted) {
      setState(() {
        _categories = MockData.kpiCategories;
        _isLoading = false;
        _isLive = false;
      });
    }
  }

  String _formatValue(double value, String unit) {
    if (unit == 'percentage') {
      return '${value.toStringAsFixed(1)}%';
    }
    if (value >= 1000) {
      // Format with commas
      return value.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBg,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page header
                    _buildPageHeader(),
                    const SizedBox(height: 24),
                    // Categorized KPI Indicator Sections
                    ..._categories.map((category) => Padding(
                          padding: const EdgeInsets.only(bottom: 28),
                          child: KpiCategorySection(
                            category: category,
                            onIndicatorTap: (indicator, cat) {
                              context.go(
                                  '/dashboard/indicator/${indicator.number}');
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hubs & Spokes Performance',
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Monitoring Implementation Dashboard • 2025',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                // Live / Mock indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isLive
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isLive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _isLive ? 'Live' : 'Mock Data',
                        style: GoogleFonts.inter(
                          color: _isLive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Filter button
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withValues(alpha: 0.5),
                  builder: (context) => DashboardFilterPanel(
                    onApply: () {
                      // Apply filter logic here
                    },
                  ),
                );
              },
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.cardBorder),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Export Report button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
