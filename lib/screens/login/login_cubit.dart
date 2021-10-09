import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/constants/constants.dart';
import 'package:chatty/model/user_model.dart';
import 'package:chatty/screens/login/login_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      getUserData(value.user!.uid);
      showToast(text: "Success", color: ToastColors.SUCCESS);
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
      showToast(text: error.toString(), color: ToastColors.ERROR);
    });
  }

  void getUserData(String uid) {
    FirebaseFirestore.instance
        .collection(Constants.collectionUsers)
        .doc(uid)
        .get()
        .then((value) {
      String token = value.data()!['firebaseToken'];
      String storedToken = fireBaseToken!;
      if (token != storedToken) {
        updateUserToken(
          name: value.data()!['name'],
          phone: value.data()!['phone'],
          bio: value.data()!['bio'],
          image: value.data()!['image'],
          cover: value.data()!['cover'],
          newToken: newFireBaseToken!,
          uid: value.data()!['uid'],
          email: value.data()!['email'],
        );
      }else{
        emit(LoginSuccessState(uid));
      }
      userModel = UserModel.fromJson(value.data()!);
    });
  }

  void updateUserToken({
    required String name,
    required String phone,
    required String bio,
    required String image,
    required String cover,
    required String newToken,
    required String uid,
    required String email,
  }) {
    UserModel user = UserModel(
        name: name,
        phone: phone,
        isEmailVerified: true,
        image: image,
        bio: bio,
        cover: cover,
        uid: uid,
        email: email,
        firebaseToken: newToken);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(user.toJson())
        .then((value) {
      emit(LoginSuccessState(uid));
      print('update different token');
    });
  }
}
