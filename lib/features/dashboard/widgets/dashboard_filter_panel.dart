import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class DashboardFilterPanel extends StatefulWidget {
  final VoidCallback onApply;

  const DashboardFilterPanel({super.key, required this.onApply});

  @override
  State<DashboardFilterPanel> createState() => _DashboardFilterPanelState();
}

class _DashboardFilterPanelState extends State<DashboardFilterPanel> {
  String? _selectedFacilityType;
  String? _selectedYear;
  String? _selectedFacilityLevel;
  String? _selectedQuarter;
  String? _selectedMonth;
  String? _selectedFacility;

  final List<String> _facilityTypes = ['Hub', 'Spoke'];
  final List<String> _years = ['2023', '2024', '2025', '2026'];
  final List<String> _facilityLevels = ['Primary', 'Secondary', 'Tertiary'];
  final List<String> _quarters = ['Q1', 'Q2', 'Q3', 'Q4'];
  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final List<String> _facilities = [
    'Jembe CHC',
    'JMB Paediatric Centre',
    'Kagbere CHC',
    'Kakua Static CHC',
    'Kamabai CHC',
    'Kamaranka CHC',
    'Kenema Government Hospital',
    'Kingharman Road Hospital',
    'Koribondo CHC',
    'Kuntorloh CHC',
    'Largo CHC',
    'Levuma CHP',
    'Mabella CHC',
    'Makeni Government Hospital',
    'Malama CHP',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.cardBg,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Dashboard',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDropdown('Facility Type', _facilityTypes, _selectedFacilityType, (val) => setState(() => _selectedFacilityType = val)),
                      const SizedBox(height: 16),
                      _buildDropdown('Facility Level', _facilityLevels, _selectedFacilityLevel, (val) => setState(() => _selectedFacilityLevel = val)),
                      const SizedBox(height: 16),
                      _buildDropdown('Facility', _facilities, _selectedFacility, (val) => setState(() => _selectedFacility = val)),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildDropdown('Year', _years, _selectedYear, (val) => setState(() => _selectedYear = val)),
                      const SizedBox(height: 16),
                      _buildDropdown('Quarter', _quarters, _selectedQuarter, (val) => setState(() => _selectedQuarter = val)),
                      const SizedBox(height: 16),
                      _buildDropdown('Month', _months, _selectedMonth, (val) => setState(() => _selectedMonth = val)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFacilityType = null;
                      _selectedYear = null;
                      _selectedFacilityLevel = null;
                      _selectedQuarter = null;
                      _selectedMonth = null;
                      _selectedFacility = null;
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onApply();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                'Select $label',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              dropdownColor: AppColors.cardBg,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
