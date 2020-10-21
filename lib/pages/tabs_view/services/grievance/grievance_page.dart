import 'package:aue/model/grievance_history.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/services/grievance/new_grievance_page.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrievancePage extends StatefulWidget {
  @override
  _GrievancePageState createState() => _GrievancePageState();
}

class _GrievancePageState extends State<GrievancePage> {
  Future<List<GrievanceHistory>> _grievanceHistoryListFuture;

  void getGrievanceHistoryList() {
    _grievanceHistoryListFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    _grievanceHistoryListFuture =
        Repository().getGrievanceHistoryList(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGrievanceHistoryList();
  }

  Widget _buildNewGrievanceButton() {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: AppColors.primaryLight,
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
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
                  'New Grievance',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          Get.to(NewGrievancePage());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Grievance',
      showBackButton: true,
      image: Images.classUpdates,
      children: [
        _buildNewGrievanceButton(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "MY GRIEVANCE",
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FutureBuilder(
          future: _grievanceHistoryListFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<GrievanceHistory>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              print(snapshot.error);
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getGrievanceHistoryList(),
              );
            }
            // return ...List.generate(10, (index) => GrievanceCard()),
            return Column(
              children: snapshot.data
                  .map((GrievanceHistory grievanceHistory) =>
                      GrievanceCard(grievanceHistory: grievanceHistory))
                  .toList(),
            );
          },
        ),
        // ...List.generate(10, (index) => GrievanceCard()),
      ],
    );
  }
}

class GrievanceCard extends StatelessWidget {
  final GrievanceHistory grievanceHistory;

  const GrievanceCard({@required this.grievanceHistory});

  Widget _buildDataRow(String title, String value, bool isDashBelow,
      [bool isPrimaryColor = false]) {
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
                  color:
                      isPrimaryColor ? AppColors.primary : AppColors.blackGrey,
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
                  color:
                      isPrimaryColor ? AppColors.primary : AppColors.blueGrey,
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
        padding: const EdgeInsets.all(12.0)
            .add(const EdgeInsets.symmetric(horizontal: 6.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Case Reference', this.grievanceHistory.referenceCode,
                true, true),
            // Text(
            //   this.grantHistory?.discountTypeName ?? '',
            //   style: const TextStyle(
            //     color: AppColors.primary,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Grievance Category',
              this.grievanceHistory.categoryName,
              true,
            ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Date Reported:',
              this.grievanceHistory.submittedDate,
              true,
            ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Status:',
              this.grievanceHistory.grievanceStatus,
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
