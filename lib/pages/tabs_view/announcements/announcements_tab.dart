import 'package:aue/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:aue/model/announcement.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/announcements/announcement_detail.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class AnnouncementsTab extends StatefulWidget {
  @override
  _AnnouncementsTabState createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  Future<List<Announcement>> announcementsFuture;
  @override
  void initState() {
    getAnnouncements();
    super.initState();
  }

  void getAnnouncements() {
    announcementsFuture = null;
    final user = context.read<AuthNotifier>().user;
    announcementsFuture = Repository().getStudentAnnouncements(user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Announcements",
      image: Images.announcements,
      showBackButton: false,
      children: <Widget>[
        FutureBuilder(
          future: announcementsFuture,
          builder: (context, AsyncSnapshot<List<Announcement>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => getAnnouncements(),
              );
            }

            return ListView(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                ...snapshot.data
                    .map<Widget>((announcement) => AnnouncementTile(
                          announcement: announcement,
                          showOffsetLine: snapshot.data.indexOf(announcement) !=
                              snapshot.data.length - 1,
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
  final Announcement announcement;
  final bool showOffsetLine;
  final bool isActive;
  const AnnouncementTile({
    Key key,
    this.announcement,
    this.showOffsetLine = true,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: GestureDetector(
        onTap: () {
          Get.to(AnnouncementDetailPage(announcement: announcement));
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
                      color: announcement.readStatus
                          ? Color(0XFFD7DADA)
                          : AppColors.primary,
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
                        if (!announcement.readStatus)
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 16,
                          ),
                        if (announcement.readStatus)
                          BoxShadow(
                            color: AppColors.blackGrey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 16,
                          ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      // leading: Visibility(
                      //   visible: false,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(8),
                      //     child: Image.asset(Images.girl),
                      //   ),
                      // ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              announcement.subject,
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
                            timeago.format(announcement.dateCreated),
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
                          announcement.body ?? "",
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
