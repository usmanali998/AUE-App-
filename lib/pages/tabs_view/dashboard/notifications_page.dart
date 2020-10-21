import 'package:aue/model/notification_model.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/images.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aue/res/res.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<List<NotificationModel>> _notificationsFuture;

  void getNotifications() {
    _notificationsFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _notificationsFuture = Repository().getNotifications(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      image: Images.notification_icon,
      title: 'Notifications',
      showBackButton: true,
      children: [
        FutureBuilder<List<NotificationModel>>(
          future: _notificationsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<NotificationModel>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }
            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () => this.getNotifications(),
              );
            }
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return NotificationTile(
                  notificationModel: snapshot.data[index],
                  showOffsetLine: snapshot.data.indexOf(snapshot.data[index]) != snapshot.data.length - 1,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class NotificationTile extends StatefulWidget {
  final NotificationModel notificationModel;
  final bool showOffsetLine;
  final bool isActive;

  const NotificationTile({
    Key key,
    this.notificationModel,
    this.showOffsetLine = true,
    this.isActive = false,
  }) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    final bool readStatus = !timeago.format(widget.notificationModel.notificationDate).toLowerCase().contains('now');
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (widget.showOffsetLine)
                    Transform.translate(
                      offset: const Offset(3.5, 60),
                      child: Container(
                        width: 2,
                        height: 60,
                        color: Color(0XFFD7DADA).withOpacity(0.7),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: readStatus ? Color(0XFFD7DADA) : AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 20,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        if (!readStatus)
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 16,
                          ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          // leading: ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child: Image.asset(Images.girl),
                          // ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.notificationModel.subject,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: DS.setSP(16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                timeago.format(widget.notificationModel.notificationDate),
                                style: TextStyle(
                                  color: AppColors.blueGrey.withOpacity(0.6),
                                  fontWeight: FontWeight.w300,
                                  fontSize: DS.setSP(12),
                                ),
                              ),
                              SizedBox(width: DS.width * 0.02),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _crossFadeState == CrossFadeState.showFirst ? _crossFadeState = CrossFadeState.showSecond : _crossFadeState = CrossFadeState.showFirst;
                                  });
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          // subtitle: Visibility(
                          //   visible: false,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 4.0),
                          //     child: Text(
                          //       notificationModel.body ?? "",
                          //       maxLines: 1,
                          //       overflow: TextOverflow.ellipsis,
                          //       style: TextStyle(
                          //         color: AppColors.blueGrey.withOpacity(0.6),
                          //         fontWeight: FontWeight.w300,
                          //         fontSize: DS.setSP(14),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              widget.notificationModel.body ?? "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.blueGrey.withOpacity(0.6),
                                fontWeight: FontWeight.w300,
                                fontSize: DS.setSP(14),
                              ),
                            ),
                          ),
                          crossFadeState: _crossFadeState,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
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
