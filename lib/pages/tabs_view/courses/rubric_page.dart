import 'package:aue/model/rubric_criteria.dart';
import 'package:aue/model/rubric_descriptor.dart';
import 'package:aue/model/rubric_measurement.dart';
import 'package:aue/model/student_rubric.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import 'package:aue/model/selectable_text.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:dio/dio.dart';

class RubricPage extends StatefulWidget {
  final int courseWorkId;
  final int rubricId;

  RubricPage({
    this.courseWorkId,
    this.rubricId,
  });

  @override
  _RubricPageState createState() => _RubricPageState();
}

class _RubricPageState extends State<RubricPage> {
  Future<List<RubricCriteria>> _rubricCriteriaListFuture;
  Future<StudentRubric> _studentRubricFuture;

  int selectedRubricCriteriaId;

  @override
  void initState() {
    // getRubricCriteriaList();
    getStudentRubric();
    super.initState();
  }

  void getRubricCriteriaList() {
    _rubricCriteriaListFuture = null;
    _rubricCriteriaListFuture = Repository().gerRubricCriteriaList(null, widget.rubricId, widget.courseWorkId);
    setState(() {});
  }

  void getStudentRubric() {
    _studentRubricFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    // _studentRubricFuture = Repository().getStudentRubric(studentId, widget.courseWorkId, widget.rubricId);
    _studentRubricFuture = Repository().getStudentRubric(null, null, null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<StudentRubric>(
          future: _studentRubricFuture,
          builder: (BuildContext context, AsyncSnapshot<StudentRubric> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }

            if (snapshot.hasError && snapshot.error != null) {
              print(snapshot.error);
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getStudentRubric(),
              );
            }

//              selectedRubricCriteriaId = snapshot.data.first.rubricCriteriaId;

            return SecondaryBackgroundWidget(
              title: "Course Rubric",
              children: <Widget>[
                SizedBox(
                  height: DS.height * 0.06,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.criteria.map((StudentRubricCriteria studentRubricCriteria) {
                      if (this.selectedRubricCriteriaId == null) {
                        this.selectedRubricCriteriaId = snapshot.data.criteria.first.criteriaId;
                        snapshot.data.criteria.first.selected = true;
                      }
                      return GestureDetector(
                        onTap: () {
                          snapshot.data.criteria.forEach((element) => element.selected = false);
                          final int index = snapshot.data.criteria.indexWhere((element) => element.criteriaId == studentRubricCriteria.criteriaId);
                          snapshot.data.criteria[index].selected = true;
                          selectedRubricCriteriaId = snapshot.data.criteria[index].criteriaId;
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                            color: studentRubricCriteria.selected ? AppColors.primaryLight : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            studentRubricCriteria.criteriaHeader,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: studentRubricCriteria.selected ? AppColors.primary : Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Criteria\n${selectedRubricCriteriaId == null ? "" : snapshot.data.criteria.singleWhere((element) => element.criteriaId == selectedRubricCriteriaId).criteria}",
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: DS.setSP(14),
                  ),
                ),
                SizedBox(height: 16),
                if (selectedRubricCriteriaId != null)
                  Column(
                    children: [
                      ...snapshot.data.cells.where((element) => element.criteriaId == selectedRubricCriteriaId).map((StudentRubricCell studentRubricCell) {
                        return RubricItem(
                          studentRubricCell: studentRubricCell,
                          studentRubricMeasurements: snapshot.data.measurement,
                        );
                      }),
                    ],
                  ),
//                  RubricItem(),
//                  RubricItem(
//                    title: "GOOD",
//                    selected: true,
//                  ),
//                  RubricItem(
//                    title: "Needs Improvement",
//                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RubricItem extends StatelessWidget {
  final String title;
  final String description;
  final int rubricId;
  final int measurementId;
  final int criteriaId;
  final List<StudentRubricMeasurement> studentRubricMeasurements;
  final StudentRubricCell studentRubricCell;

  const RubricItem({
    Key key,
    this.title,
    this.description,
    this.rubricId,
    this.measurementId,
    this.criteriaId,
    this.studentRubricMeasurements,
    this.studentRubricCell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 12,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(12),
        color: this.studentRubricCell.isHighlighted ? AppColors.primary.withOpacity(0.2) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.access_time, color: Colors.white),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            this.studentRubricMeasurements.firstWhere((element) => element.measurementId == this.studentRubricCell.measurementId).measurement,
                            style: TextStyle(
                              fontSize: DS.setSP(18),
                              color: const Color(0xff042c5c),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.blueGrey, width: 0.4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${this.studentRubricCell?.minScore ?? ' '} - ${this.studentRubricCell?.maxScore}',
                            style: TextStyle(
                              fontFamily: 'Avenir-Light',
                              fontSize: DS.setSP(15),
                              color: Colors.black54,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      this.studentRubricCell.description,
                      style: TextStyle(fontSize: DS.setSP(13), color: AppColors.blueGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}