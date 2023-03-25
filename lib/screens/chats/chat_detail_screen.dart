import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/message_model.dart';
import 'package:chatty/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel user;
  ChatDetailsScreen(this.user, {Key? key}) : super(key: key);

  var msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      MainCubit.get(context).getAllMessages(receiverId: user.uid);
      return BlocConsumer<MainCubit, MainCubitStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          var cubit = MainCubit.get(context);
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
                  Conditional.single(
                      context: context,
                      conditionBuilder: (context) => cubit.messages.isNotEmpty,
                      widgetBuilder: (context) =>
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (ctx, index) {
                                  if (cubit.messages[index].senderId ==
                                      userModel!.uid) {
                                    return buildOtherMessage(
                                        cubit.messages[index]);
                                  } else {
                                    return buildMyMessage(
                                        cubit.messages[index]);
                                  }
                                },
                                separatorBuilder: (ctx, index) =>
                                const SizedBox(height: 10.0),
                                itemCount: cubit.messages.length),
                          ),
                      fallbackBuilder: (context) =>
                      cubit.messages.isEmpty
                          ? Container()
                          : const Center(child: CircularProgressIndicator())),
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
                            padding: const EdgeInsetsDirectional.only(
                                start: 8.0),
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
                                  dateTime:getDateTimeFormatted(),
                                  msg: msgController.text,
                                  msgType: 'txtMsg',
                                  userToken: user.firebaseToken);
                              msgController.clear();
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
    });
  }

  Widget buildMyMessage(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
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
          child: Text(message.msg),
        ),
      ),
    );
  }

  Widget buildOtherMessage(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
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
          child: Text(message.msg),
        ),
      ),
    );
  }
}
