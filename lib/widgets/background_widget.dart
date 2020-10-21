import 'dart:math';

import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundWidget extends StatefulWidget {
  final List<Widget> children;
  const BackgroundWidget({
    Key key,
    this.children,
  }) : super(key: key);

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  ScrollController controller;
  double height = DS.getHeight * 0.4;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChangeNotifierProvider(
          create: (context) => ScrollNotifier(controller),
          child: Consumer(
            builder: (context, ScrollNotifier notifier, child) {
              return Container(
                height: max(DS.getHeight * 0.425 - notifier.offset, DS.getHeight * 0.05),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: ListView(
            cacheExtent: 1000,
            controller: controller,
            children: widget.children,
          ),
        )
      ],
    );
  }
}

class ScrollNotifier with ChangeNotifier {
  final ScrollController controller;

  double offset = 0.0;

  ScrollNotifier(this.controller) {
    controller.addListener(() {
      offset = controller.offset;
      notifyListeners();
    });
  }
}
