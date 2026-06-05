import 'package:airman_toga_flutter_assessment/core/network/api_client.dart';
import '../models/study_note_model.dart';

abstract class NotesService {
  Future<List<StudyNoteModel>> getNotes(String userId);
  Future<List<StudyNoteModel>> getNotesBySubject(String userId, String subjectId);
  Future<StudyNoteModel> getNote(String noteId);
  Future<StudyNoteModel> createNote(Map<String, dynamic> noteData);
  Future<StudyNoteModel> updateNote(String noteId, Map<String, dynamic> updates);
  Future<void> deleteNote(String noteId);
  Future<List<StudyNoteModel>> searchNotes(String userId, String query);
  Future<List<StudyNoteModel>> getNotesByTag(String userId, String tag);
}

class MockNotesService implements NotesService {
  final List<StudyNoteModel> _mockNotes = [];

  @override
  Future<List<StudyNoteModel>> getNotes(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      if (_mockNotes.isEmpty) {
        _initializeMockNotes(userId);
      }
      return _mockNotes.where((note) => note.userId == userId).toList();
    });
  }

  @override
  Future<List<StudyNoteModel>> getNotesBySubject(String userId, String subjectId) async {
    return ApiClient.simulateNetworkCall(() async {
      final allNotes = await getNotes(userId);
      return allNotes.where((note) => note.subjectId == subjectId).toList();
    });
  }

  @override
  Future<StudyNoteModel> getNote(String noteId) async {
    return ApiClient.simulateNetworkCall(() async {
      return _mockNotes.firstWhere((note) => note.id == noteId);
    });
  }

  @override
  Future<StudyNoteModel> createNote(Map<String, dynamic> noteData) async {
    return ApiClient.simulateNetworkCall(() async {
      final newNote = StudyNoteModel.validate(
        id: 'note_${DateTime.now().millisecondsSinceEpoch}',
        userId: noteData['userId'] as String,
        subjectId: noteData['subjectId'] as String,
        chapterId: noteData['chapterId'] as String?,
        title: noteData['title'] as String,
        content: noteData['content'] as String,
        type: NoteType.values.firstWhere(
          (t) => t.name == noteData['type'] as String,
          orElse: () => NoteType.general,
        ),
        tags: List<String>.from(noteData['tags'] as List? ?? []),
        isPinned: noteData['isPinned'] as bool? ?? false,
        isPrivate: noteData['isPrivate'] as bool? ?? false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastAccessed: DateTime.now(),
        order: _mockNotes.length,
        relatedSubjectCode: noteData['relatedSubjectCode'] as String?,
        relatedChapterCode: noteData['relatedChapterCode'] as String?,
        attachments: List<String>.from(noteData['attachments'] as List? ?? []),
      );
      _mockNotes.add(newNote);
      return newNote;
    });
  }

  @override
  Future<StudyNoteModel> updateNote(String noteId, Map<String, dynamic> updates) async {
    return ApiClient.simulateNetworkCall(() async {
      final note = await getNote(noteId);
      final updatedNote = StudyNoteModel.validate(
        id: note.id,
        userId: note.userId,
        subjectId: note.subjectId,
        chapterId: updates['chapterId'] as String? ?? note.chapterId,
        title: updates['title'] as String? ?? note.title,
        content: updates['content'] as String? ?? note.content,
        type: updates['type'] != null 
            ? NoteType.values.firstWhere((t) => t.name == updates['type'] as String)
            : note.type,
        tags: updates['tags'] != null 
            ? List<String>.from(updates['tags'] as List)
            : note.tags,
        isPinned: updates['isPinned'] as bool? ?? note.isPinned,
        isPrivate: updates['isPrivate'] as bool? ?? note.isPrivate,
        createdAt: note.createdAt,
        updatedAt: DateTime.now(),
        lastAccessed: DateTime.now(),
        order: updates['order'] as int? ?? note.order,
        relatedSubjectCode: updates['relatedSubjectCode'] as String? ?? note.relatedSubjectCode,
        relatedChapterCode: updates['relatedChapterCode'] as String? ?? note.relatedChapterCode,
        attachments: updates['attachments'] != null
            ? List<String>.from(updates['attachments'] as List)
            : note.attachments,
      );
      
      final index = _mockNotes.indexWhere((n) => n.id == noteId);
      _mockNotes[index] = updatedNote;
      return updatedNote;
    });
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await ApiClient.simulateNetworkCall(() async {
      _mockNotes.removeWhere((note) => note.id == noteId);
    });
  }

  @override
  Future<List<StudyNoteModel>> searchNotes(String userId, String query) async {
    return ApiClient.simulateNetworkCall(() async {
      final allNotes = await getNotes(userId);
      final lowerQuery = query.toLowerCase();
      return allNotes.where((note) =>
          note.title.toLowerCase().contains(lowerQuery) ||
          note.content.toLowerCase().contains(lowerQuery) ||
          note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
      ).toList();
    });
  }

  @override
  Future<List<StudyNoteModel>> getNotesByTag(String userId, String tag) async {
    return ApiClient.simulateNetworkCall(() async {
      final allNotes = await getNotes(userId);
      return allNotes.where((note) => note.tags.contains(tag)).toList();
    });
  }

  void _initializeMockNotes(String userId) {
    _mockNotes.addAll([
      StudyNoteModel.validate(
        id: 'note_001',
        userId: userId,
        subjectId: 'sub_001',
        chapterId: 'chap_001',
        title: 'Lift Principles',
        content: 'Key concepts about lift generation in aircraft wings. Bernoulli\'s principle and Newton\'s laws are fundamental.',
        type: NoteType.summary,
        tags: ['aerodynamics', 'lift', 'fundamentals'],
        isPinned: true,
        isPrivate: false,
        createdAt: DateTime(2024, 1, 20),
        updatedAt: DateTime(2024, 1, 25),
        lastAccessed: DateTime.now(),
        order: 0,
        relatedSubjectCode: 'AVN-101',
        relatedChapterCode: 'CH-1',
        attachments: [],
      ),
      StudyNoteModel.validate(
        id: 'note_002',
        userId: userId,
        subjectId: 'sub_002',
        chapterId: 'chap_002',
        title: 'Navigation Formulas',
        content: 'Essential formulas for calculating position, distance, and time in navigation.',
        type: NoteType.formula,
        tags: ['navigation', 'formulas', 'calculations'],
        isPinned: false,
        isPrivate: false,
        createdAt: DateTime(2024, 2, 5),
        updatedAt: DateTime(2024, 2, 10),
        lastAccessed: DateTime.now(),
        order: 1,
        relatedSubjectCode: 'NAV-201',
        relatedChapterCode: 'CH-2',
        attachments: ['formula_sheet.pdf'],
      ),
      StudyNoteModel.validate(
        id: 'note_003',
        userId: userId,
        subjectId: 'sub_001',
        chapterId: null,
        title: 'Study Questions - Chapter 1',
        content: 'Questions to review before the quiz: 1. What generates lift? 2. How does angle of attack affect lift?',
        type: NoteType.question,
        tags: ['quiz', 'review', 'chapter1'],
        isPinned: false,
        isPrivate: false,
        createdAt: DateTime(2024, 1, 18),
        updatedAt: DateTime(2024, 1, 18),
        lastAccessed: DateTime.now(),
        order: 2,
        relatedSubjectCode: 'AVN-101',
        relatedChapterCode: null,
        attachments: [],
      ),
    ]);
  }
}
