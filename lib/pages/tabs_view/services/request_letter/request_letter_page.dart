import 'package:aue/model/letter_request.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/pages/tabs_view/services/request_letter/request_for_letter.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestLetterPage extends StatelessWidget {
  final bool isGetRequests;

  RequestLetterPage({
    this.isGetRequests = false,
  });

  Widget _buildNewLetterRequestButton() {
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
                  'New Letter Request',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
        onPressed: () {
          Get.to(RequestForLetterPage());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Official Letters',
      showBackButton: true,
      image: Images.classUpdates,
      children: [
        _buildNewLetterRequestButton(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "My Letters",
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        LetterRequestsListWidget()
      ],
    );
  }
}

class LetterRequestsListWidget extends StatefulWidget {

  @override
  _LetterRequestsListWidgetState createState() =>
      _LetterRequestsListWidgetState();
}

class _LetterRequestsListWidgetState extends State<LetterRequestsListWidget> {
  Future<List<LetterRequest>> _letterRequestsFuture;

  void getLetterRequests() {
    this._letterRequestsFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    this._letterRequestsFuture = Repository().getLetterRequests(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getLetterRequests();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _letterRequestsFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<LetterRequest>> snapshot) {
        if (snapshot.isLoading) {
          return LoadingWidget();
        }

        if (snapshot.hasError && snapshot.error != null) {
          print(snapshot.error);
          return CustomErrorWidget(
            err: snapshot.error,
            onRetryTap: () => this.getLetterRequests(),
          );
        }
        return Column(
          children: snapshot.data
              .map((LetterRequest letterRequest) =>
                  LetterRequestCard(letterRequest: letterRequest))
              .toList(),
          // return Column(
          //   children: List.generate(10, (index) => LetterRequestCard(letterRequest: ))
        );
      },
    );
  }
}

class LetterRequestCard extends StatelessWidget {
  final LetterRequest letterRequest;

  const LetterRequestCard({@required this.letterRequest});

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
        padding: const EdgeInsets.all(8.0)
            .add(const EdgeInsets.symmetric(horizontal: 6.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Images.request_letter),
                  SizedBox(width: DS.width * 0.06),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        letterRequest?.subject ?? '',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        letterRequest?.statusName ?? '',
                        style: const TextStyle(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.w300,
                            fontSize: 13.0),
                      ),
                      Text(
                        letterRequest?.addressedTo ?? '',
                        style: const TextStyle(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.w300,
                            fontSize: 13.0),
                      ),
                      Text(
                        DateFormat("dd - MMM - yyyy")
                            .format(letterRequest?.dateSubmitted),
                        style: const TextStyle(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.w300,
                            fontSize: 13.0),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
