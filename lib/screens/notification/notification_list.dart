import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/screens/notification/model/notification_model.dart';
import 'package:base_flutter/screens/notification/notification_controller.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:base_flutter/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationList extends GetView<NotificationController> {
  final List<Data>? notificationData;

  NotificationList({Key? key, required this.notificationData})
      : super(key: key);

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        id: 'notificationList',
        builder: (controller) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: () async {
              await controller.readJson();
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              await Future.delayed(const Duration(milliseconds: 1000));
              await controller.loadMore();
              _refreshController.loadComplete();
            },
            enablePullDown: !controller.searchMode.value,
            enablePullUp:
                controller.canLoadMore && !controller.searchMode.value,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text(LocaleKeys.notification_pull_up_load.tr);
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text(LocaleKeys.notification_load_fail.tr);
                } else if (mode == LoadStatus.canLoading) {
                  body = Text(LocaleKeys.notification_release_to_load.tr);
                } else {
                  body = Text(LocaleKeys.notification_no_more_data.tr);
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: notificationData!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    child: GetBuilder<NotificationController>(
                      id: 'notificationItem',
                      builder: (controller) => ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        onTap: () {
                          controller.updateReadNotification(
                              notificationData![index].id ?? "");
                        },
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: ClipOval(
                                  child: Image.network(
                                      '${notificationData![index].imageThumb}')),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Image.network(
                                        '${notificationData![index].icon}')))
                          ],
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: _NotificationContentText(
                            data: notificationData![index],
                          ),
                        ),
                        subtitle: Text(
                            Utils.dateTimeString(
                                millisecondsSinceEpoch:
                                    notificationData![index].createdAt! * 1000,
                                format: 'dd/MM/yyyy hh:mm'),
                            style: textStyle(GPTypography.body12)!
                                .mergeColor(GPColor.gray50)),
                        tileColor:
                            controller.checkReadStatus(notificationData![index])
                                ? Colors.white
                                : GPColor.unreadNotification,
                      ),
                    ),
                  );
                }),
          );
        });
  }
}

class _NotificationContentText extends StatelessWidget {
  final Data data;
  const _NotificationContentText({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: getContent()));
  }

  List<TextSpan> getContent() {
    List<TextSpan> text = [];
    String str = data.message!.text ?? "";
    var highlightList = data.message!.highlights ?? [];
    for (int i = 0; i < highlightList.length; i++) {
      var start = highlightList[i].offset ?? 0;
      var end = highlightList[i].offset! + (highlightList[i].length ?? 0);
      final boldString = data.message!.text!.substring(start, end);
      final boldText = TextSpan(
          text: boldString,
          style:
              textStyle(GPTypography.body14)!.mergeFontWeight(FontWeight.w700));
      text.add(boldText);

      start = end;
      if (i + 1 < highlightList.length) {
        end = highlightList[i + 1].offset ?? 0;
      } else {
        end = str.length;
      }
      final normalString = data.message!.text!.substring(start, end);
      final normalText =
          TextSpan(text: normalString, style: textStyle(GPTypography.body14)!);
      text.add(normalText);
    }
    return text;
  }
}
