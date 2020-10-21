import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DS {
  static double width;
  static double height;
  static double notch = ScreenUtil.statusBarHeight;
  static double bottomBar = ScreenUtil.bottomBarHeight;
  static Size mq = ScreenUtil.mediaQueryData.size;
  static setHeight(double height) => ScreenUtil.instance.setHeight(height);
  static setWidth(double width) => ScreenUtil.instance.setWidth(width);
  static setHeightRatio(double height) => ScreenUtil.instance
      .setHeight((DS.getHeight * height) - AppBar().preferredSize.height);
  static setWidthRatio(double width) =>
      ScreenUtil.instance.setWidth(DS.getWidth * width);

  static double getWidth = ScreenUtil.instance.width;
  static double getHeight = ScreenUtil.instance.height;
  static setSP(double size) => ScreenUtil.instance.setSp(size);
}
