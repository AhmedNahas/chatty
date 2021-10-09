import 'package:chatty/model/user_model.dart';

class Constants {
  static const String collectionUsers = "users";
  static const String collectionPosts = "posts";
  static const String collectionLikes = "likes";
  static const String collectionComments = "comments";
  static const String collectionChats = "chats";
  static const String collectionMessages = "messages";
  static const String documentName = "uid";
  static const String firebaseTokenAPIFCM = "key=AAAAX9bl2ts:APA91bHbj7k3CR-8E8DP_9gWCo3gDHPyFAcqhSI5hmla82WzAiJ5bJvsotrwCkAXVPAJBrH5tJdDRbznHRmfv24yda99Mvnhkf8sH5YBp0ijFIr3GjcdZwCdMn37TdJtKVtAiHPuP_8l";
}
String? uid="";
String? fireBaseToken;
String? newFireBaseToken;
UserModel? userModel;