class MessageModel {
  late String senderId;
  late String receiverId;
  late String dateTime;
  late String msg;
  late String msgType;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.msg,
    required this.msgType,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    msg = json['msg'];
    msgType = json['msgType'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'msg': msg,
      'msgType': msgType,
    };
  }
}
