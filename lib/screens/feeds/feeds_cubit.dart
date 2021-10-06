import 'package:chatty/constants/constants.dart';
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
  List<int> comments = [];

  void getPosts() {
    emit(PostsLoadingState());
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .orderBy('dateTime')
        .get()
        .then((value) {
     if(value.docs.isEmpty){
       emit(NoPostsState());
     }else{
       for (var element in value.docs) {
         getLikes(element).then((value) {
           getComments(element).then((value) {
             postsIds.add(element.id);
             posts.add(PostModel.fromJson(element.data()));
           }).catchError((error) {});
         }).catchError((error) {});
       }
     }
    }).catchError((error) {
      emit(PostsErrorState(error.toString()));
    });
  }

  Future getLikes(QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    await element.reference
        .collection(Constants.collectionLikes)
        .get()
        .then((likesV) {
      print('${likesV.docs.length} likes');
      likes.add(likesV.docs.length);
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future getComments(
      QueryDocumentSnapshot<Map<String, dynamic>> element) async {
    await element.reference
        .collection(Constants.collectionComments)
        .get()
        .then((commentsV) {
      print('${commentsV.docs.length} comments');
      comments.add(commentsV.docs.length);
      emit(PostsSuccessState());
    }).catchError((error) {
      print(error.toString());
    });
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

  void commentOnPost(String postId, String comment) {
    FirebaseFirestore.instance
        .collection(Constants.collectionPosts)
        .doc(postId)
        .collection(Constants.collectionComments)
        .doc(uid)
        .set({'comment': comment})
        .then((value) {})
        .catchError((error) {});
  }
}
