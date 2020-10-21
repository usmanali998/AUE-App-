import 'package:aue/model/class_announcement.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClassAnnouncementDetailPage extends StatelessWidget {
  final ClassAnnouncement classAnnouncement;

  const ClassAnnouncementDetailPage({
    this.classAnnouncement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
              padding: const EdgeInsets.all(20.0).subtract(const EdgeInsets.only(left: 10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: AppColors.primary),
                  Expanded(
                    child: Text(
                      "Announcement",
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 12,
                shadowColor: Colors.black26,
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          timeago.format(classAnnouncement.actionDate),
                          style: TextStyle(
                            fontSize: DS.setSP(13),
                            color: const Color(0x9a77869e),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          width: DS.setSP(100),
                          height: DS.setSP(110),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              Images.personPlaceholder,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SingleChildScrollView(
                        child: Text(
                          classAnnouncement?.postedByName ?? "",
                          style: TextStyle(
                            fontSize: DS.setSP(20),
                            color: const Color(0xff042c5c),
                            letterSpacing: 0.4,
                            height: 1.5,
                            fontWeight: FontWeight.w700
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        classAnnouncement?.message ?? "",
                        style: TextStyle(
                          fontSize: DS.setSP(13.5),
                          color: const Color(0xff77869e),
                          letterSpacing: 0.11,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return SecondaryBackgroundWidget(
      title: "Announcement",
      image: Images.announcements,
      children: <Widget>[
        Material(
          elevation: 12,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    timeago.format(classAnnouncement.actionDate),
                    style: TextStyle(
                      fontSize: DS.setSP(13),
                      color: const Color(0x9a77869e),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  width: DS.setSP(100),
                  height: DS.setSP(110),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      Images.personPlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  child: Text(
                    classAnnouncement?.postedByName ?? "",
                    style: TextStyle(
                      fontSize: DS.setSP(18),
                      color: const Color(0xff042c5c),
                      letterSpacing: 0.4,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  classAnnouncement?.message ?? "",
                  style: TextStyle(
                    fontSize: DS.setSP(12),
                    color: const Color(0xff77869e),
                    letterSpacing: 0.11,
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        )
      ],
    );
  }
}
