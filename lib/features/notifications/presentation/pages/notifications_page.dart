import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:airman_toga_flutter_assessment/features/notifications/data/models/notification_item_model.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).loadNotifications('user_arjun_menon');
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (notificationsState.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.mark_email_read),
              onPressed: () => _markAllAsRead(),
              tooltip: 'Mark all as read',
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFF0A1628),
        child: Column(
          children: [
            // Unread Count Banner
            if (notificationsState.unreadCount > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withValues(alpha: 0.1),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFF4FC3F7),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: Color(0xFF4FC3F7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${notificationsState.unreadCount} unread notification${notificationsState.unreadCount == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Color(0xFF4FC3F7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Notifications List
            Expanded(
              child: notificationsState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
                      ),
                    )
                  : notificationsState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF5350),
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load notifications',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                notificationsState.error!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(notificationsProvider.notifier).loadNotifications('user_arjun_menon');
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : notificationsState.notifications.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_none,
                                    color: Colors.white30,
                                    size: 64,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No notifications',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'You\'re all caught up!',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: notificationsState.notifications.length,
                              itemBuilder: (context, index) {
                                final notification = notificationsState.notifications[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildNotificationCard(notification),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItemModel notification) {
    final priorityColor = _getPriorityColor(notification.priority);
    final typeColor = _getTypeColor(notification.type);
    final isUnread = !notification.isRead;
    
    return InkWell(
      onTap: () {
        if (isUnread) {
          ref.read(notificationsProvider.notifier).markAsRead(notification.id);
        }
        // TODO: Navigate to related content
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnread 
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread 
                ? priorityColor.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: isUnread ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: typeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildPriorityBadge(notification.priority),
                          const SizedBox(width: 8),
                          _buildTypeBadge(notification.type),
                          if (isUnread)
                            const SizedBox(width: 8),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4FC3F7),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (notification.actionUrl != null)
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white54,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _formatTimestamp(notification.createdAt),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (notification.expiresAt != null)
                  Text(
                    'Expires: ${_formatTimestamp(notification.expiresAt!)}',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(NotificationType type) {
    final color = _getTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return const Color(0xFF9E9E9E);
      case NotificationPriority.normal:
        return const Color(0xFF4FC3F7);
      case NotificationPriority.high:
        return const Color(0xFFFFA726);
      case NotificationPriority.urgent:
        return const Color(0xFFEF5350);
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return const Color(0xFF9E9E9E);
      case NotificationType.academic:
        return const Color(0xFF4FC3F7);
      case NotificationType.flight:
        return const Color(0xFF66BB6A);
      case NotificationType.administrative:
        return const Color(0xFFFFA726);
      case NotificationType.reminder:
        return const Color(0xFFAB47BC);
      case NotificationType.alert:
        return const Color(0xFFEF5350);
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.academic:
        return Icons.school;
      case NotificationType.flight:
        return Icons.flight;
      case NotificationType.administrative:
        return Icons.admin_panel_settings;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.alert:
        return Icons.warning;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return timestamp.toString().split(' ')[0];
    }
  }

  void _markAllAsRead() {
    ref.read(notificationsProvider.notifier).markAllAsRead('user_arjun_menon');
  }
}
