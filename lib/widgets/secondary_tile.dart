import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class SecondaryTile extends StatelessWidget {
  final String icon;
  final String text;
  final TextStyle style;
  final bool isImageAsset;
  final bool showTrailing;
  final VoidCallback onTap;
  const SecondaryTile({
    Key key,
    this.icon,
    this.text,
    this.style,
    this.isImageAsset = false,
    this.showTrailing = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: this.isImageAsset ? Image.asset(icon) : ImageIcon(
                AssetImage(icon),
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: style ??
                    TextStyle(
                      color: AppColors.primary,
                      fontSize: DS.setSP(14),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (showTrailing)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.chevron_right, color: Colors.black26),
                    SizedBox(width: 4),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
