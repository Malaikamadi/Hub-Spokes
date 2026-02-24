import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../../features/auth/login_page.dart';
import '../../features/shell/app_shell.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/framework/framework_page.dart';
import '../../features/data_collection/data_collection_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = AuthService.instance.isAuthenticated;
      final isOnLogin = state.matchedLocation == '/login';

      // If not authenticated and not on login, redirect to login
      if (!isAuthenticated && !isOnLogin) {
        return '/login';
      }

      // If authenticated and on login, redirect to dashboard
      if (isAuthenticated && isOnLogin) {
        return '/dashboard';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
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
