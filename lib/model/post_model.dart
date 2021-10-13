import 'package:chatty/model/comment_model.dart';

class PostModel {
  late String name;
  late String uid;
  late String image;
  late String dateTime;
  late String body;
  late String? postImage;
  late String? firebaseToken;
  late List<String>? likes;
  late List<CommentModel>? comments;
  bool? isLiked = false;

  PostModel({
    required this.name,
    required this.uid,
    required this.image,
    required this.dateTime,
    required this.body,
    required this.postImage,
    required this.firebaseToken,
    required this.likes,
    required this.comments,
    this.isLiked = false,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
    dateTime = json['dateTime'];
    body = json['body'];
    postImage = json['postImage'];
    firebaseToken = json['firebaseToken'];
    if (json['likes'] != null) {
      likes = <String>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    if (json['comments'] != null) {
      comments = <CommentModel>[];
      json['comments'].forEach((v) {
        print(v.toString());
        comments!.add(CommentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uid'] = uid;
    data['image'] = image;
    data['dateTime'] = dateTime;
    data['body'] = body;
    data['postImage'] = postImage;
    data['firebaseToken'] = firebaseToken;
    data['likes'] = likes!.map((v) => v).toList();
    data['comments'] = comments!.map((v) => v.toJson()).toList();
    return data;
  }
}
