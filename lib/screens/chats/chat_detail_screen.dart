import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel user;

  ChatDetailsScreen(this.user);
  var msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(user.image),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    user.name,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(10.0),
                          topEnd: Radius.circular(10.0),
                          topStart: Radius.circular(10.0),
                        )),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: const Text('Hello World'),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(.2),
                        borderRadius: const BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(10.0),
                          topEnd: Radius.circular(10.0),
                          topStart: Radius.circular(10.0),
                        )),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: const Text('Hello World'),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF6D6C6C),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8.0),
                          child: TextFormField(
                            controller: msgController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type your message here ...'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: MaterialButton(
                          onPressed: () {
                            MainCubit.get(context).sendMessage(
                                receiverId: user.uid,
                                dateTime: DateTime.now().toString(),
                                msg: msgController.text,
                                msgType: 'txtMsg');
                          },
                          child: const Icon(
                            Icons.send,
                            size: 25.0,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
