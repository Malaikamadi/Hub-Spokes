import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/shell/app_shell.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/framework/framework_page.dart';
import '../../features/data_collection/data_collection_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/framework',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FrameworkPage(),
            ),
          ),
          GoRoute(
            path: '/data-collection',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DataCollectionPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
