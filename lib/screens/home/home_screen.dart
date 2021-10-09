import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
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
    return BlocConsumer<MainCubit, MainCubitStates>(listener: (context, state) {
      if (state is NewPostState) {
        navigateTo(context, NewPost());
      }
    }, builder: (context, state) {
      var cubit = MainCubit.get(context);
      return Scaffold(
        appBar: defaultAppBar(
          context: context,
          title: cubit.titles[cubit.currentIndex],
          actions: [
            SizedBox(
              width: 35.0,
              child: Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                 const Icon(
                    Icons.notification_important_outlined,
                    color: Colors.black26,
                  ),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(top: 5.0),
                      width: 18.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: state is NewMessageReceivedState
                          ? Center(child: Text(state.msgCounter.toString()))
                          : Center(child: Text(cubit.msgCounter.toString())),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black26,
                )),
          ],
          showLeading: false,
        ),
        body: cubit.screens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.black,
          currentIndex: cubit.currentIndex,
          onTap: (index) => cubit.changeBottomNavScreen(index),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                color: Colors.blueAccent,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Icon(
                          Icons.chat_rounded,
                          color: Colors.blueAccent,
                        ),
                      ),
                      cubit.msgCounter > 0 ? Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          width: 18.0,
                          height: 18.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: state is NewMessageReceivedState
                              ? Center(child: Text(state.msgCounter.toString()))
                              : Center(child: Text(cubit.msgCounter.toString())),
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
                label: "Chats"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.blueAccent,
                ),
                label: "Add"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle_sharp,
                  color: Colors.blueAccent,
                ),
                label: "Users"),
            const BottomNavigationBarItem(
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
