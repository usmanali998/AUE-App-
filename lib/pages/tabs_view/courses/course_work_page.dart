import 'dart:async';
import 'dart:io';

import 'package:aue/model/course_marks_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/pages/tabs_view/courses/request_incomplete_exam.dart';
import 'package:aue/pages/tabs_view/courses/rubric_page.dart';
import 'package:aue/services/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/widgets/custom_widgets.dart';

class CourseWorkpage extends StatefulWidget {
  @override
  _CourseWorkpageState createState() => _CourseWorkpageState();
}

class _CourseWorkpageState extends State<CourseWorkpage> {
  Future getCourseMarksFuture;

  bool _permissionReady;
  String _localPath;
  bool _isLoading;
  static String taskId;

  @override
  void initState() {
    //TODO**  FIX THIS ONCE API IS FIXED
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    getCourseMarks();
    _prepare();
//    });
    super.initState();
  }

  getCourseMarks() {
    final user = context.read<AuthNotifier>().user;
    final selectedCourse = context.read<AppStateNotifier>().selectedSection;
    getCourseMarksFuture = Repository().getCourseMarks(user.studentID, selectedCourse.sectionId);
    setState(() {});
  }

  static void flutterDownloaderCallback(String id, DownloadTaskStatus status, int progress) {
    print('Status: $status | Progress: $progress');
    if (status == DownloadTaskStatus.complete) {
      FlutterDownloader.open(taskId: taskId);
//      print('IsOpened');
//      print(isOpened);
    }
  }

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

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<CourseMarks>(
          future: this.getCourseMarksFuture,
          builder: (BuildContext context, AsyncSnapshot<CourseMarks> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getCourseMarks(),
              );
            }

