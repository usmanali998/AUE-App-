import 'package:aue/pages/tabs_view/announcements/announcement_detail.dart';
import 'package:flutter/material.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:get/get.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Chats",
      image: Images.chat,
      showBackButton: false,
      children: <Widget>
      [
        ChatTile(isActive: true),
        ChatTile(isActive: true),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
        ChatTile(),
      ],
    );
  }
}

class ChatTile extends StatelessWidget {
  final bool isActive;
  const ChatTile({
    Key key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          // Get.to(AnnouncementDetailPage());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 16,
                ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(Images.girl),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "My Grades",
                  style: TextStyle(
                    fontSize: DS.setSP(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Now",
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Check your academic performance",
                      style: TextStyle(
                        color: AppColors.blueGrey.withOpacity(0.6),
                        fontWeight: FontWeight.w300,
                        fontSize: DS.setSP(14),
                      ),
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "8",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: DS.setSP(17),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
