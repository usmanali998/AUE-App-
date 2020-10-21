import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:aue/model/announcement.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetailPage({
    Key key,
    @required this.announcement,
  }) : super(key: key);
  @override
  _AnnouncementDetailPageState createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Announcement",
      image: Images.announcements,
      showBackButton: false,
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
                    timeago.format(widget.announcement.dateCreated),
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
                    widget?.announcement?.subject ?? "",
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
                  widget?.announcement?.body ?? "",
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
