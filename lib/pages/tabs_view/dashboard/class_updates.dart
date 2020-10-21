import 'package:aue/model/class_update.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aue/res/extensions.dart';
import 'package:dio/dio.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClassUpdatesScreen extends StatefulWidget {
  @override
  _ClassUpdatesScreenState createState() => _ClassUpdatesScreenState();
}

class _ClassUpdatesScreenState extends State<ClassUpdatesScreen> {
  Future<List<ClassUpdate>> _classUpdatesFuture;

  Widget _buildShowAll() {
    return Align(
      alignment: Alignment.topRight,
      child: const Text(
        'Show All',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    getClassUpdates();
    super.initState();
  }

  void getClassUpdates() {
    _classUpdatesFuture = null;
    _classUpdatesFuture = Repository.getClassUpdates(context.read<AuthNotifier>().user.studentID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Class Updates',
      showBackButton: true,
      image: Images.classUpdates,
      listViewPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12).subtract(const EdgeInsets.only(top: 12.0)),
      children: <Widget>[
        // _buildShowAll(),
        const SizedBox(height: 12.0),
        FutureBuilder(
          future: this._classUpdatesFuture,
          builder: (BuildContext context, AsyncSnapshot<List<ClassUpdate>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }
            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: snapshot.error,
                onRetryTap: () {
                  print('Retry');
                  getClassUpdates();
                },
              );
            }
            if (snapshot.data.isEmpty) {
              return CustomErrorWidget(
                err: DioError(
                  error: 'This student have no class updates yet!',
                  type: DioErrorType.RESPONSE,
                  response: Response<String>(data: 'This student have no class updates yet!'),
                ),
                onRetryTap: () => this.getClassUpdates(),
              );
            }
            return Column(
              children: <Widget>[
                ...snapshot.data
                    .asMap()
                    .map(
                      (index, classUpdate) {
                        return MapEntry(
                          index,
                          ClassUpdateTile(
                            classUpdate: classUpdate,
                            showOffsetLine: snapshot.data.indexOf(snapshot.data[index]) != snapshot.data.length - 1,
                            // isActive: true,
                            // title: snapshot.data[index].message,
                            // showOffsetLine: true,
                          ),
                        );
                      },
                    )
                    .values
                    .toList()
              ],
            );
          },
        ),
      ],
    );
  }
}

class ClassUpdateTile extends StatefulWidget {
  final ClassUpdate classUpdate;
  final bool showOffsetLine;

  const ClassUpdateTile({
    Key key,
    this.classUpdate,
    this.showOffsetLine = true,
  }) : super(key: key);

  @override
  _ClassUpdateTileState createState() => _ClassUpdateTileState();
}

class _ClassUpdateTileState extends State<ClassUpdateTile> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    final bool readStatus = !timeago.format(this.widget.classUpdate.actionDate).toLowerCase().contains('now');
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
                      offset: Offset(3.5, 60),
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6.0),
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
                        if (readStatus)
                          BoxShadow(
                            color: AppColors.blackGrey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 16,
                          ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  this.widget?.classUpdate?.sender ?? '' + ' | ' + this.widget?.classUpdate?.sectionCode ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: DS.setSP(15), fontWeight: FontWeight.w600, color: AppColors.blueGrey),
                                ),
                              ),
                              SizedBox(width: 12),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  timeago.format(this.widget.classUpdate.actionDate),
                                  style: TextStyle(
                                    color: AppColors.blueGrey.withOpacity(0.6),
                                    fontWeight: FontWeight.w300,
                                    fontSize: DS.setSP(14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          trailing: GestureDetector(
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
//                      subtitle: Padding(
//                        padding: const EdgeInsets.only(top: 4.0),
//                        child: Text(
//                          announcement.body ?? "",
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                          style: TextStyle(
//                            color: AppColors.blueGrey.withOpacity(0.6),
//                            fontWeight: FontWeight.w300,
//                            fontSize: DS.setSP(14),
//                          ),
//                        ),
//                      ),
                        ),
                        AnimatedCrossFade(
                          crossFadeState: _crossFadeState,
                          firstChild: const SizedBox(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              widget?.classUpdate?.message ?? "",
                              style: TextStyle(
                                color: AppColors.blueGrey.withOpacity(0.6),
                                fontWeight: FontWeight.w300,
                                fontSize: DS.setSP(14),
                              ),
                            ),
                          ),
                          duration: const Duration(milliseconds: 300),
                        )
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
