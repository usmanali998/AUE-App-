import 'package:aue/model/terms_condition.dart';
import 'package:aue/pages/tabs_view/registration/finance.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatefulWidget {
  @override
  _TermsAndConditionPageState createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  List<TermsCondition> termsList = [];

  bool isloading = false;

  @override
  initState() {
    super.initState();

    getTermsAndCondition();
  }

  getTermsAndCondition() {
    isloading = true;
    Repository.getTermsAndCondition().then((value) {
      termsList = value;
      setState(() {});
    }).whenComplete(() {
      isloading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: BackButton(
                  color: AppColors.primary,
                ),
              ),
              Text(
                "Read Terms",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: DS.setSP(18),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Visibility(
                visible: false,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: <Widget>[
              Container(
                height: DS.height * 0.75,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    // child: Column(
                    //   children: <Widget>[
                    child: isloading
                        ? Container(
                            height: DS.height * 0.75,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  termsList[0].title,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: DS.setSP(18),
                                  ),
                                ),
                                Text(
                                  termsList[0].content,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.w800,
                                    fontSize: DS.setSP(16),
                                  ),
                                ),
                              ],
                            ),
                          ),

                    //   ],
                    // ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(width: 2, color: AppColors.primary),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => Finance()));
                  },
                  child: Material(
                    elevation: 12,
                    shadowColor: Colors.black.withOpacity(0.36),
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Agree & Proceed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: DS.setSP(18),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          // color: Colors.red,
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 27,
                            width: 27,
                            child: Image.asset(
                              "images/circleArrow.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
