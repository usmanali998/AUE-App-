import 'dart:convert';

import 'package:aue/model/discussion_reply_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassDiscussionReplies extends StatefulWidget {
  @override
  _ClassDiscussionRepliesState createState() => _ClassDiscussionRepliesState();
}

class _ClassDiscussionRepliesState extends State<ClassDiscussionReplies> {
  Future<DiscussionReplyModel> repliesFuture;
  List<Widget> replies = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getReplies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getReplies() {
    repliesFuture = null;
    final discussionId = context.read<AppStateNotifier>().selectedDiscussion.id;
    repliesFuture = Repository().getDiscussionsReplies(discussionId);
    if (mounted) setState(() {});
  }

  addReply() async {
    if (controller.text.isEmpty) return;
    final discussionId = context.read<AppStateNotifier>().selectedDiscussion.id;
    final user = context.read<AuthNotifier>().user;

    await Repository()
        .addDiscussionReply(discussionId, controller.text, user.studentID);

    ReplyModel replyModel =
        ReplyModel(controller.text, user.fullName, DateTime.now(), '');

    replies.add(SentWidget(replyModel: replyModel));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final classDiscussionModel = context.select(
        (AppStateNotifier stateNotifier) => stateNotifier.selectedDiscussion);

    final user =
        context.select((AuthNotifier authNotifier) => authNotifier.user);

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 44.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: AppColors.primary),
                Expanded(
                  child: Text(
                    "Class Discussion",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(20),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
                right: 24.0, left: 24.0, bottom: 26.0, top: 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                    bottom: 14.0,
                    left: 22.0,
                    right: 14.0,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        overflow: Overflow.visible,
                        children: [
                          Container(
                            height: 42.0,
                            width: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: MemoryImage(
                                  base64Decode(
                                      classDiscussionModel.imageThumbnail),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2.0,
                            right: -2.0,
                            child: Container(
                              height: 11.0,
                              width: 11.0,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 14.0),
                      Expanded(
                        child: Text(
                          '${classDiscussionModel.discussionTitle}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: DS.setSP(16),
                          ),
                        ),
                      ),
                      Text(
                        '${classDiscussionModel.datePosted.day}-${classDiscussionModel.datePosted.month}-${classDiscussionModel.datePosted.year}',
                        style: TextStyle(
                          color: AppColors.blueGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: DS.setSP(13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.blueGrey.withOpacity(0.6),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 11.5,
                    bottom: 10.5,
                    left: 22.0,
                    right: 14.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${classDiscussionModel.discussionContent}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.blueGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: DS.setSP(13),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ImageIcon(
                        AssetImage(Images.star),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: repliesFuture,
              builder: (context, AsyncSnapshot<DiscussionReplyModel> snapshot) {
                if (snapshot.isLoading) {
                  return LoadingWidget();
                }

                if (snapshot.hasError && snapshot.error != null) {
                  return CustomErrorWidget(
                    err: snapshot.error,
                    onRetryTap: () => getReplies(),
                  );
                }

                replies.addAll(snapshot.data.replies
                    .map((e) => e.studentName == user.fullName
                        ? SentWidget(replyModel: e)
                        : ReceivedWidget(replyModel: e))
                    .toList());

                return ListView(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: replies,
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 11.0, vertical: 14.0),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(Images.emoji),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: AppColors.blackGrey,
                      fontSize: DS.setSP(17),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0.0),
                      hintText: 'Type here...',
                      hintStyle: TextStyle(
                        color: AppColors.blackGrey,
                        fontSize: DS.setSP(17),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Container(
                  height: 24.0,
                  width: 0.5,
                  color: Color(0xFFADADAD),
                ),
                SizedBox(width: 24.0),
                Icon(
                  Icons.add,
                  color: Color(0xFF8C8C8C),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () => addReply(),
                  child: ImageIcon(
                    AssetImage(Images.send),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SentWidget extends StatelessWidget {
  final ReplyModel replyModel;

  const SentWidget({Key key, @required this.replyModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 24.0),
          Text(
            '${DateFormat.jm().format(replyModel.datePosted)}',
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w300,
              fontSize: DS.setSP(13),
            ),
          ),
          SizedBox(width: 14.0),
          ImageIcon(
            AssetImage(Images.sentSeen),
            color: AppColors.primary,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 24.0, left: 4.0, top: 0.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      bottom: 8.0,
                      left: 6.0,
                      right: 14.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(replyModel.imageThumbnail),
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -2.0,
                              right: -2.0,
                              child: Container(
                                height: 11.0,
                                width: 11.0,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            '${replyModel.studentName}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: DS.setSP(13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 11.5,
                      bottom: 10.5,
                      left: 6.0,
                      right: 14.0,
                    ),
                    child: Text(
                      '${replyModel.replyText}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: DS.setSP(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedWidget extends StatelessWidget {
  final ReplyModel replyModel;

  const ReceivedWidget({Key key, @required this.replyModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17.0,
        left: 24.0,
        right: 24.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                '${replyModel.replyText}',
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: DS.setSP(16),
                ),
              ),
            ),
          ),
          SizedBox(width: 11.0),
          Text(
            '${DateFormat.jm().format(replyModel.datePosted)}',
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w300,
              fontSize: DS.setSP(13),
            ),
          ),
        ],
      ),
    );
  }
}
