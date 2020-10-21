import 'dart:convert';

import 'package:aue/model/core_courses.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class SelectedCourseExpensionTile extends StatefulWidget {
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
  final String faculty;
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;
  final String imageUrl;
  final int index;

  const SelectedCourseExpensionTile({
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
    this.faculty,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.imageUrl,
    this.index,
  }) : super(key: key);

  @override
  _SelectedCourseExpensionTileState createState() =>
      _SelectedCourseExpensionTileState();
}

class _SelectedCourseExpensionTileState
    extends State<SelectedCourseExpensionTile> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final borderradius = BorderRadius.circular(8);
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: borderradius),
              color: Colors.white,
              child: ExpansionTile(
                leading: Container(
                  height: 50,
                  width: 65,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color:
                              widget.primary ? Colors.white : AppColors.primary,
                          borderRadius: borderradius,
                          border: widget.primary
                              ? Border.all(width: 1, color: AppColors.primary)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          child: ImageIcon(
                            AssetImage(widget.leadingIcon),
                            color: !widget.primary
                                ? Colors.white
                                : AppColors.primary,
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
                    widget.title,
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
                    "Status: " + widget.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontSize: DS.setSP(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 3),
                        child: Text(
                          "Timing",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                        // width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              width: 1,
                              color: AppColors.primary.withOpacity(0.6)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                cart.removeItem(widget.index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 3, right: 3),
                                child: Text(
                                  "remove",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  timingCard(
                    context,
                    name: widget.faculty,
                    mon: widget.monday,
                    tue: widget.tuesday,
                    wed: widget.wednesday,
                    thu: widget.thursday,
                    fri: widget.friday,
                    sat: widget.saturday,
                    sun: widget.sunday,
                    image: widget.imageUrl,
                  )
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
                          widget.courseCode,
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
                            widget.creditHour.toString(),
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

  Widget timingCard(
    context, {
    var name,
    var mon,
    var tue,
    var wed,
    var thu,
    var fri,
    var sat,
    var sun,
    var image,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: MediaQuery.of(context).size.height * 0.14,
      // color: Colors.amber,
      child:
          //  Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          // Container(
          //   margin: EdgeInsets.only(top: 5, left: 10, bottom: 5),
          //   child: Text(
          //     "choose Timings",
          //     style: TextStyle(
          //       fontSize: DS.setSP(15),
          //       color: AppColors.blueGrey,
          //     ),
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
          Material(
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.memory(
                    base64Decode(widget.imageUrl),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: DS.setSP(16),
                          color: Color(0xff042C5C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      mon == null
                          ? Container()
                          : Text(
                              "Mon - $mon",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      tue == null
                          ? Container()
                          : Text(
                              "TUE - $tue",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      wed == null
                          ? Container()
                          : Text(
                              "WED - $wed",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      thu == null
                          ? Container()
                          : Text(
                              "THU - $thu",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      fri == null
                          ? Container()
                          : Text(
                              "FRI - $fri",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      sat == null
                          ? Container()
                          : Text(
                              "SAT - $sat",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      sun == null
                          ? Container()
                          : Text(
                              "SUN - $sun",
                              style: TextStyle(
                                fontSize: DS.setSP(13),
                                color: AppColors.blueGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                        // border: Border.all(
                        //   width: 2,
                        //   color: AppColors.primary,
                        // )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //   ],
      // ),
    );
  }
}
