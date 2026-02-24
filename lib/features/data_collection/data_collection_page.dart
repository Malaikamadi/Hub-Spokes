import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class DataCollectionPage extends StatefulWidget {
  const DataCollectionPage({super.key});

  @override
  State<DataCollectionPage> createState() => _DataCollectionPageState();
}

class _DataCollectionPageState extends State<DataCollectionPage> {
  String _selectedFacilityType = 'All';
  String _selectedQuarter = 'Q1 2025';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 24),
            _buildFilters(),
            const SizedBox(height: 24),
            _buildStatusCards(),
            const SizedBox(height: 24),
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Collection',
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Track and manage data submissions from Hubs and Spokes.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('New Submission'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list_rounded, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Text(
            'Filters:',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          // Facility Type dropdown
          _buildDropdown(
            value: _selectedFacilityType,
            items: ['All', 'Hub', 'Spoke'],
            onChanged: (val) => setState(() => _selectedFacilityType = val!),
          ),
          const SizedBox(width: 12),
          // Quarter dropdown
          _buildDropdown(
            value: _selectedQuarter,
            items: ['Q1 2025', 'Q2 2025', 'Q3 2025', 'Q4 2025'],
            onChanged: (val) => setState(() => _selectedQuarter = val!),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.cardBorder),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 13,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatusCards() {
    final statuses = [
      _StatusInfo('Total Submissions', '48', Icons.assignment_rounded, AppColors.primary),
      _StatusInfo('Pending Review', '12', Icons.pending_actions_rounded, AppColors.warning),
      _StatusInfo('Approved', '32', Icons.check_circle_rounded, AppColors.success),
      _StatusInfo('Rejected', '4', Icons.cancel_rounded, AppColors.danger),
    ];

    return Row(
      children: statuses.map((status) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: status != statuses.last ? 16 : 0,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: status.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(status.icon, color: status.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.value,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        status.label,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDataTable() {
    final submissions = [
      _Submission('Kitwe General Hospital', 'Hub', 'Q1 2025', 'Approved', '2025-01-15'),
      _Submission('Ndola Teaching Hospital', 'Hub', 'Q1 2025', 'Approved', '2025-01-18'),
      _Submission('Mufulira District Hospital', 'Spoke', 'Q1 2025', 'Pending', '2025-01-20'),
      _Submission('Luanshya Mine Hospital', 'Spoke', 'Q1 2025', 'Approved', '2025-01-22'),
      _Submission('Kalulushi District Hospital', 'Spoke', 'Q1 2025', 'Rejected', '2025-01-25'),
      _Submission('Wusakile Mine Hospital', 'Hub', 'Q1 2025', 'Pending', '2025-01-28'),
      _Submission('Chambishi Mine Hospital', 'Spoke', 'Q1 2025', 'Approved', '2025-02-01'),
      _Submission('Mpongwe District Hospital', 'Spoke', 'Q1 2025', 'Pending', '2025-02-05'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Submissions',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.cardBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.tableHeader,
              border: Border(
                top: BorderSide(color: AppColors.tableBorder),
                bottom: BorderSide(color: AppColors.tableBorder),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Facility Name', style: _headerStyle())),
                SizedBox(width: 80, child: Center(child: Text('Type', style: _headerStyle()))),
                SizedBox(width: 80, child: Center(child: Text('Quarter', style: _headerStyle()))),
                SizedBox(width: 100, child: Center(child: Text('Status', style: _headerStyle()))),
                SizedBox(width: 100, child: Text('Submitted', style: _headerStyle())),
                SizedBox(width: 80, child: Text('Action', style: _headerStyle())),
              ],
            ),
          ),
          // Rows
          ...submissions.map((s) => _buildSubmissionRow(s)),
        ],
      ),
    );
  }

  Widget _buildSubmissionRow(_Submission submission) {
    Color statusColor;
    switch (submission.status) {
      case 'Approved':
        statusColor = AppColors.success;
        break;
      case 'Pending':
        statusColor = AppColors.warning;
        break;
      case 'Rejected':
        statusColor = AppColors.danger;
        break;
      default:
        statusColor = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.tableBorder, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              submission.facility,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: submission.type == 'Hub'
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  submission.type,
                  style: GoogleFonts.inter(
                    color: submission.type == 'Hub'
                        ? AppColors.primary
                        : AppColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Center(
              child: Text(
                submission.quarter,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  submission.status,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              submission.date,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.visibility_rounded, size: 18),
              color: AppColors.textSecondary,
              tooltip: 'View',
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return GoogleFonts.inter(
      color: AppColors.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }
}

class _StatusInfo {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusInfo(this.label, this.value, this.icon, this.color);
}

class _Submission {
  final String facility;
  final String type;
  final String quarter;
  final String status;
  final String date;

  const _Submission(this.facility, this.type, this.quarter, this.status, this.date);
}
