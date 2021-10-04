class PostModel {
  late String name;
  late String uid;
  late String image;
  late String dateTime;
  late String body;
  late String postImage;

  PostModel({
    required this.name,
    required this.uid,
    required this.image,
    required this.dateTime,
    required this.body,
    required this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
    dateTime = json['dateTime'];
    body = json['body'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'image': image,
      'dateTime': dateTime,
      'body': body,
      'postImage': postImage,
    };
  }
}
