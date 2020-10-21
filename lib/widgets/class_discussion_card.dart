import 'package:aue/model/class_discussion_model.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/images.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/widgets/dash_line_widget.dart';
import 'package:flutter/material.dart';

class ClassDiscussionCard extends StatelessWidget {
  final ClassDiscussionModel classDiscussionModel;

  const ClassDiscussionCard({Key key, @required this.classDiscussionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(right: 24.0, left: 24.0, bottom: 26.0, top: 0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 24.0,
              bottom: 14.0,
              left: 22.0,
              right: 14.0,
            ),
            child: Row(
              children: [
                Text(
                  '${classDiscussionModel.discussionTitle}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: DS.setSP(16),
                  ),
                ),
                Spacer(),
                Text(
                  '${classDiscussionModel.datePosted.day}-${classDiscussionModel.datePosted.month}-${classDiscussionModel.datePosted.year}',
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontWeight: FontWeight.w300,
                    fontSize: DS.setSP(13),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blueGrey.withOpacity(0.6),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 11.5,
              bottom: 10.5,
              left: 22.0,
              right: 14.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${classDiscussionModel.discussionContent}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: DS.setSP(13),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ImageIcon(
                  AssetImage(Images.star),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          DashLine(
            color: AppColors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 22.0,
              right: 21.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${classDiscussionModel.statusName}',
                  style: TextStyle(
                    color: AppColors.darkerBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: DS.setSP(13),
                  ),
                ),
                SizedBox(width: 32.0),
                ImageIcon(
                  AssetImage(Images.message1),
                  color: AppColors.primary,
                ),
                SizedBox(width: 8.0),
                Text(
                  '${classDiscussionModel.repliesCount} Comments',
                  style: TextStyle(
                    color: AppColors.darkerBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: DS.setSP(13),
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
