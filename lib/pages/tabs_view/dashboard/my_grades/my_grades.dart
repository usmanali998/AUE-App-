import 'dart:async';
import 'dart:convert';
import 'package:aue/model/student_grades.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:http/http.dart' as http;

class MyGrades extends StatefulWidget {
  final StudentGrades studentGrades;

  MyGrades({this.studentGrades});

  @override
  _MyGradesState createState() => _MyGradesState();
}

class _MyGradesState extends State<MyGrades> {
  StudentGradesSemester _selectedSemester;
  List<StudentGradesSemester> _semesters = [];

  // List<Map<String, dynamic>> gradesData = [];
  // List<Map<String, dynamic>> filteredGradesData = [];

  // Future<void> getStudentGrades(String studentId) async {
  //   var url =
  //       "http://integrations.aue.ae/stdsvc/Student/GetStudentGrades?StudentID=$studentId";
  //   String username = 'mobileuser';
  //   String password = 'Auedev2020';
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   print(basicAuth);
  //
  //   Map<String, String> headers = {
  //     'content-type': 'application/json',
  //     'accept': 'application/json',
  //     'authorization': basicAuth
  //   };
  //   try {
  //     final response = await http.get(url, headers: headers);
  //     final responseJson = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       print(responseJson);
  //       for (int i = 0; i < responseJson['Table'].length; i++) {
  //         gradesData.add(responseJson['Table'][i]);
  //       }
  //       filteredGradesData = gradesData
  //           .where((element) => element['SemesterName'] == 'Fall 2017 - 2018')
  //           .toList();
  //
  //       print(gradesData);
  //     } else {
  //       return [];
  //     }
  //   } catch (error) {
  //     print(error);
  //     return [];
  //   }
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _semesters = widget.studentGrades.semesters;
    _selectedSemester = _semesters.first;
    // final studentId =
    //     Provider.of<AuthNotifier>(context, listen: false).user.studentID;
    // getStudentGrades(studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                const Spacer(),
                Text(
                  "My Grades",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(22),
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Visibility(
                  visible: false,
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ProgressCard(cgpa: _selectedSemester.cgpa, academicStanding: _selectedSemester.academicStanding),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: selectSemester(_selectedSemester.sgpa.toString()),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Courses(
                cardHeight: 110,
                cardWidth: MediaQuery.of(context).size.width,
                studentGradesDetail: widget.studentGrades.details
                    .where((StudentGradesDetail studentGradesDetail) => studentGradesDetail.semesterId == _selectedSemester.semesterId).toList()),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget selectSemester(String sgpa) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "SELECT SEMESTER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              Text(
                "SGPA: $sgpa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          DropdownButton<StudentGradesSemester>(
            icon: Icon(Icons.keyboard_arrow_down),
            value: _selectedSemester,
            onChanged: (newValue) {
              setState(() {
                _selectedSemester = newValue;

                // if (_selectedSemester == 'FALL SEMESTER 2020-2021') {
                //   filteredGradesData = gradesData
                //       .where((element) =>
                //           element['SemesterName'] == 'Fall 2017 - 2018')
                //       .toList();
                // } else {
                //   filteredGradesData = gradesData
                //       .where((element) =>
                //           element['SemesterName'] == 'Spring 2017 - 2018')
                //       .toList();
                // }
              });
            },
            items: _semesters.map((semester) {
              return DropdownMenuItem(
                child: Text(
                  semester.semesterName,
                  style: TextStyle(
                    color: Color(0xffB79959),
                    fontSize: DS.setSP(18),
                  ),
                ),
                value: semester,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatefulWidget {
  final double cgpa;
  final String academicStanding;

  ProgressCard({this.cgpa, this.academicStanding});

  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text('OVERALL CGPA'),
            SizedBox(height: 20),
            Expanded(
              child: SleekCircularSlider(
                min: 0,
                max: 4,
                initialValue: widget.cgpa,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.chartPie,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.academicStanding,
                        style: TextStyle(
                          fontSize: DS.setSP(14),
                          color: const Color(0xff77869e),
                          letterSpacing: 0.23,
                        ),
                      ),
                      Text(
                        widget.cgpa.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: DS.setSP(40),
                          color: const Color(0xff042c5c),
                          letterSpacing: 0.8509615516662598,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'out of 4.0 CGPA',
                        style: TextStyle(
                          fontSize: DS.setSP(14),
                          color: const Color(0xff77869e),
                          letterSpacing: 0.23,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Courses extends StatefulWidget {
  // final List<Map<String, dynamic>> studentCoursesData;
  final List<StudentGradesDetail> studentGradesDetail;
  final double cardHeight;
  final double cardWidth;

  Courses({this.cardHeight, this.cardWidth, this.studentGradesDetail});

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: widget.studentGradesDetail.length,
      itemBuilder: (context, index) {
        return _card(index);
      },
    );
  }

  Widget _card(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: widget.cardHeight,
        width: widget.cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: CircularPercentIndicator(
                progressColor: AppColors.primary,
                radius: 80.0,
                lineWidth: 5.0,
                percent: (widget.studentGradesDetail[index].gpa / 4.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${widget.studentGradesDetail[index].gpa}/4.0',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff042C5C), fontSize: 12),
                    ),
                    Text(
                      'GPA',
                      style: TextStyle(color: Color(0xff77869E), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 5 / 100,
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.studentGradesDetail[index].courseName,
                      style: TextStyle(color: AppColors.blackGrey, fontSize: 14, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: MediaQuery.of(context).size.height * 5 / 100,
                  width: MediaQuery.of(context).size.width * 45 / 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Grade: ${widget.studentGradesDetail[index].grade} | ${widget.studentGradesDetail[index].gradeTotal} %",
                        style: TextStyle(color: Color(0xff77869E), fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      Visibility(
                        visible: false,
                        child: Text(
                          'dgsdg',
                          style: TextStyle(color: Color(0xff77869E), fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
