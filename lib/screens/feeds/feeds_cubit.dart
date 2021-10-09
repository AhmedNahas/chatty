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
  List<int> likes = [];
  List<List<CommentModel>> comments = [];
  List<CommentModel> secondComments = [];

  Future<void> getPosts() async {
    emit(PostsLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .orderBy('dateTime')
        .get()
        .then((value) async {
      posts.clear();
      postsIds.clear();
      likes.clear();
      comments.clear();
      if (value.docs.isEmpty) {
        emit(NoPostsState());
      } else {
        for (var element in value.docs) {
          postsIds.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          await element.reference
              .collection(Constants.collectionLikes)
              .get()
              .then((likesV) async {
            likes.add(likesV.docs.length);
            await element.reference
                .collection(Constants.collectionComments)
                .get()
                .then((commentsV) {
              secondComments = [];
              commentsV.docs.forEach((element) {
                secondComments.add(CommentModel(
                    count: commentsV.docs.length,
                    userID: element.id,
                    comment: element.data()['comment'],
                    name: element.data()['name'],
                    time: element.data()['time'],
                    image: element.data()['image']));
              });
              comments.add(secondComments);
            }).catchError((error) {});
          }).catchError((error) {});
        }
        emit(PostsSuccessState());
      }
    }).catchError((error) {
      emit(PostsErrorState(error.toString()));
    });
  }

  Future getLikes(QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    element.reference.collection(Constants.collectionLikes).get();
  }

  Future getComments(
      QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    await element.reference.collection(Constants.collectionComments).get();
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .collection(Constants.collectionLikes)
        .doc(uid)
        .set({'like': true}).then((value) {
      emit(LikesSuccessState());
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
      getPosts();
    }).catchError((error) {});
  }

  void changeCommentButton(String s, int index) {
    if (s.isNotEmpty)
      emit(ShowSendCommentState(index));
    else
      emit(HideSendCommentState());
  }
}
