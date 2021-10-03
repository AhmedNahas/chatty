import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/user_model.dart';
import 'package:chatty/screens/chats/chat_screen.dart';
import 'package:chatty/screens/feeds/feed_screen.dart';
import 'package:chatty/screens/new_post/new_post.dart';
import 'package:chatty/screens/settings/settins_screen.dart';
import 'package:chatty/screens/users/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(MainCubitInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  User? userModel;

  void getUserData() {
    emit(MainCubitLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionName)
        .doc(uid)
        .get()
        .then((value) {
      userModel = User.fromJson(value.data()!);
      print(userModel?.name);
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
}
