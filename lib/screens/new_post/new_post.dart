import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var postController = TextEditingController();
    return BlocConsumer<MainCubit, MainCubitStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          var cubit = MainCubit.get(context);
          return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: "Create Post",
                showLeading: true,
                actions: [
                  TextButton(
                      onPressed: () {
                        cubit.createPostWithPicIfExist(
                            dateTime: getDateTimeFormatted(),
                            body: postController.text);
                      },
                      child: const Text('Post')),
                ]),
            body: userModel != null ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is CreatePostLoadingState)
                    const LinearProgressIndicator(
                      minHeight: 10.0,
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(userModel!.image),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(userModel!.name,
                          style: Theme.of(context).textTheme.subtitle1!),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: postController,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind ...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (cubit.postImageFile != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 180.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(cubit.postImageFile!),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  child: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      cubit.removePostImage();
                                    },
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  TextButton(
                    onPressed: () {
                      cubit.getPostImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_outlined),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Add photo"),
                      ],
                    ),
                  ),
                ],
              ),
            ) : const Center(child: CircularProgressIndicator()),
          );
        });
  }
}
