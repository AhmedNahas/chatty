import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context){
      MainCubit.get(context).getAllUsers();
      return BlocConsumer<MainCubit, MainCubitStates>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            var cubit = MainCubit.get(context);
            return state is UsersLoadingState
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                itemBuilder: (context, index) =>
                    buildUserItem(cubit.users[index], context),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 30.0),
                  child: Container(
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                itemCount: cubit.users.length);
          });
    });
  }

  Widget buildUserItem(UserModel user, BuildContext context) => InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(user));
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(user.image),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(user.name, style: Theme.of(context).textTheme.subtitle1!),
        ],
      ),
    ),
  );
}
