import 'package:aue/model/core_courses.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/splash/splash.dart';
import 'package:aue/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'res/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  Utils.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => AuthNotifier(),
        ),
        ChangeNotifierProxyProvider(
          lazy: false,
          create: (_) => AppStateNotifier(),
          update: (context, AuthNotifier authNotifier,
                  AppStateNotifier appnotifier) =>
              appnotifier..update(authNotifier),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: "Avenir",
          accentColor: AppColors.primary,
        ),
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            ScreenUtil.instance = ScreenUtil(width: 414, height: 896)
              ..init(context);
            DS.height = size.height;
            DS.width = size.width;
            return SplashScreen();
          },
        ),
      ),
    );
  }
}
