// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationItemModel _$NotificationItemModelFromJson(
  Map<String, dynamic> json,
) => NotificationItemModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  priority: $enumDecode(_$NotificationPriorityEnumMap, json['priority']),
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  actionUrl: json['actionUrl'] as String?,
  actionLabel: json['actionLabel'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  isDismissible: json['isDismissible'] as bool,
  dismissedAt: json['dismissedAt'] == null
      ? null
      : DateTime.parse(json['dismissedAt'] as String),
  senderId: json['senderId'] as String?,
  senderName: json['senderName'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$NotificationItemModelToJson(
  NotificationItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'priority': _$NotificationPriorityEnumMap[instance.priority]!,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
  'readAt': instance.readAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'actionUrl': instance.actionUrl,
  'actionLabel': instance.actionLabel,
  'metadata': instance.metadata,
  'isDismissible': instance.isDismissible,
  'dismissedAt': instance.dismissedAt?.toIso8601String(),
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'category': instance.category,
};

const _$NotificationTypeEnumMap = {
  NotificationType.system: 'system',
  NotificationType.academic: 'academic',
  NotificationType.flight: 'flight',
  NotificationType.administrative: 'administrative',
  NotificationType.reminder: 'reminder',
  NotificationType.alert: 'alert',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};
