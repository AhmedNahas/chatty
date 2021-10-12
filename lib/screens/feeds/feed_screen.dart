import 'dart:ui';

import 'package:chatty/components/reusable_comp/func/reusable_func.dart';
import 'package:chatty/constants/constants.dart';
import 'package:chatty/screens/feeds/feeds_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feeds_states.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();

    return BlocConsumer<FeedsCubit, FeedCubitStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = FeedsCubit.get(ctx);
        return RefreshIndicator(
            child: state is PostsLoadingState
                ? const Center(child: CircularProgressIndicator())
                : Stack(
              alignment: AlignmentDirectional.topCenter,
                    children: [
                      state is NoPostsState
                          ? buildNoPostsView(context)
                          : cubit.posts.isEmpty &&
                                  cubit.comments.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, i) => Card(
                                        elevation: 10.0,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25.0,
                                                    backgroundImage:
                                                        NetworkImage(cubit
                                                            .posts[i].image),
                                                  ),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cubit.posts[i].name,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                          cubit.posts[i]
                                                              .dateTime,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10.0),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.more_horiz)),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40.0,
                                                    top: 10.0,
                                                    right: 30.0,
                                                    bottom: 10.0),
                                                child: Container(
                                                  height: 1.0,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              Text(cubit.posts[i].body),
                                              if (cubit.posts[i].postImage !=
                                                      null &&
                                                  cubit.posts[i].postImage!
                                                      .isNotEmpty)
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                              if (cubit.posts[i].postImage !=
                                                      null &&
                                                  cubit.posts[i].postImage!
                                                      .isNotEmpty)
                                                Container(
                                                  height: 140.0,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(cubit
                                                              .posts[i]
                                                              .postImage ??
                                                          ''),
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
                                                              cubit.posts[i].isLiked! ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            )),
                                                        Text(
                                                          "${cubit.posts[i].likes!.length} Likes",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return buildBottomSheet(
                                                                cubit,
                                                                context,
                                                                i);
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .comment_bank_outlined,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                        const SizedBox(
                                                            width: 10.0),
                                                        Text(
                                                          "${cubit.comments.isEmpty ? 0 : cubit.comments[i].length} comment",
                                                          style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .caption,
                                                        ),
                                                      ],
                                                    ),
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                            userModel!.image),
                                                  ),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      onChanged: (s) {
                                                        cubit
                                                            .changeCommentButton(
                                                                s, i);
                                                      },
                                                      controller: state
                                                                  is ShowSendCommentState &&
                                                              state.index == i
                                                          ? commentController
                                                          : TextEditingController(),
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Write a comment ...",
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          13.0)),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      state is ShowSendCommentState &&
                                                              state.index == i
                                                          ? IconButton(
                                                              onPressed: () {
                                                                if (commentController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  cubit.commentOnPost(
                                                                      cubit.postsIds[
                                                                          i],
                                                                      commentController
                                                                          .text,
                                                                      getDateTimeFormatted(),i);
                                                                  commentController
                                                                      .clear();
                                                                  cubit.changeCommentButton(
                                                                      commentController
                                                                          .text,
                                                                      i);
                                                                }
                                                              },
                                                              iconSize: 20.0,
                                                              icon: Icon(
                                                                Icons.send,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              ))
                                                          : IconButton(
                                                              onPressed: () {
                                                                cubit.likePost(postId: cubit.postsIds[
                                                                i], postToLike: cubit.posts[i]);
                                                              },
                                                              iconSize: 20.0,
                                                              icon: Icon(
                                                                cubit.posts[i].isLiked! ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              cubit.comments.isNotEmpty && cubit.comments[i].isNotEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .only(
                                                              start: 15.0),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 14.0,
                                                            backgroundImage:
                                                                NetworkImage(cubit
                                                                    .comments[i]
                                                                    .last
                                                                    .image!),
                                                          ),
                                                          const SizedBox(
                                                            width: 20.0,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              cubit
                                                                  .comments[i]
                                                                  .last
                                                                  .comment!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20.0,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                  separatorBuilder: (ctx, i) => const SizedBox(
                                        height: 10.0,
                                      ),
                                  itemCount: cubit.posts.length),
                      state is IncomingPostsState
                          ? buildNewPostBadge(cubit: cubit)
                          : Container(),
                    ],
                  ),
            onRefresh: () {
              return cubit.loadNewPosts();
            });
      },
    );
  }

  Widget buildNoPostsView(context) => Card(
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
              padding: const EdgeInsets.all(8.0),
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
      );

  Widget buildBottomSheet(FeedsCubit cubit, context, index) => Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Container(
          height: 400.0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                  topRight: Radius.circular(45.0)),
              color: Colors.grey[300]!.withAlpha(1)),
          child: cubit.comments.isNotEmpty && cubit.comments[index].isNotEmpty
              ? ListView.separated(
                  itemBuilder: (ctx, i) => Row(
                        children: [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundImage:
                                NetworkImage(cubit.comments[index][i].image!),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            cubit.comments[index][i].name!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!,
                                          ),
                                        ),
                                        Text(
                                          cubit.comments[index][i].time!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(fontSize: 10.0),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      cubit.comments[index][i].comment!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(fontSize: 15.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                  separatorBuilder: (ctx, i) => const SizedBox(height: 10.0),
                  itemCount: cubit.comments[index].length)
              : const Center(child: Text('No Comments')),
        ),
      );

  Widget buildNewPostBadge({required FeedsCubit cubit}) => InkWell(
        onTap: () {
          cubit.loadNewPosts();
        },
        child: Container(
          width: 120.0,
          height: 40.0,
          margin: const EdgeInsets.only(top: 10.0),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
          ),
          child: const Center(
              child: Text(
            'New Posts',
            style: TextStyle(color: Colors.white),
          )),
        ),
      );
}
