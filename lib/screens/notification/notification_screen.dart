import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainCubitStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          return Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: "Notification",
              showLeading: true,
            ),
            body: ListView.builder(
              itemBuilder: (context, index) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(
                              cubit.notifications[index].image!),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cubit.notifications[index].msg!,
                                style: Theme.of(context).textTheme.subtitle1!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                cubit.notifications[index].time!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 30.0, bottom: 10.0),
                    child: Container(
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              shrinkWrap: true,
              itemCount: cubit.notifications.length,
            ),
          );
        });
  }
}
