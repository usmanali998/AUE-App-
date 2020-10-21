import 'dart:convert';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudyPlans extends StatefulWidget {
  @override
  _StudyPlansState createState() => _StudyPlansState();
}

class _StudyPlansState extends State<StudyPlans> {
  List<Map<String, dynamic>> courseCategories = [];
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> generalEducation = [];
  List<Map<String, dynamic>> coreRequirements = [];
  List<Map<String, dynamic>> specializationRequirements = [];
  List<Map<String, dynamic>> electiveCourses = [];

  bool _loading = true;

  Future<void> getStudyPlans(String studentId) async {
    var url =
        "https://integrations.aue.ae/stdsvc/Student/GetStudyPlan?StudentID=$studentId";
    String username = 'mobileuser';
    String password = 'Auedev2020';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': basicAuth
    };
    try {
      courseCategories.clear();
      courses.clear();
      generalEducation.clear();
      coreRequirements.clear();
      specializationRequirements.clear();
      electiveCourses.clear();
      final response = await http.get(url, headers: headers);
      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        // print(responseJson);
        for (int i = 0; i < responseJson['CourseCategories'].length; i++) {
          courseCategories.add(responseJson['CourseCategories'][i]);
          courses.add(responseJson['Courses'][i]);
          if (responseJson['CourseCategories'][i]['Name'] ==
              'General Education') {
            for (int j = 0; j < responseJson['Courses'].length; j++) {
              if (responseJson['Courses'][j]['CourseCategoryID'] ==
                  responseJson['CourseCategories'][i]['CourseCategoryID']) {
                generalEducation.add(responseJson['Courses'][j]);
              }
            }
          }
          if (responseJson['CourseCategories'][i]['Name'] ==
              'Core Requirement') {
            for (int j = 0; j < responseJson['Courses'].length; j++) {
              if (responseJson['Courses'][j]['CourseCategoryID'] ==
                  responseJson['CourseCategories'][i]['CourseCategoryID']) {
                coreRequirements.add(responseJson['Courses'][j]);
              }
            }
          }
          if (responseJson['CourseCategories'][i]['Name'] ==
              'Specialization Requirement') {
            for (int j = 0; j < responseJson['Courses'].length; j++) {
              if (responseJson['Courses'][j]['CourseCategoryID'] ==
                  responseJson['CourseCategories'][i]['CourseCategoryID']) {
                specializationRequirements.add(responseJson['Courses'][j]);
              }
            }
          }
          if (responseJson['CourseCategories'][i]['Name'] ==
              'Elective Course') {
            for (int j = 0; j < responseJson['Courses'].length; j++) {
              if (responseJson['Courses'][j]['CourseCategoryID'] ==
                  responseJson['CourseCategories'][i]['CourseCategoryID']) {
                electiveCourses.add(responseJson['Courses'][j]);
              }
            }
          }
        }
        print("The Course Categories are");
        print(courseCategories);
        print("The Courses are");
        print(courses);
        print("The Courses of General Education are");
        print(generalEducation);
        print("The Courses of Core Requirements are");
        print(coreRequirements);
      } else {
        print('response not found');
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;
    getStudyPlans(studentId);
  }

  List<Widget> loader = [LoadingWidget()];

  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Study Plans",
      image: Images.course_list,
      imageSize: Size(90, 90),
      listViewPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      children: _loading
          ? loader
          : <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    courseCategories[0]['Name'],
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
                        '${courseCategories[0]['CompletedCredits']}/${courseCategories[0]['RequiredCredits']} CH',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 20),
              _listView(generalEducation),
              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    courseCategories[1]['Name'],
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
                        '${courseCategories[1]['CompletedCredits']}/${courseCategories[1]['RequiredCredits']} CH',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 20),
              _listView(coreRequirements),

              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    courseCategories[2]['Name'],
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
                        '${courseCategories[2]['CompletedCredits']}/${courseCategories[2]['RequiredCredits']} CH',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 20),
              _listView(specializationRequirements),

              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    courseCategories[3]['Name'],
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
                        '${courseCategories[3]['CompletedCredits']}/${courseCategories[3]['RequiredCredits']} CH',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 20),
              _listView(electiveCourses),

              SizedBox(height: 30)
            ],
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
        iconColor: list[index]['CourseStatus'] == 'Eligible but not Offered' ||
                list[index]['CourseStatus'] == 'Not Eligible and Not Offered'
            ? AppColors.primary
            : Colors.white,
        iconBackgroundColor: list[index]['CourseStatus'] ==
                    'Eligible but not Offered' ||
                list[index]['CourseStatus'] == 'Not Eligible and Not Offered'
            ? Colors.white
            : AppColors.primary,
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
    List<String> preReqsList = widget.preReqs
        .split(', ') // split the text into an array
        .map((String text) => text) // put the text inside a widget
        .toList();
    print(preReqsList);
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
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(widget.preReqs,
                                        style: TextStyle(
                                            color: AppColors.primary))),
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
