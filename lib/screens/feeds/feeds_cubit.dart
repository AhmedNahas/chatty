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
  List<String> postsIds = [];

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
          for (var element in value.docs) {
            PostModel post = PostModel.fromJson(element.data());
            if (post.likes!.isNotEmpty) {
              for (var element in post.likes!) {
                if (element == userModel!.uid) {
                  post.isLiked = true;
                  break;
                }
              }
            }
            postsIds.add(element.id);
            posts.add(post);
            postsIds = List.from(postsIds.reversed);
            posts = List.from(posts.reversed);
          }
          emit(PostsSuccessState());
        }
      }
    });
  }

  Future<void> loadNewPosts() async {
    posts.clear();
    postsIds.clear();
    getPosts();
  }

  void likePost({required PostModel postToLike, required String postId}) {
    var liked = postToLike.isLiked!;
    var uid = userModel!.uid;
    if (liked) {
      postToLike.likes!.removeWhere((element) => element == uid);
    } else {
      postToLike.likes!.add(uid);
    }
    PostModel post = PostModel(
      name: postToLike.name,
      uid: postToLike.uid,
      image: postToLike.image,
      body: postToLike.body,
      postImage: postToLike.postImage ?? "",
      dateTime: postToLike.dateTime,
      likes: postToLike.likes!,
      isLiked: liked ? false : true,
      comments: postToLike.comments,
    );
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .update(post.toJson())
        .then((value) {
      postToLike.isLiked = liked ? false : true ;
      emit(LikesSuccessState());
    }).catchError((error) {
      emit(LikesErrorState(error.toString()));
    });
  }

  void commentOnPost(PostModel postToLike, String postId, String comment, String dateTime, int postIndex) {
    CommentModel commentModel = CommentModel(
        userID: userModel!.uid,
        name: userModel!.name,
        image: userModel!.image,
        time: dateTime,
        comment: comment);
    postToLike.comments!.add(commentModel);
    PostModel post = PostModel(
      name: postToLike.name,
      uid: postToLike.uid,
      image: postToLike.image,
      body: postToLike.body,
      postImage: postToLike.postImage ?? "",
      dateTime: postToLike.dateTime,
      likes: postToLike.likes!,
      isLiked: postToLike.isLiked,
      comments: postToLike.comments,
    );
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .update(post.toJson())
        .then((value) {
      emit(UpdateLastCommentState());
    }).catchError((error) {});
  }

  void changeCommentButton(String s, int index) {
    if (s.isNotEmpty)
      emit(ShowSendCommentState(index));
    else
      emit(HideSendCommentState());
  }
}
