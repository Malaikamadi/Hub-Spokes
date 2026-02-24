import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/dashboard_models.dart';

class FrameworkPage extends StatelessWidget {
  const FrameworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page header
            _buildPageHeader(),
            const SizedBox(height: 28),
            // Framework levels
            ...MockData.frameworkLevels.map(
              (level) => _buildLevelSection(level),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'M&E Framework',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Detailed logic model for the Hubs & Spokes implementation project.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Color _getLevelColor(String levelName) {
    switch (levelName) {
      case 'Impact Level':
        return AppColors.impactLevel;
      case 'Outcome Level':
        return AppColors.outcomeLevel;
      case 'Output Level':
        return AppColors.outputLevel;
      case 'Input/Process Level':
        return AppColors.inputProcessLevel;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildLevelSection(FrameworkLevel level) {
    final levelColor = _getLevelColor(level.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
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
          // Level header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                Text(
                  level.name,
                  style: GoogleFonts.inter(
                    color: levelColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${level.indicatorCount} Indicators',
                    style: GoogleFonts.inter(
                      color: levelColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Table
          _buildIndicatorTable(level.indicators),
        ],
      ),
    );
  }

  Widget _buildIndicatorTable(List<IndicatorItem> indicators) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: const BoxDecoration(
            color: AppColors.tableHeader,
            border: Border(
              top: BorderSide(color: AppColors.tableBorder),
              bottom: BorderSide(color: AppColors.tableBorder),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '#',
                  style: _headerStyle(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Indicator Name',
                  style: _headerStyle(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Definition',
                  style: _headerStyle(),
                ),
              ),
              SizedBox(
                width: 90,
                child: Center(
                  child: Text(
                    'Freq',
                    style: _headerStyle(),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: Center(
                  child: Text(
                    'Target',
                    style: _headerStyle(),
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                child: Text(
                  'Source',
                  style: _headerStyle(),
                ),
              ),
            ],
          ),
        ),
        // Table rows
        ...indicators.map((indicator) => _buildTableRow(indicator)),
      ],
    );
  }

  Widget _buildTableRow(IndicatorItem indicator) {
    return _HoverableRow(indicator: indicator);
  }

  TextStyle _headerStyle() {
    return GoogleFonts.inter(
      color: AppColors.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }
}

class _HoverableRow extends StatefulWidget {
  final IndicatorItem indicator;

  const _HoverableRow({required this.indicator});

  @override
  State<_HoverableRow> createState() => _HoverableRowState();
}

class _HoverableRowState extends State<_HoverableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.tableRowHover : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: AppColors.tableBorder, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                widget.indicator.number.toString(),
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.indicator.name,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                widget.indicator.definition,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(
              width: 90,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.indicator.frequency,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: Text(
                  widget.indicator.target,
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 140,
              child: Text(
                widget.indicator.source,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
