import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/features/logbook/presentation/providers/logbook_provider.dart';

class LogbookSummaryCard extends ConsumerWidget {
  const LogbookSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logbookState = ref.watch(logbookProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF66BB6A).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: logbookState.isLoading
          ? _buildLoading()
          : logbookState.error != null
              ? _buildError(logbookState.error!)
              : _buildContent(logbookState.totalHours),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF66BB6A)),
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFEF5350),
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load logbook',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, double> totalHours) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF66BB6A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: Color(0xFF66BB6A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logbook Summary',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Total Flight Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${totalHours['totalFlightHours']?.toStringAsFixed(1) ?? '0.0'}h',
                style: const TextStyle(
                  color: Color(0xFF66BB6A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHourStat(
                  'Day Hours',
                  totalHours['totalDayHours']?.toStringAsFixed(1) ?? '0.0',
                  Icons.wb_sunny,
                  const Color(0xFFFFA726),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHourStat(
                  'Night Hours',
                  totalHours['totalNightHours']?.toStringAsFixed(1) ?? '0.0',
                  Icons.nightlight_round,
                  const Color(0xFF7E57C2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHourStat(
                  'Instrument',
                  totalHours['totalInstrumentHours']?.toStringAsFixed(1) ?? '0.0',
                  Icons.explore,
                  const Color(0xFF42A5F5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHourStat(
                  'Cross Country',
                  totalHours['totalCrossCountryHours']?.toStringAsFixed(1) ?? '0.0',
                  Icons.public,
                  const Color(0xFFEF5350),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHourStat(
                  'PIC Hours',
                  totalHours['totalPilotInCommandHours']?.toStringAsFixed(1) ?? '0.0',
                  Icons.flight_takeoff,
                  const Color(0xFF26A69A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHourStat(
                  'Dual Received',
                  totalHours['totalDualReceivedHours']?.toStringAsFixed(1) ?? '0.0',
                  Icons.school,
                  const Color(0xFFAB47BC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
