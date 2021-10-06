class UserModel {
  late String name;
  late String email;
  late String uid;
  late String phone;
  late bool isEmailVerified;
  late String image;
  late String cover;
  late String bio;
  late String firebaseToken;

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.phone,
    this.isEmailVerified = false,
    required this.image,
    required this.cover,
    required this.bio,
    required this.firebaseToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    uid = json['uid'];
    phone = json['phone'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    firebaseToken = json['firebaseToken'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'phone': phone,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'cover': cover,
      'bio': bio,
      'firebaseToken': firebaseToken,
    };
  }
}
