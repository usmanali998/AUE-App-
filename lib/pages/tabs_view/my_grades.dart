import 'dart:async';
import 'dart:convert';
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
  final double cpga;
  MyGrades({this.cpga});
  @override
  _MyGradesState createState() => _MyGradesState();
}

class _MyGradesState extends State<MyGrades> {
  bool _loading = true;
  String _selectedSemester = 'FALL SEMESTER 2020-2021';
  List<String> _semester = [
    'FALL SEMESTER 2020-2021',
    'SPRING SEMESTER 2020-2021',
  ];

  List<Map<String, dynamic>> gradesData = [];
  List<Map<String, dynamic>> filteredGradesData = [];

  Future<void> getStudentGrades(String studentId) async {
    var url =
        "http://integrations.aue.ae/stdsvc/Student/GetStudentGrades?StudentID=$studentId";
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
      final response = await http.get(url, headers: headers);
      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseJson);
        for (int i = 0; i < responseJson['Table'].length; i++) {
          gradesData.add(responseJson['Table'][i]);
        }
        filteredGradesData = gradesData
            .where((element) => element['SemesterName'] == 'Fall 2017 - 2018')
            .toList();

        print(gradesData);
      } else {
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
    getStudentGrades(studentId);
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
                Expanded(
                  child: Text(
                    "My Grades",
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
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ProgressCard(cgpa: widget.cpga),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: selectSemester(),
          ),
          SizedBox(height: 16),
          _loading
              ? Container(
                  height: MediaQuery.of(context).size.width * 30 / 100,
                  child: Center(child: LoadingWidget()),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Courses(
                    cardHeight: 130,
                    cardWidth: MediaQuery.of(context).size.width,
                    studentCoursesData: filteredGradesData,
                  ),
                ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget selectSemester() {
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
                  fontWeight: FontWeight.w100,
                  fontSize: 13,
                ),
              ),
              Text(
                "GPA SCALE : 0.0 - 4.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w100,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          DropdownButton(
            icon: Icon(Icons.keyboard_arrow_down),
            value: _selectedSemester,
            onChanged: (newValue) {
              setState(() {
                _selectedSemester = newValue;

                if (_selectedSemester == 'FALL SEMESTER 2020-2021') {
                  filteredGradesData = gradesData
                      .where((element) =>
                          element['SemesterName'] == 'Fall 2017 - 2018')
                      .toList();
                } else {
                  filteredGradesData = gradesData
                      .where((element) =>
                          element['SemesterName'] == 'Spring 2017 - 2018')
                      .toList();
                }
              });
              print(_selectedSemester);
            },
            items: _semester.map((location) {
              return DropdownMenuItem(
                child: Text(
                  location,
                  style: TextStyle(
                    color: Color(0xffB79959),
                    fontSize: DS.setSP(18),
                  ),
                ),
                value: location,
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

  ProgressCard({this.cgpa});

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
                        'Total',
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
  final List<Map<String, dynamic>> studentCoursesData;
  final double cardHeight;
  final double cardWidth;
  Courses({this.cardHeight, this.cardWidth, this.studentCoursesData});
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.studentCoursesData.length,
        itemBuilder: (context, index) {
          return _card(index);
        },
      ),
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
                percent: (widget.studentCoursesData[index]['GPA'] / 4.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${widget.studentCoursesData[index]['GPA']}/4.0',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff042C5C),
                          fontSize: 12),
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
                      widget.studentCoursesData[index]['CourseName'],
                      style: TextStyle(color: Color(0xff042C5C), fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 9 / 100,
                  width: MediaQuery.of(context).size.width * 45 / 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Grade: ${widget.studentCoursesData[index]['Grade']} | GPA: ${widget.studentCoursesData[index]['GPA']} | CGPA: 4.00",
                        style:
                            TextStyle(color: Color(0xff77869E), fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.studentCoursesData[index]['AcademicStanding'],
                        style:
                            TextStyle(color: Color(0xff77869E), fontSize: 12),
                        textAlign: TextAlign.left,
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
