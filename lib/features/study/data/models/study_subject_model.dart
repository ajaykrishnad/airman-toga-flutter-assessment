import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';

part 'study_subject_model.g.dart';

enum SubjectStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('on_hold')
  onHold,
}

extension SubjectStatusExtension on SubjectStatus {
  String get statusText {
    switch (this) {
      case SubjectStatus.notStarted:
        return 'Not Started';
      case SubjectStatus.inProgress:
        return 'In Progress';
      case SubjectStatus.completed:
        return 'Completed';
      case SubjectStatus.onHold:
        return 'On Hold';
    }
  }
}

@JsonSerializable()
class StudySubjectModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String category;
  final SubjectStatus status;
  @JsonKey(name: 'totalChapters')
  final int totalChapters;
  @JsonKey(name: 'completedChapters')
  final int completedChapters;
  @JsonKey(name: 'progressPercentage')
  final double progressPercentage;
  @JsonKey(name: 'requiredHours')
  final double requiredHours;
  @JsonKey(name: 'completedHours')
  final double completedHours;
  final List<String> prerequisites;
  final String? instructorId;
  @JsonKey(name: 'startDate')
  final DateTime? startDate;
  @JsonKey(name: 'completionDate')
  final DateTime? completionDate;
  @JsonKey(name: 'lastAccessed')
  final DateTime? lastAccessed;
  final int order;
  final bool isMandatory;

  const StudySubjectModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.totalChapters,
    required this.completedChapters,
    required this.progressPercentage,
    required this.requiredHours,
    required this.completedHours,
    required this.prerequisites,
    this.instructorId,
    this.startDate,
    this.completionDate,
    this.lastAccessed,
    required this.order,
    required this.isMandatory,
  });

  // Assertions for data integrity
  factory StudySubjectModel.validate({
    required String id,
    required String code,
    required String title,
    required String description,
    required String category,
    required SubjectStatus status,
    required int totalChapters,
    required int completedChapters,
    required double progressPercentage,
    required double requiredHours,
    required double completedHours,
    required List<String> prerequisites,
    String? instructorId,
    DateTime? startDate,
    DateTime? completionDate,
    DateTime? lastAccessed,
    required int order,
    required bool isMandatory,
  }) {
    assert(code.isNotEmpty, 'Subject code cannot be empty');
    assert(title.isNotEmpty, 'Subject title cannot be empty');
    assert(description.isNotEmpty, 'Subject description cannot be empty');
    assert(category.isNotEmpty, 'Subject category cannot be empty');
    assert(totalChapters > 0, 'Total chapters must be greater than 0');
    assert(completedChapters >= 0, 'Completed chapters cannot be negative');
    assert(completedChapters <= totalChapters, 'Completed chapters cannot exceed total chapters');
    assert(progressPercentage >= 0 && progressPercentage <= 100, 
           'Progress percentage must be between 0 and 100');
    assert(requiredHours > 0, 'Required hours must be greater than 0');
    assert(completedHours >= 0, 'Completed hours cannot be negative');
    assert(completedHours <= requiredHours, 'Completed hours cannot exceed required hours');
    assert(order >= 0, 'Order cannot be negative');
    
    // Validate status consistency
    if (status == SubjectStatus.completed) {
      assert(completedChapters == totalChapters, 
             'Completed status requires all chapters to be completed');
      assert(progressPercentage == 100, 'Completed status requires 100% progress');
      assert(completionDate != null, 'Completed status requires a completion date');
    }
    
    if (status == SubjectStatus.notStarted) {
      assert(completedChapters == 0, 'Not started status requires 0 completed chapters');
      assert(progressPercentage == 0, 'Not started status requires 0% progress');
      assert(completedHours == 0, 'Not started status requires 0 completed hours');
    }

    return StudySubjectModel(
      id: id,
      code: code,
      title: title,
      description: description,
      category: category,
      status: status,
      totalChapters: totalChapters,
      completedChapters: completedChapters,
      progressPercentage: progressPercentage,
      requiredHours: requiredHours,
      completedHours: completedHours,
      prerequisites: prerequisites,
      instructorId: instructorId,
      startDate: startDate,
      completionDate: completionDate,
      lastAccessed: lastAccessed,
      order: order,
      isMandatory: isMandatory,
    );
  }

  factory StudySubjectModel.fromJson(JsonMap json) => _$StudySubjectModelFromJson(json);

  JsonMap toJson() => _$StudySubjectModelToJson(this);

  // Computed properties for functional specification
  String get statusText {
    switch (status) {
      case SubjectStatus.notStarted:
        return 'Not Started';
      case SubjectStatus.inProgress:
        return 'In Progress';
      case SubjectStatus.completed:
        return 'Completed';
      case SubjectStatus.onHold:
        return 'On Hold';
    }
  }

  bool get isCompleted => status == SubjectStatus.completed;
  
  bool get isStarted => status != SubjectStatus.notStarted;
  
  bool get isBehindSchedule => completedHours < (requiredHours * 0.5) && 
                              status == SubjectStatus.inProgress;
  
  bool get isOnTrack => completedHours >= (requiredHours * 0.5) && 
                       status == SubjectStatus.inProgress;
  
  int get remainingChapters => totalChapters - completedChapters;
  
  double get remainingHours => requiredHours - completedHours;
  
  String get progressCategory {
    if (progressPercentage == 0) return 'Not Started';
    if (progressPercentage < 25) return 'Beginning';
    if (progressPercentage < 50) return 'Early Progress';
    if (progressPercentage < 75) return 'Mid Progress';
    if (progressPercentage < 100) return 'Advanced';
    return 'Completed';
  }
}
