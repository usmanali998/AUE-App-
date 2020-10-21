import 'dart:io';

import 'package:aue/model/course_material.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';
import 'package:aue/widgets/primary_tile.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CourseMaterialsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return SecondaryBackgroundWidget(
//      image: Images.square,
//      title: 'Test Course Materials',
//      children: <Widget>[
//        CourseMaterialsList()
//      ],
//    );
    return Scaffold(
      body: SecondaryBackgroundWidget(
        image: Images.square,
        title: "Course Materials",
        children: <Widget>[
          CourseMaterialsList(),
          // Text(
          //   "Week 1",
          //   style: TextStyle(
          //     color: AppColors.blueGrey,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // Text(
          //   "Week 2",
          //   style: TextStyle(
          //     color: AppColors.blueGrey,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // Text(
          //   "Week 3",
          //   style: TextStyle(
          //     color: AppColors.blueGrey,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // Text(
          //   "Week 4",
          //   style: TextStyle(
          //     color: AppColors.blueGrey,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // Text(
          //   "Week 5",
          //   style: TextStyle(
          //     color: AppColors.blueGrey,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
          // PrimaryTile(
          //   padding: EdgeInsets.symmetric(vertical: 8),
          //   leadingIcon: Images.square,
          //   title: "Course Title",
          //   subtitle:
          //       "Course Description goes here second line of description goes here",
          //   trailingPadding: EdgeInsets.all(2),
          //   trailingWidget: Icon(
          //     Icons.arrow_downward,
          //     color: AppColors.primary,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CourseMaterialsList extends StatefulWidget {
  @override
  _CourseMaterialsListState createState() => _CourseMaterialsListState();
}

class _CourseMaterialsListState extends State<CourseMaterialsList> {

  Future<List<CourseMaterial>> courseMaterialResponseList;

  bool _permissionReady;
  String _localPath;
  bool _isLoading;
  static String taskId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCourseMaterialList();
    });
    _prepare();
  }

  static void flutterDownloaderCallback(String id, DownloadTaskStatus status, int progress) {
    print('Status: $status | Progress: $progress');
    if (status == DownloadTaskStatus.complete) {
      FlutterDownloader.open(taskId: taskId);
//      print('IsOpened');
//      print(isOpened);
    }
  }

  getCourseMaterialList() {
    // final user = context.read<AuthNotifier>().user;
    final selectedCourse = context.read<AppStateNotifier>().selectedSection;
    courseMaterialResponseList = Repository().getCourseMaterialList(selectedCourse);
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Null> _prepare() async {
    _permissionReady = await _checkPermission();
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Downloads';
    final savedDir = Directory(_localPath);
    bool isDirExist = await savedDir.exists();
    if (!isDirExist) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: courseMaterialResponseList,
      builder: (context, AsyncSnapshot<List<CourseMaterial>> snapshot) {
        if (snapshot.isLoading) {
          return LoadingWidget();
        }

        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: snapshot.error,
            onRetryTap: () => getCourseMaterialList(),
          );
        }

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // final map = Map();
          // if (snapshot?.data?.isNotEmpty ?? false)
          //   snapshot.data.forEach((material) => {
          //
          //   });
          //   snapshot.data.forEach((material) {
          //     if (map.containsKey(material.weekNo)) {
          //       final list = map[material.weekNo] as List;
          //       list.add(material);
          //       map[material.weekNo] = list;
          //     } else {
          //       map.addAll({
          //         material.weekNo: [material]
          //       });
          //     }
          //   });

          // if (map.isEmpty) {
          //   return Center(
          //     child: Text("No Material Found"),
          //   );
          // }

          return Column(
              children: snapshot.data.map(
            (CourseMaterial courseMaterial) {
              return PrimaryTile(
                padding: EdgeInsets.symmetric(vertical: 8),
                leadingIcon: Images.square,
                title: courseMaterial?.materialName ?? "",
                subtitle: courseMaterial?.materialFileName ?? '',
                onTap: () async {
                  taskId = await FlutterDownloader.enqueue(
                    url: courseMaterial.downloadLink,
                    savedDir: _localPath,
                    showNotification: true,
                    headers: {
                      "Authorization": "Basic bW9iaWxldXNlcjpBdWVkZXYyMDIw",
                    },
                    openFileFromNotification: true,
                  );
                  FlutterDownloader.registerCallback(_CourseMaterialsListState.flutterDownloaderCallback);
                },
                trailingPadding: EdgeInsets.all(2),
                trailingWidget: Icon(
                  Icons.arrow_downward,
                  color: AppColors.primary,
                ),
              );
            },
          ).toList());

          // return Column(
          //   // shrinkWrap: true,
          //   children: map.keys.map<Widget>((key) {
          //     final list = map[key] as List;
          //
          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Text(
          //           "Week $key",
          //           style: TextStyle(
          //             color: AppColors.blueGrey,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         for (var i = 0; i < list.length; i++)
          //           PrimaryTile(
          //             padding: EdgeInsets.symmetric(vertical: 8),
          //             leadingIcon: Images.square,
          //             title: list[i].materialName ?? "",
          //             subtitle: "",
          //             trailingPadding: EdgeInsets.all(2),
          //             trailingWidget: Icon(
          //               Icons.arrow_downward,
          //               color: AppColors.primary,
          //             ),
          //           ),
          //       ],
          //     );
          //   }).toList(),
          // );
        }

        return Container();
      },
    );
  }
}
