import 'package:aue/model/grant_history_model.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GrantsHistoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Grants History',
      image: Images.classUpdates,
      showBackButton: true,
      isSingleChildScrollView: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DISCOUNT HISTORY',
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: DS.height * 0.015),
            GrantsHistoryCards(),
          ],
        ),
      ),
    );
  }
}

class GrantsHistoryCards extends StatefulWidget {
  @override
  _GrantsHistoryCardsState createState() => _GrantsHistoryCardsState();
}

class _GrantsHistoryCardsState extends State<GrantsHistoryCards> {
  Future<List<GrantHistory>> _grantsHistoryFuture;

  void getGrantsHistory() {
    _grantsHistoryFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _grantsHistoryFuture = Repository().getGrantsHistory(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getGrantsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GrantHistory>>(
      future: _grantsHistoryFuture,
      builder: (BuildContext context, AsyncSnapshot<List<GrantHistory>> snapshot) {
        if (snapshot.isLoading) {
          return LoadingWidget();
        }

        if (snapshot.hasError && snapshot.error != null) {
          return CustomErrorWidget(
            err: snapshot.error,
            onRetryTap: () => this.getGrantsHistory(),
          );
        }

        return Column(
          children: snapshot.data.map((GrantHistory grantHistory) => GrantHistoryCard(grantHistory: grantHistory)).toList(),
        );
      },
    );
  }
}

class GrantHistoryCard extends StatelessWidget {
  final GrantHistory grantHistory;

  GrantHistoryCard({@required this.grantHistory});

  Widget _buildDataRow(String title, String value, bool isDashBelow) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: AutoSizeText(
                title,
                style: const TextStyle(
                  color: AppColors.blackGrey,
                  fontWeight: FontWeight.w700,
                ),
                maxFontSize: 14.0,
              ),
            ),
            Expanded(
              flex: 4,
              child: AutoSizeText(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.blueGrey,
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
      elevation: 4.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.grantHistory?.discountTypeName ?? '',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Requested Semester: ',
              this.grantHistory?.semesterName ?? '',
              true,
            ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Requested Date: ',
              DateFormat("dd-MMM-yyyy").format(this.grantHistory.dateRequested),
              true,
            ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Company Name: ',
              this.grantHistory?.corporateName ?? '',
              true,
            ),
            SizedBox(height: DS.height * 0.01),
            _buildDataRow(
              'Status: ',
              this.grantHistory?.requestStatus ?? '',
              false,
            ),
          ],
        ),
      ),
    );
  }
}
