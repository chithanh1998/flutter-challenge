import 'dart:convert';

import 'package:base_flutter/screens/notification/model/notification_model.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  Notification notification = Notification();
  List<Data> listNotification = <Data>[];
  List<Data> notificationSearch = <Data>[];
  var isLoading = false.obs;
  var searchMode = false.obs;
  int numberItem = 8;
  int page = 1;
  var canLoadMore = true;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _binding();
    readJson();
  }

  void _binding() {
    searchController.addListener(() {
      searchNotification(searchController.text);
    });
  }

  Future<void> readJson() async {
    isLoading.value = true;
    page = 1;
    final String response =
        await rootBundle.loadString('assets/json/noti.json');
    final data = json.decode(response);
    notification = Notification.fromJson(data);
    var dataNotification = notification.data;
    listNotification.clear();
    if (dataNotification!.length <= numberItem) {
      canLoadMore = false;
      listNotification.addAll(dataNotification);
    } else {
      canLoadMore = true;
      for (int i = 0; i < numberItem; i++) {
        listNotification.add(dataNotification[i]);
      }
    }
    isLoading.value = false;
  }

  void updateReadNotification(String id) {
    var index = notification.data!.indexWhere((e) => e.id == id);
    notification.data![index].status = "read";
    update(['notificationItem']);
  }

  void toggleSearchMode() {
    searchMode.value = !searchMode.value;
    if (searchMode.value) searchNotification("");
  }

  void searchNotification(String input) {
    isLoading.value = true;
    notificationSearch.clear();
    List<Data> notificationList = notification.data ?? [];
    for (Data data in notificationList) {
      String message = data.message!.text ?? "";
      String messageNonAccent = toNonAccentVietnamese(data.message);
      // print(messageNonAccent);
      if (message.contains(input) || messageNonAccent.contains(input)) {
        notificationSearch.add(data);
      }
    }
    isLoading.value = false;
  }

  bool checkReadStatus(Data data) {
    return data.isRead(data);
  }

  String toNonAccentVietnamese(Message? message) {
    return message!.toNonAccentVietnamese(message.text ?? "");
  }

  Future<void> loadMore() async {
    page++;
    var dataNotification = notification.data;
    int maxPage = (dataNotification!.length / numberItem).ceil();
    if (page != maxPage) {
      for (int i = numberItem * (page - 1); i < numberItem * page; i++) {
        listNotification.add(dataNotification[i]);
      }
    } else {
      for (int i = numberItem * (page - 1); i < dataNotification.length; i++) {
        listNotification.add(dataNotification[i]);
      }
      canLoadMore = false;
    }
    update(['notificationList']);
  }
}
