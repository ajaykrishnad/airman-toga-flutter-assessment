// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyNoteModel _$StudyNoteModelFromJson(Map<String, dynamic> json) =>
    StudyNoteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      subjectId: json['subjectId'] as String,
      chapterId: json['chapterId'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$NoteTypeEnumMap, json['type']),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isPinned: json['isPinned'] as bool,
      isPrivate: json['isPrivate'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
      order: (json['order'] as num).toInt(),
      relatedSubjectCode: json['relatedSubjectCode'] as String?,
      relatedChapterCode: json['relatedChapterCode'] as String?,
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StudyNoteModelToJson(StudyNoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'subjectId': instance.subjectId,
      'chapterId': instance.chapterId,
      'title': instance.title,
      'content': instance.content,
      'type': _$NoteTypeEnumMap[instance.type]!,
      'tags': instance.tags,
      'isPinned': instance.isPinned,
      'isPrivate': instance.isPrivate,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
      'order': instance.order,
      'relatedSubjectCode': instance.relatedSubjectCode,
      'relatedChapterCode': instance.relatedChapterCode,
      'attachments': instance.attachments,
    };

const _$NoteTypeEnumMap = {
  NoteType.general: 'general',
  NoteType.summary: 'summary',
  NoteType.question: 'question',
  NoteType.formula: 'formula',
  NoteType.procedure: 'procedure',
};
