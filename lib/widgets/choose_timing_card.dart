import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class ChooseTimingCard extends StatelessWidget {
  final String leadingIcon;
  final String leadingIconBadge;
  final String title;
  final String subtitle;
  final Widget trailing;
  final String trailingText;
  final bool primary;
  final bool isTrailingHollow;
  final Widget trailingWidget;
  final EdgeInsets padding;
  final EdgeInsets trailingPadding;
  final String courseCode;
  final int creditHour;

  const ChooseTimingCard({
    Key key,
    this.leadingIcon,
    this.leadingIconBadge,
    this.title,
    this.subtitle,
    this.trailing,
    this.trailingText,
    this.primary = true,
    this.isTrailingHollow = true,
    this.trailingWidget,
    this.padding,
    this.trailingPadding,
    this.courseCode,
    this.creditHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderradius = BorderRadius.circular(8);
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
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
                              color: primary ? Colors.white : AppColors.primary,
                              borderRadius: borderradius,
                              border: primary
                                  ? Border.all(
                                      width: 1, color: AppColors.primary)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              child: ImageIcon(
                                AssetImage(leadingIcon),
                                color:
                                    !primary ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              // margin: EdgeInsets.only(top: 5),
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
                        title,
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
                        "Status: " + subtitle,
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
                  // SizedBox(height: 20),
                  Container(
                    height: 2,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    // height: 200,
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                          child: Text(
                            "choose Timings",
                            style: TextStyle(
                              fontSize: DS.setSP(15),
                              color: AppColors.blueGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // timingCard(),
                        // timingCard(context),
                        // timingCard(),
                      ],
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
                          courseCode,
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
                            creditHour.toString(),
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
    );
  }
}
