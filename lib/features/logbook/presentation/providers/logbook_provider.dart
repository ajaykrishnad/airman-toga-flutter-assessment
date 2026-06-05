import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/logbook_service.dart';
import '../../data/models/logbook_summary_model.dart';

// Service provider
final logbookServiceProvider = Provider<LogbookService>((ref) {
  return MockLogbookService();
});

// Logbook state
class LogbookState {
  final List<LogbookSummaryModel> entries;
  final Map<String, double> totalHours;
  final bool isLoading;
  final String? error;

  const LogbookState({
    this.entries = const [],
    this.totalHours = const {},
    this.isLoading = false,
    this.error,
  });

  LogbookState copyWith({
    List<LogbookSummaryModel>? entries,
    Map<String, double>? totalHours,
    bool? isLoading,
    String? error,
  }) {
    return LogbookState(
      entries: entries ?? this.entries,
      totalHours: totalHours ?? this.totalHours,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Logbook notifier
class LogbookNotifier extends StateNotifier<LogbookState> {
  final LogbookService service;
  String? _currentUserId;

  LogbookNotifier({required this.service}) : super(const LogbookState());

  Future<void> loadLogbookEntries(String userId) async {
    _currentUserId = userId;
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final entries = await service.getLogbookEntries(userId);
      final totalHours = await service.getTotalHours(userId);
      state = state.copyWith(
        isLoading: false,
        entries: entries,
        totalHours: totalHours,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addEntry(Map<String, dynamic> entryData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final entry = await service.addLogbookEntry(entryData);
      state = state.copyWith(
        isLoading: false,
        entries: [entry, ...state.entries],
      );
      // Refresh total hours
      if (_currentUserId != null) {
        final totalHours = await service.getTotalHours(_currentUserId!);
        state = state.copyWith(totalHours: totalHours);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateEntry(String entryId, Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final updatedEntry = await service.updateLogbookEntry(entryId, updates);
      final updatedEntries = state.entries.map((entry) => 
        entry.id == entryId ? updatedEntry : entry
      ).toList();
      state = state.copyWith(
        isLoading: false,
        entries: updatedEntries,
      );
      // Refresh total hours
      if (_currentUserId != null) {
        final totalHours = await service.getTotalHours(_currentUserId!);
        state = state.copyWith(totalHours: totalHours);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteEntry(String entryId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.deleteLogbookEntry(entryId);
      final updatedEntries = state.entries.where((entry) => entry.id != entryId).toList();
      state = state.copyWith(
        isLoading: false,
        entries: updatedEntries,
      );
      // Refresh total hours
      if (_currentUserId != null) {
        final totalHours = await service.getTotalHours(_currentUserId!);
        state = state.copyWith(totalHours: totalHours);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadEntriesByDateRange(DateTime start, DateTime end) async {
    if (_currentUserId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final entries = await service.getEntriesByDateRange(_currentUserId!, start, end);
      state = state.copyWith(
        isLoading: false,
        entries: entries,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadEntriesByType(FlightType type) async {
    if (_currentUserId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final entries = await service.getEntriesByType(_currentUserId!, type);
      state = state.copyWith(
        isLoading: false,
        entries: entries,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Logbook provider
final logbookProvider = StateNotifierProvider<LogbookNotifier, LogbookState>((ref) {
  final service = ref.watch(logbookServiceProvider);
  return LogbookNotifier(service: service);
});

// Individual entry provider (FutureProvider)
final logbookEntryProvider = FutureProvider.family<LogbookSummaryModel, String>((ref, entryId) async {
  final service = ref.watch(logbookServiceProvider);
  return await service.getLogbookEntry(entryId);
});

// Total hours provider (FutureProvider)
final totalHoursProvider = FutureProvider.family<Map<String, double>, String>((ref, userId) async {
  final service = ref.watch(logbookServiceProvider);
  return await service.getTotalHours(userId);
});
