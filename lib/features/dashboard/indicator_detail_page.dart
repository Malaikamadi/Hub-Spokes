import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/dashboard_models.dart';
import '../../core/models/database_models.dart' as db;
import '../../core/services/data_service.dart';
import 'widgets/facility_map_widget.dart';

class IndicatorDetailPage extends StatefulWidget {
  final int indicatorNumber;

  const IndicatorDetailPage({super.key, required this.indicatorNumber});

  @override
  State<IndicatorDetailPage> createState() => _IndicatorDetailPageState();
}

class _IndicatorDetailPageState extends State<IndicatorDetailPage> {
  late KpiIndicator _indicator;
  late KpiCategory _category;
  String _selectedQuarter = 'All';
  String _activeView = 'Aggregate';
  bool _isLive = false;

  @override
  void initState() {
    super.initState();
    _findIndicator();
    _tryFetchLiveData();
  }

  void _findIndicator() {
    // Start with mock data as default
    for (final cat in MockData.kpiCategories) {
      for (final ind in cat.indicators) {
        if (ind.number == widget.indicatorNumber) {
          _indicator = ind;
          _category = cat;
          return;
        }
      }
    }
  }

  Future<void> _tryFetchLiveData() async {
    try {
      final ind = await DataService.instance
          .getIndicatorByNumber(widget.indicatorNumber);
      if (ind == null) return;

      final summaries = await DataService.instance
          .getIndicatorSummaries(indicatorId: ind.id, year: 2025);

      final latest = summaries.isNotEmpty ? summaries.last : null;

      if (mounted) {
        setState(() {
          _indicator = KpiIndicator(
            number: ind.number,
            name: ind.name,
            value: latest != null
                ? latest.combinedTotal.toInt().toString()
                : _indicator.value,
            changeText: latest?.changeText ?? _indicator.changeText,
            isPositive: latest?.isPositive ?? _indicator.isPositive,
            sdgTag: ind.sdgTag,
            source: ind.dataSource ?? _indicator.source,
            targetDescription:
                ind.targetDescription ?? _indicator.targetDescription,
            status: latest?.status ?? _indicator.status,
          );
          _isLive = true;
        });
      }
    } catch (e) {
      debugPrint('Detail page: using mock data ($e)');
    }
  }

