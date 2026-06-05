import 'package:airman_toga_flutter_assessment/core/network/api_client.dart';
import '../models/notification_item_model.dart';

abstract class NotificationsService {
  Future<List<NotificationItemModel>> getNotifications(String userId);
  Future<List<NotificationItemModel>> getUnreadNotifications(String userId);
  Future<NotificationItemModel> getNotification(String notificationId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> dismissNotification(String notificationId);
  Future<NotificationItemModel> createNotification(Map<String, dynamic> notificationData);
  Future<int> getUnreadCount(String userId);
}

class MockNotificationsService implements NotificationsService {
  final List<NotificationItemModel> _mockNotifications = [];

  @override
  Future<List<NotificationItemModel>> getNotifications(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      if (_mockNotifications.isEmpty) {
        _initializeMockNotifications(userId);
      }
      return _mockNotifications.where((notif) => notif.userId == userId).toList();
    });
  }

  @override
  Future<List<NotificationItemModel>> getUnreadNotifications(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      final allNotifications = await getNotifications(userId);
      return allNotifications.where((notif) => !notif.isRead).toList();
    });
  }

  @override
  Future<NotificationItemModel> getNotification(String notificationId) async {
    return ApiClient.simulateNetworkCall(() async {
      return _mockNotifications.firstWhere((notif) => notif.id == notificationId);
    });
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await ApiClient.simulateNetworkCall(() async {
      final notification = await getNotification(notificationId);
      final updatedNotification = NotificationItemModel.validate(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        priority: notification.priority,
        isRead: true,
        createdAt: notification.createdAt,
        readAt: DateTime.now(),
        expiresAt: notification.expiresAt,
        actionUrl: notification.actionUrl,
        actionLabel: notification.actionLabel,
        metadata: notification.metadata,
        isDismissible: notification.isDismissible,
        dismissedAt: notification.dismissedAt,
        senderId: notification.senderId,
        senderName: notification.senderName,
        category: notification.category,
      );
      
      final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
      _mockNotifications[index] = updatedNotification;
    });
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await ApiClient.simulateNetworkCall(() async {
      final unreadNotifications = await getUnreadNotifications(userId);
      for (final notification in unreadNotifications) {
        await markAsRead(notification.id);
      }
    });
  }

  @override
  Future<void> dismissNotification(String notificationId) async {
    await ApiClient.simulateNetworkCall(() async {
      final notification = await getNotification(notificationId);
      if (!notification.isDismissible) {
        throw Exception('Notification is not dismissible');
      }
      
      final updatedNotification = NotificationItemModel.validate(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        priority: notification.priority,
        isRead: notification.isRead,
        createdAt: notification.createdAt,
        readAt: notification.readAt,
        expiresAt: notification.expiresAt,
        actionUrl: notification.actionUrl,
        actionLabel: notification.actionLabel,
        metadata: notification.metadata,
        isDismissible: notification.isDismissible,
        dismissedAt: DateTime.now(),
        senderId: notification.senderId,
        senderName: notification.senderName,
        category: notification.category,
      );
      
      final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
      _mockNotifications[index] = updatedNotification;
    });
  }

  @override
  Future<NotificationItemModel> createNotification(Map<String, dynamic> notificationData) async {
    return ApiClient.simulateNetworkCall(() async {
      final newNotification = NotificationItemModel.validate(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        userId: notificationData['userId'] as String,
        title: notificationData['title'] as String,
        message: notificationData['message'] as String,
        type: NotificationType.values.firstWhere(
          (t) => t.name == notificationData['type'] as String,
          orElse: () => NotificationType.system,
        ),
        priority: NotificationPriority.values.firstWhere(
          (p) => p.name == notificationData['priority'] as String,
          orElse: () => NotificationPriority.normal,
        ),
        isRead: false,
        createdAt: DateTime.now(),
        readAt: null,
        expiresAt: notificationData['expiresAt'] != null 
            ? DateTime.parse(notificationData['expiresAt'] as String)
            : null,
        actionUrl: notificationData['actionUrl'] as String?,
        actionLabel: notificationData['actionLabel'] as String?,
        metadata: notificationData['metadata'] as Map<String, dynamic>?,
        isDismissible: notificationData['isDismissible'] as bool? ?? true,
        dismissedAt: null,
        senderId: notificationData['senderId'] as String?,
        senderName: notificationData['senderName'] as String?,
        category: notificationData['category'] as String?,
      );
      _mockNotifications.add(newNotification);
      return newNotification;
    });
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      final unreadNotifications = await getUnreadNotifications(userId);
      return unreadNotifications.length;
    });
  }

  void _initializeMockNotifications(String userId) {
    _mockNotifications.addAll([
      NotificationItemModel.validate(
        id: 'notif_001',
        userId: userId,
        title: 'Chapter 1 Quiz Available',
        message: 'You can now take the quiz for Chapter 1: Introduction to Flight.',
        type: NotificationType.academic,
        priority: NotificationPriority.normal,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        readAt: null,
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        actionUrl: '/study/sub_001/chap_001/quiz',
        actionLabel: 'Take Quiz',
        metadata: {'subjectId': 'sub_001', 'chapterId': 'chap_001'},
        isDismissible: true,
        dismissedAt: null,
        senderId: 'sys_001',
        senderName: 'Academic System',
        category: 'quiz',
      ),
      NotificationItemModel.validate(
        id: 'notif_002',
        userId: userId,
        title: 'Flight Log Signed Off',
        message: 'Your flight log from March 15th has been signed off by Capt. Smith.',
        type: NotificationType.flight,
        priority: NotificationPriority.normal,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        readAt: DateTime.now().subtract(const Duration(hours: 20)),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        actionUrl: '/logbook/log_001',
        actionLabel: 'View Log',
        metadata: {'logEntryId': 'log_001'},
        isDismissible: true,
        dismissedAt: null,
        senderId: 'inst_001',
        senderName: 'Capt. Smith',
        category: 'logbook',
      ),
      NotificationItemModel.validate(
        id: 'notif_003',
        userId: userId,
        title: 'Study Progress Alert',
        message: 'You are behind schedule in Navigation Systems. Please catch up on your studies.',
        type: NotificationType.alert,
        priority: NotificationPriority.high,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        readAt: null,
        expiresAt: DateTime.now().add(const Duration(days: 3)),
        actionUrl: '/study/sub_002',
        actionLabel: 'View Progress',
        metadata: {'subjectId': 'sub_002', 'progress': 37.5},
        isDismissible: true,
        dismissedAt: null,
        senderId: 'sys_002',
        senderName: 'Study Tracker',
        category: 'progress',
      ),
      NotificationItemModel.validate(
        id: 'notif_004',
        userId: userId,
        title: 'Upcoming Flight Scheduled',
        message: 'Flight training session scheduled for tomorrow at 09:00 with Capt. Smith.',
        type: NotificationType.reminder,
        priority: NotificationPriority.urgent,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        readAt: null,
        expiresAt: DateTime.now().add(const Duration(days: 1)),
        actionUrl: '/schedule',
        actionLabel: 'View Schedule',
        metadata: {'flightDate': DateTime.now().add(const Duration(days: 1)).toIso8601String()},
        isDismissible: false,
        dismissedAt: null,
        senderId: 'sys_003',
        senderName: 'Scheduling System',
        category: 'flight',
      ),
    ]);
  }
}
