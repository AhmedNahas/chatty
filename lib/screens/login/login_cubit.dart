import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/screens/login/login_states.dart';
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
          emit(LoginSuccessState(value.user!.uid));
      showToast(text: "Success", color: ToastColors.SUCCESS);
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
      showToast(text: error.toString(), color: ToastColors.ERROR);
    });
  }
}
