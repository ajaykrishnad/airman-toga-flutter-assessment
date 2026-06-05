import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/features/logbook/presentation/providers/logbook_provider.dart';

class UpcomingFlightCard extends ConsumerWidget {
  const UpcomingFlightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logbookState = ref.watch(logbookProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: logbookState.isLoading
          ? _buildLoading()
          : logbookState.error != null
              ? _buildError(logbookState.error!)
              : logbookState.entries.isEmpty
                  ? _buildEmpty()
                  : _buildContent(logbookState.entries.first),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
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
            'Failed to load flight data',
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

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.flight_takeoff,
            color: Colors.white.withValues(alpha: 0.3),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'No upcoming flights',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check back later for scheduled flights',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic flight) {
    // Mock upcoming flight data
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
                  color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flight,
                  color: Color(0xFF4FC3F7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Flight',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tomorrow, 09:00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF66BB6A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF66BB6A).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Confirmed',
                  style: TextStyle(
                    color: Color(0xFF66BB6A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          _buildFlightDetail('Aircraft', 'Cessna 172 • N12345'),
          const SizedBox(height: 12),
          _buildFlightDetail('Instructor', 'Capt. Smith'),
          const SizedBox(height: 12),
          _buildFlightDetail('Mission', 'Pattern Work & Circuits'),
          const SizedBox(height: 12),
          _buildFlightDetail('Weather', 'VFR • Clear Skies'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatChip('Duration', '1.5h', Icons.access_time),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip('Type', 'Training', Icons.school),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4FC3F7), size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