  Color get _statusColor {
    switch (_indicator.status) {
      case 'On Track':
        return const Color(0xFF22C55E);
      case 'Off Track':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.scaffoldBg,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Back + Breadcrumb ───────────────────────────
                _buildBreadcrumb(),
                const SizedBox(height: 24),
                // ─── Indicator Hero Card ─────────────────────────
                _buildHeroSection(),
                const SizedBox(height: 24),
                // ─── Chart + Sidebar ─────────────────────────────
                _buildAnalyticsSection(),
              ],
            ),
          ),
        ),
        // Floating AI Insight Button
        Positioned(
          bottom: 28,
          right: 28,
          child: _buildFloatingAiButton(),
        ),
      ],
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        InkWell(
          onTap: () => context.go('/dashboard'),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Dashboard',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.chevron_right_rounded,
            size: 18, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _category.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _category.level,
            style: GoogleFonts.inter(
              color: _category.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right_rounded,
            size: 18, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _indicator.name,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: indicator details
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number + Level tag
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${_indicator.number} • ${_category.level} Level',
                        style: GoogleFonts.inter(
                          color: _category.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_indicator.sdgTag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EA5E9)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _indicator.sdgTag!,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0284C7),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  _indicator.name,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Source: ${_indicator.source}',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                // Value
                Text(
                  _indicator.value,
                  style: GoogleFonts.inter(
                    color: _indicator.isPositive
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _indicator.targetDescription,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right: Status card + trend
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Status card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'STATUS',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _indicator.status,
                          style: GoogleFonts.inter(
                            color: _statusColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Change badge
                      Text(
                        _indicator.changeText,
                        style: GoogleFonts.inter(
                          color: _indicator.isPositive
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return _buildChart();
  }

  Widget _buildChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title + controls
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _indicator.name,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _activeView == 'Distribution'
                          ? 'Facility Distribution ($_selectedQuarter – 2025)'
                          : _activeView == 'Map'
                              ? 'Facility Heat Map ($_selectedQuarter – 2025)'
                              : 'Hub vs Spoke Trend ($_selectedQuarter – 2025)',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Aggregate / Distribution toggle
              _buildViewToggle(),
            ],
          ),
          const SizedBox(height: 16),
          // Quarter selectors
          _buildQuarterSelector(),
          const SizedBox(height: 24),
          // Chart area
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _activeView == 'Distribution'
                ? _buildDistributionChart()
                : _activeView == 'Map'
                    ? FacilityMapWidget(selectedQuarter: _selectedQuarter)
                    : _buildAggregateChart(),
          ),
          const SizedBox(height: 16),
          // Legend
          if (_activeView != 'Distribution')
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Hubs', AppColors.chartHub),
                const SizedBox(width: 24),
                _buildLegendItem('Spokes', AppColors.chartSpoke),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('Aggregate', _activeView == 'Aggregate', () {
            setState(() => _activeView = 'Aggregate');
          }),
          _buildToggleButton('Distribution', _activeView == 'Distribution', () {
            setState(() => _activeView = 'Distribution');
          }),
          _buildToggleButton('Map', _activeView == 'Map', () {
            setState(() => _activeView = 'Map');
          }),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuarterSelector() {
    final quarters = ['All', 'Q1', 'Q2', 'Q3', 'Q4'];
    return Row(
      children: quarters.map((q) {
        final isSelected = _selectedQuarter == q;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedQuarter = q),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  q == 'All' ? 'All Quarters' : q,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<ChartDataPoint> _getFilteredData() {
    if (_selectedQuarter == 'All') {
      return MockData.maternalMortalityData;
    }
    final qIndex =
        MockData.quarterlyData.indexWhere((q) => q.quarter == _selectedQuarter);
    if (qIndex >= 0) {
      return MockData.quarterlyData[qIndex].monthlyData;
    }
    return MockData.maternalMortalityData;
  }

  int _getMonthOffset() {
    switch (_selectedQuarter) {
      case 'Q2':
        return 3;
      case 'Q3':
        return 6;
      case 'Q4':
        return 9;
      default:
        return 0;
    }
  }

  Widget _buildAggregateChart() {
    final data = _getFilteredData();
    final offset = _getMonthOffset();
    final maxY = data.fold<double>(0, (max, d) {
      final v = d.hubValue > d.spokeValue ? d.hubValue : d.spokeValue;
      return v > max ? v : max;
    });
    final chartMaxY = ((maxY / 5).ceil() * 5 + 5).toDouble();
    final allMonths = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return SizedBox(
      key: ValueKey('aggregate_$_selectedQuarter'),
      height: 280,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: chartMaxY / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: AppColors.divider, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: chartMaxY / 4,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(
                      color: AppColors.textMuted, fontSize: 11),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt() + offset;
                  if (idx >= 0 && idx < allMonths.length &&
                      value.toInt() >= 0 && value.toInt() < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        allMonths[idx],
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted, fontSize: 11),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: chartMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.hubValue))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.chartHub,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4, color: AppColors.chartHub,
                    strokeWidth: 2, strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.chartHub.withValues(alpha: 0.08),
              ),
            ),
            LineChartBarData(
              spots: data.asMap().entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.spokeValue))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.chartSpoke,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4, color: AppColors.chartSpoke,
                    strokeWidth: 2, strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.chartSpoke.withValues(alpha: 0.08),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => AppColors.sidebarBg,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final isHub = spot.barIndex == 0;
                  return LineTooltipItem(
                    '${isHub ? "Hub" : "Spoke"}: ${spot.y.toStringAsFixed(1)}',
                    GoogleFonts.inter(
                      color: isHub
                          ? AppColors.chartHub
                          : AppColors.chartSpoke,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistributionChart() {
    final quarter = _selectedQuarter == 'All' ? 'Q1' : _selectedQuarter;
    final facilities = MockData.facilityDistribution[quarter] ?? [];
    final maxVal = facilities.fold<double>(
        0, (max, f) => f.value > max ? f.value : max);

    return SizedBox(
      key: ValueKey('distribution_$_selectedQuarter'),
      height: 280,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: ((maxVal / 5).ceil() * 5 + 2).toDouble(),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => AppColors.sidebarBg,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final facility = facilities[groupIndex];
                return BarTooltipItem(
                  '${facility.facilityName}\n${facility.value.toStringAsFixed(1)}',
                  GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(
                      color: AppColors.textMuted, fontSize: 11),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < facilities.length) {
                    final name = facilities[value.toInt()].facilityName
                        .replaceAll(' Hub', '\nHub')
                        .replaceAll(' Spoke', '\nSpoke');
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 9,
                          height: 1.2,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: AppColors.divider, strokeWidth: 1);
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: facilities.asMap().entries.map((entry) {
            final f = entry.value;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: f.value,
                  width: 18,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  color: f.isHub ? AppColors.chartHub : AppColors.chartSpoke,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingAiButton() {
    return _FloatingAiButton(indicatorName: _indicator.name);
  }


}

// ─── Floating AI Button Widget ──────────────────────────────────────
class _FloatingAiButton extends StatefulWidget {
  final String indicatorName;

  const _FloatingAiButton({required this.indicatorName});

  @override
  State<_FloatingAiButton> createState() => _FloatingAiButtonState();
}

class _FloatingAiButtonState extends State<_FloatingAiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // TODO: AI insight action
        },
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: _isHovered ? 20 : 0,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(_isHovered ? 28 : 30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                        alpha: 0.2 + (_pulseAnimation.value * 0.15)),
                    blurRadius: 16 + (_pulseAnimation.value * 8),
                    spreadRadius: _pulseAnimation.value * 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      if (_isHovered) ...[
                        Text(
                          'AI Insight',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
