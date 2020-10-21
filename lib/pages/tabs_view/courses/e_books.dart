import 'dart:convert';

import 'package:aue/model/ebooks_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/services/repository.dart';
import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EbooksPage extends StatefulWidget {
  @override
  _EbooksPageState createState() => _EbooksPageState();
}

class _EbooksPageState extends State<EbooksPage> {
  Future<List<EBook>> _ebooksFuture;

  @override
  void initState() {
    getEbooks();
    super.initState();
  }

  void getEbooks() {
    _ebooksFuture = null;
    final String studentId = context.read<AuthNotifier>().user.studentID;
    final int sectionId = context.read<AppStateNotifier>().selectedSection.sectionId;
    _ebooksFuture = Repository().getEBooks(studentId: studentId, sectionId: sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SecondaryBackgroundWidget(
        //TODO change the icon here to match with E-books
        image: Images.square,
        title: "Text Books & E-Books",
        children: <Widget>[
          Text(
            'FEATURED BOOK',
            style: TextStyle(
              fontSize: DS.setSP(13),
              color: AppColors.blueGrey,
              letterSpacing: 0.6250000038146972,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          FutureBuilder<List<EBook>>(
            future: _ebooksFuture,
            builder: (BuildContext context, AsyncSnapshot<List<EBook>> snapshot) {
              if (snapshot.isLoading) {
                return LoadingWidget();
              }

              if (snapshot.hasError && snapshot.error != null) {
                print(snapshot.error);
                return CustomErrorWidget(
                  err: dio.DioError(
                      error: snapshot.error,
                      type: dio.DioErrorType.RESPONSE,
                      response: dio.Response<String>(data: snapshot.error)),
                  onRetryTap: () => getEbooks(),
                );
              }

              return Material(
                elevation: 12,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.blueGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Image.memory(
                          base64Decode(snapshot.data.first.coverPhoto),
                          width: 110,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data.first.title,
                            style: TextStyle(
                                fontSize: DS.setSP(15),
                                color: AppColors.blackGrey,
                                letterSpacing: 0.35,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: DS.height * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'By: ' + snapshot.data.first.author,
                                  style: TextStyle(
                                    fontSize: DS.setSP(14),
                                    color: AppColors.blueGrey,
                                    letterSpacing: 0.35,
                                  ),
                                ),
                              ),
                              Text(
                                'ISBN: ' + snapshot.data.first.isbn,
                                style: TextStyle(
                                  fontSize: DS.setSP(14),
                                  color: AppColors.blueGrey,
                                  letterSpacing: 0.35,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Visibility(
                        visible: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Adobe XD layer: 'By: Dr. James Higham' (text)
                            Text(
                              'By: Dr. James Higham',
                              style: TextStyle(
                                fontSize: DS.setSP(14),
                                color: const Color(0xff77869e),
                                letterSpacing: 0.1,
                              ),
                            ), // Adobe XD layer: 'ISBN: 9781845416577' (text)
                            Text(
                              'ISBN: 9781845416577',
                              style: TextStyle(
                                fontSize: DS.setSP(14),
                                color: const Color(0xff77869e),
                                letterSpacing: 0.1,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: DS.height * 0.05,
                        child: PrimaryButton(
                          text: 'Read Now',
                          width: double.infinity,
                          padding: const EdgeInsets.all(0.0),
                          margin: const EdgeInsets.all(0.0).add(
                            const EdgeInsets.symmetric(horizontal: 14.0),
                          ),
                          onTap: () async {
                            if (await canLaunch(snapshot.data.first.accessLink)) {
                              await launch(snapshot.data.first.accessLink);
                            } else {
                              Get.snackbar('Error', 'Cannot open link.');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Visibility(
            visible: false,
            child: Column(
              children: [
                SizedBox(height: 24),
                Text(
                  'Course Books',
                  style: TextStyle(
                    fontSize: DS.setSP(13),
                    color: AppColors.blueGrey,
                    letterSpacing: 0.6250000038146972,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            Images.bookPlaceholder,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
