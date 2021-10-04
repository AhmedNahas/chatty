import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:chatty/model/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = MainCubit.get(ctx);
        return Conditional.single(
            context: context,
            conditionBuilder: (ctx) => cubit.posts.isNotEmpty,
            widgetBuilder: (ctx){
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
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
                    ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) => buildPostItem(ctx, cubit.posts[i]),
                        separatorBuilder: (ctx, i) => const SizedBox(
                          height: 10.0,
                        ),
                        itemCount: cubit.posts.length)
                  ],
                ),
              );
            },
            fallbackBuilder: (ctx){return const CircularProgressIndicator();});
      },
    );
  }

  Widget buildPostItem(context, PostModel post) => Card(
        elevation: 10.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
              const SizedBox(
                height: 8.0,
              ),
              if (post.postImage != null && post.postImage.isNotEmpty)
                Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(post.postImage),
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
                          "122",
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
                        "122 comment",
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
                  Expanded(
                    child: InkWell(
                      child: Text(
                        "write a comment ...",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 2.0),
                      ),
                      onTap: () {},
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
                              onPressed: () {},
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
