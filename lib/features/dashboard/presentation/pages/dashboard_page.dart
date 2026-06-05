import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/features/auth/presentation/providers/auth_provider.dart';
import 'package:airman_toga_flutter_assessment/features/dashboard/presentation/widgets/profile_header_widget.dart';
import 'package:airman_toga_flutter_assessment/features/dashboard/presentation/widgets/upcoming_flight_card.dart';
import 'package:airman_toga_flutter_assessment/features/dashboard/presentation/widgets/logbook_summary_card.dart';
import 'package:airman_toga_flutter_assessment/features/dashboard/presentation/widgets/continue_study_card.dart';
import 'package:airman_toga_flutter_assessment/features/logbook/presentation/providers/logbook_provider.dart';
import 'package:airman_toga_flutter_assessment/features/study/presentation/providers/study_provider.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load data when dashboard initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(logbookProvider.notifier).loadLogbookEntries('user_arjun_menon');
      ref.read(subjectsProvider.notifier).loadSubjects('user_arjun_menon');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadet Dashboard'),
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  GoRouter.of(context).push('/notifications');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF5350),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authNotifier.logout();
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF0A1628),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              const ProfileHeaderWidget(),
              const SizedBox(height: 24),
              
              // Continue Study CTA (Primary)
              const ContinueStudyCard(),
              const SizedBox(height: 24),
              
              // Upcoming Flight Card
              const UpcomingFlightCard(),
              const SizedBox(height: 24),
              
              // Logbook Summary Card
              InkWell(
                onTap: () => GoRouter.of(context).push('/logbook'),
                borderRadius: BorderRadius.circular(16),
                child: const LogbookSummaryCard(),
              ),
              const SizedBox(height: 24),
              
              // Quick Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Flight Hours',
                      '45.5',
                      Icons.flight,
                      const Color(0xFF4FC3F7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Missions',
                      '12',
                      Icons.military_tech,
                      const Color(0xFF66BB6A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Subjects',
                      '3',
                      Icons.book,
                      const Color(0xFFAB47BC),
                      onTap: () => GoRouter.of(context).push('/study'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Notes',
                      '5',
                      Icons.note,
                      const Color(0xFFFFA726),
                      onTap: () => GoRouter.of(context).push('/notes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
