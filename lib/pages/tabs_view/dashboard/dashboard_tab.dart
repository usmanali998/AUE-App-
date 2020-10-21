import 'dart:async';
import 'dart:convert';
import 'package:aue/model/announcements.dart';
import 'package:aue/model/event.dart';
import 'package:aue/model/student_grades.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/dashboard/my_grades/my_grades.dart';
import 'package:aue/pages/tabs_view/dashboard/notifications_page.dart';
import 'package:aue/pages/tabs_view/dashboard/study_plans/study_plans.dart';
import 'package:aue/pages/tabs_view/dashboard/academic_calendar.dart';
import 'package:aue/pages/tabs_view/dashboard/class_updates.dart';
import 'package:aue/pages/tabs_view/dashboard/highlight_details.dart';
import 'package:aue/pages/tabs_view/dashboard/student_profile.dart';
import 'package:aue/pages/tabs_view/registration/course_registration.dart';
import 'package:aue/res/utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:dio/dio.dart';
import 'package:aue/pages/tabs_view/registration/finance.dart';
import 'package:aue/pages/tabs_view/registration/terms_condition.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashBoardTab extends StatefulWidget {
  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  Future<StudentGrades> _studentGradesFuture;

  @override
  void initState() {
    super.initState();
    getStudentGrades();
  }

  void getStudentGrades() {
    _studentGradesFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _studentGradesFuture = Repository().getStudentGrades(studentId);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(StudentProfileScreen());
                  },
                  icon: const Icon(Icons.more_horiz, size: 45.0, color: Colors.white),
                ),
//                Text(
//                  "Dashboard",
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontWeight: FontWeight.w600,
//                    fontSize: DS.setSP(22),
//                  ),
//                ),
                GestureDetector(
                  onTap: () {
                    Get.to(NotificationsPage());
                  },
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          AnimatedImages(onTap: (int year, int id) {
            Get.to(HighlightDetailsScreen(year: year, id: id));
          }),
          Container(
              height: DS.height * 0.08,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black12, width: 0.4),
              // ),
              child: CGPABox()
              //  Row(
              //   children: [
              //     Expanded(
              //       child: GradeBox(
              //         title: "Attendance",
              //         subtitle: "80%",
              //       ),
              //     ),
              //     SizedBox(width: 8),
              //     Expanded(
              //       child: CGPABox(),
              //     ),
              //   ],
              // ),
              ),
          PrimaryTile(
            leadingIcon: Images.classUpdates,
            title: "Class Updates",
            subtitle: "17 Monday June",
            trailingText: "8",
            primary: false,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ClassUpdatesScreen(),
                ),
              );
            },
          ),
          FutureBuilder<StudentGrades>(
              future: _studentGradesFuture,
              builder: (context, AsyncSnapshot<StudentGrades> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return PrimaryTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => FutureBuilder<StudentGrades>(
                            future: _studentGradesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.isLoading) {
                                return LoadingWidget();
                              }
                              if (snapshot.hasError && snapshot.error != null) {
                                return CustomErrorWidget(
                                  err: snapshot.error,
                                );
                              }
                              return MyGrades(studentGrades: snapshot.data);
                            },
                          ),
                        ),
                      );
                    },
                    leadingIcon: Images.classUpdates,
                    title: "My Grades",
                    subtitle: "Check your academic performance",
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFFDDDDDD),
                    ),
                  );
                }
              }),
          PrimaryTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudyPlans()),
              );
            },
            leadingIcon: Images.studyPlans,
            title: "Study Plans",
            subtitle: "Check your semester plan",
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color(0XFFDDDDDD),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "STUDY",
              style: TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          PrimaryTile(
            onTap: () async {
              Get.to(AcademicCalendarScreen());
//              const url = 'https://aue.ae/en/weekday-calendar-academic';
//              if (await canLaunch(url)) {
//                await launch(url);
//              } else {
//                throw 'Could not launch $url';
//              }
            },
            leadingIcon: Images.calendar,
            title: "Academic Calendar",
            subtitle: "Find important dates",
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color(0XFFDDDDDD),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => CourseRegistration(),
                        ),
                      );
                    },
                    child: IconTextBox(
                      icon: Images.registration,
                      text: "Registration",
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => Finance(),
                        ),
                      );
                    },
                    child: IconTextBox(
                      icon: Images.finance,
                      text: "Finance",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          EventsWidget(),
          SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
          //   child: Text(
          //     "YOUR CHATS",
          //     style: TextStyle(
          //       color: AppColors.blueGrey,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 16),
          // Container(
          //   height: DS.setHeight(190),
          //   child: ListView(
          //       padding: EdgeInsets.symmetric(horizontal: 24),
          //       scrollDirection: Axis.horizontal,
          //       children: List.generate(
          //         10,
          //         (index) {
          //           return Padding(
          //             padding: const EdgeInsets.only(bottom: 8.0, right: 8),
          //             child: Material(
          //               elevation: 4,
          //               shadowColor: Colors.black12,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(16),
          //               ),
          //               child: Container(
          //                 width: DS.setWidth(120),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(16),
          //                 ),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     FlutterLogo(
          //                       size: DS.setSP(40),
          //                     ),
          //                     Padding(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 12.0),
          //                       child: Text(
          //                         "Add New Contact",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           color: AppColors.blueGrey,
          //                           fontWeight: FontWeight.w500,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ).toList()),
          // ),
          // SizedBox(height: 30),
        ],
      ),
    );
  }
}

