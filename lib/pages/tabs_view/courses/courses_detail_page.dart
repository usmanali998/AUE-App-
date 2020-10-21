import 'dart:convert';

import 'package:aue/model/attendance_summary.dart';
import 'package:aue/model/sections.dart';
import 'package:aue/model/single_section.dart';
import 'package:aue/model/user.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/courses/assignments.dart';
import 'package:aue/pages/tabs_view/courses/class_announcements.dart';
import 'package:aue/pages/tabs_view/courses/class_discussion.dart';
import 'package:aue/pages/tabs_view/courses/course_materials.dart';
import 'package:aue/pages/tabs_view/courses/course_outline.dart';
import 'package:aue/pages/tabs_view/courses/course_time_line_detail.dart';
import 'package:aue/pages/tabs_view/courses/course_withdrawal.dart';
import 'package:aue/pages/tabs_view/courses/course_work_page.dart';
import 'package:aue/pages/tabs_view/courses/e_books.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

int sectionId;

class CoursesDetailsPage extends StatefulWidget {
  @override
  _CoursesDetailsPageState createState() => _CoursesDetailsPageState();
}

class _CoursesDetailsPageState extends State<CoursesDetailsPage> {
  bool _permissionReady;
  String _localPath;
  bool _isLoading;
  static String taskId;

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Null> _prepare() async {
    _permissionReady = await _checkPermission();
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Downloads';
    final savedDir = Directory(_localPath);
    bool isDirExist = await savedDir.exists();
    if (!isDirExist) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _permissionReady = false;
    _prepare();
  }

