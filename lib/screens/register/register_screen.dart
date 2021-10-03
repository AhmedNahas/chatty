import 'dart:developer';
import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
import 'package:chatty/screens/home/home_screen.dart';
import 'package:chatty/screens/register/register_cubit.dart';
import 'package:chatty/screens/register/register_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (ctx, state) {
          if (state is CreateUserSuccessState) {
            navigateAndFinish(context, HomeScreen());
          }
        },
        builder: (ctx, state) {
          return Form(
            key: formKey,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          'Register now to meet new friends',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          controller: userNameController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter your username";
                            }
                          },
                          inputType: TextInputType.emailAddress,
                          label: "User name",
                          icon: const Icon(Icons.supervised_user_circle),
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
                          obscure: RegisterCubit.get(ctx).isPassword,
                          icon: const Icon(Icons.lock),
                          suffix: IconButton(
                            icon: Icon(RegisterCubit.get(ctx).suffix),
                            onPressed: () {
                              RegisterCubit.get(ctx)
                                  .changePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter your phone";
                            }
                          },
                          inputType: TextInputType.phone,
                          label: "Phone number",
                          icon: const Icon(Icons.phone_android),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        state is RegisterLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : defaultButton(
                                width: double.infinity,
                                background: Colors.blue,
                                onPress: () {
                                  if (formKey.currentState!.validate()) {
                                    RegisterCubit.get(ctx).registerUser(
                                        name: userNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text);
                                  }
                                },
                                label: 'REGISTER',
                                textColor: Colors.white,
                              ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
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