class CGPABox extends StatefulWidget {
  final Future<Response> cGPAFuture;

  const CGPABox({
    this.cGPAFuture,
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
      final dio = Utils.dio;
      cGPAFuture = dio.get(
        "http://integrations.aue.ae/stdsvc/Student/GetCGPA?StudentID=$studentId",
        options: buildCacheOptions(
          Duration(days: 3),
          forceRefresh: true,
          options: Options(
            headers: {"Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw"},
          ),
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
        if (snapshot.hasError) {
          return Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final cgpa = double.parse(snapshot.data.data["CGPA"]);
          final academicStanding = snapshot.data.data["AcademicStanding"];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            leading: Icon(
              FontAwesomeIcons.graduationCap,
              size: DS.setSP(36),
              color: AppColors.primary,
            ),
            title: Text(
              "Academic Standing",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: DS.setSP(16),
              ),
            ),
            subtitle: Text(
              academicStanding ?? "",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: DS.setSP(15),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(),
                Text(
                  "CGPA",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: DS.setSP(16),
                  ),
                ),
                Spacer(),
                Text(
                  "$cgpa",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: DS.setSP(15),
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        }
        // return GradeBox(
        //   title: "CGPA",
        //   subtitle: cgpa.toString(),
        //   angle: cgpa > 3 ? 0 : null,
        //   color: cgpa > 3 ? null : Colors.red,
        // );
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
  Future<List<Event>> eventsFuture;

  @override
  void initState() {
    getCourses();

    super.initState();
  }

  getCourses() {
    eventsFuture = null;
    eventsFuture = Repository().getEventsByType();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "EVENTS",
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Visibility(
                visible: false,
                child: InkWell(
                  onTap: () {
                    //TODO Move To Show More Events Screen
                  },
                  child: Text(
                    "Show More",
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          FutureBuilder(
            future: eventsFuture,
            builder: (context, AsyncSnapshot<List<Event>> snapshot) {
              if (snapshot.isLoading) {
                return buildMaterial(LoadingWidget());
              }

              if (snapshot.hasError && snapshot.error != null) {
                return CustomErrorWidget(
                  err: snapshot.error,
                  onRetryTap: () => getCourses(),
                );
              }

              return buildMaterial(
                Column(
                  children: snapshot.data
                      .take(4)
                      .map(
                        (event) => ListTile(
                          title: Text(
                            event.nameEN,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: DS.setSP(14),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    DateFormat("dd/M/yyyy").format(event.startDate),
                                    style: TextStyle(fontSize: DS.setSP(13)),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "${DateFormat('EEE - h:mm a').format(event.registrationStart)} - ${DateFormat('h:mm a').format(event.registrationEnd)}".toUpperCase(),
                                  style: TextStyle(fontSize: DS.setSP(13)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );

              // return ListView(
              //   primary: false,
              //   shrinkWrap: true,
              //   padding: EdgeInsets.zero,
              //   children: <Widget>[
              //     ...snapshot.data
              //         .map<Widget>((course) => CourseTile(course: course))
              //         .toList()
              //   ],
              // );
            },
          ),
        ],
      ),
    );
  }

  Material buildMaterial(Widget child) {
    return Material(
      shadowColor: Colors.black12,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
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

class AnimatedImages extends StatefulWidget {
  final Function(int, int) onTap;

  const AnimatedImages({
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _AnimatedImagesState createState() => _AnimatedImagesState();
}

class _AnimatedImagesState extends State<AnimatedImages> {
  int currentIndex = 0;
  PageController controller;

  Future<Announcements> _announcementsFuture;

  Timer timer;

  @override
  void initState() {
    getAnnouncements();
    controller = PageController(initialPage: currentIndex);

    timer = Timer.periodic(Duration(seconds: 7), (_) {
      if (currentIndex == 2) {
        currentIndex = -1;
      }
      if (mounted) {
        try {
          controller.animateToPage(
            ++currentIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.linearToEaseOut,
          );
        } catch (e) {
          print(e);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }

  void getAnnouncements() {
    _announcementsFuture = null;
    _announcementsFuture = Repository().getAnnouncements(context.read<AuthNotifier>().user.studentID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Announcements>(
      future: _announcementsFuture,
      builder: (BuildContext context, AsyncSnapshot<Announcements> snapshot) {
        if (snapshot.isLoading) {
          return LoadingWidget();
        }

        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: DioError(
              type: DioErrorType.RESPONSE,
              response: Response<String>(data: 'Could not fetch announcements right now'),
              error: 'Could not fetch announcements right now',
            ),
            onRetryTap: () => this.getAnnouncements(),
          );
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          height: DS.height * 0.525,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  return widget.onTap(snapshot.data.announcement.singleWhere((announcement) => announcement.masterId == snapshot.data.images[currentIndex].masterId).masterYear,
                      snapshot.data.images[currentIndex].masterId);
                },
                child: Container(
                  width: double.infinity,
                  height: DS.height * 0.525,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   stops: [0.7, 1.0],
                    //   colors: [
                    //     Colors.transparent,
                    //     Colors.black87,
                    //   ],
                    // ),
                  ),
                ),
              ),
              PageView(
                controller: controller,
                onPageChanged: (index) {
                  currentIndex = index;
                  setState(() {});
                },
                children: [
                  ...snapshot.data.images.map((AnnouncementImage announcementImage) {
                    return GestureDetector(
                      onTap: () => widget.onTap(snapshot.data.announcement.singleWhere((announcement) => announcement.masterId == announcementImage.masterId).masterYear, announcementImage.masterId),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Transform.scale(
                          scale: 1.01,
                          child: Image.memory(
                            base64.decode(announcementImage.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
//                    GestureDetector(
//                      onTap: widget.onTap,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(24),
//                        child: Transform.scale(
//                          scale: 1.01,
//                          child: Image.asset(
//                            Images.student,
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: widget.onTap,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(24),
//                        child: Transform.scale(
//                          scale: 1.01,
//                          child: Image.asset(
//                            Images.student,
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: widget.onTap,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(24),
//                        child: Transform.scale(
//                          scale: 1.01,
//                          child: Image.asset(
//                            Images.student,
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(snapshot.data.images.length, (index) {
                            return Container(
                              width: 20,
                              height: 5,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: currentIndex == index ? Color(0XFFF4C96F) : Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            );
                          }),
                        )),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Transform.translate(
                          offset: Offset(0, 4),
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: DS.setSP(18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
