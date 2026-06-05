import 'package:airman_toga_flutter_assessment/core/network/api_client.dart';
import '../models/study_subject_model.dart';
import '../models/chapter_model.dart';

abstract class StudyService {
  Future<List<StudySubjectModel>> getSubjects(String userId);
  Future<StudySubjectModel> getSubject(String subjectId);
  Future<List<ChapterModel>> getChapters(String subjectId);
  Future<ChapterModel> getChapter(String chapterId);
  Future<StudySubjectModel> updateSubjectProgress(String subjectId, Map<String, dynamic> progress);
  Future<ChapterModel> updateChapterProgress(String chapterId, Map<String, dynamic> progress);
}

class MockStudyService implements StudyService {
  @override
  Future<List<StudySubjectModel>> getSubjects(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      return [
        StudySubjectModel.validate(
          id: 'sub_001',
          code: 'AVN-101',
          title: 'Aviation Fundamentals',
          description: 'Introduction to basic aviation concepts and principles',
          category: 'Core',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 6,
          progressPercentage: 60.0,
          requiredHours: 40.0,
          completedHours: 24.0,
          prerequisites: [],
          startDate: DateTime(2024, 1, 15),
          lastAccessed: DateTime.now(),
          order: 1,
          isMandatory: true,
        ),
        StudySubjectModel.validate(
          id: 'sub_002',
          code: 'NAV-201',
          title: 'Navigation Systems',
          description: 'Advanced navigation techniques and systems',
          category: 'Advanced',
          status: SubjectStatus.inProgress,
          totalChapters: 8,
          completedChapters: 3,
          progressPercentage: 37.5,
          requiredHours: 35.0,
          completedHours: 13.0,
          prerequisites: ['AVN-101'],
          startDate: DateTime(2024, 2, 1),
          lastAccessed: DateTime.now(),
          order: 2,
          isMandatory: true,
        ),
        StudySubjectModel.validate(
          id: 'sub_003',
          code: 'MET-301',
          title: 'Meteorology',
          description: 'Weather patterns and aviation meteorology',
          category: 'Specialized',
          status: SubjectStatus.notStarted,
          totalChapters: 12,
          completedChapters: 0,
          progressPercentage: 0.0,
          requiredHours: 45.0,
          completedHours: 0.0,
          prerequisites: ['AVN-101', 'NAV-201'],
          lastAccessed: null,
          order: 3,
          isMandatory: false,
        ),
      ];
    });
  }

  @override
  Future<StudySubjectModel> getSubject(String subjectId) async {
    return ApiClient.simulateNetworkCall(() async {
      final subjects = await getSubjects('user_001');
      return subjects.firstWhere((s) => s.id == subjectId);
    });
  }

  @override
  Future<List<ChapterModel>> getChapters(String subjectId) async {
    return ApiClient.simulateNetworkCall(() async {
      return [
        ChapterModel.validate(
          id: 'chap_001',
          subjectId: subjectId,
          code: 'CH-1',
          title: 'Introduction to Flight',
          description: 'Basic principles of flight',
          status: ChapterStatus.completed,
          order: 1,
          estimatedDuration: 4.0,
          actualDuration: 3.5,
          learningObjectives: ['Understand lift', 'Learn drag principles', 'Master thrust concepts'],
          resources: ['textbook_ch1.pdf', 'video_intro.mp4'],
          hasQuiz: true,
          quizScore: 92.0,
          quizPassed: true,
          startDate: DateTime(2024, 1, 15),
          completionDate: DateTime(2024, 1, 20),
          lastAccessed: DateTime.now(),
          attemptsCount: 1,
          prerequisites: [],
        ),
        ChapterModel.validate(
          id: 'chap_002',
          subjectId: subjectId,
          code: 'CH-2',
          title: 'Aircraft Systems',
          description: 'Understanding aircraft components',
          status: ChapterStatus.inProgress,
          order: 2,
          estimatedDuration: 5.0,
          actualDuration: null,
          learningObjectives: ['Identify systems', 'Learn maintenance procedures'],
          resources: ['systems_manual.pdf'],
          hasQuiz: true,
          quizScore: null,
          quizPassed: null,
          startDate: DateTime(2024, 1, 21),
          lastAccessed: DateTime.now(),
          attemptsCount: 0,
          prerequisites: ['chap_001'],
        ),
      ];
    });
  }

  @override
  Future<ChapterModel> getChapter(String chapterId) async {
    return ApiClient.simulateNetworkCall(() async {
      final chapters = await getChapters('sub_001');
      return chapters.firstWhere((c) => c.id == chapterId);
    });
  }

  @override
  Future<StudySubjectModel> updateSubjectProgress(String subjectId, Map<String, dynamic> progress) async {
    return ApiClient.simulateNetworkCall(() async {
      final subject = await getSubject(subjectId);
      final newStatus = SubjectStatus.values.firstWhere(
        (s) => s.name == progress['status'] as String,
        orElse: () => subject.status,
      );
      final newStartDate = newStatus == SubjectStatus.inProgress
          ? (subject.startDate ?? DateTime.now())
          : subject.startDate;

      return StudySubjectModel.validate(
        id: subject.id,
        code: subject.code,
        title: subject.title,
        description: subject.description,
        category: subject.category,
        status: newStatus,
        totalChapters: subject.totalChapters,
        completedChapters: progress['completedChapters'] as int? ?? subject.completedChapters,
        progressPercentage: progress['progressPercentage'] as double? ?? subject.progressPercentage,
        requiredHours: subject.requiredHours,
        completedHours: progress['completedHours'] as double? ?? subject.completedHours,
        prerequisites: subject.prerequisites,
        instructorId: subject.instructorId,
        startDate: newStartDate,
        completionDate: progress['isCompleted'] == true ? DateTime.now() : subject.completionDate,
        lastAccessed: DateTime.now(),
        order: subject.order,
        isMandatory: subject.isMandatory,
      );
    });
  }

  @override
  Future<ChapterModel> updateChapterProgress(String chapterId, Map<String, dynamic> progress) async {
    return ApiClient.simulateNetworkCall(() async {
      final chapter = await getChapter(chapterId);
      final newStatus = ChapterStatus.values.firstWhere(
        (s) => s.name == progress['status'] as String,
        orElse: () => chapter.status,
      );

      final newStartDate = newStatus == ChapterStatus.inProgress
          ? (chapter.startDate ?? DateTime.now())
          : chapter.startDate;

      return ChapterModel.validate(
        id: chapter.id,
        subjectId: chapter.subjectId,
        code: chapter.code,
        title: chapter.title,
        description: chapter.description,
        status: newStatus,
        order: chapter.order,
        estimatedDuration: chapter.estimatedDuration,
        actualDuration: progress['actualDuration'] as double? ?? chapter.actualDuration,
        learningObjectives: chapter.learningObjectives,
        resources: chapter.resources,
        hasQuiz: chapter.hasQuiz,
        quizScore: progress['quizScore'] as double? ?? chapter.quizScore,
        quizPassed: progress['quizPassed'] as bool? ?? chapter.quizPassed,
        startDate: newStartDate,
        completionDate: progress['isCompleted'] == true ? DateTime.now() : chapter.completionDate,
        lastAccessed: DateTime.now(),
        attemptsCount: (progress['attemptsCount'] as int? ?? chapter.attemptsCount) + 1,
        prerequisites: chapter.prerequisites,
      );
    });
  }
}
