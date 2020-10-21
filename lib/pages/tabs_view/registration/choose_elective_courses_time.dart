import 'package:aue/model/core_courses.dart';
import 'package:aue/model/course_timings.dart';
import 'dart:convert';
import 'package:aue/model/offered_elective_courses.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/registration/cart.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';

class ChooseElectiveCourseTimings extends StatefulWidget {
  final OfferedElectiveCourses courseObj;

  ChooseElectiveCourseTimings({this.courseObj});

  @override
  _ChooseElectiveCourseTimingsState createState() =>
      _ChooseElectiveCourseTimingsState();
}

class _ChooseElectiveCourseTimingsState
    extends State<ChooseElectiveCourseTimings> {
  List<CourseTiming> courseTimingList = [];

  bool _isloading = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    getCourseTimings();
  }

  getCourseTimings() {
    _isloading = true;
    setState(() {});
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;
    // final semesterId = Provider.of<AuthNotifier>(context, listen: false)
    //     .user
    //     .currentSemester
    //     .semesterID;

    // print("Semester id is : $semesterId");

    Repository.getCourseTimings(
            studentId: studentId, courseCode: widget.courseObj.courseCode)
        .then((value) {
      if (value.isNotEmpty) {
        print("this is value $value");
        courseTimingList = value;
      }
    }).whenComplete(() {
      print(courseTimingList);
      _isloading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final borderradius = BorderRadius.circular(8);
    return SecondaryBackgroundWidget(
      title: "Choose Elective Courses",
      image: Images.course_list,
      imageSize: Size(90, 90),
      listViewPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ELECTIVE COURSES",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: DS.setSP(16),
                ),
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
        _isloading
            ? Container(
                height: DS.height * 0.37,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Material(
                          elevation: 5,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 65,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: borderradius,
                                        ),
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: ImageIcon(
                                              AssetImage(Images.classUpdates),
                                              color: Colors.white),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 25,
                                          width: 35,
                                          child: Image.asset(
                                            'images/a_badge.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(right: 52),
                                  child: Text(
                                    widget.courseObj.courseName,
                                    style: TextStyle(
                                      color: Color(0xff042C5C),
                                      fontSize: DS.setSP(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "Status: " + "Eligible and Offered",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.blueGrey,
                                      fontSize: DS.setSP(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 2,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 5, left: 10, bottom: 0),
                                      child: Text(
                                        "choose Timings",
                                        style: TextStyle(
                                          fontSize: DS.setSP(15),
                                          color: AppColors.blueGrey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // ...courseTimingWidget(),
                                    Container(
                                      // color: Colors.red,
                                      height: courseTimingList.length <= 1
                                          ? MediaQuery.of(context).size.height *
                                              0.15
                                          : MediaQuery.of(context).size.height *
                                              0.31,
                                      // color: Colors.red,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: courseTimingList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            // color: Colors.pink,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.14,
                                            // color: Colors.amber,
                                            child: Material(
                                              elevation: 5,
                                              shadowColor: Colors.black12,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 4,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        // color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.memory(
                                                          base64Decode(
                                                              courseTimingList[
                                                                      index]
                                                                  .imageThumbnail),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 7,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      // color: Colors.blue,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            SizedBox(height: 5),
                                                            Text(
                                                              courseTimingList[
                                                                      index]
                                                                  .faculty,
                                                              style: TextStyle(
                                                                fontSize: DS
                                                                    .setSP(16),
                                                                color: Color(
                                                                    0xff042C5C),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            courseTimingList[
                                                                            index]
                                                                        .monday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "THU - ${courseTimingList[index].monday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                            courseTimingList[
                                                                            index]
                                                                        .tuesday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "TUE - ${courseTimingList[index].tuesday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                            courseTimingList[
                                                                            index]
                                                                        .wednesday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "WED - ${courseTimingList[index].wednesday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                            courseTimingList[
                                                                            index]
                                                                        .thursday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "THU - ${courseTimingList[index].thursday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                            courseTimingList[
                                                                            index]
                                                                        .friday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "FRI - ${courseTimingList[index].friday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                            courseTimingList[
                                                                            index]
                                                                        .saturday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "SAT - ${courseTimingList[index].saturday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                            courseTimingList[
                                                                            index]
                                                                        .sunday ==
                                                                    null
                                                                ? Container()
                                                                : Text(
                                                                    "SUN - ${courseTimingList[index].sunday}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          DS.setSP(
                                                                              13),
                                                                      color: AppColors
                                                                          .blueGrey,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10, top: 10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            _selectedIndex =
                                                                index;
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                _selectedIndex ==
                                                                        index
                                                                    ? BoxDecoration(
                                                                        color: AppColors
                                                                            .primary,
                                                                        borderRadius:
                                                                            BorderRadius.circular(30),
                                                                      )
                                                                    : BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(30),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColors.primary,
                                                                        ),
                                                                      ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  height: 30,
                                  child: Material(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: FlatButton(
                                      onPressed: () {
                                        cart.addItem(
                                          courseCode:
                                              widget.courseObj.courseCode,
                                          courseName:
                                              widget.courseObj.courseName,
                                          name: "Eligible and Offered",
                                          courseCreditHour:
                                              widget.courseObj.creditHours,
                                          faculty:
                                              courseTimingList[_selectedIndex]
                                                  .faculty,
                                          mon: courseTimingList[_selectedIndex]
                                              .monday,
                                          tue: courseTimingList[_selectedIndex]
                                              .tuesday,
                                          wed: courseTimingList[_selectedIndex]
                                              .wednesday,
                                          thu: courseTimingList[_selectedIndex]
                                              .thursday,
                                          fri: courseTimingList[_selectedIndex]
                                              .friday,
                                          sat: courseTimingList[_selectedIndex]
                                              .saturday,
                                          sun: courseTimingList[_selectedIndex]
                                              .sunday,
                                          imageThumbnail:
                                              courseTimingList[_selectedIndex]
                                                  .imageThumbnail,
                                        );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) => CartScreen()));
                                      },
                                      color: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Save Selection & Close",
                                        style: TextStyle(
                                          fontSize: DS.setSP(15),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: DS.height * 0.05,
                          width: DS.width * 0.18,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  // color: Colors.green,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.courseObj.courseCode,
                                      style: TextStyle(
                                        fontSize: DS.setSP(13),
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "CH:",
                                        style: TextStyle(
                                          fontSize: DS.setSP(13),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        widget.courseObj.creditHours.toString(),
                                        style: TextStyle(
                                          fontSize: DS.setSP(13),
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 14,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
