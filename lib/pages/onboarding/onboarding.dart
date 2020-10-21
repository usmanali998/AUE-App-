import 'package:aue/pages/auth/login.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                height: DS.height * 0.3,
                child: BottomSheet(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    controller = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              currentIndex = index;
              setState(() {});
            },
            children: [
              OnBoardingItem(),
              OnBoardingItem(),
              OnBoardingItem(),
            ],
          ),
        ),
        Container(
          height: DS.getHeight * 0.025,
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              bool current = currentIndex == index;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: current ? DS.getHeight * 0.012 : DS.getHeight * 0.008,
                height: current ? DS.getHeight * 0.012 : DS.getHeight * 0.008,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: current ? AppColors.primary : Colors.black12,
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 6),
        PrimaryButton(
          width: double.infinity,
          text: "Login",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LoginPage(),
              ),
            );
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Text(
        //         "SKIP",
        //         style: TextStyle(
        //           color: AppColors.blueGrey,
        //           fontWeight: FontWeight.w700,
        //           fontSize: DS.setSP(13),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(height: 8),
        Expanded(
          child: Image.asset(
            Images.phone,
          ),
        ),
        SizedBox(height: DS.height * 0.125),
      ],
    );
  }
}

class OnBoardingItem extends StatelessWidget {
  final String title;
  final String description;

  const OnBoardingItem({
    Key key,
    this.title = "In hac habitasse platea dictumst.",
    this.description =
        "Donec facilisis tortor ut augue lacinia, at viverra est semper.",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DS.setSP(42)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(flex: 1),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: DS.setSP(18),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: DS.setSP(13),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
