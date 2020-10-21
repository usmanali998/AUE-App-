import 'package:aue/model/core_courses.dart';
import 'package:aue/model/elective_colleges.dart';
import 'package:aue/model/offered_elective_courses.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/registration/choose_course_timings.dart';
import 'package:aue/pages/tabs_view/registration/choose_elective_courses_time.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/course_tile.dart';
import 'package:aue/widgets/primary_tile.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';

class ElectiveCourses extends StatefulWidget {
  final completedCreditHour;
  final requiredCreditHour;

  ElectiveCourses({this.completedCreditHour, this.requiredCreditHour});
  // final categoryName;

  // CoreCourses({this.categoryName});

  @override
  _ElectiveCoursesState createState() => _ElectiveCoursesState();
}

class _ElectiveCoursesState extends State<ElectiveCourses> {
  List<ElectiveColleges> _electiveCollege = []; // Option 2
  String _selectedSemester;

  // List<CoreCoursesObj> coreCoursesList = [];
  List<OfferedElectiveCourses> offeredCoursesList = [];
  String _selectedOfferedCources;

  bool _isloading = false;
  var collegeId = 2;

  @override
  void initState() {
    super.initState();
    getElectiveCollege();
    getOfferedElectiveCourses();
  }

  getElectiveCollege() {
    Repository.getElectiveColleges().then((value) {
      print("This is elective College $value");
      _electiveCollege = value;

      setState(() {});
    }).whenComplete(() {
      _selectedSemester = _electiveCollege[0].name;
      // collegeId = _electiveCollege[0].collegeId;

      getOfferedElectiveCourses();
    });
  }

  getOfferedElectiveCourses() {
    _isloading = true;
    setState(() {});
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;

    Repository.getOfferedElectiveCorses(
            studentId: studentId, electiveCategoryId: 1, collegeId: collegeId)
        .then((value) {
      if (value.isNotEmpty) {
        print("this is value $value");
        offeredCoursesList = value;
      }
    }).whenComplete(() {
      print(offeredCoursesList);
      _selectedOfferedCources = offeredCoursesList[0].courseName;
      _isloading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return SecondaryBackgroundWidget(
      title: "Choose Elective Courses",
      image: Images.course_list,
      imageSize: Size(90, 90),
      listViewPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SELECT COLLEGE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontWeight: FontWeight.w200,
                      fontSize: DS.setSP(13),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.77,
                    child: DropdownButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: _selectedSemester,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSemester = newValue;
                          print("this is ontap value : $newValue");
                          // collegeId = newValue;
                        });
                      },
                      items: _electiveCollege.map((location) {
                        setState(() {});
                        return DropdownMenuItem(
                          child: InkWell(
                            onTap: () {
                              print(
                                  "this is loaction id : ${location.collegeId}");
                              collegeId = location.collegeId;
                              _selectedSemester = location.name;
                              getOfferedElectiveCourses();

                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text(
                              location.name,
                              style: TextStyle(
                                fontSize: DS.setSP(14),
                              ),
                            ),
                          ),
                          value: location.name,
                        );
                      }).toList(),
                    ),
                  ),
                  // Text(
                  //   "SELECT AVAILABLE COURSES",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: AppColors.blueGrey,
                  //     fontWeight: FontWeight.w100,
                  //     fontSize: DS.setSP(13),
                  //   ),
                  // ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.77,
                  //   child: DropdownButton(
                  //     isExpanded: true,
                  //     icon: Icon(Icons.keyboard_arrow_down),
                  //     value: _selectedOfferedCources,
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         _selectedOfferedCources = newValue;
                  //       });
                  //     },
                  //     items: offeredCoursesList.map((location) {
                  //       return DropdownMenuItem(
                  //         child: Text(
                  //           location.courseName,
                  //           style: TextStyle(
                  //             fontSize: DS.setSP(14),
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         value: location.courseName,
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                ],
              ),
              Container(
                height: 45,
                width: 50,
                // color: Colors.red,
                child: Stack(
                  children: <Widget>[
                    // ImageIcon(
                    //   AssetImage(Images.calander_icon),
                    //   color: AppColors.blueGrey,
                    //   size: 45,
                    // ),

                    Center(
                      child: Container(
                        height: 32,
                        width: 28,
                        child: Image.asset(
                          "images/briefcase.png",
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      left: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          cart.itemList.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "AVAILABLE ELECTIVE COURSES",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 25,
                // width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      width: 1, color: AppColors.primary.withOpacity(0.6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      child: Text(
                        widget.completedCreditHour.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "/",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.requiredCreditHour.toString(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 3),
                      child: Text(
                        " CH",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _isloading
            ? Container(
                height: DS.height * 0.37,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : offeredCoursesList.length <= 0
                ? Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25,
                    ),
                    child: Text(
                      "No offered elective courses found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: DS.setSP(16),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        ...coreCoureseWidget(),
                      ],
                    ),
                  ),
      ],
    );
  }

  List<Widget> coreCoureseWidget() {
    List<Widget> list = [];

    for (int i = 0; i < offeredCoursesList.length; i++) {
      list.add(
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => ChooseElectiveCourseTimings(
                          courseObj: offeredCoursesList[i],
                        )));
          },
          child: CourseTile(
            leadingIcon: Images.classUpdates,
            title: offeredCoursesList[i].courseName,
            subtitle: "Eligible and Offered",
            primary: false,
            courseCode: offeredCoursesList[i].courseCode,
            creditHour: offeredCoursesList[i].creditHours,
          ),
        ),
      );
    }
    return list;
  }
}
