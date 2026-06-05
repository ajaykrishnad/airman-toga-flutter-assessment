import 'package:flutter_test/flutter_test.dart';
import 'package:airman_toga_flutter_assessment/features/study/data/models/study_subject_model.dart';

void main() {
  group('StudySubjectModel - Progress Status Conversions', () {
    test('should return correct status text for Not Started', () {
      expect(SubjectStatus.notStarted.statusText, 'Not Started');
    });

    test('should return correct status text for In Progress', () {
      expect(SubjectStatus.inProgress.statusText, 'In Progress');
    });

    test('should return correct status text for Completed', () {
      expect(SubjectStatus.completed.statusText, 'Completed');
    });

    test('should return correct status text for On Hold', () {
      expect(SubjectStatus.onHold.statusText, 'On Hold');
    });

    test('should handle all status enum values', () {
      final allStatuses = SubjectStatus.values;
      expect(allStatuses.length, 4);
      expect(allStatuses, contains(SubjectStatus.notStarted));
      expect(allStatuses, contains(SubjectStatus.inProgress));
      expect(allStatuses, contains(SubjectStatus.completed));
      expect(allStatuses, contains(SubjectStatus.onHold));
    });
  });

  group('StudySubjectModel - Invalid Progress Bounds Handling', () {
    test('should throw assertion when progress percentage is negative', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 5,
          progressPercentage: -10.0,
          requiredHours: 20.0,
          completedHours: 10.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        throwsAssertionError,
      );
    });

    test('should throw assertion when progress percentage exceeds 100', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 5,
          progressPercentage: 150.0,
          requiredHours: 20.0,
          completedHours: 10.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        throwsAssertionError,
      );
    });

    test('should throw assertion when completed chapters exceed total chapters', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 15,
          progressPercentage: 50.0,
          requiredHours: 20.0,
          completedHours: 10.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        throwsAssertionError,
      );
    });

    test('should throw assertion when completed hours exceed required hours', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 5,
          progressPercentage: 50.0,
          requiredHours: 20.0,
          completedHours: 25.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        throwsAssertionError,
      );
    });

    test('should throw assertion when total chapters is zero', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 0,
          completedChapters: 0,
          progressPercentage: 0.0,
          requiredHours: 20.0,
          completedHours: 0.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        throwsAssertionError,
      );
    });

    test('should throw assertion when required hours is zero', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 0,
          progressPercentage: 0.0,
          requiredHours: 0.0,
          completedHours: 0.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        throwsAssertionError,
      );
    });

    test('should accept valid progress bounds', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.inProgress,
          totalChapters: 10,
          completedChapters: 5,
          progressPercentage: 50.0,
          requiredHours: 20.0,
          completedHours: 10.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        returnsNormally,
      );
    });

    test('should accept zero progress at start', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.notStarted,
          totalChapters: 10,
          completedChapters: 0,
          progressPercentage: 0.0,
          requiredHours: 20.0,
          completedHours: 0.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        returnsNormally,
      );
    });

    test('should accept full progress at completion', () {
      expect(
        () => StudySubjectModel.validate(
          id: 'test_id',
          code: 'SUB001',
          title: 'Test Subject',
          description: 'Test Description',
          category: 'Test Category',
          status: SubjectStatus.completed,
          totalChapters: 10,
          completedChapters: 10,
          progressPercentage: 100.0,
          requiredHours: 20.0,
          completedHours: 20.0,
          prerequisites: const [],
          order: 1,
          isMandatory: true,
        ),
        returnsNormally,
      );
    });
  });

  group('StudySubjectModel - Model Translation Integrity', () {
    test('should serialize and deserialize correctly', () {
      final original = StudySubjectModel(
        id: 'test_id',
        code: 'SUB001',
        title: 'Test Subject',
        description: 'Test Description',
        category: 'Test Category',
        status: SubjectStatus.inProgress,
        totalChapters: 10,
        completedChapters: 5,
        progressPercentage: 50.0,
        requiredHours: 20.0,
        completedHours: 10.0,
        prerequisites: ['PREREQ001'],
        instructorId: 'instructor_123',
        startDate: DateTime(2024, 1, 1),
        completionDate: null,
        lastAccessed: DateTime(2024, 6, 1),
        order: 1,
        isMandatory: true,
      );

      final json = original.toJson();
      final deserialized = StudySubjectModel.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.code, original.code);
      expect(deserialized.title, original.title);
      expect(deserialized.description, original.description);
      expect(deserialized.category, original.category);
      expect(deserialized.status, original.status);
      expect(deserialized.totalChapters, original.totalChapters);
      expect(deserialized.completedChapters, original.completedChapters);
      expect(deserialized.progressPercentage, original.progressPercentage);
      expect(deserialized.requiredHours, original.requiredHours);
      expect(deserialized.completedHours, original.completedHours);
      expect(deserialized.prerequisites, original.prerequisites);
      expect(deserialized.instructorId, original.instructorId);
      expect(deserialized.order, original.order);
      expect(deserialized.isMandatory, original.isMandatory);
    });

    test('should preserve enum values through serialization', () {
      final original = StudySubjectModel(
        id: 'test_id',
        code: 'SUB001',
        title: 'Test Subject',
        description: 'Test Description',
        category: 'Test Category',
        status: SubjectStatus.inProgress,
        totalChapters: 10,
        completedChapters: 5,
        progressPercentage: 50.0,
        requiredHours: 20.0,
        completedHours: 10.0,
        prerequisites: const [],
        order: 1,
        isMandatory: true,
      );

      final json = original.toJson();
      final deserialized = StudySubjectModel.fromJson(json);

      expect(deserialized.status, SubjectStatus.inProgress);
    });

    test('should preserve DateTime fields through serialization', () {
      final startDate = DateTime(2024, 1, 1);
      final lastAccessed = DateTime(2024, 6, 1);

      final original = StudySubjectModel(
        id: 'test_id',
        code: 'SUB001',
        title: 'Test Subject',
        description: 'Test Description',
        category: 'Test Category',
        status: SubjectStatus.inProgress,
        totalChapters: 10,
        completedChapters: 5,
        progressPercentage: 50.0,
        requiredHours: 20.0,
        completedHours: 10.0,
        prerequisites: const [],
        startDate: startDate,
        lastAccessed: lastAccessed,
        order: 1,
        isMandatory: true,
      );

      final json = original.toJson();
      final deserialized = StudySubjectModel.fromJson(json);

      expect(deserialized.startDate, isNotNull);
      expect(deserialized.startDate!.toIso8601String(), startDate.toIso8601String());
      expect(deserialized.lastAccessed, isNotNull);
      expect(deserialized.lastAccessed!.toIso8601String(), lastAccessed.toIso8601String());
    });

    test('should preserve null fields through serialization', () {
      final original = StudySubjectModel(
        id: 'test_id',
        code: 'SUB001',
        title: 'Test Subject',
        description: 'Test Description',
        category: 'Test Category',
        status: SubjectStatus.inProgress,
        totalChapters: 10,
        completedChapters: 5,
        progressPercentage: 50.0,
        requiredHours: 20.0,
        completedHours: 10.0,
        prerequisites: const [],
        order: 1,
        isMandatory: true,
      );

      final json = original.toJson();
      final deserialized = StudySubjectModel.fromJson(json);

      expect(deserialized.instructorId, isNull);
      expect(deserialized.startDate, isNull);
      expect(deserialized.completionDate, isNull);
    });

    test('should preserve list fields through serialization', () {
      final original = StudySubjectModel(
        id: 'test_id',
        code: 'SUB001',
        title: 'Test Subject',
        description: 'Test Description',
        category: 'Test Category',
        status: SubjectStatus.inProgress,
        totalChapters: 10,
        completedChapters: 5,
        progressPercentage: 50.0,
        requiredHours: 20.0,
        completedHours: 10.0,
        prerequisites: ['PREREQ001', 'PREREQ002', 'PREREQ003'],
        order: 1,
        isMandatory: true,
      );

      final json = original.toJson();
      final deserialized = StudySubjectModel.fromJson(json);

      expect(deserialized.prerequisites.length, 3);
      expect(deserialized.prerequisites, contains('PREREQ001'));
      expect(deserialized.prerequisites, contains('PREREQ002'));
      expect(deserialized.prerequisites, contains('PREREQ003'));
    });

    test('should handle empty prerequisites list', () {
      final original = StudySubjectModel(
        id: 'test_id',
        code: 'SUB001',
        title: 'Test Subject',
        description: 'Test Description',
        category: 'Test Category',
        status: SubjectStatus.inProgress,
        totalChapters: 10,
        completedChapters: 5,
        progressPercentage: 50.0,
        requiredHours: 20.0,
        completedHours: 10.0,
        prerequisites: const [],
        order: 1,
        isMandatory: true,
      );

      final json = original.toJson();
      final deserialized = StudySubjectModel.fromJson(json);

      expect(deserialized.prerequisites, isEmpty);
    });
  });
}
