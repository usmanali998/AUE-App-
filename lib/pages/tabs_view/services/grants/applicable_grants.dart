import 'package:aue/model/applicable_grant_model.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/services/grants/apply_grant.dart';
import 'package:aue/pages/tabs_view/services/grants/grants_history.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicableGrantsPage extends StatefulWidget {
  @override
  _ApplicableGrantsPageState createState() => _ApplicableGrantsPageState();
}

class _ApplicableGrantsPageState extends State<ApplicableGrantsPage> {
  Future<List<ApplicableGrant>> _applicableGrantsFuture;

  void getApplicableGrants() {
    _applicableGrantsFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _applicableGrantsFuture = Repository().getApplicableGrants(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getApplicableGrants();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Grant Request',
      image: Images.classUpdates,
      showBackButton: true,
      children: [
        Row(
          children: [
            Expanded(
              child: IconTextBox(
                text: 'History',
                iconData: Icons.history,
                onTap: () {
                  Get.to(
                    GrantsHistoryPage(),
                  );
                },
              ),
            ),
            SizedBox(width: DS.width * 0.04),
            const Spacer(),
            Visibility(
              visible: false,
              child: Expanded(
                child: IconTextBox(
                  text: 'Requirements',
                  // icon: Images.regulation,
                  iconData: Icons.format_list_bulleted,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: DS.height * 0.04),
        const Text(
          'AVAILABLE GRANTS',
          style: const TextStyle(
            color: AppColors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        FutureBuilder<List<ApplicableGrant>>(
          future: _applicableGrantsFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<ApplicableGrant>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getApplicableGrants(),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.65,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(ApplyGrantPage(
                        discountTypeId: snapshot.data[index].discountTypeId,
                        subTypeId: snapshot.data[index].subTypeId,
                        title: snapshot.data[index].discountType));
                  },
                  child: GrantCard(
                    applicableGrant: snapshot.data[index],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class GrantCard extends StatelessWidget {
  final ApplicableGrant applicableGrant;

  GrantCard({this.applicableGrant});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(6.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: const BorderRadius.all(
                const Radius.circular(8.0),
              ),
            ),
            child: Image.asset(
              Images.grantTemp,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: DS.height * 0.01),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: AutoSizeText(
                  this.applicableGrant.discountType,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: DS.height * 0.01),
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: DS.setSP(20),
                ),
                SizedBox(width: DS.width * 0.02),
                // Adobe XD layer: 'View Paper' (text)
                Text(
                  'Apply Grant',
                  style: TextStyle(
                    fontSize: DS.setSP(14),
                    color: AppColors.primary,
                    letterSpacing: 0.25,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
