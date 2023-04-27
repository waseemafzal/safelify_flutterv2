import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'popUp.dart';
import '../widgets/app_bar.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/comments_controller.dart';
import '../../controllers/notifications_controller.dart';
import '../../controllers/report_controller.dart';
import '../../models/notification.dart' as sfN;
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  NotificationsController _notificationsController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationsController.fechNotifications();
  }

  RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: getAppBar(
          context: context,
          title: Text(
            "Notifications",
            style: TextStyle(color: Colors.black87),
          ),
          iconColor: kcPrimaryGradient,
        ),
        body: Obx(() {
          return _notificationsController.isLoading == true
              ? getLoading()
              : SmartRefresher(
                  enablePullDown: true,
                  onRefresh: () {
                    _notificationsController.fechNotifications();
                  },
                  controller: _refreshController,
                  child: ListView.separated(
                      padding: EdgeInsets.all(kdPadding - 10),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _notificationsController.notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == _notificationsController.notifications.length) {
                          return Column(
                            children: [
                              NotificationCard(report: _notificationsController.notifications[index]),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(11)),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Add",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }

                        return NotificationCard(report: _notificationsController.notifications[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5.h);
                      }),
                );
        }),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  NotificationCard({
    Key? key,
    required this.report,
  }) : super(key: key);

  final sfN.Notification report;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return MightyPopupDialogue(content: [
                    Padding(
                      padding: EdgeInsets.all(kdPadding),
                      child: Text(widget.report.body),
                    )
                  ]);
                });
          },
          child: Row(
            children: [
              Icon(Icons.notifications),
              SizedBox(width: 10.w),
              Expanded(
                  child: Text(
                widget.report.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
