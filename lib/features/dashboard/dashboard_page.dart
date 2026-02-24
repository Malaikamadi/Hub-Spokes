import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/mock_data.dart';
import 'widgets/kpi_card.dart';
import 'widgets/mortality_chart.dart';
import 'widgets/ai_insight_card.dart';
import 'widgets/target_progress_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
            const SizedBox(height: 24),
            // KPI Cards Row
            _buildKpiRow(),
            const SizedBox(height: 24),
            // Chart + Sidebar
            _buildChartSection(),
          ],
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
            Text(
              'Monitoring Implementation Dashboard • 2025',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Filter button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.cardBorder),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildKpiRow() {
    final colors = [
      AppColors.kpiRed,
      AppColors.kpiOrange,
      AppColors.kpiGreen,
      AppColors.kpiBlue,
    ];

    return Row(
      children: List.generate(MockData.kpiCards.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < MockData.kpiCards.length - 1 ? 16 : 0,
            ),
            child: KpiCard(
              data: MockData.kpiCards[index],
              accentColor: colors[index],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChartSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart area (take 65%)
        const Expanded(
          flex: 65,
          child: MortalityChart(),
        ),
        const SizedBox(width: 20),
        // Right sidebar (take 35%)
        Expanded(
          flex: 35,
          child: Column(
            children: [
              const AiInsightCard(),
              const SizedBox(height: 20),
              TargetProgressCard(items: MockData.targetProgress),
            ],
          ),
        ),
      ],
    );
  }
}
