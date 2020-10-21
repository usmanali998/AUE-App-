import 'package:aue/model/semester.dart';
import 'package:aue/model/semester_details.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aue/res/extensions.dart';
import 'package:dio/dio.dart';

class AcademicCalendarScreen extends StatefulWidget {
  @override
  _AcademicCalendarScreenState createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  Future<List<Semester>> _semestersFuture;
  Future<List<SemesterDetails>> _semesterDetailsFuture;
  Semester _selectedSemester;

  @override
  void initState() {
    getSemesters();
    super.initState();
  }

  void getSemesters() {
    _semestersFuture = null;
    _semestersFuture =
        Repository.getSemesters(context.read<AuthNotifier>().user.studentID, 1);
    setState(() {});
  }

  void getSemesterDetails() async {
    _semesterDetailsFuture = null;
    _semesterDetailsFuture = Repository.getSemesterDetails(
        context.read<AuthNotifier>().user.studentID,
        _selectedSemester.semesterId);
    setState(() {});
  }

  Widget buildMaterial(Widget child) {
    return Material(
      shadowColor: Colors.black12,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Academic Calendar',
      image: Images.calendar,
      showBackButton: true,
      children: <Widget>[
        const Text(
          'SELECT SEMESTER',
          style: const TextStyle(color: AppColors.blueGrey),
        ),
        FutureBuilder(
          future: _semestersFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Semester>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: DioError(
                  type: DioErrorType.RESPONSE,
                  error: 'Error fetching semesters',
                  response: Response<String>(data: 'Error fetching semesters'),
                ),
              );
            }

            return DropdownButton<Semester>(
              items: snapshot.data.map((Semester semester) {
                return DropdownMenuItem<Semester>(
                  child: Text(semester.semesterName),
                  value: semester,
                );
              }).toList(),
              onChanged: (Semester selectedSemester) {
                _selectedSemester = selectedSemester;
                this.getSemesterDetails();
              },
              value: _selectedSemester,
//              value: _selectedSemester,
              isExpanded: true,
              autofocus: true,
              style: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            );
          },
        ),
        if (_selectedSemester != null)
          FutureBuilder<List<SemesterDetails>>(
            future: _semesterDetailsFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<SemesterDetails>> snapshot) {
              if (snapshot.isLoading) {
                return LoadingWidget();
              }

              if (snapshot.hasError && snapshot.error != null) {
                return CustomErrorWidget(
                  err: DioError(
                    error: 'Cannot fetch semester details',
                    response:
                        Response<String>(data: 'Cannot fetch semester details'),
                    type: DioErrorType.RESPONSE,
                  ),
                  onRetryTap: () => this.getSemesterDetails(),
                );
              }

              print(snapshot.data.length);

              return buildMaterial(Column(
                children: snapshot.data
                    .map(
                      (SemesterDetails semesterDetails) => ListTile(
                    title: Text(
                      semesterDetails.label,
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: DS.setSP(14),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              DateFormat("dd/M/yyyy")
                                  .format(semesterDetails.date),
                              style: TextStyle(fontSize: DS.setSP(13)),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "${DateFormat('EEE - h:mm a').format(semesterDetails.date)} - ${DateFormat('h:mm a').format(semesterDetails.date)}"
                                .toUpperCase(),
                            style: TextStyle(fontSize: DS.setSP(13)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .toList(),
              ));
              // return Column(
              //   children: <Widget>[
              //     ...snapshot.data.map(
              //       (SemesterDetails semesterDetails) {
              //         DateFormat dateFormatter = DateFormat('MMMM');
              //         return TimeLineTime(
              //           date: semesterDetails.date.day.toString(),
              //           monthAndYear:
              //               '${dateFormatter.format(semesterDetails.date)} ${semesterDetails.date.year}',
              //           label: semesterDetails.label,
              //         );
              //       },
              //     ).toList()
              //   ],
              // );
            },
          ),

//        CustomExpansionTile(
//          title: 'SELECT SEMESTER',
//          text: 'WEEKEND CLASSES CALENDAR',
//        ),
      ],
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String text;

  CustomExpansionTile({this.title, this.text});

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.blueGrey,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_crossFadeState.index == 0) {
                _crossFadeState = CrossFadeState.showSecond;
              } else {
                _crossFadeState = CrossFadeState.showFirst;
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: DS.width * 0.22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.text,
                  style: const TextStyle(
                      color: AppColors.blueGrey, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        Divider(color: Colors.black, endIndent: DS.width * 0.22),
        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: TimeLineTime(),
          crossFadeState: _crossFadeState,
          duration: const Duration(milliseconds: 500),
        ),
      ],
    );
  }
}

