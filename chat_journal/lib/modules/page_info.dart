import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/data.dart';

class Category {
  final String title;
  final IconData icon;

  const Category({
    this.icon = Icons.favorite,
    this.title = '',
  });
}

class Event {
  int? id;
  int? pageId;
  String? message;
  String? imagePath;
  Category? category;
  bool isBookmarked;
  String? formattedSendTime;
  DateTime? sendTime;

  Event({
    this.id,
    this.pageId = -1,
    this.message = '',
    this.imagePath,
    this.category,
    this.isBookmarked = false,
    this.sendTime,
    this.formattedSendTime,
  }) {
    sendTime ??= DateTime.now();
    formattedSendTime ??= '';
  }

  Event copyWith({
    int? id,
    Category? category,
    String? formattedSendTime,
    bool? isBookmarked,
    String? message,
    int? pageId,
    DateTime? sendTime,
  }) {
    return Event(
      id: id ?? this.id,
      category: category ?? this.category,
      formattedSendTime: formattedSendTime ?? this.formattedSendTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      message: message ?? this.message,
      pageId: pageId ?? this.pageId,
      sendTime: sendTime ?? this.sendTime,
    );
  }

  int compareTo(Event other) {
    return sendTime!.isAfter(other.sendTime!) ? -1 : 1;
  }

  void updateSendTime() {
    final now = DateTime.now();
    sendTime = now;
    formattedSendTime = 'edited ${now.hour}:${now.minute}';
  }

  Map<String, dynamic> toMap() {
    return {
      'pageId': pageId,
      'categoryId': category != null ? initCategories.indexOf(category!) : -1,
      'message': message,
      'imagePath': imagePath ?? '',
      'formattedSendTime': formattedSendTime,
      'sendTime': sendTime.toString(),
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }
}

class PageInfo {
  int? id;
  Icon? icon;
  String title;
  String lastMessage;
  String? lastEditDate;
  String? createDate;
  bool isPinned;
  List<Event> events = <Event>[];

  PageInfo({
    this.id,
    this.title = '',
    this.lastMessage = 'No Events. Click to create one.',
    this.lastEditDate,
    this.createDate,
    this.isPinned = false,
    this.events = const [],
    this.icon,
  }) {
    createDate ??= DateTime.now().toString();
  }

  PageInfo copyWith({
    int? id,
    String? title,
    String? lastMessage,
    String? lastEditDate,
    String? createDate,
    bool? isPinned,
    Icon? icon,
    List<Event>? events,
  }) {
    return PageInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastEditDate: lastEditDate ?? this.lastEditDate,
      createDate: createDate ?? this.createDate,
      isPinned: isPinned ?? this.isPinned,
      icon: icon ?? this.icon,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iconIndex': defaultIcons.indexOf(icon!.icon!),
      'title': title,
      'lastMessage': lastMessage,
      'lastEditDate': lastEditDate,
      'createDate': createDate,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  PageInfo.from(PageInfo page)
      : events = page.events,
        lastMessage = page.lastMessage,
        title = page.title,
        lastEditDate = page.lastEditDate,
        createDate = page.createDate,
        isPinned = page.isPinned,
        icon = page.icon;

  List<Event> sortEvents() {
    events.sort((a, b) => a.compareTo(b));
    return events;
  }
}