  static void flutterDownloaderCallback(String id, DownloadTaskStatus status, int progress) {
    print('Status: $status | Progress: $progress');
    if (status == DownloadTaskStatus.complete) {
      FlutterDownloader.open(taskId: taskId);
//      print('IsOpened');
//      print(isOpened);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BackgroundWidget(
        children: [
          const TopBar(),
          const ProfileCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryTile(
                    icon: Images.message,
                    text: "Message",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SecondaryTile(
                    icon: Images.announcementFilled,
                    text: "Announcement",
                    onTap: () {
                      Get.to(ClassAnnouncementsPage());
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: DS.height * 0.08),
          GradeLineWidget(),
          SizedBox(height: DS.height * 0.03),
          //TODO Change the icons here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: IconTextBox(
                    onTap: () => Get.to(AssignmentsPage()),
                    icon: Images.registration,
                    text: "Assignments",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: IconTextBox(
                    onTap: () => Get.to(EbooksPage()),
                    icon: Images.ebook,
                    text: "E-Books",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "COURSE",
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  icon: Images.syllabus,
                  text: "Syllabus",
                  isImageAsset: true,
                  showTrailing: true,
                  onTap: () async {
                    taskId = await FlutterDownloader.enqueue(
                      url:
                          // 'http://integrations.aue.ae/stdsvc/Student/GetSectionSyllabus?StudentID=191220052&SectionID=17532',
                          'http://integrations.aue.ae/stdsvc/Student/GetSectionSyllabus?StudentID=${context.read<AuthNotifier>().user.studentID}&SectionID=${context.read<AppStateNotifier>().selectedSection.sectionId}',
                      savedDir: _localPath,
                      showNotification: true,
                      headers: {
                        "Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw",
                      },
                      openFileFromNotification: true,
                    );
                    FlutterDownloader.registerCallback(_CoursesDetailsPageState.flutterDownloaderCallback);
                  },
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  onTap: () {
                    Get.to(CourseMaterialsPage());
                  },
                  icon: Images.materials_icon,
                  text: "Materials",
                  isImageAsset: true,
                  showTrailing: true,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  onTap: () {
                    Get.to(CourseTimelineDetail());
                  },
                  icon: Images.timeline,
                  text: "Timeline",
                  showTrailing: true,
                  isImageAsset: true,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  onTap: () {
                    Get.to(CourseWorkpage());
                  },
                  icon: Images.marks,
                  text: "Marks",
                  showTrailing: true,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  onTap: () {
                    Get.to(ClassDiscussionPage());
                  },
                  icon: Images.class_discussion,
                  text: "Class Discussion",
                  isImageAsset: true,
                  showTrailing: true,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  icon: Images.course_outline,
                  text: "Outline",
                  isImageAsset: true,
                  showTrailing: true,
                  onTap: () {
                    Get.to(CourseOutlinePage());
                  },
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                SizedBox(height: 12),
                SecondaryTile(
                  icon: Images.course_withdrawal,
                  text: "Withdrawal",
                  isImageAsset: true,
                  showTrailing: true,
                  onTap: () {
                    Get.to(CourseWithdrawalPage());
                  },
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
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

class GradeLineWidget extends StatefulWidget {
  @override
  _GradeLineWidgetState createState() => _GradeLineWidgetState();
}

class _GradeLineWidgetState extends State<GradeLineWidget> {
  Future<AttendanceSummary> _attendanceSummaryFuture;

  @override
  void initState() {
//    getAttendanceSummary(context.read<AuthNotifier>().user.studentID, sectionId);
//    getAttendanceSummary(appStateNotifier.user.studentID, appStateNotifier.selectedSection.sectionId);
    getAttendanceSummary(context.read<AuthNotifier>().user.studentID, context.read<AppStateNotifier>().selectedSection.sectionId);
    super.initState();
  }

  void getAttendanceSummary([String studentId, int sectionId]) {
    _attendanceSummaryFuture = null;
    _attendanceSummaryFuture = Repository.getAttendanceSummary(studentId, sectionId);
    setState(() {});
  }

  Color getBarColor(int levelId) {
    switch (levelId) {
      case 0:
        return Colors.green;
        break;
      case 1:
        return Colors.yellow;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.redAccent;
        break;
      case 4:
        return Colors.red;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: FutureBuilder<AttendanceSummary>(
          future: this._attendanceSummaryFuture,
          builder: (BuildContext context, AsyncSnapshot<AttendanceSummary> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: DioError(error: 'Error fetching attendance summary', response: Response<String>(data: 'Error fetching attendance summary'), type: DioErrorType.RESPONSE),
//              onRetryTap: () => this.getAttendanceSummary(context.read<AuthNotifier>().user.studentID, sectionId),
                onRetryTap: () => this.getAttendanceSummary(),
              );
            }

//          print(snapshot.data.rangeSlider.length);
//          print(snapshot.data.studentAttendanceSummary.first.levelId);
//          print(snapshot.data.studentAttendanceSummary.first.levelId / snapshot.data.rangeSlider.length);

            return Column(
              children: <Widget>[
                GradesRow(
//                grades: const ["Good", "1st", "2nd", "3rd", "FA"],
                  grades: snapshot.data.rangeSlider.map((rangeSlider) => rangeSlider.levelDescription).toList(),
                  textStyle: TextStyle(
                    fontSize: DS.setSP(14),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: CustomProgressIndicator(
                    height: 6,
                    value: snapshot.data.studentAttendanceSummary.first.levelId / snapshot.data.rangeSlider.length,
                    backgroundColor: Colors.black26,
//                    valueColor: const AlwaysStoppedAnimation<Color>(const Color(0XFFF19E4D)),
                    valueColor: AlwaysStoppedAnimation<Color>(getBarColor(snapshot.data.studentAttendanceSummary.first.levelId)),
                  ),
                ),
                GradesRow(
                  grades: snapshot.data.rangeSlider.map((rangeSlider) => rangeSlider.hoursMissedLabel).toList(),
                  textStyle: TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: DS.setSP(13),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class GradesRow extends StatelessWidget {
  final List<String> grades;
  final TextStyle textStyle;

  const GradesRow({
    Key key,
    this.grades,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            grades?.first ?? "",
            style: textStyle,
          ),
        ),
        Expanded(
          child: Text(
            grades?.elementAt(1) ?? "",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        Expanded(
          child: Text(
            grades?.elementAt(2) ?? "",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        Expanded(
          child: Text(
            grades?.elementAt(3) ?? "",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        Expanded(
          child: Text(
            grades?.last ?? "",
            textAlign: TextAlign.end,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key key,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Future<SingleSection> _sectionFuture;

  @override
  void initState() {
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    getSection();
//    });

    super.initState();
  }

  getSection() {
    final studentId = context.read<AuthNotifier>().user;
    _sectionFuture = Repository().getSingleSection(context.read<AppStateNotifier>().selectedSection.sectionId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthNotifier, User>((value) => value.user);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: DS.height * 0.2,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FutureBuilder(
        future: this._sectionFuture,
        builder: (BuildContext context, AsyncSnapshot<SingleSection> snapshot) {
          // print(snapshot);
          if (snapshot.isLoading) {
            return LoadingWidget();
          }

          if (snapshot.hasError && snapshot.error != null) {
            print('Error');
            print(snapshot.error);
            return CustomErrorWidget(
              err: DioError(type: DioErrorType.RESPONSE, response: Response<String>(data: snapshot.error.toString()), error: snapshot.error),
              onRetryTap: () => getSection(),
            );
          }

          sectionId = snapshot.data.sectionId;

          return Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.7,
                      color: AppColors.grey,
                    ),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(12.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(12.0),
                    ),
                    child: Image.memory(
                      base64.decode(snapshot.data.imageByte),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data.fullName,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        snapshot?.data?.schedule ?? '',
                        style: TextStyle(
                          color: AppColors.blueGrey,
                          fontSize: DS.setSP(14),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
//                      SizedBox(height: 8),
//                      ...snapshot.data.schedule
//                          .map(
//                            (schedule) => Text(
//                              "${schedule.day ?? schedule.dayId} - ${DateFormat("hh:mm a").format(schedule.startTime)} - ${DateFormat("hh:mm a").format(schedule.endTime)}",
//                              style: TextStyle(
//                                color: AppColors.blueGrey,
//                                fontSize: DS.setSP(14),
//                                fontWeight: FontWeight.w500,
//                              ),
//                            ),
//                          )
//                          .toList(),
                      // Text(
                      //   "MON - 4:00 PM - 5:30 PM",
                      //   style: TextStyle(
                      //     color: AppColors.blueGrey,
                      //     fontSize: DS.setSP(14),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // // SizedBox(height: 4),
                      // Text(
                      //   "MON - 4:00 PM - 5:30 PM",
                      //   style: TextStyle(
                      //     color: AppColors.blueGrey,
                      //     fontSize: DS.setSP(14),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // // SizedBox(height: 4),
                      // Text(
                      //   "WED - 4:00 PM - 5:30 PM",
                      //   style: TextStyle(
                      //     color: AppColors.blueGrey,
                      //     fontSize: DS.setSP(14),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // SizedBox(height: 4),
//                      Text(
//                        snapshot.data.schedule.first.sectionCode, // "CR 7111",
//                        style: TextStyle(
//                          color: AppColors.blueGrey,
//                          fontSize: DS.setSP(14),
//                          fontWeight: FontWeight.w500,
//                        ),
//                      ),
//                      if (snapshot.data.message != null)
//                        Text(
//                          "MESSAGE " + snapshot.data.message, // "CR 7111",
//                          style: TextStyle(
//                            color: Colors.black54,
//                            fontSize: DS.setSP(14),
//                            fontWeight: FontWeight.w700,
//                          ),
//                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final course = context.select<AppStateNotifier, Section>((value) => value.selectedSection);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: Colors.white),
          Column(
            children: [
              Text(
                course.courseName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: DS.setSP(20),
                ),
              ),
              Text(
                course.courseCode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: DS.setSP(12),
                ),
              ),
            ],
          ),
          const SizedBox(),
          Visibility(
            visible: false,
            child: Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: ImageIcon(
                  AssetImage(Images.bell),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
