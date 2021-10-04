abstract class MainCubitStates {}

class MainCubitInitialState extends MainCubitStates{}

class MainCubitLoadingState extends MainCubitStates{}

class MainCubitSuccessState extends MainCubitStates{}

class MainCubitErrorState extends MainCubitStates{
  final String error;
  MainCubitErrorState(this.error);
}

class PostsLoadingState extends MainCubitStates{}

class PostsSuccessState extends MainCubitStates{}

class PostsErrorState extends MainCubitStates{
  final String error;
  PostsErrorState(this.error);
}

class BottomNavStates extends MainCubitStates{}

class NewPostState extends MainCubitStates{}

class PicProfileImageSuccessState extends MainCubitStates{}

class PicProfileImageErrorState extends MainCubitStates{}

class PicCoverImageSuccessState extends MainCubitStates{}

class PicCoverImageErrorState extends MainCubitStates{}

class CoverImageUploadSuccessState extends MainCubitStates{}

class CoverImageUploadErrorState extends MainCubitStates{
  CoverImageUploadErrorState(String error);
}

class ImageUploadSuccessState extends MainCubitStates{}

class UpdateUserDataLoadingState extends MainCubitStates{}

class ImageUploadErrorState extends MainCubitStates{
  ImageUploadErrorState(String error);
}

class UpdateUserDataErrorState extends MainCubitStates{
  UpdateUserDataErrorState(String error);
}

//create post
class CreatePostLoadingState extends MainCubitStates{}

class CreatePostSuccessState extends MainCubitStates{}

class CreatePostErrorState extends MainCubitStates{
  CreatePostErrorState(String error);
}

class PickPostImageSuccessState extends MainCubitStates{}

class PickPostImageErrorState extends MainCubitStates{}

class RemovePostImageState extends MainCubitStates{}