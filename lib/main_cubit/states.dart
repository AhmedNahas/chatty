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
