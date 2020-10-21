import 'package:aue/model/attendance_excuse.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/services/attendance_excuse/attendance_excuse_request.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceExcuseHistory extends StatefulWidget {
  @override
  _AttendanceExcuseHistoryState createState() => _AttendanceExcuseHistoryState();
}

class _AttendanceExcuseHistoryState extends State<AttendanceExcuseHistory> {
  Future<List<AttendanceExcuse>> _attendanceExcuseHistoryFuture;

  void getAttendanceExcuseHistory() {
    _attendanceExcuseHistoryFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    _attendanceExcuseHistoryFuture = Repository().getAttendanceExcuseHistory(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getAttendanceExcuseHistory();
  }

  Widget _buildNewAttendanceExcuseRequestButton() {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: AppColors.primaryLight,
        shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: const Text(
                  'Submit New Excuse',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
        onPressed: () {
          Get.to(AttendanceExcuseRequestPage());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Attendance Excuse',
      showBackButton: true,
      image: Images.classUpdates,
      children: [
        _buildNewAttendanceExcuseRequestButton(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "PREVIOUS EXCUSES",
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FutureBuilder(
          future: _attendanceExcuseHistoryFuture,
          builder: (BuildContext context, AsyncSnapshot<List<AttendanceExcuse>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              print(snapshot.error);
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getAttendanceExcuseHistory(),
              );
            }
            // return ...List.generate(10, (index) => GrievanceCard()),
            return Column(
              children: snapshot.data.map((AttendanceExcuse attendanceExcuse) => AttendanceExcuseCard(attendanceExcuse: attendanceExcuse)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class AttendanceExcuseCard extends StatelessWidget {
  final AttendanceExcuse attendanceExcuse;
  final DateFormat _dateFormat = DateFormat("dd-MMM-yyyy");

  AttendanceExcuseCard({@required this.attendanceExcuse});

  Widget _buildDataRow(String title, String value, bool isDashBelow, [bool isPrimaryColor = false]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: AutoSizeText(
                title,
                style: TextStyle(
                  color: isPrimaryColor ? AppColors.primary : AppColors.blackGrey,
                  fontWeight: FontWeight.w700,
                ),
                maxFontSize: 14.0,
              ),
            ),
            Expanded(
              flex: 6,
              child: AutoSizeText(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isPrimaryColor ? AppColors.primary : AppColors.blueGrey,
                ),
                maxFontSize: 14.0,
              ),
            )
          ],
        ),
        SizedBox(height: DS.height * 0.01),
        if (isDashBelow)
          const DottedLine(
            lineLength: double.infinity,
            direction: Axis.horizontal,
            lineThickness: 1.0,
            dashLength: 3.0,
            dashColor: AppColors.grey,
            dashRadius: 0.0,
            dashGapLength: 2.0,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
      ],
    );
  }

  Widget _buildStatusRow(String title, String status, bool isDashBelow, [bool isPrimaryColor = false]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: AutoSizeText(
                title,
                style: TextStyle(
                  color: isPrimaryColor ? AppColors.primary : AppColors.blackGrey,
                  fontWeight: FontWeight.w700,
                ),
                maxFontSize: 14.0,
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  const Icon(Icons.close, color: AppColors.red),
                  AutoSizeText(
                    'Rejected',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: isPrimaryColor ? AppColors.primary : AppColors.blueGrey,
                    ),
                    maxFontSize: 14.0,
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: DS.height * 0.01),
        if (isDashBelow)
          const DottedLine(
            lineLength: double.infinity,
            direction: Axis.horizontal,
            lineThickness: 1.0,
            dashLength: 3.0,
            dashColor: AppColors.grey,
            dashRadius: 0.0,
            dashGapLength: 2.0,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        ),
      ),
      shadowColor: Colors.black38,
      margin: const EdgeInsets.only(bottom: 15.0),
      elevation: 4.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Start date:', _dateFormat.format(this.attendanceExcuse.attendanceDate), true, true),
            // Text(
            //   this.grantHistory?.discountTypeName ?? '',
            //   style: const TextStyle(
            //     color: AppColors.primary,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow('End date', _dateFormat.format(this.attendanceExcuse.requestDate), true, true),
            SizedBox(height: DS.height * 0.01),
            _buildStatusRow(
              'Status:',
              this.attendanceExcuse.statusName,
              true,
            ),
            SizedBox(height: DS.height * 0.01),
            if (attendanceExcuse.processedDate != null)
              _buildDataRow(
                'Approved by:',
                'To be decided',
                false,
              ),
            // SizedBox(height: DS.height * 0.01),
            // _buildDataRow(
            //   'Status: ',
            //   this.grantHistory?.requestStatus ?? '',
            //   false,
            // ),
          ],
        ),
      ),
    );
  }
}
