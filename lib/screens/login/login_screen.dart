import 'dart:developer';
import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
import 'package:chatty/helper/cache_helper.dart';
import 'package:chatty/screens/home/home_screen.dart';
import 'package:chatty/screens/login/login_cubit.dart';
import 'package:chatty/screens/login/login_states.dart';
import 'package:chatty/screens/register/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (ctx, state) {
          if (state is LoginSuccessState) {
            CacheHelper.putData(key: "uid", value: state.uid).then((value) {
              navigateAndFinish(context, HomeScreen());
            });
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        'Login now to meet new people',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultTextFormField(
                        controller: emailController,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter your Email address";
                          }
                        },
                        inputType: TextInputType.emailAddress,
                        label: "Email address",
                        icon: const Icon(Icons.email),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultTextFormField(
                        controller: passwordController,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                        },
                        inputType: TextInputType.visiblePassword,
                        label: "Password",
                        obscure: true,
                        icon: const Icon(Icons.lock),
                        suffix: const Icon(
                          Icons.remove_red_eye,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultButton(
                        width: double.infinity,
                        background: Colors.blue,
                        onPress: () {
                          LoginCubit.get(ctx).userLogin(
                              email: emailController.text,
                              password: passwordController.text);
                        },
                        label: 'LOGIN',
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                          ),
                          TextButton(
                            onPressed: () =>
                                navigateTo(context, RegisterScreen()),
                            child: const Text(
                              'Register Now',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
