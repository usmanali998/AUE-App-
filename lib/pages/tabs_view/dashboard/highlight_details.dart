import 'dart:convert';

import 'package:aue/model/announcement_details.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aue/res/extensions.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class HighlightDetailsScreen extends StatefulWidget {
  final int year;
  final int id;

  HighlightDetailsScreen({
    this.id,
    this.year,
  });

  @override
  _HighlightDetailsScreenState createState() => _HighlightDetailsScreenState();
}

class _HighlightDetailsScreenState extends State<HighlightDetailsScreen> {
  Future<AnnouncementDetails> _announcementDetailsFuture;

  @override
  void initState() {
    getAnnouncementDetails();
    super.initState();
  }

  void getAnnouncementDetails() {
    _announcementDetailsFuture = null;
    _announcementDetailsFuture = Repository.getAnnouncementDetails(widget.year, widget.id);
    setState(() {});
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0).add(
        const EdgeInsets.only(top: 15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
            ),
          ),
          Text(
            "Highlights",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: DS.setSP(22),
            ),
          ),
          Visibility(
            visible: false,
            child: Image.asset(
              Images.bell,
              scale: 2.7,
              color: AppColors.primary,
            ),
          ),
//          const ImageIcon(
//            const AssetImage(Images.bell),
//            color: Colors.white,
//          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(AnnouncementDetails announcementDetails) {
    return Card(
      margin: const EdgeInsets.all(20.0).subtract(const EdgeInsets.only(top: 13.0)),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: DS.height * 0.54,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
              child: Transform.scale(
                scale: 1.01,
                child: Image.memory(
                  base64.decode(announcementDetails.images.first.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0).add(const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0)),
            child: Column(
              children: <Widget>[
                Text(
                  announcementDetails.announcement.first.announcementNotes,
                  style: const TextStyle(color: AppColors.blueGrey, fontWeight: FontWeight.w600, fontSize: 15.5),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 15.0),
                PrimaryButton(
                  width: double.infinity,
                  margin: const EdgeInsets.all(0.0),
                  text: 'Open Link',
                  onTap: () async {
                    if (await canLaunch(announcementDetails.announcement.first.registrationUrl)) {
                      await launch(announcementDetails.announcement.first.registrationUrl);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: (DS.getHeight * 0.05),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomRight: const Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: FutureBuilder<AnnouncementDetails>(
                future: _announcementDetailsFuture,
                builder: (BuildContext context, AsyncSnapshot<AnnouncementDetails> snapshot) {

                  if (snapshot.isLoading) {
                    return Align(alignment: Alignment.center, child: LoadingWidget());
                  }

                  if (snapshot.hasError && snapshot.error != null) {
                    return CustomErrorWidget(
                      err: DioError(
                        response: Response<String>(data: 'Could not fetch announcement detail right now.'),
                        error: 'Could not fetch announcement detail right now.',
                        type: DioErrorType.RESPONSE,
                      ),
                      onRetryTap: () => this.getAnnouncementDetails(),
                    );
                  }

                  return Column(
                    children: [
                      _buildHeader(),
                      _buildHighlightCard(snapshot.data),
                    ],
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
