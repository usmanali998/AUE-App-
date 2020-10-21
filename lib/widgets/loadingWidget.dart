import 'package:aue/res/res.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool fullSize;
  const LoadingWidget({
    Key key,
    this.fullSize = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildLoader();
  }

  buildLoader() {
    return Container(
      width: DS.width,
      height: fullSize ? DS.height * 0.9 : DS.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text("    Loading ..."),
        ],
      ),
    );
  }
}
