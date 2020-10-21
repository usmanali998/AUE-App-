import 'package:aue/model/core_courses.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/registration/choose_course_timings.dart';
import 'package:aue/pages/tabs_view/registration/terms_condition.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/course_tile.dart';
import 'package:aue/widgets/primary_tile.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:aue/widgets/selected_course_expension_tile.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  // final categoryName;

  // CoreCourses({this.categoryName});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CoreCoursesObj> coreCoursesList = [];

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    // getCoreCourses();
  }

  getCoreCourses() {
    _isloading = true;
    setState(() {});
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;

    Repository.getCoreCourese().then((value) {
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
      title: "Selected Courses",
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
                "ALL SELECTED COURSES & SCHEDULES",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: DS.setSP(14),
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
        SizedBox(height: 16),
        _isloading
            ? Container(
                height: DS.height * 0.37,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    ...coreCoureseWidget(cart),
                  ],
                ),
              ),
        cart.itemList.length <= 0
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: AppColors.primary)),
                  child: InkWell(
                    onTap: () {
                      Repository.saveSelectedCourses().then((value) {
                        print("courses Save Successfully");
                      }).whenComplete(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => TermsAndConditionPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Proceed To Payment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: DS.setSP(18),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  List<Widget> coreCoureseWidget(Cart cart) {
    List<Widget> list = [];

    for (int i = 0; i < cart.itemList.length; i++) {
      list.add(
        InkWell(
          onTap: () {},
          child: SelectedCourseExpensionTile(
            leadingIcon: Images.classUpdates,
            title: cart.itemList[i].courseName,
            subtitle: cart.itemList[i].name,
            primary: false,
            courseCode: cart.itemList[i].courseCode,
            creditHour: cart.itemList[i].courseCreditHours,
            faculty: cart.itemList[i].faculty,
            monday: cart.itemList[i].monday,
            tuesday: cart.itemList[i].tuesday,
            wednesday: cart.itemList[i].wednesday,
            thursday: cart.itemList[i].thursday,
            friday: cart.itemList[i].friday,
            saturday: cart.itemList[i].saturday,
            sunday: cart.itemList[i].sunday,
            imageUrl: cart.itemList[i].imageThumbnail,
            index: i,
          ),
        ),
      );
    }
    return list;
  }
}
