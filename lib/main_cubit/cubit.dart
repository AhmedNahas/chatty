import 'dart:convert';
import 'dart:io';

import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/message_model.dart';
import 'package:chatty/model/post_model.dart';
import 'package:chatty/model/user_model.dart';
import 'package:chatty/screens/chats/chat_screen.dart';
import 'package:chatty/screens/feeds/feed_screen.dart';
import 'package:chatty/screens/new_post/new_post.dart';
import 'package:chatty/screens/settings/settings_screen.dart';
import 'package:chatty/screens/users/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(MainCubitInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  String? profileImageUrl;
  String? coverImageUrl;
  int currentIndex = 0;
  List<Widget> screens = [
    FeedScreen(),
    ChatScreen(),
    NewPost(),
    UsersScreen(),
    SettingsScreen()
  ];
  List<String> titles = ["Feeds", "Chats", "Add", "Users", "Settings"];
  File? profileImage;
  var picker = ImagePicker();
  File? coverImage;
  File? postImageFile;

  void getUserData() {
    emit(MainCubitLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
        .doc(uid)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      profileImageUrl = userModel!.image;
      coverImageUrl = userModel!.cover;
    }).catchError((error) {
      emit(MainCubitErrorState(error.toString()));
    });
  }

  void changeBottomNavScreen(int index) {
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(BottomNavStates());
    }
  }

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PicProfileImageSuccessState());
    } else {
      emit(PicProfileImageErrorState());
    }
  }

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PicCoverImageSuccessState());
    } else {
      emit(PicCoverImageErrorState());
    }
  }

  Future<firebase_storage.TaskSnapshot> uploadProfilePicture() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!);
  }

  Future<firebase_storage.TaskSnapshot> uploadCoverPicture() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!);
  }

  void updateUserDate({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateUserDataLoadingState());

    if (profileImage != null) {
      uploadProfilePicture().then((value) {
        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          if (coverImage != null) {
            uploadCoverPicture().then((value) {
              value.ref.getDownloadURL().then((value) {
                coverImageUrl = value;
                callFireStore(name: name, phone: phone, bio: bio);
              });
            }).catchError((error) {
              emit(CoverImageUploadErrorState(error.toString()));
            });
            emit(CoverImageUploadSuccessState());
          } else {
            callFireStore(name: name, phone: phone, bio: bio);
          }
        });
      }).catchError((error) {
        emit(ImageUploadErrorState(error.toString()));
      });
    } else {
      callFireStore(name: name, phone: phone, bio: bio);
    }
  }

  void callFireStore({
    required String name,
    required String phone,
    required String bio,
  }) {
    UserModel user = UserModel(
        name: name,
        phone: phone,
        isEmailVerified: true,
        image: profileImageUrl!,
        bio: bio,
        cover: coverImageUrl!,
        uid: userModel!.uid,
        email: userModel!.email, firebaseToken: fireBaseToken.toString());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(user.toJson())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserDataErrorState(error.toString()));
    });
  }

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);
      emit(PickPostImageSuccessState());
    } else {
      emit(PickPostImageErrorState());
    }
  }

  void createPostWithPicIfExist(
      {required String dateTime, required String body}) async {
    emit(CreatePostLoadingState());
    if (postImageFile != null) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImageFile!.path).pathSegments.last}')
          .putFile(postImageFile!)
          .then((v) {
        v.ref.getDownloadURL().then((postImageUrl) {
          createPost(dateTime: dateTime, body: body, postImage: postImageUrl);
        }).catchError((error) {
          emit(CreatePostErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(CreatePostErrorState(error.toString()));
      });
    } else {
      createPost(dateTime: dateTime, body: body);
    }
  }

  void createPost(
      {required String dateTime, required String body, String? postImage}) {
    PostModel post = PostModel(
      name: userModel!.name,
      uid: userModel!.uid,
      image: userModel!.image,
      body: body,
      postImage: postImage ?? "",
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(post.toJson())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState(error.toString()));
    });
  }

  void removePostImage() {
    postImageFile = null;
    emit(RemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String>? postsIds = [];
  List<int>? likes = [];
  List<int>? comments = [];

  Future getLikes(QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    await element.reference
        .collection(Constants.collectionLikes)
        .get()
        .then((likesV) {
      print('${likesV.docs.length} likes');
      likes!.add(likesV.docs.length);
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future getComments(
      QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    await element.reference
        .collection(Constants.collectionComments)
        .get()
        .then((commentsV) {
      print('${commentsV.docs.length} comments');
      comments!.add(commentsV.docs.length);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void commentOnPost(String postId, String comment) {
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .collection(Constants.collectionComments)
        .doc(uid)
        .set({'comment': comment})
        .then((value) {})
        .catchError((error) {});
  }

  List<UserModel> users = [];

  void getAllUsers() {
    emit(UsersLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
        .get()
        .then((value) {
      users.clear();
      for (var element in value.docs) {
        if (element.data()['uid'] != uid) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(UsersSuccessState());
    }).catchError((error) {
      emit(UsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String msg,
    required String msgType,
    required String userToken,
  }) {
    MessageModel newMessage = MessageModel(
        senderId: userModel!.uid,
        receiverId: receiverId,
        dateTime: dateTime,
        msg: msg,
        msgType: msgType);

    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
        .doc(userModel!.uid)
        .collection(Constants.collectionChats)
        .doc(receiverId)
        .collection(Constants.collectionMessages)
        .add(newMessage.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
        .doc(receiverId)
        .collection(Constants.collectionChats)
        .doc(userModel!.uid)
        .collection(Constants.collectionMessages)
        .add(newMessage.toJson())
        .then((value) {
          // List<String> receivers = [];
          // receivers.add(receiverId);
          sendNotification(userToken,msg);
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getAllMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
        .doc(userModel!.uid)
        .collection(Constants.collectionChats)
        .doc(receiverId)
        .collection(Constants.collectionMessages)
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
        print('hit server');
      }
      emit(SendMessageSuccessState());
    });
  }

  Future<bool> sendNotification(String userToken, String msg) async {

    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to" : userToken,
      "notification" : {
        "title": userModel!.name,
        "body" : msg,
        "sound" : "default",
      },
      "android" : {
        "priority": "HIGH",
        "notification" : {
          "notification_priority": "PRIORITY_MAX",
          "sound" : "default",
          "default_sound" : true,
          "default_vibrate_timings" : true,
          "default_light_settings" : true,
        }
      },
      "data" : {
        "type": "order",
        "id" : "89",
        "click_action" : "FLUTTER_NOTIFICATION_CLICK",
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': Constants.firebaseTokenAPIFCM // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
