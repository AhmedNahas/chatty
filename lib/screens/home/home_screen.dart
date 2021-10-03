import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/screens/new_post/new_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if(state is NewPostState){
            navigateTo(context, NewPost());
          }
        },
        builder: (context, state) {
          var cubit = MainCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notification_important_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeBottomNavScreen(index),
              backgroundColor: Colors.grey.shade100,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_filled,
                      color: Colors.blueAccent,
                    ),
                    label: "Home",
                    backgroundColor: Colors.black),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat_rounded,
                      color: Colors.blueAccent,
                    ),
                    label: "Chats"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.blueAccent,
                    ),
                    label: "Add"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.supervised_user_circle_sharp,
                      color: Colors.blueAccent,
                    ),
                    label: "Users"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.blueAccent,
                    ),
                    label: "Settings"),
              ],
            ),
          );
        });
  }

  Widget buildHomeUI() => Column();

  Widget verifyEmail(context) => Column(
        children: [
          Conditional.single(
            context: context,
            conditionBuilder: (ctx) =>
                FirebaseAuth.instance.currentUser!.emailVerified,
            widgetBuilder: (ctx) => buildHomeUI(),
            fallbackBuilder: (ctx) => Container(
              color: Colors.amberAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Expanded(child: Text("Please verify your email")),
                    const SizedBox(
                      width: 20.0,
                    ),
                    TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();
                        },
                        child: const Text("Send")),
                  ],
                ),
              ),
            ),
          )
        ],
      );

//for email verification
/* Conditional.single(
  context: context,
  conditionBuilder: (ctx) =>
  MainCubit.get(context).userModel != null,
  widgetBuilder: (ctx) => verifyEmail(ctx),
  fallbackBuilder: (ctx) => const Center(
  child: CircularProgressIndicator(),
  ),
  )*/
}
