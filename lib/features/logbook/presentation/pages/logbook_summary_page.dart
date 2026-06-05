import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/features/logbook/presentation/providers/logbook_provider.dart';
import 'package:airman_toga_flutter_assessment/features/logbook/data/models/logbook_summary_model.dart';

class LogbookSummaryPage extends ConsumerStatefulWidget {
  const LogbookSummaryPage({super.key});

  @override
  ConsumerState<LogbookSummaryPage> createState() => _LogbookSummaryPageState();
}

class _LogbookSummaryPageState extends ConsumerState<LogbookSummaryPage> {
  FlightType? _selectedType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(logbookProvider.notifier).loadLogbookEntries('user_arjun_menon');
    });
  }

  @override
  Widget build(BuildContext context) {
    final logbookState = ref.watch(logbookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logbook Summary'),
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF0A1628),
        child: Column(
          children: [
            // Total Hours Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A5F), Color(0xFF0A1628)],
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: Colors.white12,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Flight Time',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${logbookState.totalHours['totalFlightHours']?.toStringAsFixed(1) ?? '0.0'}h',
                        style: const TextStyle(
                          color: Color(0xFF66BB6A),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHourStat('Day', logbookState.totalHours['totalDayHours']),
                            _buildHourStat('Night', logbookState.totalHours['totalNightHours']),
                            _buildHourStat('Instrument', logbookState.totalHours['totalInstrumentHours']),
                            _buildHourStat('Cross Country', logbookState.totalHours['totalCrossCountryHours']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Flight Entries List
            Expanded(
              child: logbookState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
                      ),
                    )
                  : logbookState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF5350),
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load logbook',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                logbookState.error!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(logbookProvider.notifier).loadLogbookEntries('user_arjun_menon');
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : logbookState.entries.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flight_takeoff,
                                    color: Colors.white30,
                                    size: 64,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No flight entries',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Start logging your flights',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: logbookState.entries.length,
                              itemBuilder: (context, index) {
                                final entry = logbookState.entries[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildFlightCard(entry),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new flight entry
        },
        backgroundColor: const Color(0xFF4FC3F7),
        child: const Icon(Icons.add, color: Color(0xFF0A1628)),
      ),
    );
  }

  Widget _buildHourStat(String label, double? hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${hours?.toStringAsFixed(1) ?? '0.0'}h',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(LogbookSummaryModel entry) {
    final typeColor = _getFlightTypeColor(entry.flightType);
    
    return InkWell(
      onTap: () {
        // TODO: Show flight details
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: typeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: typeColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getFlightTypeIcon(entry.flightType),
                    color: typeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.flightDate.toString().split(' ')[0],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildFlightTypeBadge(entry.flightType),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${entry.departureLocation} → ${entry.arrivalLocation}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${entry.aircraftModel} • ${entry.aircraftRegistration}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.flightDuration.toStringAsFixed(1)}h',
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (entry.isSignedOff)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF66BB6A),
                        size: 16,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white12),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildHourChip('Day', entry.dayHours.toStringAsFixed(1)),
                const SizedBox(width: 8),
                _buildHourChip('Night', entry.nightHours.toStringAsFixed(1)),
                const SizedBox(width: 8),
                _buildHourChip('Instrument', entry.instrumentHours.toStringAsFixed(1)),
                const SizedBox(width: 8),
                _buildHourChip('XC', entry.crossCountryHours.toStringAsFixed(1)),
                const Spacer(),
                if (entry.instructorName != null)
                  Text(
                    'Instr: ${entry.instructorName}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip('Takeoffs', '${entry.takeoffs}', Icons.flight_takeoff),
                const SizedBox(width: 8),
                _buildStatChip('Landings', '${entry.landings}', Icons.flight_land),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF4FC3F7).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    entry.missionCode,
                    style: const TextStyle(
                      color: Color(0xFF4FC3F7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightTypeBadge(FlightType type) {
    final color = _getFlightTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHourChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getFlightTypeColor(FlightType type) {
    switch (type) {
      case FlightType.training:
        return const Color(0xFF4FC3F7);
      case FlightType.solo:
        return const Color(0xFF66BB6A);
      case FlightType.supervised:
        return const Color(0xFFFFA726);
      case FlightType.evaluation:
        return const Color(0xFFAB47BC);
      case FlightType.mission:
        return const Color(0xFFEF5350);
    }
  }

  IconData _getFlightTypeIcon(FlightType type) {
    switch (type) {
      case FlightType.training:
        return Icons.school;
      case FlightType.solo:
        return Icons.flight_takeoff;
      case FlightType.supervised:
        return Icons.visibility;
      case FlightType.evaluation:
        return Icons.assignment;
      case FlightType.mission:
        return Icons.military_tech;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text(
          'Filter Flights',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flight Type',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: FlightType.values.map((type) {
                return ChoiceChip(
                  label: Text(
                    type.name.toUpperCase(),
                    style: TextStyle(
                      color: _selectedType == type ? const Color(0xFF0A1628) : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? type : null;
                    });
                  },
                  selectedColor: const Color(0xFF4FC3F7),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedType = null;
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Color(0xFF4FC3F7)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_selectedType != null) {
                ref.read(logbookProvider.notifier).loadEntriesByType(_selectedType!);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Apply',
              style: TextStyle(color: Color(0xFF4FC3F7)),
            ),
          ),
        ],
      ),
    );
  }
}
