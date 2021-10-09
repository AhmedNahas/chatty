class CommentModel {
  late int? count;
  late String? userID;
  late String? name;
  late String? image;
  late String? time;
  late String? comment;

  CommentModel({
    this.count = 0,
    required this.userID,
    required this.name,
    required this.image,
    required this.time,
    required this.comment,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    name = json['name'];
    image = json['image'];
    time = json['time'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'image': image,
      'time': time,
      'comment': comment,
    };
  }
}
