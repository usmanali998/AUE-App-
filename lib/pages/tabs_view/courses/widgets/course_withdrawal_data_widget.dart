import 'package:aue/model/course_withdrawal_data.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aue/res/extensions.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class CourseWithdrawalDataWidget extends StatefulWidget {
  final void Function(String, double) data;

  CourseWithdrawalDataWidget({@required this.data});

  @override
  _CourseWithdrawalDataWidgetState createState() => _CourseWithdrawalDataWidgetState();
}

class _CourseWithdrawalDataWidgetState extends State<CourseWithdrawalDataWidget> {
  Future<CourseWithdrawalData> _courseWithdrawalDataFuture;

  @override
  void initState() {
    super.initState();
    getCourseWithdrawalData();
  }

  void getCourseWithdrawalData() {
    _courseWithdrawalDataFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    final int sectionId = context.read<AppStateNotifier>().selectedSection.sectionId;
    _courseWithdrawalDataFuture =
        Repository().getCourseWithdrawalData(studentId: studentId, sectionId: sectionId);
    setState(() {});
  }

  Widget _buildDate() {
    return Text(
      'As of Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 15.0),
    );
  }

  Widget _buildOutlinedBox(String text) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.blueGrey,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseWithdrawalData>(
      future: _courseWithdrawalDataFuture,
      builder: (BuildContext context, AsyncSnapshot<CourseWithdrawalData> snapshot) {
        if (snapshot.isLoading) {
          return const LoadingWidget();
        }

        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: DioError(
              response: Response<String>(data: snapshot.error),
              type: DioErrorType.RESPONSE,
              error: snapshot.error,
            ),
            onRetryTap: () => getCourseWithdrawalData(),
          );
        }

        widget.data(snapshot.data.grade, snapshot.data.refundPercentage);

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
                  child: Column(
                    children: [
                      Text(
                        snapshot.data.disclaimerTitle,
                        style: const TextStyle(
                          color: AppColors.blackGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: DS.height * 0.02),
                      Text(
                        snapshot.data.disclaimerContent,
                        style: const TextStyle(
                          color: AppColors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: DS.height * 0.02),
            _buildDate(),
            SizedBox(height: DS.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildOutlinedBox('Refund: ${snapshot.data.refundPercentage}'),
                ),
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: _buildOutlinedBox('Grade: ${snapshot.data.grade}'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}