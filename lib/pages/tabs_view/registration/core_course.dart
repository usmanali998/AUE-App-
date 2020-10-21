import 'package:aue/model/core_courses.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/registration/choose_course_timings.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/course_tile.dart';
import 'package:aue/widgets/primary_tile.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';

class CoreCourses extends StatefulWidget {
  final categoryName;
  final title;
  final courseCategoryId;
  final requiredCreditHour;
  final completedCreditHour;
  final isGroupHeader;

  CoreCourses({
    this.categoryName,
    this.title,
    this.courseCategoryId,
    this.requiredCreditHour,
    this.completedCreditHour,
    this.isGroupHeader,
  });

  @override
  _CoreCoursesState createState() => _CoreCoursesState();
}

class _CoreCoursesState extends State<CoreCourses> {
  List<CoreCoursesObj> coreCoursesList = [];

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    getCoreCourses();
  }

  getCoreCourses() {
    _isloading = true;
    setState(() {});
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;

    Repository.getCoreCourese(
            studentId: studentId, categoryId: widget.courseCategoryId)
        .then((value) {
      if (value.isNotEmpty) {
        print("this is value $value");
        coreCoursesList = value;
      }
    }).whenComplete(() {
      print(coreCoursesList);
      _isloading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return SecondaryBackgroundWidget(
      title: widget.categoryName,
      image: Images.course_list,
      imageSize: Size(90, 90),
      listViewPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(16),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(width: 10),
                  ImageIcon(
                    AssetImage(Images.regulation),
                    color: AppColors.blueGrey,
                    size: 23,
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
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.isGroupHeader
                  ? _isloading
                      ? Container()
                      : Text(
                          coreCoursesList[0].groupHeader,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                  : Text(
                      "Offered Courses",
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
            : coreCoursesList.length <= 0
                ? Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25,
                    ),
                    child: Text(
                      "No eligible offered courses found",
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

    for (int i = 0; i < coreCoursesList.length; i++) {
      list.add(
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => ChooseCourseTiming(
                          courseObj: coreCoursesList[i],
                          title: widget.title,
                          categoryName: widget.categoryName,
                        )));
          },
          child: CourseTile(
            leadingIcon: Images.classUpdates,
            title: coreCoursesList[i].courseName,
            subtitle: coreCoursesList[i].name,
            primary: false,
            courseCode: coreCoursesList[i].courseCode,
            creditHour: coreCoursesList[i].courseCreditHours,
          ),
        ),
      );
    }
    return list;
  }
}
