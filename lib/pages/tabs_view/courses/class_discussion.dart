import 'package:aue/model/class_discussion_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/pages/tabs_view/courses/class_discussion_replies.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/class_discussion_card.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClassDiscussionPage extends StatefulWidget {
  @override
  _ClassDiscussionPageState createState() => _ClassDiscussionPageState();
}

class _ClassDiscussionPageState extends State<ClassDiscussionPage> {
  Future<List<ClassDiscussionModel>> discussionsFuture;

  @override
  void initState() {
    super.initState();
    getDiscussions();
  }

  getDiscussions() {
    discussionsFuture = null;
    final sectionId = context.read<AppStateNotifier>().selectedSection.sectionId;
    discussionsFuture = Repository().getDiscussions(sectionId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: FutureBuilder(
              future: discussionsFuture,
              builder: (context, AsyncSnapshot<List<ClassDiscussionModel>> snapshot) {
                if (snapshot.isLoading) {
                  return LoadingWidget();
                }

                if (snapshot.hasError && snapshot.error != null) {
                  return CustomErrorWidget(
                    err: snapshot.error,
                    onRetryTap: () => getDiscussions(),
                  );
                }

                return ListView(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ...snapshot.data
                        .map<Widget>(
                          (d) => GestureDetector(
                            onTap: () async {
                              context.read<AppStateNotifier>().selectedDiscussion = d;
                              await Get.to(ClassDiscussionReplies());
                              context.read<AppStateNotifier>().selectedDiscussion = null;
                            },
                            child: ClassDiscussionCard(classDiscussionModel: d),
                          ),
                        )
                        .toList()
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
