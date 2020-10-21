import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:aue/model/time_line.dart';
import 'package:aue/res/extensions.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/error_widget.dart';
import 'package:aue/widgets/loadingWidget.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:intl/intl.dart';

class CourseTimelineDetail extends StatefulWidget {
  const CourseTimelineDetail({Key key}) : super(key: key);
  @override
  _CourseTimelineDetailState createState() => _CourseTimelineDetailState();
}

class _CourseTimelineDetailState extends State<CourseTimelineDetail> {
  Future<List<Timeline>> courseTimeLine;

  @override
  void initState() {
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTimeLine();
//    });
    super.initState();
  }

  getTimeLine() {
    final selectedCourse = context.read<AppStateNotifier>().selectedSection;
    //TODO CHANGE TO USE REAL SECTION ID
    courseTimeLine = Repository().getTimeLine(sectionId: selectedCourse.sectionId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: "Course Timeline",
      image: Images.calendar,
      imageSize: Size(70, 70),
      listViewPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      children: <Widget>[
        FutureBuilder(
          future: courseTimeLine,
          builder: (context, AsyncSnapshot<List<Timeline>> snapshot) {
            print(snapshot.connectionState);
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => getTimeLine(),
              );
            }

            return ListView(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                ...snapshot.data
                    .map<Widget>(
                      (item) => TimeLineTime(
                        timeline: item,
                        showOffSetLine: snapshot.data.indexOf(item) !=
                            snapshot.data.length - 1,
                      ),
                    )
                    .toList(),
                // TimeLineTime(),
                // TimeLineTime(),
                // TimeLineTime(),
                // TimeLineTime(),
                // TimeLineTime(),
                // TimeLineTime(),
                // TimeLineTime(),
                // TimeLineTime(showOffSetLine: false),
              ],
            );
          },
        ),
      ],
    );
  }
}

class TimeLineTime extends StatelessWidget {
  final Timeline timeline;
  final bool showOffSetLine;
  const TimeLineTime({
    Key key,
    this.timeline,
    this.showOffSetLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, 40),
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 140,
                        color: showOffSetLine
                            ? Color(0XFFD7DADA).withOpacity(0.7)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFFD7DADA),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 16,
            child: Stack(
              children: <Widget>[
                Material(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: ImageIcon(
                              AssetImage(Images.classUpdates),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateFormat("dd-MM-yyyy | EEE").format(timeline
                                    ?.dated), // timeline?.dated?.toString() ?? "29 -01-2020 | Wednesday",
                                style: TextStyle(
                                  color: AppColors.blueGrey,
                                  fontSize: DS.setSP(18),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                timeline?.description ??
                                    "Project & Presentation",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: DS.setSP(20),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "In class ${timeline?.courseWorkTypeName ?? "assignment"} (${timeline?.totalMark ?? "5"} Marks)",
                                style: TextStyle(
                                  color: AppColors.blueGrey,
                                  fontSize: DS.setSP(16),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
