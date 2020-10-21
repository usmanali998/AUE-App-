import 'package:aue/model/assignment.dart';
import 'package:aue/res/res.dart';
import 'package:aue/widgets/secondary_background_widget.dart';
import 'package:flutter/material.dart';

class AssignmentDetail extends StatelessWidget {
  final Assignment assignment;

  const AssignmentDetail({Key key, this.assignment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(assignment.toJson());
    return Scaffold(
      body: SecondaryBackgroundWidget(
        //TODO change the icon here to match with assignments
        image: Images.square,
        title: "Assignment",
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 12,
                shadowColor: Colors.black26,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        // child: Text(
                        //   "2hr",
                        //   textAlign: TextAlign.end,
                        //   style: TextStyle(
                        //     color: AppColors.blueGrey,
                        //     fontSize: DS.setSP(16),
                        //   ),
                        // ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Submission Date",
                        style: TextStyle(
                          fontSize: DS.setSP(18),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "${assignment.endDate ?? '04 April 2020'}",
                        style: TextStyle(
                          fontSize: DS.setSP(18),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        assignment.attachmentName ??
                            "Read, interpret and critically analyze the article review. Based on your understanding, discuss the potential career opportunities that can improve the sports industry. Analyze the key responsibilities of a sports manager when utilizing technology.",
                        style: TextStyle(color: AppColors.blueGrey),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                },
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 12,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Download Attachment",
                            style: TextStyle(
                              fontSize: DS.setSP(17),
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_downward,
                            color: AppColors.primary,
                            size: DS.setSP(18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Attachments: (if any)",
                style: TextStyle(
                  fontSize: DS.setSP(16),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "No File Selected",
                        style: TextStyle(
                          fontSize: DS.setSP(15),
                          color: AppColors.blueGrey,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.folder,
                      color: AppColors.blueGrey,
                      size: DS.setSP(24),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
              Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 12,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Submit Assignment",
                          style: TextStyle(
                            fontSize: DS.setSP(17),
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.primary,
                          size: DS.setSP(18),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
