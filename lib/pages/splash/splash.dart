import 'package:aue/res/res.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            right: -mq.width * 0.1,
            top: -mq.height * 0.22,
            child: Container(
              width: mq.width * 0.75,
              height: mq.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.75),
              ),
            ),
          ),
          Positioned(
            right: -mq.width * 0.35,
            top: -mq.height * 0.15,
            child: Container(
              width: mq.width * 0.75,
              height: mq.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.75),
              ),
            ),
          ),
          Positioned(
            left: -mq.width * 0.1,
            bottom: -mq.height * 0.28,
            child: Container(
              width: mq.width * 0.75,
              height: mq.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.75),
              ),
            ),
          ),
          Positioned(
            left: -mq.width * 0.35,
            bottom: -mq.height * 0.2,
            child: Container(
              width: mq.width * 0.75,
              height: mq.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.75),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              Images.logo,
              width: mq.width * 0.65,
              height: mq.height * 0.65,
            ),
          )
        ],
      ),
    );
  }
}
