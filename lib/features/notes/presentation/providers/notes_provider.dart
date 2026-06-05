import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/notes_service.dart';
import '../../data/models/study_note_model.dart';

// Service provider
final notesServiceProvider = Provider<NotesService>((ref) {
  return MockNotesService();
});

// Notes state
class NotesState {
  final List<StudyNoteModel> notes;
  final bool isLoading;
  final String? error;

  const NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.error,
  });

  NotesState copyWith({
    List<StudyNoteModel>? notes,
    bool? isLoading,
    String? error,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notes notifier
class NotesNotifier extends StateNotifier<NotesState> {
  final NotesService service;
  String? _currentUserId;

  NotesNotifier({required this.service}) : super(const NotesState());

  Future<void> loadNotes(String userId) async {
    _currentUserId = userId;
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notes = await service.getNotes(userId);
      state = state.copyWith(
        isLoading: false,
        notes: notes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadNotesBySubject(String userId, String subjectId) async {
    _currentUserId = userId;
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notes = await service.getNotesBySubject(userId, subjectId);
      state = state.copyWith(
        isLoading: false,
        notes: notes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createNote(Map<String, dynamic> noteData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final note = await service.createNote(noteData);
      state = state.copyWith(
        isLoading: false,
        notes: [note, ...state.notes],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateNote(String noteId, Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final updatedNote = await service.updateNote(noteId, updates);
      final updatedNotes = state.notes.map((note) => 
        note.id == noteId ? updatedNote : note
      ).toList();
      state = state.copyWith(
        isLoading: false,
        notes: updatedNotes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteNote(String noteId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.deleteNote(noteId);
      final updatedNotes = state.notes.where((note) => note.id != noteId).toList();
      state = state.copyWith(
        isLoading: false,
        notes: updatedNotes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchNotes(String query) async {
    if (_currentUserId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notes = await service.searchNotes(_currentUserId!, query);
      state = state.copyWith(
        isLoading: false,
        notes: notes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadNotesByTag(String userId, String tag) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notes = await service.getNotesByTag(userId, tag);
      state = state.copyWith(
        isLoading: false,
        notes: notes,
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

// Notes provider
final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  final service = ref.watch(notesServiceProvider);
  return NotesNotifier(service: service);
});

// Individual note provider (FutureProvider)
final noteProvider = FutureProvider.family<StudyNoteModel, String>((ref, noteId) async {
  final service = ref.watch(notesServiceProvider);
  return await service.getNote(noteId);
});
