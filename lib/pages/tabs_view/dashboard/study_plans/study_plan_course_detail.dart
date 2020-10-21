import 'package:aue/model/study_plan.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class StudyPlanCourseDetailPage extends StatelessWidget {
  final String requiredCredits;
  final String completedCredits;
  final String courseCategoryName;
  final List<StudyPlanCourse> studyPlanCourseList;

  const StudyPlanCourseDetailPage({
    this.studyPlanCourseList,
    this.requiredCredits,
    this.completedCredits,
    this.courseCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Study Plans',
      showBackButton: true,
      image: Images.studyPlans,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.courseCategoryName,
              style: TextStyle(fontSize: 15, color: Color(0xff77869E)),
            ),
            Container(
              width: 80,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
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
                child: Text(
                  '${this.completedCredits}/${this.requiredCredits} CH',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: this.studyPlanCourseList.length,
          itemBuilder: (context, index) => CustomExpansionTile(
            title: this.studyPlanCourseList[index].courseName,
            subtitle: this.studyPlanCourseList[index].courseStatus,
            iconColor: this.studyPlanCourseList[index].courseStatus ==
                        'Eligible but not Offered' ||
                    this.studyPlanCourseList[index].courseStatus ==
                        'Not Eligible and Not Offered'
                ? AppColors.primary
                : Colors.white,
            iconBackgroundColor: this.studyPlanCourseList[index].courseStatus ==
                        'Eligible but not Offered' ||
                    this.studyPlanCourseList[index].courseStatus ==
                        'Not Eligible and Not Offered'
                ? Colors.white
                : AppColors.primary,
            grade: this.studyPlanCourseList[index].grade == ""
                ? '-'
                : this.studyPlanCourseList[index].grade,
            group: this.studyPlanCourseList[index].group,
            courseCode: this.studyPlanCourseList[index].courseCode,
            creditHour:
                this.studyPlanCourseList[index].courseCreditHours.toString(),
            preReqs: this.studyPlanCourseList[index].prerequisite,
          ),
        )
      ],
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
    List<String> preReqsList = widget.preReqs
        .split(', ') // split the text into an array
        .map((String text) => text) // put the text inside a widget
        .toList();
    print(preReqsList);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        // SizedBox(height: 10),
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
                                child: ImageIcon(
                                    AssetImage(Images.classUpdates),
                                    color: widget.iconColor),
                              ),
                            ),
                            Align(
                              alignment: Alignment(1, -0.8),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    widget.grade,
                                    style: TextStyle(
                                        color: widget.iconBackgroundColor),
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
                            : Wrap(
                                children: preReqsList
                                    .map(
                                      (String text) => Chip(
                                        label: Text(text, style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        )),
                                        padding: const EdgeInsets.all(0.0),
                                        labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        backgroundColor: Colors.transparent,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
                                          side: const BorderSide(color: AppColors.primary, width: 1.2),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                spacing: 10,
                              )
                        // : Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Center(
                        //       child: Text(
                        //         widget.preReqs,
                        //         style: TextStyle(color: AppColors.primary),
                        //       ),
                        //     ),
                        //   )
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
