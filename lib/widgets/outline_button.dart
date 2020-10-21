import 'package:flutter/material.dart';

class OutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const OutlinedButton({
    Key key,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black54, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(vertical: 14),
      onPressed: onTap ?? () {},
      color: Colors.transparent,
      child: Text(
        text,
        // style: Theme.of(context).textTheme.bodyText1.copyWith(
        //       color: AppColors.blueGrey,
        //     ),
      ),
    );
  }
}
