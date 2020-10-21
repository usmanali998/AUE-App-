import 'package:aue/model/course_withdrawal_reason.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:aue/res/extensions.dart';
import 'package:dio/dio.dart';

class CourseWithdrawalReasonsWidget extends StatefulWidget {
  final Function(CourseWithdrawalReason) onReasonSelect;

  CourseWithdrawalReasonsWidget({@required this.onReasonSelect});

  @override
  _CourseWithdrawalReasonsWidgetState createState() => _CourseWithdrawalReasonsWidgetState();
}

class _CourseWithdrawalReasonsWidgetState extends State<CourseWithdrawalReasonsWidget> {
  Future<List<CourseWithdrawalReason>> _courseWithdrawalReasonsFuture;
  CourseWithdrawalReason _selectedReason;

  @override
  void initState() {
    getCourseWithdrawalReasons();
    super.initState();
  }

  void getCourseWithdrawalReasons() {
    _courseWithdrawalReasonsFuture = null;
    _courseWithdrawalReasonsFuture = Repository().getCourseWithdrawalReasons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseWithdrawalReason>>(
      future: _courseWithdrawalReasonsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<CourseWithdrawalReason>> snapshot) {
        if (snapshot.isLoading) {
          return const LoadingWidget();
        }

        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: DioError(
              error: snapshot.error,
              type: DioErrorType.RESPONSE,
              response: Response<String>(data: snapshot.error),
            ),
            onRetryTap: () => getCourseWithdrawalReasons(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reason Category',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
            DropdownButton<CourseWithdrawalReason>(
              items: snapshot.data.map<DropdownMenuItem<CourseWithdrawalReason>>(
                (CourseWithdrawalReason reason) {
                  return DropdownMenuItem<CourseWithdrawalReason>(
                    child: Text(
                      reason.reasonTypeEn,
                      style: const TextStyle(
                        color: AppColors.blueGrey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: reason,
                  );
                },
              ).toList(),
              value: _selectedReason,
              hint: const Text(
                'Select Reason Category',
                style: const TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              onChanged: (CourseWithdrawalReason reason) {
                _selectedReason = reason;
                setState(() {});
                widget.onReasonSelect(reason);
              },
              icon: Container(
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                  color: Colors.transparent,
                  border: const Border.fromBorderSide(
                    const BorderSide(color: AppColors.blueGrey, width: 1.3),
                  ),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
            ),
            Container(
              transform: Matrix4.translationValues(0, -12, 0),
              child: const Divider(
                color: AppColors.blueGrey,
                thickness: 1.1,
              ),
            )
          ],
        );
      },
    );
  }
}
