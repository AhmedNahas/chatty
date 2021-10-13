abstract class MainCubitStates {}

class MainCubitInitialState extends MainCubitStates{}

class MainCubitLoadingState extends MainCubitStates{}

class MainCubitSuccessState extends MainCubitStates{}

class MainCubitErrorState extends MainCubitStates{
  final String error;
  MainCubitErrorState(this.error);
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

class UsersLoadingState extends MainCubitStates{}

class UsersSuccessState extends MainCubitStates{}

class UsersErrorState extends MainCubitStates{
  final String error;
  UsersErrorState(this.error);
}

class SendMessageSuccessState extends MainCubitStates{}

class NewMessageReceivedState extends MainCubitStates{
  int msgCounter;
  NewMessageReceivedState(this.msgCounter);
}

class NewNotificationState extends MainCubitStates{
  int notificationCounter;
  NewNotificationState(this.notificationCounter);
}

class SendMessageErrorState extends MainCubitStates{
  final String error;
  SendMessageErrorState(this.error);
}
