import 'package:aue/model/grievance_terms_and_conditions.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/services/grievance/academic_grievance_page.dart';
import 'package:aue/pages/tabs_view/services/grievance/behavior_grievance_page.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewGrievancePage extends StatefulWidget {
  @override
  _NewGrievancePageState createState() => _NewGrievancePageState();
}

class _NewGrievancePageState extends State<NewGrievancePage> {
  Future<List<GrievanceTermsAndConditions>> _academicGrievanceTermsAndConditions;
  Future<List<GrievanceTermsAndConditions>> _behaviorGrievanceTermsAndConditions;

  void getAcademicGrievanceTermsAndConditions() {
    _academicGrievanceTermsAndConditions = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    _academicGrievanceTermsAndConditions = Repository().getGrievanceTermsAndConditions(studentId, 4, 1);
    setState(() {});
  }

  void getBehaviorGrievanceTermsAndConditions() {
    _behaviorGrievanceTermsAndConditions = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    _behaviorGrievanceTermsAndConditions = Repository().getGrievanceTermsAndConditions(studentId, 5, 1);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getAcademicGrievanceTermsAndConditions();
    this.getBehaviorGrievanceTermsAndConditions();
  }

  Widget _buildCard(String title, String description) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
        shadowColor: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.blackGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: DS.height * 0.015),
              Text(
                description,
                style: const TextStyle(color: AppColors.blueGrey, fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.4),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 44.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: const Radius.circular(40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0).subtract(const EdgeInsets.only(bottom: 16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: AppColors.primary),
                  const Spacer(),
                  Text(
                    "New Grievance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(20),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Visibility(
                    visible: false,
                    child: ImageIcon(
                      const AssetImage(Images.bell),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DS.width * 0.07, vertical: 14.0),
              child: Column(
                children: [
                  FutureBuilder<List<GrievanceTermsAndConditions>>(
                    future: _academicGrievanceTermsAndConditions,
                    builder: (BuildContext context, AsyncSnapshot<List<GrievanceTermsAndConditions>> snapshot) {
                      if (snapshot.isLoading) {
                        return LoadingWidget();
                      }
                      if (snapshot.hasError && snapshot.error != null) {
                        return CustomErrorWidget(
                          err: snapshot.error,
                          onRetryTap: () => this.getAcademicGrievanceTermsAndConditions(),
                        );
                      }
                      return Column(
                        children: [
                          _buildCard(snapshot.data?.first?.title, snapshot.data?.first?.content),
                          Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                            margin: const EdgeInsets.all(10.0).add(const EdgeInsets.symmetric(vertical: 10.0)),
                            shadowColor: Colors.black38,
                            child: InkWell(
                              onTap: () {
                                Get.to(AcademicGrievancePage(
                                  title: snapshot.data?.first?.title,
                                  content: snapshot.data?.first?.content,
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Apply for Academic Grievance',
                                      style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(
                                          const BorderSide(color: AppColors.primary, width: 1.5),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  FutureBuilder<List<GrievanceTermsAndConditions>>(
                    future: _behaviorGrievanceTermsAndConditions,
                    builder: (BuildContext context, AsyncSnapshot<List<GrievanceTermsAndConditions>> snapshot) {
                      if (snapshot.isLoading) {
                        return LoadingWidget();
                      }
                      if (snapshot.hasError && snapshot.error != null) {
                        return CustomErrorWidget(
                          err: snapshot.error,
                          onRetryTap: () => this.getBehaviorGrievanceTermsAndConditions(),
                        );
                      }
                      return Column(
                        children: [
                          _buildCard(snapshot.data?.first?.title, snapshot.data?.first?.content),
                          Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                            margin: const EdgeInsets.all(10.0).add(const EdgeInsets.symmetric(vertical: 10.0)),
                            shadowColor: Colors.black38,
                            child: InkWell(
                              onTap: () {
                                Get.to(BehaviorGrievancePage(
                                  title: snapshot.data?.first?.title ?? '',
                                  content: snapshot.data?.first?.content ?? '',
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Apply for Behavior Grievance',
                                      style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(
                                          const BorderSide(color: AppColors.primary, width: 1.5),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
