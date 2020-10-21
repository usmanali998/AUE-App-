class ClassDiscussionModel {
  int id;
  String discussionTitle;
  String discussionContent;
  DateTime datePosted;
  int status;
  String statusName;
  int repliesCount;
  String facultyName;
  String imageThumbnail;

  ClassDiscussionModel.fromMap(Map m) {
    id = m['ID'];
    discussionTitle = m['DiscussionTitle'];
    discussionContent = m['DiscussionContent'];
    datePosted = DateTime.tryParse(m['DatePosted']);
    status = m['Status'];
    statusName = m['StatusName'];
    repliesCount = m['RepliesCount'];
    facultyName = m['FacultyName'];
    imageThumbnail = m['ImageThumbnail'];
  }
}
