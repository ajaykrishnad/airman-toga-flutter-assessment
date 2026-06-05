import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/aircraft.dart';

class AircraftCard extends ConsumerWidget {
  final Aircraft aircraft;

  const AircraftCard({
    super.key,
    required this.aircraft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: aircraft.isActive
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.flight,
                    color: aircraft.isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aircraft.registration,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        aircraft.model,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.business,
              'Manufacturer',
              aircraft.manufacturer,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.people,
              'Capacity',
              '${aircraft.capacity} passengers',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.straighten,
              'Range',
              '${aircraft.rangeKm.toStringAsFixed(0)} km',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: aircraft.isActive
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            aircraft.isActive ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: aircraft.isActive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            aircraft.isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: aircraft.isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
