import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF0D9488); // Teal
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF0F766E);

  // Sidebar / Navigation
  static const Color sidebarBg = Color(0xFF1E293B); // Dark navy
  static const Color sidebarItemActive = Color(0xFF0D9488);
  static const Color sidebarText = Color(0xFFCBD5E1);
  static const Color sidebarTextActive = Colors.white;

  // Top bar
  static const Color topBarBg = Color(0xFF1E293B);
  static const Color topBarText = Colors.white;

  // Content area
  static const Color scaffoldBg = Color(0xFFF1F5F9); // Light gray
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // KPI card accent colors
  static const Color kpiRed = Color(0xFFEF4444);
  static const Color kpiOrange = Color(0xFFF59E0B);
  static const Color kpiGreen = Color(0xFF22C55E);
  static const Color kpiBlue = Color(0xFF3B82F6);

  // Chart colors
  static const Color chartHub = Color(0xFF0D9488);
  static const Color chartSpoke = Color(0xFFF59E0B);

  // Dividers
  static const Color divider = Color(0xFFE2E8F0);

  // Table
  static const Color tableHeader = Color(0xFFF8FAFC);
  static const Color tableRowHover = Color(0xFFF1F5F9);
  static const Color tableBorder = Color(0xFFE2E8F0);

  // Framework level colors
  static const Color impactLevel = Color(0xFF0D9488);
  static const Color outcomeLevel = Color(0xFF3B82F6);
  static const Color outputLevel = Color(0xFFF59E0B);
  static const Color inputProcessLevel = Color(0xFF8B5CF6);
}
