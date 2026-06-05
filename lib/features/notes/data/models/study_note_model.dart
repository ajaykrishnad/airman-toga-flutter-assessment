import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';

part 'study_note_model.g.dart';

enum NoteType {
  @JsonValue('general')
  general,
  @JsonValue('summary')
  summary,
  @JsonValue('question')
  question,
  @JsonValue('formula')
  formula,
  @JsonValue('procedure')
  procedure,
}

@JsonSerializable()
class StudyNoteModel {
  final String id;
  final String userId;
  final String subjectId;
  final String? chapterId;
  final String title;
  final String content;
  final NoteType type;
  final List<String> tags;
  final bool isPinned;
  final bool isPrivate;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @JsonKey(name: 'lastAccessed')
  final DateTime? lastAccessed;
  final int order;
  final String? relatedSubjectCode;
  final String? relatedChapterCode;
  final List<String> attachments;

  const StudyNoteModel({
    required this.id,
    required this.userId,
    required this.subjectId,
    this.chapterId,
    required this.title,
    required this.content,
    required this.type,
    required this.tags,
    required this.isPinned,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    this.lastAccessed,
    required this.order,
    this.relatedSubjectCode,
    this.relatedChapterCode,
    required this.attachments,
  });

  // Assertions for data integrity
  factory StudyNoteModel.validate({
    required String id,
    required String userId,
    required String subjectId,
    String? chapterId,
    required String title,
    required String content,
    required NoteType type,
    required List<String> tags,
    required bool isPinned,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastAccessed,
    required int order,
    String? relatedSubjectCode,
    String? relatedChapterCode,
    required List<String> attachments,
  }) {
    assert(userId.isNotEmpty, 'User ID cannot be empty');
    assert(subjectId.isNotEmpty, 'Subject ID cannot be empty');
    assert(title.isNotEmpty, 'Note title cannot be empty');
    assert(content.isNotEmpty, 'Note content cannot be empty');
    assert(tags.every((t) => t.isNotEmpty), 'Tags cannot be empty strings');
    assert(order >= 0, 'Order cannot be negative');
    assert(attachments.every((a) => a.isNotEmpty), 'Attachments cannot be empty strings');
    assert(updatedAt.isAtSameMomentAs(createdAt) || updatedAt.isAfter(createdAt), 
           'Updated date must be after or equal to created date');
    
    // Validate chapter-specific notes
    if (chapterId != null) {
      assert(chapterId.isNotEmpty, 'Chapter ID cannot be empty if provided');
    }

    return StudyNoteModel(
      id: id,
      userId: userId,
      subjectId: subjectId,
      chapterId: chapterId,
      title: title,
      content: content,
      type: type,
      tags: tags,
      isPinned: isPinned,
      isPrivate: isPrivate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastAccessed: lastAccessed,
      order: order,
      relatedSubjectCode: relatedSubjectCode,
      relatedChapterCode: relatedChapterCode,
      attachments: attachments,
    );
  }

  factory StudyNoteModel.fromJson(JsonMap json) => _$StudyNoteModelFromJson(json);

  JsonMap toJson() => _$StudyNoteModelToJson(this);

  // Computed properties
  String get typeText {
    switch (type) {
      case NoteType.general:
        return 'General';
      case NoteType.summary:
        return 'Summary';
      case NoteType.question:
        return 'Question';
      case NoteType.formula:
        return 'Formula';
      case NoteType.procedure:
        return 'Procedure';
    }
  }

  bool get isRecentlyUpdated {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    return difference.inDays <= 7;
  }

  bool get isStale {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    return difference.inDays > 30;
  }

  bool get hasAttachments => attachments.isNotEmpty;
  
  bool get hasTags => tags.isNotEmpty;
  
  bool get isChapterSpecific => chapterId != null && chapterId!.isNotEmpty;
  
  int get contentLength => content.length;
  
  String get contentPreview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}
