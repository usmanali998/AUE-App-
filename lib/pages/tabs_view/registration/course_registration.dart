import 'package:aue/model/core_courses.dart';
import 'package:aue/model/course_categories.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/registration/core_course.dart';
import 'package:aue/pages/tabs_view/registration/elective_courses.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/res/utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CourseRegistration extends StatefulWidget {
  @override
  _CourseRegistrationState createState() => _CourseRegistrationState();
}

class _CourseRegistrationState extends State<CourseRegistration> {
  List<String> _semester = [
    'FALL SEMESTER 2020-2021',
  ]; // Option 2
  String _selectedSemester = 'FALL SEMESTER 2020-2021';

  // var courseCategoryList = List<CourseCategories>();
  List<CourseCategories> courseCategoryList = [];

  bool _isloading = false;

  var initialVal0 = 0.0;
  var initialVal1 = 0.0;
  var initialVal2 = 0.0;
  var initialVal3 = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCourseCategories();
  }

  getCourseCategories() {
    _isloading = true;
    setState(() {});
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;

    Repository.getCourseCategories(studentId: studentId).then((value) {
      if (value.isNotEmpty) {
        print("this is value $value");
        courseCategoryList = value;
      }
    }).whenComplete(() {
      print(courseCategoryList);
      _isloading = false;
      initialValue();
      if (mounted) setState(() {});
    });
  }

  initialValue() {
    int reqCr0 = courseCategoryList[0].required_credits;
    int compCr0 = courseCategoryList[0].completed_credits;

    if (reqCr0 == 0 && compCr0 == 0) {
      initialVal0 = 0.0;
      print('thiis is value $initialVal0');
    } else {
      initialVal0 = compCr0 / reqCr0 * 100;
    }

    int reqCr1 = courseCategoryList[1].required_credits;
    int compCr1 = courseCategoryList[1].completed_credits;
    if (reqCr1 == 0 && compCr1 == 0) {
      initialVal1 = 0.0;
      print('thiis is value $initialVal1');
    } else {
      initialVal1 = compCr1 / reqCr1 * 100;
    }

    int reqCr2 = courseCategoryList[2].required_credits;
    int compCr2 = courseCategoryList[2].completed_credits;
    if (reqCr2 == 0 && compCr2 == 0) {
      initialVal2 = 0.0;
      print('thiis is value $initialVal2');
    } else {
      initialVal2 = compCr2 / reqCr2 * 100;
    }

    int reqCr3 = courseCategoryList[3].required_credits;
    int compCr3 = courseCategoryList[3].completed_credits;
    if (reqCr3 == 0 && compCr3 == 0) {
      initialVal3 = 0.0;
      print('thiis is value $initialVal3');
    } else {
      initialVal3 = compCr3 / reqCr3 * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return SecondaryBackgroundWidget(
      title: "Course Registration",
      image: Images.course_list,
      imageSize: Size(90, 90),
      listViewPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SELECT SEMESTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontWeight: FontWeight.w100,
                      fontSize: DS.setSP(16),
                    ),
                  ),
                  DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: _selectedSemester,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSemester = newValue;
                      });
                    },
                    items: _semester.map((location) {
                      return DropdownMenuItem(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: DS.setSP(18),
                          ),
                        ),
                        value: location,
                      );
                    }).toList(),
                  ),
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
        SizedBox(height: 15),
        _isloading
            ? Container(
                height: DS.height * 0.35,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => CoreCourses(
                                          categoryName:
                                              "Choose General Education Courses",
                                          title: "General Education Courses",
                                          courseCategoryId:
                                              courseCategoryList[0]
                                                  .course_category_id,
                                          completedCreditHour:
                                              courseCategoryList[0]
                                                  .completed_credits,
                                          requiredCreditHour:
                                              courseCategoryList[0]
                                                  .required_credits,
                                          isGroupHeader: true,
                                        )));
                          },
                          child: ProgressCard(
                            title: courseCategoryList[0].name,
                            requiredCredits:
                                courseCategoryList[0].required_credits,
                            completedCredits:
                                courseCategoryList[0].completed_credits,
                            initialValue: initialVal0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => CoreCourses(
                                          categoryName: "Choose Core Courses",
                                          title: "Core Courses",
                                          courseCategoryId:
                                              courseCategoryList[1]
                                                  .course_category_id,
                                          completedCreditHour:
                                              courseCategoryList[1]
                                                  .completed_credits,
                                          requiredCreditHour:
                                              courseCategoryList[1]
                                                  .required_credits,
                                          isGroupHeader: false,
                                        )));
                          },
                          child: ProgressCard(
                            title: courseCategoryList[1].name,
                            requiredCredits:
                                courseCategoryList[1].required_credits,
                            completedCredits:
                                courseCategoryList[1].completed_credits,
                            initialValue: initialVal1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => CoreCourses(
                                          categoryName: "Choose Specialization",
                                          title: "Specialization Courses",
                                          courseCategoryId:
                                              courseCategoryList[2]
                                                  .course_category_id,
                                          completedCreditHour:
                                              courseCategoryList[2]
                                                  .completed_credits,
                                          requiredCreditHour:
                                              courseCategoryList[2]
                                                  .required_credits,
                                          isGroupHeader: false,
                                        )));
                          },
                          child: ProgressCard(
                            title: courseCategoryList[2].name,
                            requiredCredits:
                                courseCategoryList[2].required_credits,
                            completedCredits:
                                courseCategoryList[2].completed_credits,
                            initialValue: initialVal2,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => ElectiveCourses(
                                          completedCreditHour:
                                              courseCategoryList[3]
                                                  .completed_credits,
                                          requiredCreditHour:
                                              courseCategoryList[3]
                                                  .required_credits,
                                        )));
                          },
                          child: ProgressCard(
                              title: courseCategoryList[3].name,
                              requiredCredits:
                                  courseCategoryList[3].required_credits,
                              completedCredits:
                                  courseCategoryList[3].completed_credits,
                              initialValue: initialVal2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class ProgressCard extends StatelessWidget {
  String title;
  var requiredCredits;
  var completedCredits;
  double initialValue;

  ProgressCard({
    Key key,
    this.title,
    this.requiredCredits,
    this.completedCredits,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                title,
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
                  initialValue: initialValue,
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
                              completedCredits.toString(),
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
                              requiredCredits.toString(),
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
    );
  }
}
