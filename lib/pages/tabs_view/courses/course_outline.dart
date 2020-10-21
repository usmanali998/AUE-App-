import 'package:aue/model/course_outline_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CourseOutlinePage extends StatefulWidget {
  @override
  _CourseOutlinePageState createState() => _CourseOutlinePageState();
}

class _CourseOutlinePageState extends State<CourseOutlinePage> {
  Future<List<CourseOutline>> _courseOutlinesFuture;

  getCourseOutlines() {
    _courseOutlinesFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    int sectionId = context.read<AppStateNotifier>().selectedSection.sectionId;
    _courseOutlinesFuture =
        Repository().getCourseOutlines(studentId, sectionId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCourseOutlines();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseOutline>>(
      future: _courseOutlinesFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<CourseOutline>> snapshot) {
        if (snapshot.isLoading) {
          return Scaffold(body: LoadingWidget());
        }

        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: DioError(
              response: Response<String>(data: snapshot.error),
              type: DioErrorType.RESPONSE,
              error: snapshot.error,
            ),
            onRetryTap: () => this.getCourseOutlines(),
          );
        }
        snapshot.data.sort((a, b) =>  int.tryParse(a.week).compareTo(int.tryParse(b.week)));
        return SecondaryBackgroundWidget(
          title: 'Course Outline',
          showBackButton: true,
          image: Images.course_list,
          children: snapshot.data.map<Widget>(
            (CourseOutline courseOutline) {
              return Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(4.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        'Week ${courseOutline.week}:',
                        style: const TextStyle(
                          color: AppColors.blueGrey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: DS.width * 0.025),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: .0),
                          child: Text(
                            courseOutline.topics,
                            style: const TextStyle(
                              color: AppColors.blueGrey,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
