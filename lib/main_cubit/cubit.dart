import 'dart:io';

import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/message_model.dart';
import 'package:chatty/model/notification_model.dart';
import 'package:chatty/model/post_model.dart';
import 'package:chatty/model/user_model.dart';
import 'package:chatty/screens/chats/chat_screen.dart';
import 'package:chatty/screens/feeds/feed_screen.dart';
import 'package:chatty/screens/new_post/new_post.dart';
import 'package:chatty/screens/settings/settings_screen.dart';
import 'package:chatty/screens/users/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showToast(text: "onMessageBackground", color: ToastColors.SUCCESS);
}

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
    } else if (index == 1) {
      if (msgCounter > 0) {
        msgCounter = 0;
        currentIndex = index;
        emit(NewMessageReceivedState(msgCounter));
      } else {
        currentIndex = index;
        emit(BottomNavStates());
      }
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
        email: userModel!.email,
        firebaseToken: fireBaseToken.toString());

    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
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
      likes: [],
      comments: [],
      firebaseToken: userModel!.firebaseToken,
    );
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
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
      sendNotification(
          userToken: userToken,
          msg: msg,
          title: userModel!.name,
          type: 'inbox');
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
      // messages = [];
      if (messages.isNotEmpty) {
        var length = messages.length;
        for (int i = length; i < event.docs.length; i++) {
          print('no need to load all');
          messages.add(MessageModel.fromJson(event.docs[i].data()));
        }
      } else {
        for (var element in event.docs) {
          messages.add(MessageModel.fromJson(element.data()));
          print('load all');
        }
      }
      emit(SendMessageSuccessState());
    });
  }

  int msgCounter = 0;
  int notificationCounter = 0;
  List<NotificationModel> notifications = [];

  void onMessageReceived() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'inbox') {
        msgCounter++;
        emit(NewMessageReceivedState(msgCounter));
      } else {
        notifications.add(NotificationModel(
            msg: message.notification!.body!,
            image: message.data['userImage'],
            time: message.data['time']));
        notificationCounter++;
        emit(NewNotificationState(notificationCounter));
      }
    });
  }

  void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showToast(text: "onMessageOpenedApp", color: ToastColors.SUCCESS);
    });
  }

  void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void clearNotificationsBadge(){
    notificationCounter = 0;
    emit(NewNotificationState(notificationCounter));
  }
}
