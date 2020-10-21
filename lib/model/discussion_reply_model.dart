import 'package:aue/model/class_discussion_model.dart';

class DiscussionReplyModel {
  List<ClassDiscussionModel> classDiscussionModel = [];
  List<ReplyModel> replies = [];

  DiscussionReplyModel.fromMap(Map m) {
    (m['Topic'] as List).forEach((element) =>
        classDiscussionModel.add(ClassDiscussionModel.fromMap(element)));
    (m['Replies'] as List)
        .forEach((element) => replies.add(ReplyModel.fromMap(element)));
  }
}

class ReplyModel {
  String replyText;
  String studentName;
  DateTime datePosted;
  String imageThumbnail;

  ReplyModel(
      this.replyText, this.studentName, this.datePosted, this.imageThumbnail);

  ReplyModel.fromMap(Map m) {
    replyText = m['ReplyText'];
    studentName = m['StudentName'];
    datePosted = DateTime.tryParse(m['DatePosted']);
    imageThumbnail = m['ImageThumbnail'];
  }
}
