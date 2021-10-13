class NotificationModel {
  late String? msg;
  late String? image;
  late String? time;

  NotificationModel({
    required this.msg,
    required this.image,
    required this.time,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    image = json['userImage'];
    time = json['time'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userImage': image,
      'time': time,
      'msg': msg,
    };
  }
}
