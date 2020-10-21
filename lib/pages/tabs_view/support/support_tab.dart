import 'dart:convert';

import 'package:aue/model/video_tutorial.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/contacts/contacts_tab.dart';
import 'package:aue/res/images.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:aue/res/res.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportTab extends StatefulWidget {
  @override
  _SupportTabState createState() => _SupportTabState();
}

class _SupportTabState extends State<SupportTab> {
  Future<List<VideoTutorial>> _videoTutorialFuture;

  void getVideoTutorials() {
    _videoTutorialFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _videoTutorialFuture = Repository().getVideoTutorials(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getVideoTutorials();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Support',
      image: Images.chat,
      showBackButton: false,
      children: [
        FutureBuilder<List<VideoTutorial>>(
          future: _videoTutorialFuture,
          builder: (BuildContext context, AsyncSnapshot<List<VideoTutorial>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getVideoTutorials(),
              );
            }
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoTutorialCard(
                  videoTutorial: snapshot.data[index],
                );
              },
            );
          },
        ),
        SizedBox(
          child: FlatButton(
            onPressed: () {
              Get.to(ContactsTab());
            },
            padding: const EdgeInsets.all(16.0),
            color: AppColors.primaryLight,
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(8.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.whatsApp,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6.0),
                const Text(
                  'Contact us',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: DS.height * 0.02),
      ],
    );
  }
}

class VideoTutorialCard extends StatelessWidget {
  final VideoTutorial videoTutorial;

  const VideoTutorialCard({@required this.videoTutorial});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(this.videoTutorial.link)) {
          await launch(this.videoTutorial.link);
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 4.0,
        shadowColor: Colors.black45,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        margin: const EdgeInsets.only(bottom: 15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(12.0),
                  ),
                  child: Image.memory(
                    base64Decode(this.videoTutorial.thumbnail),
                  ),
                ),
              ),
              SizedBox(width: DS.width * 0.04),
              Expanded(
                flex: 2,
                child: AutoSizeText(
                  this.videoTutorial.title,
                  style: const TextStyle(
                    color: AppColors.blackGrey,
                    fontSize: 14.50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.play_circle_filled,
                color: AppColors.primary,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
