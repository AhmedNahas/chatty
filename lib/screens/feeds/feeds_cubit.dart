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
        .snapshots()
        .listen((value) async {
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
          postsIds = List.from(postsIds.reversed);
          posts = List.from(posts.reversed);
          element.reference
              .collection(Constants.collectionLikes)
              .snapshots()
              .listen((likesV) async {
            likes.add(likesV.docs.length);
            likes = List.from(likes.reversed);
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
          });
        }
      }
    });
  }

  Future getLikes(QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    element.reference.collection(Constants.collectionLikes).get();
  }

  Future getComments(
      QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    await element.reference.collection(Constants.collectionComments).get();
  }

  void likePost(String postId,int index) {
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .collection(Constants.collectionLikes)
        .doc(uid)
        .set({'like': true}).then((value) {
          likes.insert(index, likes[index]+1);
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
