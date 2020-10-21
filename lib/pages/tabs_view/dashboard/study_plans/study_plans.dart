import 'package:aue/model/study_plan.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/dashboard/study_plans/study_plan_course_detail.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class StudyPlans extends StatefulWidget {
  @override
  _StudyPlansState createState() => _StudyPlansState();
}

class _StudyPlansState extends State<StudyPlans> {
  Future<StudyPlan> _studyPlanFuture;

  void getStudyPlan() {
    _studyPlanFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _studyPlanFuture = Repository().getStudyPlan(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getStudyPlan();
  }

  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Study Plans",
      image: Images.course_list,
      imageSize: Size(90, 90),
      listViewPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      children: [
        FutureBuilder<StudyPlan>(
          future: _studyPlanFuture,
          builder: (BuildContext context, AsyncSnapshot<StudyPlan> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }
            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getStudyPlan(),
              );
            }
            return GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 20),
              children: snapshot.data.courseCategories
                  .map((studyPlanCourseCategory) => ProgressCard(
                        studyPlanCourseCategory: studyPlanCourseCategory,
                        studyPlanCourseList: snapshot.data.courses.where((studyPlanCourse) => studyPlanCourse.courseCategoryId == studyPlanCourseCategory.courseCategoryId).toList(),
                      ))
                  .toList(),
            );
          },
        ),
      ],
      // children: _loading
      //     ? loader
      //     : <Widget>[
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text(
      //               courseCategories[0]['Name'],
      //               style: TextStyle(fontSize: 15, color: Color(0xff77869E)),
      //             ),
      //             Container(
      //               width: 80,
      //               height: 25,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(4),
      //                 color: Color(0xffFEFEFE),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey,
      //                     offset: Offset(0.0, 1.0),
      //                     blurRadius: 6.0,
      //                   ),
      //                 ],
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   '${courseCategories[0]['CompletedCredits']}/${courseCategories[0]['RequiredCredits']} CH',
      //                   style: TextStyle(fontSize: 12, color: AppColors.primary),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         // SizedBox(height: 20),
      //         _listView(generalEducation),
      //         SizedBox(height: 50),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text(
      //               courseCategories[1]['Name'],
      //               style: TextStyle(fontSize: 15, color: Color(0xff77869E)),
      //             ),
      //             Container(
      //               width: 80,
      //               height: 25,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(4),
      //                 color: Color(0xffFEFEFE),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey,
      //                     offset: Offset(0.0, 1.0),
      //                     blurRadius: 6.0,
      //                   ),
      //                 ],
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   '${courseCategories[1]['CompletedCredits']}/${courseCategories[1]['RequiredCredits']} CH',
      //                   style: TextStyle(fontSize: 12, color: AppColors.primary),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         // SizedBox(height: 20),
      //         _listView(coreRequirements),
      //         SizedBox(height: 50),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text(
      //               courseCategories[2]['Name'],
      //               style: TextStyle(fontSize: 15, color: Color(0xff77869E)),
      //             ),
      //             Container(
      //               width: 80,
      //               height: 25,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(4),
      //                 color: Color(0xffFEFEFE),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey,
      //                     offset: Offset(0.0, 1.0),
      //                     blurRadius: 6.0,
      //                   ),
      //                 ],
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   '${courseCategories[2]['CompletedCredits']}/${courseCategories[2]['RequiredCredits']} CH',
      //                   style: TextStyle(fontSize: 12, color: AppColors.primary),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         // SizedBox(height: 20),
      //         _listView(specializationRequirements),
      //         SizedBox(height: 50),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text(
      //               courseCategories[3]['Name'],
      //               style: TextStyle(fontSize: 15, color: Color(0xff77869E)),
      //             ),
      //             Container(
      //               width: 80,
      //               height: 25,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(4),
      //                 color: Color(0xffFEFEFE),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey,
      //                     offset: Offset(0.0, 1.0),
      //                     blurRadius: 6.0,
      //                   ),
      //                 ],
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   '${courseCategories[3]['CompletedCredits']}/${courseCategories[3]['RequiredCredits']} CH',
      //                   style: TextStyle(fontSize: 12, color: AppColors.primary),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         // SizedBox(height: 20),
      //         _listView(electiveCourses),
      //         SizedBox(height: 30)
      //       ],
    );
  }

  Widget _listView(List<Map<String, dynamic>> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) => CustomExpansionTile(
        title: list[index]['CourseName'],
        subtitle: list[index]['CourseStatus'],
        iconColor: list[index]['CourseStatus'] == 'Eligible but not Offered' || list[index]['CourseStatus'] == 'Not Eligible and Not Offered' ? AppColors.primary : Colors.white,
        iconBackgroundColor: list[index]['CourseStatus'] == 'Eligible but not Offered' || list[index]['CourseStatus'] == 'Not Eligible and Not Offered' ? Colors.white : AppColors.primary,
        grade: list[index]['Grade'] == "" ? '-' : list[index]['Grade'],
        group: list[index]['Group'],
        courseCode: list[index]['CourseCode'],
        creditHour: list[index]['CourseCreditHours'].toString(),
        preReqs: list[index]['Prerequisite'],
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String courseCode;
  final String creditHour;
  final String grade;
  final String group;
  final String preReqs;

  CustomExpansionTile(
      {@required this.title,
      @required this.subtitle,
      @required this.iconColor,
      @required this.iconBackgroundColor,
      @required this.courseCode,
      @required this.creditHour,
      @required this.grade,
      @required this.group,
      @required this.preReqs});

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    // List<String> preReqsList = widget.preReqs
    //     .split(', ') // split the text into an array
    //     .map((String text) => text) // put the text inside a widget
    //     .toList();
    // print(preReqsList);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(widget.group, style: TextStyle(color: Color(0xffB89A5B))),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffFEFEFE),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ExpansionTile(
                      leading: Container(
                        height: 100,
                        width: 70,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: widget.iconBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: ImageIcon(AssetImage(Images.classUpdates), color: widget.iconColor),
                              ),
                            ),
                            Align(
                              alignment: Alignment(1, -0.8),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    widget.grade,
                                    style: TextStyle(color: widget.iconBackgroundColor),
                                  ),
                                ),
                                height: 18,
                                width: 27,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xffFEFEFE),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      trailing: Column(
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 1,
                          ),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            child: Text(widget.title),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            'Status: ${widget.subtitle}',
                            style: TextStyle(color: Color(0xff77869E)),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          height: 2,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            child: Text(
                              'Prerequisites',
                              style: TextStyle(
                                color: Color(0xff77869E),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.all(10),
                        //   height: 50,
                        // ),
                        widget.preReqs == ''
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('No Prerequisites'),
                              ))
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text(widget.preReqs, style: TextStyle(color: AppColors.primary))),
                              )
                        // Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: <Widget>[
                        //         Container(
                        //           child: Center(
                        //             child: Text(preReqsList[0],
                        //                 style: TextStyle(
                        //                     color: AppColors.primary)),
                        //           ),
                        //           height: 25,
                        //           width: 80,
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(5),
                        //             border: Border.all(
                        //                 color: AppColors.primary,
                        //                 width: 1.2),
                        //             color: Color(0xffFEFEFE),
                        //           ),
                        //         ),
                        //         preReqsList.length == 2
                        //             ? Container(
                        //                 child: Center(
                        //                   child: Text(preReqsList[1],
                        //                       style: TextStyle(
                        //                           color:
                        //                               AppColors.primary)),
                        //                 ),
                        //                 height: 25,
                        //                 width: 80,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(5),
                        //                   border: Border.all(
                        //                       color: AppColors.primary,
                        //                       width: 1.2),
                        //                   color: Color(0xffFEFEFE),
                        //                 ),
                        //               )
                        //             : Container(),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(1, 0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.courseCode,
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        color: Colors.white,
                        height: 2,
                      ),
                      Text(
                        'CH: ${widget.creditHour}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProgressCard extends StatelessWidget {
  final StudyPlanCourseCategory studyPlanCourseCategory;
  final List<StudyPlanCourse> studyPlanCourseList;

  ProgressCard({
    Key key,
    this.studyPlanCourseCategory,
    this.studyPlanCourseList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.studyPlanCourseCategory.completedCredits == 0) {
          Fluttertoast.showToast(msg: 'This course has 0 completed credits', toastLength: Toast.LENGTH_SHORT);
          return;
        }
        Get.to(StudyPlanCourseDetailPage(
          completedCredits: this.studyPlanCourseCategory.completedCredits.toString(),
          requiredCredits: this.studyPlanCourseCategory.requiredCredits.toString(),
          studyPlanCourseList: this.studyPlanCourseList,
          courseCategoryName: this.studyPlanCourseCategory.name
        ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: DS.width * 0.43,
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
                Text(
                  this.studyPlanCourseCategory.name,
                  style: TextStyle(
                    fontSize: DS.setSP(15),
                    color: const Color(0xff042c5c),
                    letterSpacing: 0.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SleekCircularSlider(
                    min: 0,
                    max: 100,
                    initialValue: (this.studyPlanCourseCategory.completedCredits / this.studyPlanCourseCategory.requiredCredits) * 100,
                    appearance: CircularSliderAppearance(
                      angleRange: 360,
                      startAngle: 160,
                      customWidths: CustomSliderWidths(
                        shadowWidth: 3,
                        progressBarWidth: 7,
                        handlerSize: 5,
                        trackWidth: 3,
                      ),
                      size: DS.setSP(160),
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
                            width: 20,
                            height: 40,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                this.studyPlanCourseCategory.completedCredits.toString(),
                                style: TextStyle(
                                  fontSize: DS.setSP(20),
                                  color: const Color(0xff042c5c),
                                  letterSpacing: 0.8509615516662598,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  fontSize: DS.setSP(20),
                                  color: const Color(0xff042c5c),
                                  letterSpacing: 0.8509615516662598,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                this.studyPlanCourseCategory.requiredCredits.toString(),
                                style: TextStyle(
                                  fontSize: DS.setSP(20),
                                  color: const Color(0xff042c5c),
                                  letterSpacing: 0.8509615516662598,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text(
                            'CH',
                            style: TextStyle(
                              fontSize: DS.setSP(14),
                              color: const Color(0xff77869e),
                              letterSpacing: 0.23,
                            ),
                          ),
                          // Text(
                          //   'out of 100',
                          //   style: TextStyle(
                          //     fontSize: DS.setSP(14),
                          //     color: const Color(0xff77869e),
                          //     letterSpacing: 0.23,
                          //   ),
                          // ),
                          SizedBox(
                            height: DS.setSP(20),
                          ),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.blueGrey,
                              size: 15,
                            ),
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
      ),
    );
  }
}
