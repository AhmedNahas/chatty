import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (ctx, i) => buildPostItem(ctx),
              separatorBuilder: (ctx, i) => const SizedBox(
                    height: 10.0,
                  ),
              itemCount: 10)
        ],
      ),
    );
  }

  Widget buildPostItem(context) => Card(
        elevation: 10.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                        'https://cdn.dribbble.com/users/1355613/screenshots/15234311/media/863e1b6962855907bf7b31f09a4c3eb1.jpg?compress=1&resize=1200x900'),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ahmed El-Nahas",
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Novemver 19 , 2021 at 11:00 PM",
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
              const Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
              const SizedBox(
                height: 8.0,
              ),
              Container(
                height: 140.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://cdn.dribbble.com/users/1355613/screenshots/15252730/media/28f348daf9654c440f5dcf398d8e097a.jpg?compress=1&resize=1200x900'),
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
                  const CircleAvatar(
                    radius: 18.0,
                    backgroundImage: NetworkImage(
                        'https://cdn.dribbble.com/users/1355613/screenshots/15234311/media/863e1b6962855907bf7b31f09a4c3eb1.jpg?compress=1&resize=1200x900'),
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
