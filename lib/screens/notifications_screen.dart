import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../providers/notification_provider.dart';
import '../providers/language_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer2<NotificationProvider, LanguageProvider>(
        builder: (context, provider, languageProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageProvider.translate('notifications'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  Consumer<NotificationProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final count = Random().nextInt(2) + 1;
                              for (var i = 0; i < count; i++) {
                                provider.addRandomNotification(context);
                                if (i < count - 1) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            tooltip: languageProvider.translate('refresh'),
                          ),
                          if (provider.notifications.isNotEmpty) ...[
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? const Color(0xFF1E1E1E)
                                            : Colors.white,
                                    title: Text(
                                      languageProvider
                                          .translate('mark_all_read'),
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    content: Text(
                                      languageProvider
                                          .translate('mark_all_read_confirm'),
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          languageProvider.translate('cancel'),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          provider.markAllAsRead();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  languageProvider.translate(
                                                      'all_notifications_marked_read')),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          languageProvider.translate('confirm'),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.done_all,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              tooltip:
                                  languageProvider.translate('mark_all_read'),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? const Color(0xFF1E1E1E)
                                            : Colors.white,
                                    title: Text(
                                      languageProvider.translate(
                                          'delete_all_notifications'),
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    content: Text(
                                      languageProvider
                                          .translate('delete_all_confirm'),
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          languageProvider.translate('cancel'),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          provider.deleteAllNotifications();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  languageProvider.translate(
                                                      'all_notifications_deleted')),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          languageProvider.translate('confirm'),
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.delete_sweep,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              tooltip: languageProvider
                                  .translate('delete_all_notifications'),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    if (provider.notifications.isEmpty) {
                      return RefreshIndicator(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                        strokeWidth: 2.5,
                        onRefresh: () async {
                          final count = Random().nextInt(2) + 1;
                          for (var i = 0; i < count; i++) {
                            provider.addRandomNotification(context);
                            if (i < count - 1) {
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                            }
                          }
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.notifications_off_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      languageProvider
                                          .translate('no_notifications'),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      strokeWidth: 2.5,
                      onRefresh: () async {
                        final count = Random().nextInt(2) + 1;
                        for (var i = 0; i < count; i++) {
                          provider.addRandomNotification(context);
                          if (i < count - 1) {
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                          }
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: provider.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = provider.notifications[index];
                          return Dismissible(
                            key: Key(notification.id),
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                provider.deleteNotification(notification.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(languageProvider
                                        .translate('notification_deleted')),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                provider.markAsRead(notification.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(languageProvider
                                        .translate('notification_marked_read')),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return false;
                              }
                              return true;
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[800]!
                                        : Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  leading: Icon(
                                    notification.icon,
                                    color: notification.isRead
                                        ? Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[600]
                                            : Colors.grey[400]
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black87,
                                    size: 28,
                                  ),
                                  title: Text(
                                    notification.message,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? (notification.isRead
                                              ? Colors.grey[500]
                                              : Colors.white)
                                          : (notification.isRead
                                              ? Colors.grey[600]
                                              : Colors.black87),
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _formatDate(notification.timestamp,
                                        languageProvider),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[600]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  trailing: notification.isRead
                                      ? null
                                      : Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? (notification.isRead
                                                        ? Colors.grey[500]
                                                        : Colors.white)
                                                    : (notification.isRead
                                                        ? Colors.grey[600]
                                                        : Colors.black87),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date, LanguageProvider languageProvider) {
    final formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);
    return formattedDate
        .replaceAll('Jan', languageProvider.translate('jan'))
        .replaceAll('Feb', languageProvider.translate('feb'))
        .replaceAll('Mar', languageProvider.translate('mar'))
        .replaceAll('Apr', languageProvider.translate('apr'))
        .replaceAll('May', languageProvider.translate('may'))
        .replaceAll('Jun', languageProvider.translate('jun'))
        .replaceAll('Jul', languageProvider.translate('jul'))
        .replaceAll('Aug', languageProvider.translate('aug'))
        .replaceAll('Sep', languageProvider.translate('sep'))
        .replaceAll('Oct', languageProvider.translate('oct'))
        .replaceAll('Nov', languageProvider.translate('nov'))
        .replaceAll('Dec', languageProvider.translate('dec'));
  }
}