class TimeLineTime extends StatefulWidget {
  final String date;
  final String monthAndYear;
  final String label;
  final bool showOffSetLine;

  const TimeLineTime({
    Key key,
    this.date,
    this.label,
    this.monthAndYear,
    this.showOffSetLine = true,
  }) : super(key: key);

  @override
  _TimeLineTimeState createState() => _TimeLineTimeState();
}

class _TimeLineTimeState extends State<TimeLineTime> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  Widget _buildDetailRow(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 7.0,
                )),
            width: 20,
            height: 20,
          ),
          SizedBox(width: DS.width * 0.07),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                Text(
//                  title,
//                  style: const TextStyle(
//                    color: Colors.black,
//                  ),
//                ),
//                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                        color: widget.showOffSetLine
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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_crossFadeState.index == 0) {
                    _crossFadeState = CrossFadeState.showSecond;
                  } else {
                    _crossFadeState = CrossFadeState.showFirst;
                  }
                });
              },
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              width: 50,
                              height: 50,
                              child: Text(
                                widget.date,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 37.0),
                              ),
                            ),
                            const SizedBox(width: 14.0),
                            Text(
                              widget.monthAndYear,
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 15.0),
                            )
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState: _crossFadeState,
                    firstChild: const SizedBox(),
                    secondChild: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          const Divider(color: Colors.black, thickness: 0.7),
//                          _buildDetailRow("1st - 5th SEP", "ADMISSION PLACEMENT TESTS"),
                          _buildDetailRow("", widget.label),
                        ],
                      ),
                    ),
                    duration: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ),
          ),
//          Expanded(
//            flex: 16,
//            child: Stack(
//              children: <Widget>[
//                Material(
//                  elevation: 4,
//                  shadowColor: Colors.black26,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(12),
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Expanded(
//                          child: Container(
//                            width: 48,
//                            height: 48,
//                            decoration: BoxDecoration(
//                              color: AppColors.primary,
//                              borderRadius: BorderRadius.circular(6),
//                            ),
//                            alignment: Alignment.center,
//                            child: ImageIcon(
//                              AssetImage(Images.classUpdates),
//                              color: Colors.white,
//                            ),
//                          ),
//                        ),
//                        SizedBox(width: 24),
//                        Expanded(
//                          flex: 6,
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                'date', // timeline?.dated?.toString() ?? "29 -01-2020 | Wednesday",
//                                style: TextStyle(
//                                  color: AppColors.blueGrey,
//                                  fontSize: DS.setSP(18),
//                                  fontWeight: FontWeight.w600,
//                                ),
//                              ),
//                              SizedBox(height: 4),
//                              Text(
//                                "Project & Presentation",
//                                style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: DS.setSP(20),
//                                  fontWeight: FontWeight.w700,
//                                ),
//                              ),
//                              SizedBox(height: 12),
//                              Text(
//                                "In class ${"assignment"} (${"5"} Marks)",
//                                style: TextStyle(
//                                  color: AppColors.blueGrey,
//                                  fontSize: DS.setSP(16),
//                                  fontWeight: FontWeight.w600,
//                                ),
//                              )
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          )
        ],
      ),
    );
  }
}


