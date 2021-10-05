import 'package:chatty/model/post_model.dart';
import 'package:chatty/screens/feeds/feeds_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'feeds_states.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();

    return BlocConsumer<FeedsCubit, FeedCubitStates>(
      listener: (ctx, state) {
      },
      builder: (ctx, state) {
        var cubit = FeedsCubit.get(ctx);
        return state is PostsLoadingState
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /*Card(
                      elevation: 10.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          const Image(
                            fit: BoxFit.cover,
                            height: 200.0,
                            width: double.infinity,
                            image: NetworkImage(
                                'https://cdn.dribbble.com/users/1355613/screenshots/6533809/invoice_maker_4x.jpg?compress=1&resize=1200x900'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Meet\nnew\nfriends",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    ),*/
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) => buildPostItem(
                            ctx, cubit.posts[i], cubit, i, commentController),
                        separatorBuilder: (ctx, i) => const SizedBox(
                              height: 10.0,
                            ),
                        itemCount: cubit.posts.length)
                  ],
                ),
              );
      },
    );
  }

  Widget buildPostItem(context, PostModel post, FeedsCubit cubit, int index,
          TextEditingController commentController) =>
      Card(
        elevation: 10.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(post.image),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.name,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          post.dateTime,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontSize: 10.0),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, top: 10.0, right: 30.0, bottom: 10.0),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Text(post.body),
              if (post.postImage != null && post.postImage!.isNotEmpty)
                const SizedBox(
                  height: 8.0,
                ),
              if (post.postImage != null && post.postImage!.isNotEmpty)
                Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(post.postImage ?? ''),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            iconSize: 20.0,
                            icon: Icon(
                              Icons.thumb_up_alt_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        Text(
                          "${cubit.likes.length}",
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          iconSize: 20.0,
                          icon: Icon(
                            Icons.comment_bank_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      Text(
                        "${cubit.comments.length} comment",
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ],
              ),
              Container(
                height: 1.0,
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.0,
                    backgroundImage: NetworkImage(post.image),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  /*Expanded(
                    child: InkWell(
                      child: Text(
                        "write a comment ...",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 2.0),
                      ),
                      onTap: () {

                      },
                    ),
                  ),*/
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        print('tapped');
                      },
                      controller: commentController,
                      decoration: const InputDecoration(
                          hintText: "Write a comment ...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 13.0)),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                // cubit.likePost(cubit.postsIds[index]);
                                cubit.commentOnPost(cubit.postsIds[index],
                                    commentController.text);
                              },
                              iconSize: 20.0,
                              icon: Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          Text(
                            "like",
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
