import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class PrimaryTile extends StatelessWidget {
  final String leadingIcon;
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

  const PrimaryTile({
    Key key,
    this.leadingIcon,
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
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
      child: Material(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: borderradius),
        color: Colors.white,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary ? AppColors.primaryLight : AppColors.primary,
              borderRadius: borderradius,
            ),
            alignment: Alignment.center,
            child: ImageIcon(
              AssetImage(leadingIcon),
              color: !primary ? Colors.white : AppColors.primary,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: DS.setSP(18),
              fontWeight: FontWeight.w600,
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
          trailing: trailing ??
              Container(
                padding: trailingPadding ?? EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: isTrailingHollow
                      ? Border.all(
                          color: AppColors.primary,
                          width: 2,
                        )
                      : null,
                  color:
                      isTrailingHollow ? Colors.transparent : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: trailingWidget ??
                    Text(
                      trailingText ?? "",
                      style: TextStyle(
                        color:
                            isTrailingHollow ? AppColors.primary : Colors.white,
                        fontSize: DS.setSP(17),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ),
        ),
      ),
    );
  }
}
