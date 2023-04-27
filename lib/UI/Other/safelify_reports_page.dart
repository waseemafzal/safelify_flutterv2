import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:safe_lify/UI/widgets/mighty_button.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/comments_controller.dart';
import '../../controllers/report_controller.dart';
import '../../models/get_community_reports_model.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/migty_filter_field.dart';
import 'popUp.dart';

class SafeLifyReports extends StatefulWidget {
  const SafeLifyReports({Key? key}) : super(key: key);

  @override
  State<SafeLifyReports> createState() => _SafeLifyReportsState();
}

class _SafeLifyReportsState extends State<SafeLifyReports> {
  ReportController _reportController = Get.find()..fetchReportCategories();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reportController.fetchCommunityReports(loadMine: _shouldShowOnlyMyPosts.value, catId: _selectedCategory.value, city: _selectedCity.value);
  }

  RefreshController _refreshController = RefreshController();

  RxString selectedFilterCity = ''.obs;
  AuthController _authController = Get.find();
  RxBool _shouldShowOnlyMyPosts = false.obs;

  RxBool _shouldShowFilters = false.obs;

  RxString _selectedCategory = ''.obs;
  RxString _selectedCity = ''.obs;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cities = [
      ..._authController.user.value!.cities.map((e) => {
            'label': e,
            'value': e,
          })
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Safelify Reports",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: Colors.red),
          ),
          actions: [
            InkWell(
              onTap: () {
                _shouldShowFilters.value = !_shouldShowFilters.value;
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: kcPrimaryGradient),
                ),
                child: Row(
                  children: [
                    Text(
                      "Filters",
                      style: TextStyle(color: kcPrimaryGradient),
                    ),
                    Obx(() {
                      return Icon(!_shouldShowFilters.value ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_outlined, color: kcPrimaryGradient);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(() {
                return !_shouldShowFilters.value
                    ? SizedBox()
                    : Container(
                        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 6.0, offset: Offset(0.0, 0.40))]),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Obx(() {
                                return MightyFilterField(
                                  labelText: 'Filter By Cities',
                                  hintText: "Select City",
                                  initialValue: _selectedCity.value,
                                  items: cities,
                                  // enableInteractiveSelection: true,
                                  // changeIcon: true,

                                  // expands: true,
                                  onChanged: (value) {
                                    _selectedCity.value = value;
                                    _reportController.fetchCommunityReports(catId: _selectedCategory.value, city: _selectedCity.value);
                                  },
                                );
                              }),

                              Obx(() {
                                return MightyFilterField(
                                  initialValue: _selectedCategory.value,
                                  labelText: 'Filter By Category',
                                  hintText: "Select Category",
                                  items: [
                                    ..._reportController.categories.map((e) => {
                                          'label': e.category,
                                          'value': e.id,
                                        })
                                  ],
                                  onChanged: (value) {
                                    _selectedCategory.value = value;
                                    _reportController.fetchCommunityReports(catId: _selectedCategory.value, city: _selectedCity.value);
                                  },
                                );
                              }),
                              Row(
                                children: [
                                  Obx(() {
                                    return Checkbox(
                                      value: _shouldShowOnlyMyPosts.value,
                                      fillColor: MaterialStateProperty.resolveWith((states) => kcPrimaryGradient),
                                      onChanged: (value) {
                                        _shouldShowOnlyMyPosts.value = !_shouldShowOnlyMyPosts.value;
                                        _reportController.fetchCommunityReports(loadMine: _shouldShowOnlyMyPosts.value, catId: _selectedCategory.value, city: _selectedCity.value);
                                      },
                                    );
                                  }),
                                  Text("Show reports posted by me")
                                ],
                              ),
                              SizedBox(height: kdPadding - 15),
                              MightyButton(
                                  text: "Clear Filters",
                                  onTap: () {
                                    _selectedCategory.value = '';
                                    _selectedCity.value = '';
                                    _shouldShowOnlyMyPosts.value = false;
                                    _shouldShowFilters.value = false;
                                    _reportController.fetchCommunityReports(loadMine: _shouldShowOnlyMyPosts.value, catId: _selectedCategory.value, city: _selectedCity.value);
                                  }),
                              SizedBox(height: kdPadding - 15),

                              // SizedBox(
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Expanded(
                              //         child: Obx(() {
                              //           return PopupMenuButton(
                              //             child: Chip(
                              //               padding: EdgeInsets.symmetric(horizontal: 30),
                              //               label: Text(
                              //                 selectedFilterCity.value.length > 0 ? selectedFilterCity.value : "Cities",
                              //                 style: TextStyle(fontSize: 14.sp),
                              //               ),
                              //             ),
                              //             itemBuilder: (context) {
                              //               return _authController.user.value!.cities
                              //                   .map(
                              //                     (e) => PopupMenuItem(
                              //                       child: Text(e),
                              //                       onTap: () {
                              //                         if (selectedFilterCity.value == e) {
                              //                           selectedFilterCity.value = '';
                              //                           _reportController.fetchCommunityReports();
                              //                           return;
                              //                         }
                              //                         selectedFilterCity.value = e;

                              //                         _reportController.fetchCommunityReports(
                              //                           city: selectedFilterCity.value,
                              //                           loadMine: isMyPostSelected.value,
                              //                         );
                              //                       },
                              //                     ),
                              //                   )
                              //                   .toList();
                              //             },
                              //           );
                              //         }),
                              //       ),
                              //       Expanded(
                              //         child: Obx(() {
                              //           return GestureDetector(
                              //             onTap: () {
                              //               isMyPostSelected.value = !isMyPostSelected.value;
                              //               _reportController.fetchCommunityReports(loadMine: isMyPostSelected.value);
                              //             },
                              //             child: Chip(
                              //               backgroundColor: isMyPostSelected.value ? kcPrimaryGradient : null,
                              //               padding: EdgeInsets.symmetric(horizontal: 30),
                              //               label: Text(
                              //                 "My Posts",
                              //                 style: TextStyle(fontSize: 14.sp, color: isMyPostSelected.value ? Colors.white : null),
                              //               ),
                              //             ),
                              //           );
                              //         }),
                              //       )
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      );
              }),
              Container(
                  height: 620.h,
                  child: Obx(() {
                    return _reportController.isLoading.value
                        ? getLoading()
                        : _reportController.communityReports.length == 0
                            ? Column(
                                children: [
                                  SizedBox(height: 120),
                                  Image.asset(
                                    'assets/images/empty.png',
                                    width: 120,
                                  ),
                                  SizedBox(height: kdPadding),
                                  Text("No reports found."),
                                ],
                              )
                            : SmartRefresher(
                                enablePullDown: true,
                                onRefresh: () {
                                  _reportController.fetchCommunityReports(loadMine: _shouldShowOnlyMyPosts.value, catId: _selectedCategory.value, city: _selectedCity.value);
                                },
                                controller: _refreshController,
                                child: ListView.builder(
                                    padding: EdgeInsets.all(kdPadding - 10),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: _reportController.communityReports.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index == _reportController.communityReports.length) {
                                        return Column(
                                          children: [
                                            CommunityPostCard(report: _reportController.communityReports[index]),
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

                                      return CommunityPostCard(report: _reportController.communityReports[index]);
                                    }),
                              );
                  })),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityPostCard extends StatefulWidget {
  CommunityPostCard({
    Key? key,
    required this.report,
  }) : super(key: key);

  final CommunityReport report;

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  final CommentsController _commentsController = Get.find();
  final ReportController _reportController = Get.find();

  final AuthController _authController = Get.find();

  Future<String?> renderThumbnail(CommunityReport report) async {
    String? fileName = await VideoThumbnail.thumbnailFile(
      video: "${report.file}",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 80,
    );
    printApiResponse("File name  :: ${fileName ?? ''}");
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.report.file.trim().length == 0
                ? Container()
                : FutureBuilder(
                    future: renderThumbnail(widget.report),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return Container();
                      if (!snapshot.hasData) {
                        return Container(
                          height: 130.h,
                          width: 130.w,
                          child: getLoading(),
                        );
                      }

                      return InkWell(
                        onTap: () async {
                          VideoPlayerController videoPlayerController = VideoPlayerController.network(widget.report.file);
                          FlickManager manager = FlickManager(videoPlayerController: videoPlayerController, autoInitialize: true, autoPlay: true);
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return MightyPopupDialogue(
                                content: [
                                  FlickVideoPlayer(flickManager: manager),
                                ],
                              );
                            },
                          );
                          manager.dispose();
                          videoPlayerController.dispose();
                        },
                        child: Container(
                          height: 130.h,
                          width: 130.w,
                          child: Stack(
                            children: [
                              Image.file(
                                File(snapshot.data!.toString()),
                                fit: BoxFit.cover,
                                height: 150.h,
                                width: 150.w,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: Icon(Icons.play_arrow),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.report.name}",
                          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${widget.report.createdOn}",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 8.sp, color: Colors.black),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => MightyPopupDialogue(
                          content: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Text(
                                "Report",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              child: Text("${widget.report.title}"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      "${widget.report.title}",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _showCommentDialogue,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/chat.png',
                          height: 12.h,
                          width: 12.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "${widget.report.commentCount ?? 0}",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        GestureDetector(
                          onTap: () => FlutterShare.share(title: 'Community Post', text: """${widget.report.title}\n${widget.report.file}\n\n${_authController.user.value!.shareMessage}"""),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/share.png',
                                height: 12.h,
                                width: 12.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Share",
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Obx(() {
              return _commentsController.comments.length != null
                  ? PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            enabled: !_reportController.isCorroborating.value,
                            onTap: () {
                              _reportController.corroborate(id: widget.report.id!, status: "Flag");
                            },
                            child: Row(
                              children: [
                                Icon(Icons.flag_outlined),
                                SizedBox(width: 10.w),
                                Text("Flag as inappropriate"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            enabled: !_reportController.isCorroborating.value,
                            onTap: () {
                              _reportController.corroborate(id: widget.report.id!, status: "Corroborate");
                            },
                            child: Row(
                              children: [
                                Icon(Icons.check_outlined),
                                SizedBox(width: 10.w),
                                Text("Corroborate"),
                              ],
                            ),
                          ),
                        ];
                      },
                    )
                  : SizedBox();
            })
          ],
        ),
      ),
    );
  }

  _showCommentDialogue() async {
    _commentsController.getComments(widget.report.id);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Obx(() {
            return _commentsController.isLoading.value
                ? getLoading()
                : StatefulBuilder(builder: (context, setState) {
                    final TextEditingController commentEditingController = TextEditingController();
                    String? commentId;

                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        height: 360.h,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
                          child: Column(
                            children: [
                              Container(
                                height: 270.h,
                                // width: 270.w,
                                child: _commentsController.comments.isEmpty
                                    ? Center(child: Text('No Comments Found'))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: _commentsController.comments.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return _commentsController.isLoading == true
                                              ? getLoading()
                                              : Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
                                                  child: Container(
                                                    // width: 300.w,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: kcBackGroundGradient)),
                                                    child: ListTile(
                                                      dense: true,
                                                      trailing: _commentsController.comments[index].userId == _authController.user.value!.userId
                                                          ? Container(
                                                              height: 30,
                                                              width: 50,
                                                              child: Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _commentsController.deleteComments(_commentsController.comments.removeAt(index).id);
                                                                    },
                                                                    child: Icon(Icons.delete_forever, size: 15.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      commentEditingController.text = _commentsController.comments[index].body ?? '';
                                                                      commentId = _commentsController.comments[index].id;
                                                                    },
                                                                    child: Icon(
                                                                      Icons.edit,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : null,
                                                      title: Text(
                                                        '${_commentsController.comments[index].name}',
                                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                      ),
                                                      subtitle: Text('${_commentsController.comments[index].body}'),
                                                    ),
                                                  ),
                                                );
                                        },
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: commentEditingController,
                                  keyboardType: TextInputType.multiline,
                                  // maxLines: 4,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (commentId == null) {
                                          await _commentsController.addComments(commentEditingController.text, widget.report.id);
                                          await _commentsController.getComments(widget.report.id);
                                          commentEditingController.clear();
                                        } else {
                                          await _commentsController.updateComments(id: commentId!, body: commentEditingController.text);
                                          commentEditingController.clear();
                                        }
                                      },
                                      icon: Icon(Icons.send),
                                    ),
                                    hintText: "Comment",
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                      borderRadius: BorderRadius.circular(kdBorderRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                      borderRadius: BorderRadius.circular(kdBorderRadius),
                                    ),
                                    focusColor: kcPrimaryGradient,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
          });
        });
  }
}
