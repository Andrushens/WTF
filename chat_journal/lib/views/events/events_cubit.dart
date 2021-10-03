import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/page_info.dart';
import '../../utils/data.dart';
import '../../utils/database_provider.dart';
import '../home/home_cubit.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final Category _defaultCategory =
      const Category(icon: Icons.bubble_chart, title: '');

  EventsCubit() : super(EventsState());

  void init(PageInfo page) async {
    final events = await DatabaseProvider.fetchEvents(page.id!);
    page = page.copyWith(events: events);
    emit(
      state.copyWith(
        pageId: page.id,
        page: page,
        categories:
            state.categories.isEmpty ? initCategories : state.categories,
        selectedCategory: _defaultCategory,
        showEvents: events,
      ),
    );
  }

  void changeEditMode(bool isEditMode) {
    emit(state.copyWith(isEditMode: isEditMode));
  }

  void updateSearchQuery(String query) {
    final showEvents = state.page!.events
        .where(
          (event) =>
              event.message != null &&
              event.message!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    emit(state.copyWith(showEvents: showEvents));
  }

  void changeSearchMode(bool isSearchMode) {
    if (!isSearchMode) {
      emit(state.copyWith(showEvents: state.page!.events));
    } else {
      updateSearchQuery('');
    }
    emit(state.copyWith(isSearchMode: isSearchMode));
  }

  void changeCategory(Category category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void changeReplyPage(PageInfo page, int index) {
    emit(state.copyWith(
      replyPage: page,
      replyPageIndex: index,
    ));
  }

  void initDefaultCategory() {
    emit(state.copyWith(selectedCategory: _defaultCategory));
  }

  void changeIsMessageEdit(bool isMessageEdit) {
    emit(state.copyWith(isMessageEdit: isMessageEdit));
  }

  void unselectEvents() {
    emit(state.copyWith(selectedEvents: []));
  }

  void changeBookmarkedOnly() {
    if (state.isBookmarkedOnly) {
      emit(state.copyWith(
        showEvents: state.page!.events,
        isBookmarkedOnly: false,
      ));
    } else {
      final showEvents =
          state.page!.events.where((event) => event.isBookmarked).toList();
      emit(state.copyWith(
        showEvents: showEvents,
        isBookmarkedOnly: true,
      ));
    }
  }

  void selectEvent(int index) {
    var updatedSelectedEvents = List<int>.from(state.selectedEvents);
    if (state.selectedEvents.contains(index)) {
      updatedSelectedEvents.remove(index);
      if (updatedSelectedEvents.isEmpty) {
        changeEditMode(false);
      }
    } else {
      updatedSelectedEvents.add(index);
    }
    emit(state.copyWith(selectedEvents: updatedSelectedEvents));
  }

  void replyEvents(BuildContext context) {
    final page = state.replyPage;
    var eventsToReply = <Event>[];
    for (var i in state.selectedEvents) {
      eventsToReply.add(state.showEvents[i]);
    }
    deleteEvent();
    context.read<HomeCubit>().addEvents(eventsToReply, page!);
  }

  void copyEvent() {
    final message = state.showEvents[state.selectedEvents[0]].message;
    if (message != null) {
      Clipboard.setData(ClipboardData(text: message));
    }
    changeEditMode(false);
    unselectEvents();
  }

  void bookMarkEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    var updatedPage = PageInfo.from(state.page!);
    for (var index in selectedEvents) {
      updatedPage.events[index].isBookmarked =
          updatedPage.events[index].isBookmarked ? false : true;
      DatabaseProvider.updateEvent(updatedPage.events[index]);
    }
    changeEditMode(false);
    unselectEvents();
  }

  void deleteEvent() {
    var selectedEvents = List<int>.from(state.selectedEvents)..sort();
    for (var i = selectedEvents.length - 1; i >= 0; i--) {
      DatabaseProvider.deleteEvent(state.page!.events[selectedEvents[i]]);
      state.showEvents.remove(state.page!.events[selectedEvents[i]]);
    }
    changeEditMode(false);
    unselectEvents();
  }

  Future<void> addImageEvent() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final event = Event(imagePath: imageFile.path, pageId: state.pageId);
      state.page!.events.insert(0, event);
      DatabaseProvider.insertEvent(event);
      final s = state;
      emit(state.copyWith(
        showEvents: state.page!.events,
        isBookmarkedOnly: false,
      ));
      print(s == state);
    }
  }

  void addMessageEvent(String text) {
    if (state.selectedEvents.length == 1 && state.isMessageEdit) {
      if (text.isNotEmpty) {
        updateEvent(text);
      }
      emit(state.copyWith(selectedEvents: []));
    } else if (text.isNotEmpty) {
      final event = Event(message: text, pageId: state.pageId);
      if (state.selectedCategory != _defaultCategory) {
        event.category = state.selectedCategory;
        initDefaultCategory();
      }
      DatabaseProvider.insertEvent(event);
      state.page!.events.insert(0, event);
    }
    emit(state.copyWith(
      showEvents: state.page!.events,
      isBookmarkedOnly: false,
    ));
  }

  void updateEvent(String text) {
    final event = state.showEvents[state.selectedEvents[0]];
    event.message = text;
    if (state.selectedCategory != _defaultCategory) {
      event.category = state.selectedCategory;
      initDefaultCategory();
    }
    event.updateSendTime();
    state.page!.events[state.selectedEvents[0]] = event;
    DatabaseProvider.updateEvent(event);
  }
}
