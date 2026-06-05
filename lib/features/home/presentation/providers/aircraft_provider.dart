import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/core/errors/failures.dart';
import '../../data/repositories/aircraft_repository_impl.dart';
import '../../data/services/aircraft_service.dart';
import '../../domain/entities/aircraft.dart';
import '../../domain/repositories/aircraft_repository.dart';

// Service provider
final aircraftServiceProvider = Provider<AircraftService>((ref) {
  return AircraftServiceImpl();
});

// Repository provider
final aircraftRepositoryProvider = Provider<AircraftRepository>((ref) {
  final service = ref.watch(aircraftServiceProvider);
  return AircraftRepositoryImpl(service: service);
});

// State class
class AircraftState {
  final List<Aircraft> aircraftList;
  final bool isLoading;
  final Failure? error;

  const AircraftState({
    this.aircraftList = const [],
    this.isLoading = false,
    this.error,
  });

  AircraftState copyWith({
    List<Aircraft>? aircraftList,
    bool? isLoading,
    Failure? error,
  }) {
    return AircraftState(
      aircraftList: aircraftList ?? this.aircraftList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// State notifier
class AircraftNotifier extends StateNotifier<AircraftState> {
  final AircraftRepository repository;

  AircraftNotifier({required this.repository}) : super(const AircraftState());

  Future<void> loadAircraftList() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await repository.getAircraftList();
    
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (aircraftList) {
        state = state.copyWith(
          isLoading: false,
          aircraftList: aircraftList,
        );
      },
    );
  }

  Future<void> addAircraft(Aircraft aircraft) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await repository.addAircraft(aircraft);
    
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (_) {
        loadAircraftList();
      },
    );
  }

  Future<void> updateAircraft(Aircraft aircraft) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await repository.updateAircraft(aircraft);
    
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (_) {
        loadAircraftList();
      },
    );
  }

  Future<void> deleteAircraft(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await repository.deleteAircraft(id);
    
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (_) {
        loadAircraftList();
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for the state notifier
final aircraftProvider = StateNotifierProvider<AircraftNotifier, AircraftState>(
  (ref) {
    final repository = ref.watch(aircraftRepositoryProvider);
    final notifier = AircraftNotifier(repository: repository);
    notifier.loadAircraftList();
    return notifier;
  },
);
