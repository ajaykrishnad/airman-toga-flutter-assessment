import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/study_service.dart';
import '../../data/models/study_subject_model.dart';
import '../../data/models/chapter_model.dart';

// Service provider
final studyServiceProvider = Provider<StudyService>((ref) {
  return MockStudyService();
});

// Subjects state
class SubjectsState {
  final List<StudySubjectModel> subjects;
  final bool isLoading;
  final String? error;

  const SubjectsState({
    this.subjects = const [],
    this.isLoading = false,
    this.error,
  });

  SubjectsState copyWith({
    List<StudySubjectModel>? subjects,
    bool? isLoading,
    String? error,
  }) {
    return SubjectsState(
      subjects: subjects ?? this.subjects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Subjects notifier
class SubjectsNotifier extends StateNotifier<SubjectsState> {
  final StudyService service;
  String? _currentUserId;

  SubjectsNotifier({required this.service}) : super(const SubjectsState());

  Future<void> loadSubjects(String userId) async {
    _currentUserId = userId;
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final subjects = await service.getSubjects(userId);
      state = state.copyWith(
        isLoading: false,
        subjects: subjects,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateSubjectProgress(String subjectId, Map<String, dynamic> progress) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.updateSubjectProgress(subjectId, progress);
      if (_currentUserId != null) {
        await loadSubjects(_currentUserId!);
      }
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

// Subjects provider
final subjectsProvider = StateNotifierProvider<SubjectsNotifier, SubjectsState>((ref) {
  final service = ref.watch(studyServiceProvider);
  return SubjectsNotifier(service: service);
});

// Chapters state
class ChaptersState {
  final List<ChapterModel> chapters;
  final bool isLoading;
  final String? error;

  const ChaptersState({
    this.chapters = const [],
    this.isLoading = false,
    this.error,
  });

  ChaptersState copyWith({
    List<ChapterModel>? chapters,
    bool? isLoading,
    String? error,
  }) {
    return ChaptersState(
      chapters: chapters ?? this.chapters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Chapters notifier
class ChaptersNotifier extends StateNotifier<ChaptersState> {
  final StudyService service;

  ChaptersNotifier({required this.service}) : super(const ChaptersState());

  Future<void> loadChapters(String subjectId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final chapters = await service.getChapters(subjectId);
      state = state.copyWith(
        isLoading: false,
        chapters: chapters,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateChapterProgress(String chapterId, Map<String, dynamic> progress) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.updateChapterProgress(chapterId, progress);
      final chapter = await service.getChapter(chapterId);
      final updatedChapters = state.chapters.map((c) => 
        c.id == chapterId ? chapter : c
      ).toList();
      state = state.copyWith(
        isLoading: false,
        chapters: updatedChapters,
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

// Chapters provider
final chaptersProvider = StateNotifierProvider<ChaptersNotifier, ChaptersState>((ref) {
  final service = ref.watch(studyServiceProvider);
  return ChaptersNotifier(service: service);
});

// Individual subject provider (FutureProvider)
final subjectProvider = FutureProvider.family<StudySubjectModel, String>((ref, subjectId) async {
  final service = ref.watch(studyServiceProvider);
  return await service.getSubject(subjectId);
});

// Individual chapter provider (FutureProvider)
final chapterProvider = FutureProvider.family<ChapterModel, String>((ref, chapterId) async {
  final service = ref.watch(studyServiceProvider);
  return await service.getChapter(chapterId);
});
