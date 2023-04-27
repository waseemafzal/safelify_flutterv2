import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../utils/global_helpers.dart';

import '../../models/chat.dart';
import '../styles/styles.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatController _chatController = Get.find()..fetchInitialChat();

  GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _messageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            'assets/logo/app_logo.png',
            width: 30.w,
            height: 30.w,
            color: kcPrimaryGradient,
          ),
          iconTheme: IconThemeData(color: kcPrimaryGradient),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Obx(
                () {
                  return _chatController.isLoading.value
                      ? getLoading()
                      : _chatController.chat.value == null || _chatController.chat.value!.messages.length == 0
                          ? Center(
                              child: Text("No Messages Yet."),
                            )
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 70.h),
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: _chatController.chat.value!.messages.length,
                                separatorBuilder: (_, index) => SizedBox(
                                  height: 10.h,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return chatBubble(_chatController.chat.value!.messages.reversed.elementAt(index));
                                },
                              ),
                            );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Form(
                              key: _key,
                              child: TextFormField(
                                validator: (value) => value == null || value.trim().length == 0 ? "Please type something..." : null,
                                cursorColor: kcPrimaryGradient,
                                controller: _messageEditingController,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  suffixIcon: InkWell(
                                    onTap: () async {
                                      if (_key.currentState!.validate() && _chatController.chat.value != null) {
                                        await _chatController.sendMessage(_messageEditingController.text.trim(), _chatController.chat.value!.userId);
                                        _messageEditingController.clear();
                                      }
                                    },
                                    child: Container(
                                      width: 20,
                                      decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(10)),
                                      child: Icon(
                                        Icons.chat_bubble_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  hintText: 'Type here...',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 15.w,
                      // ),
                      // Container(
                      //   width: 45.w,
                      //   height: 45.h,
                      //   decoration: BoxDecoration(color: Colors.greenAccent.shade200, borderRadius: BorderRadius.circular(10)),
                      //   child: Icon(
                      //     Icons.camera_alt_sharp,
                      //     color: Colors.white,
                      //     size: 25,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubble(Message message) {
    return Row(
      mainAxisAlignment: message.isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: message.isOwner ? Colors.grey : kcPrimaryGradient),
          width: Get.width * 0.8,
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Text(
            message.body,
            style: TextStyle(
              letterSpacing: 1.1,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
