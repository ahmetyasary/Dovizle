import 'dart:math';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  final Random _random = Random();

  List<NotificationModel> get notifications => List.from(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    // İlk açılışta 3 bildirim ekle
    Future.delayed(const Duration(milliseconds: 500), () {
      addNotification(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'USD/TL son 24 saatte %2.5 yükseldi!',
          icon: Icons.currency_exchange,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: false,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      addNotification(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'EUR/TL teknik analize göre yükseliş trendinde.',
          icon: Icons.euro_rounded,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isRead: false,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      addNotification(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'Gram Altın rekor kırdı! Takipte kalın.',
          icon: Icons.monetization_on,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: false,
        ),
      );
    });
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index =
        _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void deleteAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void addRandomNotification(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final notifications = [
      {
        'message':
            'USD/TL ${_random.nextBool() ? languageProvider.translate("increased") : languageProvider.translate("decreased")} ${_random.nextInt(5) + 1}% in the last 24 hours!',
        'icon': Icons.currency_exchange,
      },
      {
        'message':
            'EUR/TL ${languageProvider.translate("is_in")} ${_random.nextBool() ? languageProvider.translate("upward") : languageProvider.translate("downward")} ${languageProvider.translate("trend")}.',
        'icon': Icons.euro_rounded,
      },
      {
        'message':
            '${languageProvider.translate("gold")} ${_random.nextBool() ? languageProvider.translate("broke_record") : languageProvider.translate("is_falling")}! ${languageProvider.translate("stay_tuned")}.',
        'icon': Icons.monetization_on,
      },
      {
        'message':
            'GBP/TL ${languageProvider.translate("sharp")} ${_random.nextBool() ? languageProvider.translate("rise") : languageProvider.translate("fall")} ${languageProvider.translate("movement")}!',
        'icon': Icons.currency_pound,
      },
      {
        'message':
            '${languageProvider.translate("gold_ounce")} ${_random.nextBool() ? languageProvider.translate("rising") : languageProvider.translate("falling")} ${languageProvider.translate("in_global_markets")}.',
        'icon': Icons.monetization_on,
      },
      {
        'message':
            'JPY/TL ${languageProvider.translate("in_last")} ${_random.nextInt(4) + 1} ${languageProvider.translate("hours")} ${_random.nextInt(3) + 1}% ${_random.nextBool() ? languageProvider.translate("gained_value") : languageProvider.translate("lost_value")}.',
        'icon': Icons.currency_yen,
      },
    ];

    final notification = notifications[_random.nextInt(notifications.length)];
    addNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: notification['message'] as String,
        icon: notification['icon'] as IconData,
        timestamp: DateTime.now(),
        isRead: false,
      ),
    );
  }
}
