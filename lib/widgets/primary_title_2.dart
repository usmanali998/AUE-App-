import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class PrimaryTile2 extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final String trailingText;
  final bool primary;
  final bool isTrailingHollow;
  final Widget trailingWidget;
  final EdgeInsets padding;
  final EdgeInsets trailingPadding;
  final VoidCallback onTap;

  const PrimaryTile2({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.trailingText,
    this.primary = true,
    this.isTrailingHollow = true,
    this.trailingWidget,
    this.padding,
    this.trailingPadding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderradius = BorderRadius.circular(8);
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: borderradius),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: this.leading,
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xff042C5C),
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black54,
              fontSize: DS.setSP(13),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
