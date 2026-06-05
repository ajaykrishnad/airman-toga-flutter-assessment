import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/notifications_service.dart';
import '../../data/models/notification_item_model.dart';

// Service provider
final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return MockNotificationsService();
});

// Notifications state
class NotificationsState {
  final List<NotificationItemModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationItemModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifications notifier
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsService service;

  NotificationsNotifier({required this.service}) : super(const NotificationsState());

  Future<void> loadNotifications(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notifications = await service.getNotifications(userId);
      final unreadCount = await service.getUnreadCount(userId);
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadUnreadNotifications(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notifications = await service.getUnreadNotifications(userId);
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        unreadCount: notifications.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.markAsRead(notificationId);
      final updatedNotifications = state.notifications.map((notif) =>
        notif.id == notificationId 
            ? NotificationItemModel.validate(
                id: notif.id,
                userId: notif.userId,
                title: notif.title,
                message: notif.message,
                type: notif.type,
                priority: notif.priority,
                isRead: true,
                createdAt: notif.createdAt,
                readAt: DateTime.now(),
                expiresAt: notif.expiresAt,
                actionUrl: notif.actionUrl,
                actionLabel: notif.actionLabel,
                metadata: notif.metadata,
                isDismissible: notif.isDismissible,
                dismissedAt: notif.dismissedAt,
                senderId: notif.senderId,
                senderName: notif.senderName,
                category: notif.category,
              )
            : notif
      ).toList();
      
      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
      state = state.copyWith(
        isLoading: false,
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsReadById(String notificationId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.markAsRead(notificationId);
      final updatedNotifications = state.notifications.map((notif) =>
        notif.id == notificationId 
            ? NotificationItemModel.validate(
                id: notif.id,
                userId: notif.userId,
                title: notif.title,
                message: notif.message,
                type: notif.type,
                priority: notif.priority,
                isRead: true,
                createdAt: notif.createdAt,
                readAt: DateTime.now(),
                expiresAt: notif.expiresAt,
                actionUrl: notif.actionUrl,
                actionLabel: notif.actionLabel,
                metadata: notif.metadata,
                isDismissible: notif.isDismissible,
                dismissedAt: notif.dismissedAt,
                senderId: notif.senderId,
                senderName: notif.senderName,
                category: notif.category,
              )
            : notif
      ).toList();
      
      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
      state = state.copyWith(
        isLoading: false,
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAllAsRead(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.markAllAsRead(userId);
      await loadNotifications(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> dismissNotification(String notificationId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await service.dismissNotification(notificationId);
      final updatedNotifications = state.notifications.where((notif) => notif.id != notificationId).toList();
      final wasUnread = state.notifications.firstWhere((n) => n.id == notificationId).isRead;
      final newUnreadCount = wasUnread ? state.unreadCount : (state.unreadCount > 0 ? state.unreadCount - 1 : 0);
      
      state = state.copyWith(
        isLoading: false,
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createNotification(Map<String, dynamic> notificationData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notification = await service.createNotification(notificationData);
      state = state.copyWith(
        isLoading: false,
        notifications: [notification, ...state.notifications],
        unreadCount: state.unreadCount + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshUnreadCount(String userId) async {
    try {
      final unreadCount = await service.getUnreadCount(userId);
      state = state.copyWith(unreadCount: unreadCount);
    } catch (e) {
      // Don't update state on error for count refresh
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  bool isNotificationRead(String notificationId) {
    final notification = state.notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => state.notifications.isNotEmpty 
          ? NotificationItemModel.validate(
              id: state.notifications.first.id,
              userId: state.notifications.first.userId,
              title: state.notifications.first.title,
              message: state.notifications.first.message,
              type: state.notifications.first.type,
              priority: state.notifications.first.priority,
              isRead: true,
              createdAt: state.notifications.first.createdAt,
              readAt: state.notifications.first.readAt,
              expiresAt: state.notifications.first.expiresAt,
              actionUrl: state.notifications.first.actionUrl,
              actionLabel: state.notifications.first.actionLabel,
              metadata: state.notifications.first.metadata,
              isDismissible: state.notifications.first.isDismissible,
              dismissedAt: state.notifications.first.dismissedAt,
              senderId: state.notifications.first.senderId,
              senderName: state.notifications.first.senderName,
              category: state.notifications.first.category,
            )
          : NotificationItemModel.validate(
              id: 'default',
              userId: 'default',
              title: 'Default',
              message: 'Default',
              type: NotificationType.system,
              priority: NotificationPriority.normal,
              isRead: true,
              createdAt: DateTime.now(),
              isDismissible: true,
            ),
    );
    return notification.isRead;
  }
}

// Notifications provider
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  final service = ref.watch(notificationsServiceProvider);
  return NotificationsNotifier(service: service);
});

// Unread count provider (FutureProvider)
final unreadCountProvider = FutureProvider.family<int, String>((ref, userId) async {
  final service = ref.watch(notificationsServiceProvider);
  return await service.getUnreadCount(userId);
});

// Individual notification provider (FutureProvider)
final notificationProvider = FutureProvider.family<NotificationItemModel, String>((ref, notificationId) async {
  final service = ref.watch(notificationsServiceProvider);
  return await service.getNotification(notificationId);
});
