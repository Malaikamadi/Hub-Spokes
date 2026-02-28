import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class ActivityItem {
  final int id;
  final String name;
  final String scope;
  final String location;
  final String status;
  final String startDate;

  const ActivityItem({
    required this.id,
    required this.name,
    required this.scope,
    required this.location,
    required this.status,
    required this.startDate,
  });
}

const List<ActivityItem> dummyActivities = [
  ActivityItem(
    id: 1,
    name: 'Training of Health Workers on Data Collection',
    scope: 'Hub',
    location: 'District Hospital',
    status: 'Completed',
    startDate: '2023-01-15',
  ),
  ActivityItem(
    id: 2,
    name: 'Distribution of Maternal Care Kits',
    scope: 'Spoke',
    location: 'Community Health Center A',
    status: 'In Progress',
    startDate: '2023-03-10',
  ),
  ActivityItem(
    id: 3,
    name: 'Quarterly Review Meeting',
    scope: 'Hub & Spoke',
    location: 'Regional Office',
    status: 'Planned',
    startDate: '2023-06-01',
  ),
  ActivityItem(
    id: 4,
    name: 'Community Sensitization Program',
    scope: 'Spoke',
    location: 'Village B',
    status: 'In Progress',
    startDate: '2023-04-20',
  ),
  ActivityItem(
    id: 5,
    name: 'Supervision Visit to Health Facilities',
    scope: 'Hub & Spoke',
    location: 'Multiple Locations',
    status: 'Planned',
    startDate: '2023-05-15',
  ),
];

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

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
            // Activities Table container
            Container(
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
              child: _buildActivitiesTable(),
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
          'Activities',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track and monitor project activities across Hubs and Spokes.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesTable() {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.tableHeader,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border(
              bottom: BorderSide(color: AppColors.tableBorder),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  'ID',
                  style: _headerStyle(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Activity Name',
                  style: _headerStyle(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Scope',
                  style: _headerStyle(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Location',
                  style: _headerStyle(),
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  'Start Date',
                  style: _headerStyle(),
                ),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    'Status',
                    style: _headerStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table rows
        ...dummyActivities.map((activity) => _HoverableActivityRow(activity: activity)),
      ],
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

class _HoverableActivityRow extends StatefulWidget {
  final ActivityItem activity;

  const _HoverableActivityRow({required this.activity});

  @override
  State<_HoverableActivityRow> createState() => _HoverableActivityRowState();
}

class _HoverableActivityRowState extends State<_HoverableActivityRow> {
  bool _isHovered = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'planned':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.activity.status);

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
                'ACT-${widget.activity.id}',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                widget.activity.name,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.activity.scope,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.activity.location,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                widget.activity.startDate,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
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
                    widget.activity.status,
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
