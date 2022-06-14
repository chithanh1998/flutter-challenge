import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/screens/notification/model/notification_model.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_controller.dart';
import 'notification_list.dart';

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<Data>? data;
                  if (controller.searchMode.value) {
                    data = controller.notificationSearch;
                  } else {
                    data = controller.listNotification;
                  }
                  return NotificationList(
                    notificationData: data,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends GetView<NotificationController> {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 15, 12, 5),
        child: Obx(() {
          if (controller.searchMode.value) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: controller.toggleSearchMode,
                    child:
                        const Icon(Icons.close, color: GPColor.contentPrimary)),
                const Expanded(child: _SearchInput())
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.notification_title.tr,
                  style: textStyle(GPTypography.heading),
                ),
                InkWell(
                    onTap: controller.toggleSearchMode,
                    child:
                        const Icon(Icons.search, color: GPColor.contentPrimary))
              ],
            );
          }
        }));
  }
}

class _SearchInput extends GetView<NotificationController> {
  const _SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 32,
      decoration: BoxDecoration(
        color: GPColor.inputBackground,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextField(
        controller: controller.searchController,
        style: const TextStyle(fontSize: 16, height: 19 / 16),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              controller.searchController.clear();
            },
            icon: Container(
                decoration: BoxDecoration(
                    color: GPColor.gray50,
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: GPColor.inputBackground,
                )),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          hintText: LocaleKeys.notification_search.tr,
          hintStyle: const TextStyle(fontSize: 16, height: 19 / 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 5),
          prefixIcon: const Icon(Icons.search, color: GPColor.contentPrimary),
        ),
      ),
    );
  }
}
