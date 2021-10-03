import 'package:chatty/model/user_model.dart' as new_user;
import 'package:chatty/screens/register/register_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createNewUser(
          name: name, email: email, phone: phone, uid: value.user!.uid);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createNewUser(
      {required String name,
      required String email,
      required String phone,
      required String uid}) {
    new_user.User user = new_user.User(
        name: name,
        email: email,
        uid: uid,
        phone: phone,
        isEmailVerified: false,
        image:
            "https://cdn.dribbble.com/users/1355613/screenshots/15594500/media/aea41a7cf22d09be0bb41afa85be2f5e.jpg?compress=1&resize=1200x900",
        bio: "write your bio ...",
        cover:
            "https://cdn.dribbble.com/users/1139587/screenshots/15315651/media/902bb8dcecb3af51092656f6467dba3f.jpg?compress=1&resize=1200x900");
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toJson())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordState());
  }
}
