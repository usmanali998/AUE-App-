import 'package:aue/model/assignment.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/courses/assignment_detail.dart';
import 'package:aue/services/repository.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AssignmentsPage extends StatefulWidget {
  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  Future<List<Assignment>> courseTimeLine;

  @override
  void initState() {
    getTimeLine();
    super.initState();
  }

  getTimeLine() {
    //TODO ADD REAL IDS
    final studentId = context.read<AuthNotifier>().user.studentID;
    final sectionId = context.read<AppStateNotifier>().selectedSection.sectionId;
    //Repository().getStudentAssignmentsBySectionID();
    print('SectionID: $sectionId');
    courseTimeLine = null;
    courseTimeLine = Repository().getStudentAssignmentsBySectionID(studentId, sectionId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SecondaryBackgroundWidget(
        image: Images.square,
        title: "Assignments",
        children: <Widget>[
          FutureBuilder(
            future: courseTimeLine,
            builder: (context, AsyncSnapshot<List<Assignment>> snapshot) {
              if (snapshot.isLoading) {
                return LoadingWidget();
              }

              if (snapshot.hasError && snapshot.error != null) {
                return Text(snapshot.error.toString());
                return CustomErrorWidget(
                  err: snapshot.error,
                  onRetryTap: () => getTimeLine(),
                );
              }

              return ListView(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ...snapshot.data
                      .map<Widget>(
                        (item) => AssignmentTile(
                          onTap: () {
                            Get.to(AssignmentDetail(assignment: item));
                          },
                          assignment: item,
                          showOffSetLine: snapshot.data.indexOf(item) !=
                              snapshot.data.length - 1,
                        ),
                      )
                      .toList(),
                  // TimeLineTime(),
                  // TimeLineTime(),
                  // TimeLineTime(),
                  // TimeLineTime(),
                  // TimeLineTime(),
                  // TimeLineTime(),
                  // TimeLineTime(),
                  // TimeLineTime(showOffSetLine: false),
                ],
              );
            },
          ),
          // AssignmentTile(
          // onTap: () {
          //   //TODO ADD REAL IDS
          //   final studentId = context.read<AuthNotifier>().user.studentID;
          //   final sectionId =
          //       context.read<AppStateNotifier>().selectedCourse.sectionId;
          //   Repository().getStudentAssignmentsBySectionID("181210060", 14397);
          //   },
          // ),
          // AssignmentTile(),
          // AssignmentTile(),
          // AssignmentTile(),
          // AssignmentTile(),
          // AssignmentTile(),
          // AssignmentTile(),
          // AssignmentTile(showOffSetLine: false),
        ],
      ),
    );
  }
}

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;
  final bool showOffSetLine;
  final VoidCallback onTap;
  const AssignmentTile({
    Key key,
    this.assignment,
    this.showOffSetLine = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            // Get.to(AnnouncementDetailPage());
          },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, 40),
                      child: Center(
                        child: Container(
                          width: 4,
                          height: 120,
                          color: showOffSetLine
                              ? Color(0XFFD7DADA).withOpacity(0.7)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0XFFD7DADA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 16,
              child: Material(
                elevation: 4,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: ImageIcon(
                            AssetImage(Images.classUpdates),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Submission Date: ${DateFormat("dd-MM-YYYY").format(assignment.endDate)}",
                                    style: TextStyle(
                                      color: AppColors.blueGrey,
                                      fontSize: DS.setSP(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black26,
                                  size: DS.setSP(16),
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              assignment.attachmentName ??
                                  "Read, interpret and critically analyze the article review. Based on your  ",
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: DS.setSP(14),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
