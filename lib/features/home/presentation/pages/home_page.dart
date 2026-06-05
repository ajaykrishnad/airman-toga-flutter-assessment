import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/aircraft_provider.dart';
import '../widgets/aircraft_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aircraftProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aircraft Fleet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(aircraftProvider.notifier).loadAircraftList();
            },
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add aircraft page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add aircraft feature coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AircraftState state) {
    if (state.isLoading && state.aircraftList.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null) {
      return ErrorWidgetCustom(
        message: state.error!.message,
        onRetry: () {
          ref.read(aircraftProvider.notifier).loadAircraftList();
        },
      );
    }

    if (state.aircraftList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No aircraft found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first aircraft to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(aircraftProvider.notifier).loadAircraftList();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.aircraftList.length,
        itemBuilder: (context, index) {
          final aircraft = state.aircraftList[index];
          return AircraftCard(aircraft: aircraft);
        },
      ),
    );
  }
}
