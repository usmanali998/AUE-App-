import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aue/res/res.dart';

class SecondaryBackgroundWidget extends StatefulWidget {
  final String title;
  final String image;
  final List<Widget> children;
  final bool showBackButton;
  final Size imageSize;
  final EdgeInsets listViewPadding;
  final double initialHeight;
  final Widget child;
  final bool isSingleChildScrollView;

  const SecondaryBackgroundWidget({
    Key key,
    this.title,
    this.image,
    this.children,
    this.showBackButton = true,
    this.imageSize,
    this.listViewPadding,
    this.initialHeight,
    this.child,
    this.isSingleChildScrollView = false,
  }) : super(key: key);

  @override
  _SecondaryBackgroundWidgetState createState() =>
      _SecondaryBackgroundWidgetState();
}

class _SecondaryBackgroundWidgetState extends State<SecondaryBackgroundWidget> {
  ScrollController controller;
  double height = 0;

  @override
  void initState() {
    height = widget.initialHeight ?? DS.getHeight * 0.2;
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: widget.isSingleChildScrollView ? SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ChangeNotifierProvider(
              create: (context) => Notifier(controller),
              child: Consumer(
                builder: (context, Notifier notifier, child) {
                  return Container(
                    height: max(
                      height - notifier.offset,
                      DS.getHeight * 0.08 + safeAreaHeight,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          height: max(height - notifier.offset,
                              DS.getHeight * 0.08 + safeAreaHeight),
                          child: SafeArea(
                            child: Container(
                              width: DS.width,
                              child: Row(
                                children: <Widget>[
                                  if (widget.showBackButton)
                                    BackButton(color: Colors.white),
                                  Expanded(
                                    child: Text(
                                      widget.title ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: DS.setSP(22),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.3,
                                      ),
                                    ),
                                  ),
                                  if (widget.showBackButton) SizedBox(width: 48),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.image != null)
                          Positioned(
                            bottom: 24,
                            right: 36,
                            child: Transform.rotate(
                              angle: 0.2,
                              child: Image.asset(
                                widget.image,
                                color: Colors.white.withOpacity(0.25),
                                width: widget?.imageSize?.width,
                                height: widget?.imageSize?.height,
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            widget.children == null
                ? widget.child
                : Expanded(
              child: ListView(
                cacheExtent: 1000,
                controller: controller,
                padding: widget.listViewPadding ??
                    EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                children: <Widget>[
                  SizedBox(height: DS.height * 0.05),
                  if (widget.children != null) ...widget.children,
                ],
              ),
            )
          ],
        ),
      ) : Column(
        children: <Widget>[
          ChangeNotifierProvider(
            create: (context) => Notifier(controller),
            child: Consumer(
              builder: (context, Notifier notifier, child) {
                return Container(
                  height: max(
                    height - notifier.offset,
                    DS.getHeight * 0.08 + safeAreaHeight,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        height: max(height - notifier.offset,
                            DS.getHeight * 0.08 + safeAreaHeight),
                        child: SafeArea(
                          child: Container(
                            width: DS.width,
                            child: Row(
                              children: <Widget>[
                                if (widget.showBackButton)
                                  BackButton(color: Colors.white),
                                Expanded(
                                  child: Text(
                                    widget.title ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: DS.setSP(22),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ),
                                if (widget.showBackButton) SizedBox(width: 48),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.image != null)
                        Positioned(
                          bottom: 24,
                          right: 36,
                          child: Transform.rotate(
                            angle: 0.2,
                            child: Image.asset(
                              widget.image,
                              color: Colors.white.withOpacity(0.25),
                              width: widget?.imageSize?.width,
                              height: widget?.imageSize?.height,
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
          widget.children == null
              ? widget.child
              : Expanded(
                  child: ListView(
                    cacheExtent: 1000,
                    controller: controller,
                    padding: widget.listViewPadding ??
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    children: <Widget>[
                      SizedBox(height: DS.height * 0.05),
                      if (widget.children != null) ...widget.children,
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class Notifier with ChangeNotifier {
  final ScrollController controller;

  double offset = 0.0;

  Notifier(this.controller) {
    controller.addListener(() {
      offset = controller.offset;
      notifyListeners();
    });
  }
}
