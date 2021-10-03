import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = MainCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 190.0,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(cubit!.cover),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 64.0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(cubit!.image),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                cubit.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                cubit.bio,
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "100",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            "Posts",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "100K",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            "Followers",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "100",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            "Following",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "100",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            "Photos",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(children: [
                Expanded(
                  child: OutlinedButton(onPressed: () {  },
                  child: const Text('Add Photos'),),
                ),
                OutlinedButton(onPressed: () {  },
                  child: const Icon(Icons.edit),)
              ])
            ],
          ),
        );
      },
    );
  }
}
