import 'package:chatty/constants/constants.dart';
import 'package:chatty/model/comment_model.dart';
import 'package:chatty/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feeds_states.dart';

class FeedsCubit extends Cubit<FeedCubitStates> {
  FeedsCubit() : super(PostsInitialState());

  static FeedsCubit get(context) => BlocProvider.of(context);

  List<PostModel> posts = [];
  List<PostModel> newPosts = [];
  List<String> postsIds = [];
  List<List<CommentModel>> comments = [];
  List<CommentModel> secondComments = [];

  Future<void> getPosts() async {
    emit(PostsLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .orderBy('dateTime')
        .snapshots()
        .listen((value) async {
      if (value.docs.isEmpty) {
        emit(NoPostsState());
      } else {
        if (posts.isNotEmpty) {
          emit(IncomingPostsState());
        } else {
          posts.clear();
          postsIds.clear();
          comments.clear();
          for (var element in value.docs) {
            postsIds.add(element.id);
            posts.add(PostModel.fromJson(element.data()));
            postsIds = List.from(postsIds.reversed);
            posts = List.from(posts.reversed);
            element.reference
                .collection(Constants.collectionComments)
                .snapshots()
                .listen((commentsV) {
              secondComments = [];
              for (var element in commentsV.docs) {
                secondComments.add(CommentModel(
                    count: commentsV.docs.length,
                    userID: element.id,
                    comment: element.data()['comment'],
                    name: element.data()['name'],
                    time: element.data()['time'],
                    image: element.data()['image']));
              }
              comments.add(secondComments);
              comments = List.from(comments.reversed);
              emit(PostsSuccessState());
            });
          }
        }
      }
    });
  }

  Future<void> loadNewPosts() async {
    posts.clear();
    postsIds.clear();
    comments.clear();
    getPosts();
  }

  void likePost({required PostModel postToLike, required String postId}) {
    var liked = postToLike.isLiked!;
    var uid = userModel!.uid;
    var list = postToLike.likes!;
    if (liked) {
      list.removeWhere((element) => element == uid);
    } else {
      list.add(uid);
    }
    PostModel post = PostModel(
      name: postToLike.name,
      uid: postToLike.uid,
      image: postToLike.image,
      body: postToLike.body,
      postImage: postToLike.postImage ?? "",
      dateTime: postToLike.dateTime,
      likes: list,
      isLiked: liked ? false : true,
    );
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .update(post.toJson())
        .then((value) {
      loadNewPosts();
    }).catchError((error) {
      emit(LikesErrorState(error.toString()));
    });
  }

  void commentOnPost(String postId, String comment, String dateTime) {
    CommentModel commentModel = CommentModel(
        userID: userModel!.uid,
        name: userModel!.name,
        image: userModel!.image,
        time: dateTime,
        comment: comment);
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .collection(Constants.collectionComments)
        .add(commentModel.toJson())
        .then((value) {
      loadNewPosts();
    }).catchError((error) {});
  }

  void changeCommentButton(String s, int index) {
    if (s.isNotEmpty)
      emit(ShowSendCommentState(index));
    else
      emit(HideSendCommentState());
  }
}
