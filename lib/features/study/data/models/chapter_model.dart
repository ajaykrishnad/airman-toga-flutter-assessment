import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';

part 'chapter_model.g.dart';

enum ChapterStatus {
  @JsonValue('locked')
  locked,
  @JsonValue('available')
  available,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

extension ChapterStatusExtension on ChapterStatus {
  String get statusText {
    switch (this) {
      case ChapterStatus.locked:
        return 'Locked';
      case ChapterStatus.available:
        return 'Available';
      case ChapterStatus.inProgress:
        return 'In Progress';
      case ChapterStatus.completed:
        return 'Completed';
    }
  }
}

@JsonSerializable()
class ChapterModel {
  final String id;
  final String subjectId;
  final String code;
  final String title;
  final String description;
  final ChapterStatus status;
  final int order;
  @JsonKey(name: 'estimatedDuration')
  final double estimatedDuration;
  @JsonKey(name: 'actualDuration')
  final double? actualDuration;
  final List<String> learningObjectives;
  final List<String> resources;
  final bool hasQuiz;
  @JsonKey(name: 'quizScore')
  final double? quizScore;
  @JsonKey(name: 'quizPassed')
  final bool? quizPassed;
  @JsonKey(name: 'startDate')
  final DateTime? startDate;
  @JsonKey(name: 'completionDate')
  final DateTime? completionDate;
  @JsonKey(name: 'lastAccessed')
  final DateTime? lastAccessed;
  @JsonKey(name: 'attemptsCount')
  final int attemptsCount;
  final List<String> prerequisites;

  const ChapterModel({
    required this.id,
    required this.subjectId,
    required this.code,
    required this.title,
    required this.description,
    required this.status,
    required this.order,
    required this.estimatedDuration,
    this.actualDuration,
    required this.learningObjectives,
    required this.resources,
    required this.hasQuiz,
    this.quizScore,
    this.quizPassed,
    this.startDate,
    this.completionDate,
    this.lastAccessed,
    required this.attemptsCount,
    required this.prerequisites,
  });

  // Assertions for data integrity
  factory ChapterModel.validate({
    required String id,
    required String subjectId,
    required String code,
    required String title,
    required String description,
    required ChapterStatus status,
    required int order,
    required double estimatedDuration,
    double? actualDuration,
    required List<String> learningObjectives,
    required List<String> resources,
    required bool hasQuiz,
    double? quizScore,
    bool? quizPassed,
    DateTime? startDate,
    DateTime? completionDate,
    DateTime? lastAccessed,
    required int attemptsCount,
    required List<String> prerequisites,
  }) {
    assert(subjectId.isNotEmpty, 'Subject ID cannot be empty');
    assert(code.isNotEmpty, 'Chapter code cannot be empty');
    assert(title.isNotEmpty, 'Chapter title cannot be empty');
    assert(description.isNotEmpty, 'Chapter description cannot be empty');
    assert(order >= 0, 'Order cannot be negative');
    assert(estimatedDuration > 0, 'Estimated duration must be greater than 0');
    assert(actualDuration == null || actualDuration >= 0, 
           'Actual duration cannot be negative');
    assert(learningObjectives.every((o) => o.isNotEmpty), 
           'Learning objectives cannot be empty strings');
    assert(attemptsCount >= 0, 'Attempts count cannot be negative');
    
    // Validate quiz-related fields (allow nullable until attempted)
    if (quizScore != null) {
      assert(quizScore >= 0 && quizScore <= 100, 'Quiz score must be between 0 and 100');
    }
    
    // Validate status consistency
    if (status == ChapterStatus.completed) {
      assert(actualDuration != null, 'Completed status requires actual duration');
      assert(completionDate != null, 'Completed status requires completion date');
      // Only require `quizPassed` when a quiz exists and has been attempted (score provided).
      if (hasQuiz && quizScore != null) {
        assert(quizPassed == true, 'Completed status with quiz requires quiz to be passed');
      }
    }
    
    if (status == ChapterStatus.inProgress) {
      assert(startDate != null, 'In progress status requires start date');
    }

    return ChapterModel(
      id: id,
      subjectId: subjectId,
      code: code,
      title: title,
      description: description,
      status: status,
      order: order,
      estimatedDuration: estimatedDuration,
      actualDuration: actualDuration,
      learningObjectives: learningObjectives,
      resources: resources,
      hasQuiz: hasQuiz,
      quizScore: quizScore,
      quizPassed: quizPassed,
      startDate: startDate,
      completionDate: completionDate,
      lastAccessed: lastAccessed,
      attemptsCount: attemptsCount,
      prerequisites: prerequisites,
    );
  }

  factory ChapterModel.fromJson(JsonMap json) => _$ChapterModelFromJson(json);

  JsonMap toJson() => _$ChapterModelToJson(this);

  // Computed properties
  String get statusText {
    switch (status) {
      case ChapterStatus.locked:
        return 'Locked';
      case ChapterStatus.available:
        return 'Available';
      case ChapterStatus.inProgress:
        return 'In Progress';
      case ChapterStatus.completed:
        return 'Completed';
    }
  }

  bool get isAccessible => status != ChapterStatus.locked;
  
  bool get isCompleted => status == ChapterStatus.completed;
  
  bool get isStarted => status == ChapterStatus.inProgress || status == ChapterStatus.completed;
  
  bool get needsQuiz => hasQuiz && quizPassed != true;
  
  bool get quizPassedSuccessfully => hasQuiz && quizPassed == true;
  
  double get progressPercentage {
    if (status == ChapterStatus.completed) return 100.0;
    if (status == ChapterStatus.inProgress) return 50.0;
    if (status == ChapterStatus.available) return 0.0;
    return 0.0;
  }
  
  String get performanceRating {
    final score = quizScore;
    if (!hasQuiz || score == null) return 'N/A';
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Good';
    if (score >= 70) return 'Satisfactory';
    if (score >= 60) return 'Passing';
    return 'Needs Improvement';
  }
}