            return BackgroundWidget(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(color: Colors.white),
                      Expanded(
                        child: Text(
                          "Coursework",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: DS.setSP(22),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: const ImageIcon(
                          const AssetImage(Images.bell),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ProgressCard(courseMarks: snapshot.data),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: false,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Show All',
                            style: TextStyle(
                              fontSize: DS.setSP(14),
                              color: const Color(0xffb89a5b),
                              letterSpacing: 0.6250000038146972,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ...snapshot.data.courseWorkDetails.map((CourseWorkDetail courseWorkDetail) {
                        print('CourseWorkID');
                        print(courseWorkDetail.courseWorkPatternId);
                        print('RubricID');
                        print(courseWorkDetail.rubricId);
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 24),
                            Material(
                              elevation: 12,
                              shadowColor: Colors.black.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    ProjectAndPresentationRow(
                                      title: courseWorkDetail.description,
                                      totalMarks: courseWorkDetail.totalMark,
                                      actualMarks: courseWorkDetail.actualMark,
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      height: DS.setSP(32),
                                      thickness: 0.1,
                                    ),
                                    TaskDetail(
                                      rubricId: courseWorkDetail.rubricId,
                                      courseWorkId: courseWorkDetail.courseWorkPatternId,
                                      onViewPaper: () async {
                                        print('PaperDownloadLink: ${courseWorkDetail.paperDownloadLink}');
                                        if (courseWorkDetail.paperDownloadLink == null) {
                                          Fluttertoast.showToast(
                                            msg: 'No paper found!',
                                            toastLength: Toast.LENGTH_SHORT
                                          );
                                          return;
                                        }
                                        taskId = await FlutterDownloader.enqueue(
                                          url: courseWorkDetail.paperDownloadLink,
                                          savedDir: _localPath,
                                          showNotification: true,
                                          headers: {
                                            "Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw",
                                          },
                                          openFileFromNotification: true,
                                        );
                                        FlutterDownloader.registerCallback(_CourseWorkpageState.flutterDownloaderCallback);
                                      },
                                      inCompleteExamEligible: courseWorkDetail.inCompleteExamEligible
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TaskDetail extends StatelessWidget {
  final String title;
  final int courseWorkId;
  final int rubricId;
  final VoidCallback onViewPaper;
  final bool inCompleteExamEligible;

  const TaskDetail({
    Key key,
    this.title,
    this.courseWorkId,
    this.rubricId,
    this.onViewPaper,
    this.inCompleteExamEligible
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: false,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.primary,
                      width: DS.setSP(6),
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(width: 24),
              Visibility(
                visible: true,
                child: Expanded(
                  flex: 6,
                  child: Text(
                    title ?? 'Assessment 1 - Journal Article Reviews',
                    style: TextStyle(
                      fontSize: DS.setSP(13.5),
                      color: AppColors.blueGrey,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.primary)),
                  alignment: Alignment.center,
                  child: Text(
                    '15/20',
                    style: TextStyle(
                      fontSize: DS.setSP(14),
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: false,
          child: Divider(
            color: Colors.black,
            height: DS.setSP(24),
            thickness: 0.1,
          ),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              visible: this.inCompleteExamEligible ?? false,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      RequestIncompleteExam(),
                    );
                  },
                  child: Text(
                    'Request for Incomplete Exam',
                    style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: DS.setSP(12.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onViewPaper,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: DS.setSP(20),
                    ),
                    // SizedBox(width: 8), // Adobe XD layer: 'View Paper' (text)
                    Text(
                      'View Paper',
                      style: TextStyle(
                        fontSize: DS.setSP(14),
                        color: AppColors.primary,
                        letterSpacing: 0.25,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(width: 8), // Adobe XD layer: 'View Paper' (text)
            Visibility(
              visible: rubricId == 0 ? false : true,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      RubricPage(
                        courseWorkId: courseWorkId,
                        rubricId: rubricId,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: DS.setSP(20),
                      ),
                      // SizedBox(width: 8), // Adobe XD layer: 'View Paper' (text)
                      Text(
                        'View Rubric',
                        style: TextStyle(
                          fontSize: DS.setSP(14),
                          color: Colors.black,
                          letterSpacing: 0.25,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: GestureDetector(
                onTap: () {
                  Get.to(RubricPage(
                    courseWorkId: courseWorkId,
                    rubricId: rubricId,
                  ));
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: DS.setSP(20),
                    ),
                    SizedBox(width: 8), // Adobe XD layer: 'View Paper' (text)
                    Text(
                      'View Rubric',
                      style: TextStyle(
                        fontSize: DS.setSP(14),
                        color: Colors.black,
                        letterSpacing: 0.25,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProjectAndPresentationRow extends StatelessWidget {
  final String title;
  final double totalMarks;
  final double actualMarks;

  const ProjectAndPresentationRow({
    Key key,
    this.title,
    this.totalMarks,
    this.actualMarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
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
        SizedBox(width: 12),
        Expanded(
          child: // Adobe XD layer: 'Project & Presentati' (text)
              SingleChildScrollView(
            child: Text(
              title ?? 'Project & Presentation',
              style: TextStyle(
                fontSize: DS.setSP(17),
                color: const Color(0xff042c5c),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            'Total\n$actualMarks/$totalMarks',
            style: TextStyle(
              fontFamily: 'Avenir-Light',
              fontSize: DS.setSP(15),
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class ProgressCard extends StatelessWidget {
  final CourseMarks courseMarks;

  const ProgressCard({
    this.courseMarks,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DS.height * 0.45,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Course Name',
              //       style: TextStyle(
              //         fontSize: DS.setSP(13),
              //         color: const Color(0xff042c5c),
              //         letterSpacing: 0.25,
              //       ),
              //     ),
              //     Text(
              //       'View Rubric',
              //       style: TextStyle(
              //         fontSize: 13,
              //         color: const Color(0xff172b4d),
              //         letterSpacing: 0.25,
              //       ),
              //       textAlign: TextAlign.right,
              //     ),
              //   ],
              // ),
              SizedBox(height: 4),
              Expanded(
                child: SleekCircularSlider(
                  min: 0,
                  max: 100,
                  initialValue: courseMarks.table1.first.totalGrades,
                  appearance: CircularSliderAppearance(
                    angleRange: 220,
                    startAngle: 160,
                    customWidths: CustomSliderWidths(
                      shadowWidth: 20,
                      progressBarWidth: 20,
                      handlerSize: 20,
                      trackWidth: 20,
                    ),
                    size: DS.setSP(300),
                    customColors: CustomSliderColors(
                      dotColor: Colors.transparent,
                      hideShadow: true,
                      trackColor: Colors.black12,
                      progressBarColor: AppColors.primary,
                    ),
                  ),
                  innerWidget: (val) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //TODO ADD IMAGE HERE
                        SizedBox(
                          width: 24,
                          height: 48,
                        ),
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: DS.setSP(14),
                            color: const Color(0xff77869e),
                            letterSpacing: 0.23,
                          ),
                        ),
                        Text(
                          courseMarks.table1.first.totalGrades.toString(),
                          style: TextStyle(
                            fontSize: DS.setSP(40),
                            color: const Color(0xff042c5c),
                            letterSpacing: 0.8509615516662598,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'out of 100',
                          style: TextStyle(
                            fontSize: DS.setSP(14),
                            color: const Color(0xff77869e),
                            letterSpacing: 0.23,
                          ),
                        ),
                        SizedBox(
                          height: DS.setSP(80),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CGPABox extends StatefulWidget {
  const CGPABox({
    Key key,
  }) : super(key: key);

  @override
  _CGPABoxState createState() => _CGPABoxState();
}

class _CGPABoxState extends State<CGPABox> {
  Future<Response> cGPAFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentId = Provider.of<AuthNotifier>(context, listen: false).user.studentID;
      cGPAFuture = Dio().get(
        "http://integrations.aue.ae/stdsvc/Student/GetCGPA?StudentID=$studentId",
        options: Options(
          headers: {"Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw"},
        ),
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cGPAFuture,
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final cgpa = double.parse(snapshot.data.data["CGPA"]);
        return GradeBox(
          title: "CGPA",
          subtitle: cgpa.toString(),
          angle: cgpa > 3 ? 0 : null,
          color: cgpa > 3 ? null : Colors.red,
        );
      },
    );
  }
}

class EventsWidget extends StatefulWidget {
  const EventsWidget({
    Key key,
  }) : super(key: key);

  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EVENTS",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontSize: DS.setSP(20),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: CalendarModel.list.map((item) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    CalendarModel.list.forEach((item) => item.selected = false);
                    final index = CalendarModel.list.indexOf(item);
                    CalendarModel.list[index].selected = true;
                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.selected ? AppColors.primaryLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: item.selected ? AppColors.primary : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          Material(
            shadowColor: Colors.black12,
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Placeholder(fallbackHeight: DS.height * 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarModel {
  String text;
  bool selected;

  CalendarModel({this.text, this.selected = false});

  static List<CalendarModel> list = [
    CalendarModel(text: "Day", selected: true),
    CalendarModel(text: "Week"),
    CalendarModel(text: "Month"),
    CalendarModel(text: "Year"),
  ];
}

class GradeBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final double angle;

  const GradeBox({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.color,
    this.angle = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color?.withOpacity(0.2) ?? AppColors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Transform.rotate(
            angle: angle,
            child: ImageIcon(
              AssetImage(
                Images.arrow,
              ),
              color: color ?? AppColors.green,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: DS.setSP(16),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: DS.setSP(18),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
