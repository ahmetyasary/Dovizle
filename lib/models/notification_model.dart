import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String message;
  final IconData icon;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? message,
    IconData? icon,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
