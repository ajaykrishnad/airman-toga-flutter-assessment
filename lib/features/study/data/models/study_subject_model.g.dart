// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudySubjectModel _$StudySubjectModelFromJson(Map<String, dynamic> json) =>
    StudySubjectModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      status: $enumDecode(_$SubjectStatusEnumMap, json['status']),
      totalChapters: (json['totalChapters'] as num).toInt(),
      completedChapters: (json['completedChapters'] as num).toInt(),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      requiredHours: (json['requiredHours'] as num).toDouble(),
      completedHours: (json['completedHours'] as num).toDouble(),
      prerequisites: (json['prerequisites'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructorId: json['instructorId'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      completionDate: json['completionDate'] == null
          ? null
          : DateTime.parse(json['completionDate'] as String),
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
      order: (json['order'] as num).toInt(),
      isMandatory: json['isMandatory'] as bool,
    );

Map<String, dynamic> _$StudySubjectModelToJson(StudySubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'status': _$SubjectStatusEnumMap[instance.status]!,
      'totalChapters': instance.totalChapters,
      'completedChapters': instance.completedChapters,
      'progressPercentage': instance.progressPercentage,
      'requiredHours': instance.requiredHours,
      'completedHours': instance.completedHours,
      'prerequisites': instance.prerequisites,
      'instructorId': instance.instructorId,
      'startDate': instance.startDate?.toIso8601String(),
      'completionDate': instance.completionDate?.toIso8601String(),
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
      'order': instance.order,
      'isMandatory': instance.isMandatory,
    };

const _$SubjectStatusEnumMap = {
  SubjectStatus.notStarted: 'not_started',
  SubjectStatus.inProgress: 'in_progress',
  SubjectStatus.completed: 'completed',
  SubjectStatus.onHold: 'on_hold',
};
