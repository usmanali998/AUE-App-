import 'package:aue/model/class_announcement.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/announcements/announcement_detail.dart';
import 'package:aue/pages/tabs_view/courses/class_announcement_detail.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/error_widget.dart';
import 'package:aue/widgets/loadingWidget.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:aue/res/extensions.dart';

class ClassAnnouncementsPage extends StatefulWidget {
  @override
  _ClassAnnouncementsPageState createState() => _ClassAnnouncementsPageState();
}

class _ClassAnnouncementsPageState extends State<ClassAnnouncementsPage> {
  Future<List<ClassAnnouncement>> _classAnnouncementsFuture;

  @override
  void initState() {
    getClassAnnouncements();
    super.initState();
  }

  void getClassAnnouncements() {
    _classAnnouncementsFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    final int sectionId = context.read<AppStateNotifier>().selectedSection.sectionId;
    _classAnnouncementsFuture =
        Repository().getClassAnnouncements(studentId: studentId, sectionId: sectionId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Announcements",
      image: Images.announcements,
      showBackButton: true,
      children: <Widget>[
        FutureBuilder(
          future: _classAnnouncementsFuture,
          builder: (context, AsyncSnapshot<List<ClassAnnouncement>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => getClassAnnouncements(),
              );
            }

            return ListView(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                ...snapshot.data
                    .map<Widget>((classAnnouncement) => AnnouncementTile(
                          classAnnouncement: classAnnouncement,
                          showOffsetLine:
                              snapshot.data.indexOf(classAnnouncement) != snapshot.data.length - 1,
                        ))
                    .toList()
              ],
            );
          },
        ),

        // AnnouncementTile(isActive: true),
        // AnnouncementTile(isActive: true),
        // AnnouncementTile(),
        // AnnouncementTile(),
        // AnnouncementTile(),
        // AnnouncementTile(),
        // AnnouncementTile(showOffsetLine: false),
      ],
    );
  }
}

class AnnouncementTile extends StatelessWidget {
  final ClassAnnouncement classAnnouncement;
  final bool showOffsetLine;
  final bool isActive;

  const AnnouncementTile({
    Key key,
    this.classAnnouncement,
    this.showOffsetLine = true,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool readStatus = !timeago.format(classAnnouncement.actionDate).toLowerCase().contains('now');
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: GestureDetector(
        onTap: () {
          Get.to(ClassAnnouncementDetailPage(classAnnouncement: classAnnouncement,));
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (showOffsetLine)
                    Transform.translate(
                      offset: Offset(3.5, 60),
                      child: Container(
                        width: 2,
                        height: 60,
                        color: Color(0XFFD7DADA).withOpacity(0.7),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: readStatus ? Color(0XFFD7DADA) : AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 20,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        if (!readStatus)
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 16,
                          ),
                        if (readStatus)
                          BoxShadow(
                            color: AppColors.blackGrey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 16,
                          ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              classAnnouncement.postedByName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: DS.setSP(16),
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.blueGrey
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            timeago.format(classAnnouncement.actionDate),
                            style: TextStyle(
                              color: AppColors.blueGrey.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                              fontSize: DS.setSP(12),
                            ),
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          classAnnouncement.message ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.blueGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: DS.setSP(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
