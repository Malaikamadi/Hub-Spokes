import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar
          _buildTopBar(context),
          // Main content
          Expanded(
            child: Row(
              children: [
                // Sidebar
                _buildSidebar(context),
                // Content area
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      color: AppColors.topBarBg,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Text(
          'Hubs & Spokes M&E Dashboard',
          style: GoogleFonts.inter(
            color: AppColors.topBarText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 220,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // Logo area
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/mohs_logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hubs & Spokes',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'M&E System',
                      style: GoogleFonts.inter(
                        color: AppColors.sidebarText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Navigation items
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isActive: location.startsWith('/dashboard'),
            onTap: () => context.go('/dashboard'),
          ),
          _SidebarItem(
            icon: Icons.account_tree_rounded,
            label: 'M&E Framework',
            isActive: location.startsWith('/framework'),
            onTap: () => context.go('/framework'),
          ),
          _SidebarItem(
            icon: Icons.assignment_rounded,
            label: 'Data Collection',
            isActive: location.startsWith('/data-collection'),
            onTap: () => context.go('/data-collection'),
          ),
          const Spacer(),
          // Project Scope widget
          _buildProjectScope(),
          const SizedBox(height: 16),
          // User info & Logout
          _buildUserSection(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProjectScope() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sidebarBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.sidebarText,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'PROJECT SCOPE',
                style: GoogleFonts.inter(
                  color: AppColors.sidebarText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hubs',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              Text(
                '6',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spokes',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              Text(
                '6',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    final auth = AuthService.instance;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  (auth.currentUser ?? 'U')[0].toUpperCase(),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.currentUser ?? 'User',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      auth.userRole ?? '',
                      style: GoogleFonts.inter(
                        color: AppColors.sidebarText,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await auth.logout();
                  if (context.mounted) context.go('/login');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: AppColors.sidebarText,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sign Out',
                        style: GoogleFonts.inter(
                          color: AppColors.sidebarText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.sidebarItemActive
                  : _isHovered
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: widget.isActive
                      ? AppColors.sidebarTextActive
                      : AppColors.sidebarText,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: widget.isActive
                        ? AppColors.sidebarTextActive
                        : AppColors.sidebarText,
                    fontSize: 13,
                    fontWeight:
                        widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
