import 'dart:convert';

import 'package:aue/model/course.dart';
import 'package:aue/model/sections.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/courses/courses_detail_page.dart';
import 'package:aue/res/extensions.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CoursesListTab extends StatefulWidget {
  @override
  _CoursesListTabState createState() => _CoursesListTabState();
}

class _CoursesListTabState extends State<CoursesListTab> {
//  Future<List<Course>> coursesFuture;
  Future<List<Section>> sectionsFuture;
  @override
  void initState() {
    getCourses();

    super.initState();
  }

  getCourses() {
//    coursesFuture = null;
    sectionsFuture = null;
    final studentId = context.read<AuthNotifier>().user.studentID;
    sectionsFuture = Repository().getSections(context.read<AuthNotifier>().user);
//    coursesFuture = Repository().getCourses(studentId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Courses",
      image: Images.courses,
      showBackButton: false,
      children: <Widget>[
        Text(
          'COURSES IN CURRENT SEMESTER',
          style: TextStyle(
            fontSize: DS.setSP(14),
            color: const Color(0xff77869e),
            letterSpacing: 0.62,
          ),
        ),
        FutureBuilder<List<Section>>(
//          future: coursesFuture,
          future: sectionsFuture,
          builder: (context, AsyncSnapshot<List<Section>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => getCourses(),
              );
            }

            return ListView(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                ...snapshot.data
                    .map<Widget>((course) => CourseTile(section: course))
                    .toList()
              ],
            );
          },
        ),
      ],
    );
  }
}

class CourseTile extends StatelessWidget {
//  final Course course;
  final Section section;

  const CourseTile({
    Key key,
    @required this.section,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 12,
        shadowColor: Colors.black12,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          onTap: () async {
            if (this.section.isAccessibleByStudent) {
//            context.read<AppStateNotifier>().selectedCourse = course;
              context
                  .read<AppStateNotifier>()
                  .selectedSection = section;
              print('SelectedCourse');
              print(context
                  .read<AppStateNotifier>()
                  .selectedSection
                  .toJson());
              print('SectionID');
              print(context
                  .read<AppStateNotifier>()
                  .selectedSection
                  .sectionId);
              await Get.to(CoursesDetailsPage());
              //context.read<AppStateNotifier>().selectedCourse = null;
            } else {
              Fluttertoast.showToast(msg: this.section.notAccessibleMessage, toastLength: Toast.LENGTH_LONG);
            }
          },
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(base64Decode(section.facultyImage)),
            ),
          ),
          title: Text(
            section.courseName,
            style: TextStyle(
              fontSize: DS.setSP(16),
              color: const Color(0xffb89a5b),
              letterSpacing: 0.325,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
