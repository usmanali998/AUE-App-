import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class IconTextBox extends StatelessWidget {
  final String icon;
  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  const IconTextBox({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryLight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon == null
                ? Icon(
                    iconData,
                    color: AppColors.primary,
                  )
                : ImageIcon(
                    AssetImage(icon),
                    color: AppColors.primary,
                  ),
            Text(
              text,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
