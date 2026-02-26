import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/dashboard_models.dart';
import 'kpi_indicator_card.dart';

class KpiCategorySection extends StatelessWidget {
  final KpiCategory category;
  final void Function(KpiIndicator indicator, KpiCategory category)? onIndicatorTap;

  const KpiCategorySection({
    super.key,
    required this.category,
    this.onIndicatorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Category Header ─────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: category.color,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              // Level icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              // Level name
              Text(
                category.level.toUpperCase(),
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 10),
              // Indicator count badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${category.indicators.length} indicators',
                  style: GoogleFonts.inter(
                    color: category.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // ─── Indicator Cards Grid ─────────────────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive: 4 on wide, 3 on medium, 2 on small
            int crossAxisCount;
            if (constraints.maxWidth > 1000) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 700) {
              crossAxisCount = 3;
            } else {
              crossAxisCount = 2;
            }
            const spacing = 14.0;
            final cardWidth =
                (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                    crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: category.indicators.map((indicator) {
                return SizedBox(
                  width: cardWidth,
                  child: KpiIndicatorCard(
                    data: indicator,
                    accentColor: category.color,
                    onTap: onIndicatorTap != null
                        ? () => onIndicatorTap!(indicator, category)
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
