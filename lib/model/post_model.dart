class PostModel {
  late String name;
  late String uid;
  late String image;
  late String dateTime;
  late String body;
  late String? postImage;
  late List<String>? likes;
  late bool? isLiked;

  PostModel({
    required this.name,
    required this.uid,
    required this.image,
    required this.dateTime,
    required this.body,
    required this.postImage,
    required this.likes,
    required this.isLiked,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
    dateTime = json['dateTime'];
    body = json['body'];
    postImage = json['postImage'];
    if (json['likes'] != null) {
      likes = <String>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    isLiked = json['isLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uid'] = uid;
    data['image'] = image;
    data['dateTime'] = dateTime;
    data['body'] = body;
    data['postImage'] = postImage;
    data['likes'] = likes!.map((v) => v).toList();
    data['isLiked'] = isLiked;
    return data;
  }
}
