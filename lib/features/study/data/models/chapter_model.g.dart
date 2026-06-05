// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) => ChapterModel(
  id: json['id'] as String,
  subjectId: json['subjectId'] as String,
  code: json['code'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$ChapterStatusEnumMap, json['status']),
  order: (json['order'] as num).toInt(),
  estimatedDuration: (json['estimatedDuration'] as num).toDouble(),
  actualDuration: (json['actualDuration'] as num?)?.toDouble(),
  learningObjectives: (json['learningObjectives'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  resources: (json['resources'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  hasQuiz: json['hasQuiz'] as bool,
  quizScore: (json['quizScore'] as num?)?.toDouble(),
  quizPassed: json['quizPassed'] as bool?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  completionDate: json['completionDate'] == null
      ? null
      : DateTime.parse(json['completionDate'] as String),
  lastAccessed: json['lastAccessed'] == null
      ? null
      : DateTime.parse(json['lastAccessed'] as String),
  attemptsCount: (json['attemptsCount'] as num).toInt(),
  prerequisites: (json['prerequisites'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subjectId': instance.subjectId,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'status': _$ChapterStatusEnumMap[instance.status]!,
      'order': instance.order,
      'estimatedDuration': instance.estimatedDuration,
      'actualDuration': instance.actualDuration,
      'learningObjectives': instance.learningObjectives,
      'resources': instance.resources,
      'hasQuiz': instance.hasQuiz,
      'quizScore': instance.quizScore,
      'quizPassed': instance.quizPassed,
      'startDate': instance.startDate?.toIso8601String(),
      'completionDate': instance.completionDate?.toIso8601String(),
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
      'attemptsCount': instance.attemptsCount,
      'prerequisites': instance.prerequisites,
    };

const _$ChapterStatusEnumMap = {
  ChapterStatus.locked: 'locked',
  ChapterStatus.available: 'available',
  ChapterStatus.inProgress: 'in_progress',
  ChapterStatus.completed: 'completed',
};
