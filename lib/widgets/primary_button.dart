import 'package:aue/notifiers/base_notifier.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class PrimaryButton extends StatelessWidget {
  final ViewState viewState;
  final String text;
  final VoidCallback onTap;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  const PrimaryButton({
    Key key,
    this.viewState = ViewState.Idle,
    @required this.text,
    this.onTap,
    this.margin,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewState == ViewState.Busy) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.5),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.symmetric(horizontal: 16),
      child: MaterialButton(
        minWidth: width,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: padding ?? EdgeInsets.symmetric(vertical: 14),
        onPressed: onTap ?? () {},
        color: AppColors.primary,
        child: Text(
          text,
          style: TextStyle(
            fontSize: DS.setSP(18),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
