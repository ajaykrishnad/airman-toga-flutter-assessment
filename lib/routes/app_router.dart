import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/study/presentation/pages/study_subjects_page.dart';
import '../features/study/presentation/pages/subject_detail_page.dart';
import '../features/notes/presentation/pages/offline_note_page.dart';
import '../features/logbook/presentation/pages/logbook_summary_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If not authenticated and not on login page, redirect to login
      if (!authState.isAuthenticated && state.matchedLocation != '/login') {
        return '/login';
      }
      // If authenticated and on login page, redirect to dashboard
      if (authState.isAuthenticated && state.matchedLocation == '/login') {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/study',
        name: 'study',
        builder: (context, state) => const StudySubjectsPage(),
        routes: [
          GoRoute(
            path: '/subjects/:subjectId',
            name: 'subjectDetail',
            builder: (context, state) {
              final subjectId = state.pathParameters['subjectId']!;
              return SubjectDetailPage(subjectId: subjectId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/notes',
        name: 'notes',
        builder: (context, state) {
          final noteId = state.uri.queryParameters['noteId'];
          return OfflineNotePage(noteId: noteId);
        },
      ),
      GoRoute(
        path: '/logbook',
        name: 'logbook',
        builder: (context, state) => const LogbookSummaryPage(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      // Add more routes as features are implemented
    ],
    errorBuilder: (context, state) => const _ErrorPage(),
  );
});

class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
