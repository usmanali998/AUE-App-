import 'package:aue/pages/tabs_view/services/attendance_excuse/attendance_excuse_history.dart';
import 'package:aue/pages/tabs_view/services/grants/applicable_grants.dart';
import 'package:aue/pages/tabs_view/services/grievance/grievance_page.dart';
import 'package:aue/pages/tabs_view/services/request_letter/request_letter_page.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesTab extends StatefulWidget {
  @override
  _ServicesTabState createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Services',
      image: Images.services,
      showBackButton: false,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Student Services",
              style: TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SecondaryTile(
              text: 'Request Letter',
              icon: Images.request_letter,
              isImageAsset: true,
              showTrailing: true,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: DS.setSP(16),
              ),
              onTap: () {
                Get.to(RequestLetterPage());
              },
            ),
            const SizedBox(height: 12.0),
            SecondaryTile(
              text: 'Apply for Grant',
              icon: Images.applyForGrant,
              isImageAsset: true,
              showTrailing: true,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: DS.setSP(16),
              ),
              onTap: () {
                Get.to(
                  ApplicableGrantsPage(),
                );
              },
            ),
            const SizedBox(height: 12.0),
            SecondaryTile(
              text: 'Attendance Excuse',
              icon: Images.applyForGrant,
              isImageAsset: true,
              showTrailing: true,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: DS.setSP(16),
              ),
              onTap: () {
                Get.to(
                  AttendanceExcuseHistory(),
                );
              },
            ),
            const SizedBox(height: 12.0),
            SecondaryTile(
              text: 'Grievance',
              icon: Images.grade_appeal,
              showTrailing: true,
              isImageAsset: true,
              onTap: () {
                Get.to(GrievancePage());
              },
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: DS.setSP(16),
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ],
    );
  }
}
