import 'dart:io';

import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/states.dart';
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

class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(MainCubitInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  String? profileImageUrl;
  String? coverImageUrl;

  void getUserData() {
    emit(MainCubitLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionName)
        .doc(uid)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      profileImageUrl = userModel!.image;
      coverImageUrl = userModel!.cover;
      emit(MainCubitSuccessState());
    }).catchError((error) {
      emit(MainCubitErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedScreen(),
    ChatScreen(),
    NewPost(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ["Feeds", "Chats", "Add", "Users", "Settings"];

  void changeBottomNavScreen(int index) {
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(BottomNavStates());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PicProfileImageSuccessState());
    } else {
      print("no file");
      emit(PicProfileImageErrorState());
    }
  }

  File? coverImage;

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
        email: userModel!.email);

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

  File? postImageFile;

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
      {required String dateTime,
      required String body}) async {
    emit(CreatePostLoadingState());
    if (postImageFile != null) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImageFile!.path).pathSegments.last}')
          .putFile(postImageFile!)
          .then((v) {
        v.ref.getDownloadURL().then((postImageUrl) {
          createPost(dateTime: dateTime, body: body,postImage: postImageUrl);
        }).catchError((error) {
          emit(CreatePostErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(CreatePostErrorState(error.toString()));
      });
    }else{
      createPost(dateTime: dateTime, body: body);
    }
  }
  void createPost({required String dateTime,
    required String body,
    String? postImage}){
    PostModel post = PostModel(
      name: userModel!.name,
      uid: userModel!.uid,
      image:userModel!.image,
      body: body,
      postImage: postImage??"",
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
  void getPosts() {
    emit(PostsLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .get()
        .then((value) {
          for (var element in value.docs) {
            posts.add(PostModel.fromJson(element.data()));
          }
      emit(PostsSuccessState());
    }).catchError((error) {
      emit(PostsErrorState(error.toString()));
    });
  }
}
