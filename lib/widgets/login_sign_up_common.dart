import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class LoginSingupCommon extends StatelessWidget {
  final String headline;
  final List<Widget> children;
  final String image;

  const LoginSingupCommon({
    Key key,
    @required this.headline,
    @required this.children,
    @required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IconButton(
        //   padding: EdgeInsets.all(24),
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: AppColors.primary,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline ?? "",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      fontSize: DS.setSP(32),
                    ),
                  ),
                  SizedBox(height: DS.height * 0.05),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: DS.width * 0.2,
                      height: DS.width * 0.2,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(image),
                    ),
                  ),
                  SizedBox(height: 24),
                  ...children,
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
