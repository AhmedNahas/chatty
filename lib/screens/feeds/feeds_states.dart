abstract class FeedCubitStates {}

class PostsInitialState extends FeedCubitStates{}

class PostsLoadingState extends FeedCubitStates{}

class NoPostsState extends FeedCubitStates{}

class PostsSuccessState extends FeedCubitStates{}

class PostsErrorState extends FeedCubitStates{
  final String error;
  PostsErrorState(this.error);
}

class LikesSuccessState extends FeedCubitStates{}

class LikesErrorState extends FeedCubitStates{
  final String error;
  LikesErrorState(this.error);
}

class ShowSendCommentState extends FeedCubitStates{
  int index;
  ShowSendCommentState(this.index);
}

class HideSendCommentState extends FeedCubitStates{}

class UpdateLastCommentState extends FeedCubitStates{}

