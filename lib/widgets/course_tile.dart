import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class CourseTile extends StatelessWidget {
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

  const CourseTile({
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
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: borderradius),
              color: Colors.white,
              child: ListTile(
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
                              ? Border.all(width: 1, color: AppColors.primary)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          child: ImageIcon(
                            AssetImage(leadingIcon),
                            color: !primary ? Colors.white : AppColors.primary,
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
                title: Padding(
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
                subtitle: Padding(
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
