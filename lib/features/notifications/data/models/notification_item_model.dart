import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';

part 'notification_item_model.g.dart';

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

enum NotificationType {
  @JsonValue('system')
  system,
  @JsonValue('academic')
  academic,
  @JsonValue('flight')
  flight,
  @JsonValue('administrative')
  administrative,
  @JsonValue('reminder')
  reminder,
  @JsonValue('alert')
  alert,
}

@JsonSerializable()
class NotificationItemModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  @JsonKey(name: 'isRead')
  final bool isRead;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'readAt')
  final DateTime? readAt;
  @JsonKey(name: 'expiresAt')
  final DateTime? expiresAt;
  final String? actionUrl;
  final String? actionLabel;
  final Map<String, dynamic>? metadata;
  final bool isDismissible;
  @JsonKey(name: 'dismissedAt')
  final DateTime? dismissedAt;
  final String? senderId;
  final String? senderName;
  final String? category;

  const NotificationItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.expiresAt,
    this.actionUrl,
    this.actionLabel,
    this.metadata,
    required this.isDismissible,
    this.dismissedAt,
    this.senderId,
    this.senderName,
    this.category,
  });

  // Assertions for data integrity
  factory NotificationItemModel.validate({
    required String id,
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    required NotificationPriority priority,
    required bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
    DateTime? expiresAt,
    String? actionUrl,
    String? actionLabel,
    Map<String, dynamic>? metadata,
    required bool isDismissible,
    DateTime? dismissedAt,
    String? senderId,
    String? senderName,
    String? category,
  }) {
    assert(userId.isNotEmpty, 'User ID cannot be empty');
    assert(title.isNotEmpty, 'Notification title cannot be empty');
    assert(message.isNotEmpty, 'Notification message cannot be empty');
    assert(expiresAt == null || expiresAt.isAfter(createdAt),
        'Expiration date must be after creation date');

    // Validate read status consistency
    if (isRead) {
      assert(readAt != null, 'Read status requires a read timestamp');
      assert(readAt!.isAtSameMomentAs(createdAt) || readAt.isAfter(createdAt),
          'Read timestamp must be after or equal to creation date');
    }

    // Validate dismiss status consistency
    if (dismissedAt != null) {
      assert(isDismissible, 'Dismissed timestamp requires notification to be dismissible');
      assert(dismissedAt.isAtSameMomentAs(createdAt) || dismissedAt.isAfter(createdAt),
          'Dismissed timestamp must be after or equal to creation date');
    }

    // Validate action button consistency
    if (actionUrl != null) {
      assert(actionUrl.isNotEmpty, 'Action URL cannot be empty if provided');
      assert(actionLabel != null, 'Action label is required when action URL is provided');
      assert(actionLabel!.isNotEmpty, 'Action label cannot be empty');
    }

    // Validate sender information
    if (senderId != null) {
      assert(senderId.isNotEmpty, 'Sender ID cannot be empty if provided');
      assert(senderName != null, 'Sender name is required when sender ID is provided');
      assert(senderName!.isNotEmpty, 'Sender name cannot be empty');
    }

    return NotificationItemModel(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      priority: priority,
      isRead: isRead,
      createdAt: createdAt,
      readAt: readAt,
      expiresAt: expiresAt,
      actionUrl: actionUrl,
      actionLabel: actionLabel,
      metadata: metadata,
      isDismissible: isDismissible,
      dismissedAt: dismissedAt,
      senderId: senderId,
      senderName: senderName,
      category: category,
    );
  }

  factory NotificationItemModel.fromJson(JsonMap json) => _$NotificationItemModelFromJson(json);

  JsonMap toJson() => _$NotificationItemModelToJson(this);

  // Computed properties
  String get typeText {
    switch (type) {
      case NotificationType.system:
        return 'System';
      case NotificationType.academic:
        return 'Academic';
      case NotificationType.flight:
        return 'Flight';
      case NotificationType.administrative:
        return 'Administrative';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.alert:
        return 'Alert';
    }
  }

  String get priorityText {
    switch (priority) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  bool get isUnread => !isRead;

  bool get isExpired {
    final e = expiresAt;
    return e != null && DateTime.now().isAfter(e);
  }

  bool get isDismissed => dismissedAt != null;

  bool get isUrgent => priority == NotificationPriority.urgent;

  bool get isHighPriority => priority == NotificationPriority.high || priority == NotificationPriority.urgent;

  bool get hasAction => actionUrl != null && actionLabel != null;

  bool get hasSender => senderId != null && senderName != null;

  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours <= 24;
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}
